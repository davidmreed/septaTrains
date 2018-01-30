public with sharing class septaStationScheduleServerController {
    public class septaStationTimetableEntry implements Comparable {
        @AuraEnabled public String trainNumber;
        @AuraEnabled public String destinationApiName;
        @AuraEnabled public String destinationDisplayName;
        @AuraEnabled public String departureTime;
        public DateTime departureDatetime;

        public Integer compareTo(Object other) {
            if (other instanceof septaStationTimetableEntry) {
                septaStationTimetableEntry o = (septaStationTimetableEntry)other;
                
                return departureDatetime < o.departureDatetime ? -1 : 1;
            }

            return 0;
        }
    }
    
    public class septaStationTimetableResponse {
        @AuraEnabled public String error;
        @AuraEnabled public List<septaStationTimetableEntry> timetable;
    }

    @AuraEnabled
    public static septaStationTimetableResponse getStationTimetable(String station) {
        // This function receives a display name from the component and needs to pass
        // an API name to the Septa API.

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        septaStationTimetableResponse r = new septaStationTimetableResponse();
        Map<String, String> mapping = septaTrainsDataHandler.getApiNameToDisplayNameMap();
        Map<String, String> reverseMapping = septaTrainsDataHandler.getDisplayNameToApiNameMap();
        String stationApiName;

        try {
            stationApiName = (reverseMapping.containsKey(station) ? reverseMapping.get(station) : station);
            
            // SEPTA's API wants %20 for spaces, not +
            // Final parameter is the number of results we want.
            req.setEndpoint('https://www3.septa.org/hackathon/Arrivals/' + 
                            EncodingUtil.urlEncode(stationApiName, 'UTF-8').replace('+', '%20') +
                        '/100');
            req.setMethod('GET');
            
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                // JSON returned can have several different structures.
                // It can be { error: errortext }
                // It can be { "Date time header": [ {"Northbound": [list of departures]}, {"Southbound": [list of departures]} ] }
                // It can be { "Date time header": [ [], {"Southbound": [list of departures]} ] }, 
                //  when there are no Northbound (or southbound) departures
                // Or it can be { "Date time header": [ [], [] ] } when there are no departures at all.
                if (res.getBody().length() > 0) {
                    Map<String, Object> o;

                    try {
                        o = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
                        if (o.containsKey('error') && String.isNotBlank((String)o.get('error'))) {
                            r.error = (String)o.get('error');
                            return r;
                        }
                        
                        // Assume good structure. If we throw an exception, we'll return an appropriate error.
                        // The response is a dictionary with only one key, a display-oriented string encoding the station
                        // and the time of the request.
                        List<Object> topLevel = (List<Object>)o.get(new List<String>(o.keySet()).get(0));
                        
                        r.timetable = new List<septaStationTimetableEntry>();
                        // The value for this top-level key is a list of dictionaries.
                        // Each dictionary contains a single key, either "Northbound" or "Southbound", 
                        // each with a value of a list of departures.
                        // If there aren't any departures, the dictionary is replaced by an empty list.
                        for (Object q : topLevel) {
                            if (!(q instanceof List<Object>)) {
                                Map<String, Object> m = (Map<String, Object>)q;

                                if (m.containsKey('Northbound') || m.containsKey('Southbound')) {
                                    String soleKey = new List<String>(m.keySet()).get(0);
                                    List<Object> listOfDepartures = (List<Object>)m.get(soleKey);

                                    if (listOfDepartures != null && listOfDepartures.size() > 0) {
                                        for (Object k : listOfDepartures) {
                                            Map<String, Object> departure = (Map<String, Object>)k;

                                            // Add a departure item for each entry
                                            // Ignore entries starting with A, which are Amtrak trains.
                                            if (departure.containsKey('train_id')) {
                                                String trainId = (String)departure.get('train_id');
                                                
                                                if (!trainId.startsWith('A')) {
                                                    septaStationTimetableEntry s = new septaStationTimetableEntry();
                                                    
                                                    s.trainNumber = trainId;
                                                    s.destinationApiName = (String)departure.get('destination');
                                                    s.destinationDisplayName = (mapping.containsKey(s.destinationApiName) 
                                                        ? mapping.get(s.destinationApiName) : s.destinationApiName);
                                                    
                                                    // Separately coerce the date time value to a string 
                                                    // so Apex can bind to the right DateTime.valueOf method
                                                    // We'll store the DateTime object for sorting. 
                                                    // (since the API returns Northbound first and then Southbound)
                                                    String dateTimeString = (String)departure.get('depart_time');
                                                    s.departureDatetime = DateTime.valueOf(dateTimeString);
                                                    s.departureTime = s.departureDatetime.format('h:mm a');
                                                    r.timetable.add(s);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        r.timetable.sort();
                    } catch (Exception e) {
                        r.error = 'Unable to parse response from SEPTA API.';
                        r.timetable = null;
                    }
                }
            } else {
                r.error = 'The SEPTA API returned result code ' + String.valueOf(res.getStatusCode());
            }
        } catch (Exception e) {
            r.error = 'Unable to contact the SEPTA API.';
        }
        
        return r;
    }
}
