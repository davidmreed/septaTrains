public class septaTrainScheduleServerController {
    public class septaTrainTimetableEntry {
        @AuraEnabled public String destinationDisplayName;
        @AuraEnabled public String destinationApiName;
        @AuraEnabled public String arrivalTime;
    }

    private class JSONseptaTrainTimetableItem {
        public String est_tm;
        public String act_tm;
        public String station;
    }
    
    public class septaTrainTimetableResponse {
        @AuraEnabled public String error;
        @AuraEnabled public List<septaTrainTimetableEntry> timetable;
    }

    @AuraEnabled
    public static septaTrainTimetableResponse getTrainTimetable(String train) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        Map<String, String> conversion = septaTrainsDataHandler.getApiNameToDisplayNameMap();
        septaTrainTimetableResponse response = new septaTrainTimetableResponse();

        try {
            req.setEndpoint('https://www3.septa.org/hackathon/RRSchedules/' + train);
            req.setMethod('GET');
            
            HttpResponse res = http.send(req);
            response.timetable = new List<septaTrainTimetableEntry>();

            if (res.getStatusCode() == 200) {
                List<JSONseptaTrainTimetableItem> items;

                try {
                    // Check for a non-HTTP error first.
                    Object x = JSON.deserializeUntyped(res.getBody());

                    if (x instanceof Map<String, Object>) {
                        Map<String, Object> m = (Map<String, Object>)x;
                        // If we got a map, it is indicating an error.
                        response.error = (String)m.get('error');
                        return response;
                    }

                    items = (List<JSONseptaTrainTimetableItem>)JSON.deserialize(res.getBody(), List<JSONseptaTrainTimetableItem>.class);

                    for (JSONseptaTrainTimetableItem i : items) {
                        if (i.act_tm == 'na') {
                            septaTrainTimetableEntry entry = new septaTrainTimetableEntry();
                            
                            entry.destinationApiName = i.station;
                            entry.arrivalTime = i.est_tm;
                            entry.destinationDisplayName = (conversion.containsKey(i.station) ? conversion.get(i.station) : i.station);

                            response.timetable.add(entry);
                        }
                    }
                } catch (Exception e) {
                    response.error = 'Unable to parse response from SEPTA API.';
                }
            } else {
                response.error = 'The SEPTA API returned an error.';
            }
        } catch (Exception e) {
            response.error = 'Unable to contact SEPTA API.';
        }
        
        return response;
    }
}