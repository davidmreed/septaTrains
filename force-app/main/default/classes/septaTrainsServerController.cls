public class septaTrainsServerController {
    private class JSONseptaTrainPosition {
        public String lat;
        public String lon;
        public String trainno;
        public String service;
        public String dest;
        public String nextstop;
        public String destDisplayName;
        public String nextstopDisplayName;
        public String line;
        public String consist;
        public Integer late;
        public String SOURCE;
        public String sourceDisplayName;
        public String TRACK;
        public String TRACK_CHANGE;
    }

    public class septaTrainPosition {
        @AuraEnabled public String lat;
        @AuraEnabled public String lng;
        @AuraEnabled public String trainNumber;
        @AuraEnabled public String service;
        @AuraEnabled public String destinationApiName;
        @AuraEnabled public String nextStopApiName;
        @AuraEnabled public String destinationDisplayName;
        @AuraEnabled public String nextStopDisplayName;
        @AuraEnabled public String line;
        @AuraEnabled public String[] cars;
        @AuraEnabled public Integer minutesLate;
        @AuraEnabled public String sourceApiName;
        @AuraEnabled public String sourceDisplayName;
    }
    
    public class septaTrainPositionResponse {
        @AuraEnabled public String error;
        @AuraEnabled public List<septaTrainPosition> positions;
    }
    
    @AuraEnabled
    public static septaTrainPositionResponse getTrainPositions() {
        septaTrainPositionResponse response = new septaTrainPositionResponse();

        try {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            Map<String, String> mapping = septaTrainsDataHandler.getApiNameToDisplayNameMap();
            
            req.setEndpoint('https://www3.septa.org/hackathon/TrainView/');
            req.setMethod('GET');
            
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                try {
                    List<JSONseptaTrainPosition> incoming;

                    response.positions = new List<septaTrainPosition>();
                    incoming = (List<JSONseptaTrainPosition>)JSON.deserialize(res.getBody(), 
                        List<JSONseptaTrainPosition>.class);
                    
                    for (JSONseptaTrainPosition s : incoming) {
                        septaTrainPosition tp = new septaTrainPosition();
                        
                        // We escape all the data coming back to protect our page, since this is populated
                        // directly into HTML in the Leaflet map.
                        tp.lat = s.lat;
                        tp.lng = s.lon;
                        tp.trainNumber = s.trainno.escapeHtml4();
                        tp.service = s.service.escapeHtml4();
                        tp.destinationApiName = s.dest.escapeHtml4();
                        tp.nextStopApiName = s.nextstop.escapeHtml4();
                        tp.line = s.line.escapeHtml4();
                        tp.cars = s.consist.escapeHtml4().split(',');
                        tp.minutesLate = s.late;
                        tp.sourceApiName = s.SOURCE.escapeHtml4();

                        tp.destinationDisplayName = (mapping.containsKey(s.dest) ? mapping.get(s.dest) : s.dest);
                        tp.nextStopDisplayName = (mapping.containsKey(s.nextstop) ? mapping.get(s.nextstop) : s.nextstop);
                        tp.sourceDisplayName = (mapping.containsKey(s.SOURCE) ? mapping.get(s.SOURCE) : s.SOURCE);

                        response.positions.add(tp);
                    }
                } catch (Exception e) {
                    response.error = 'Failed to parse response from SEPTA TrainView API.';
                }
            } else {
                response.error = 'The SEPTA TrainView API returned error ' + String.valueOf(res.getStatusCode()) + '.';
            }
        } catch (Exception e) {
            response.error = 'Unable to contact the SEPTA TrainView API.';
        }
        
        return response;
    }

    @AuraEnabled
    public static List<septaTrainsDataHandler.septaStation> loadData() {
        return septaTrainsDataHandler.loadData();
    }
}