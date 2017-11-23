public class septaTrainScheduleServerController {
    public class septaStationTimetableEntry {
        @AuraEnabled public String trainNumber;
        @AuraEnabled public String destination;
        @AuraEnabled public String departureTime;
    }
    
    public class septaStationTimetableResponse {
        @AuraEnabled public String error;
        @AuraEnabled public List<septaStationTimetableEntry> timetable;
    }
    
    @AuraEnabled
    public static String getTrainTimetable(String train) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://www3.septa.org/hackathon/RRSchedules/' + train);
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            System.debug('returning ' + res.getBody());
            return res.getBody();
        }
        
        return '';
    }
    
    @AuraEnabled
    public static septaStationTimetableResponse getStationTimetable(String station) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        septaStationTimetableResponse r = new septaStationTimetableResponse();
        
        // SEPTA's API wants %20 for spaces, not +
        // Final parameter is the number of results we want.
        req.setEndpoint('https://www3.septa.org/hackathon/Arrivals/' + 
                        EncodingUtil.urlEncode(station, 'UTF-8').replace('+', '%20') +
                       '/100');
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            // JSON returned can have several different structures.
            // It can be { error: errortext }
            // It can be { "Date time header": { [ {"Northbound": [list of departures]}, {"Southbound": [list of departures]} ] }
            // Or it can be above but with a blank list in place of the departures list.
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
                    System.debug(o.get(new List<String>(o.keySet()).get(0)));
                    List<Object> topLevel = (List<Object>)o.get(new List<String>(o.keySet()).get(0));
                    
                	r.timetable = new List<septaStationTimetableEntry>();
                    // The value for this top-level key is a list of dictionaries.
                    // Each dictionary contains a single key, either "Northbound" or "Southbound", 
                    // each with a value of a list of departures (which may be empty)
                    for (Object q : topLevel) {
                        Map<String, Object> m = (Map<String, Object>)q;

                        if (m.containsKey('Northbound') || m.containsKey('Southbound')) {
                            String soleKey = new List<String>(m.keySet()).get(0);
                            List<Object> listOfDepartures = (List<Object>)m.get(soleKey);

                            if (listOfDepartures != null && listOfDepartures.size() > 0) {
                                for (Object k : listOfDepartures) {
                                    Map<String, Object> departure = (Map<String, Object>)k;

                                    // Add a departure item for each entry
                                    septaStationTimetableEntry s = new septaStationTimetableEntry();
                                    
                                    s.trainNumber = (String)departure.get('train_id');
                                    s.destination = (String)departure.get('destination');
                                    
                                    // Separately coerce the date time value to a string 
                                    // so Apex can bind to the right DateTime.valueOf
                                    String dateTimeString = (String)departure.get('depart_time');
                                    s.departureTime = DateTime.valueOf(dateTimeString).format('h:mm a');
                                    
                                    r.timetable.add(s);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    r.error = 'Unable to parse response from SEPTA API.';
                    r.timetable = null;
                }
            }
        } else {
            r.error = 'The SEPTA API returned result code ' + String.valueOf(res.getStatusCode());
        }
        
        return r;
    }
}