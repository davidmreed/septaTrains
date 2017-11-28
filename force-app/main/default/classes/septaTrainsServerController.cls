public class septaTrainsServerController {
    public class septaTrainPosition {
        @AuraEnabled public String lat;
        @AuraEnabled public String lon;
        @AuraEnabled public String trainno;
        @AuraEnabled public String service;
        @AuraEnabled public String dest;
        @AuraEnabled public String nextstop;
        @AuraEnabled public String destDisplayName;
        @AuraEnabled public String nextstopDisplayName;
        @AuraEnabled public String line;
        @AuraEnabled public String consist;
        @AuraEnabled public Integer late;
        @AuraEnabled public String SOURCE;
        @AuraEnabled public String sourceDisplayName;
        @AuraEnabled public String TRACK;
        @AuraEnabled public String TRACK_CHANGE;
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
                    response.positions = (List<septaTrainPosition>)JSON.deserialize(res.getBody(), 
                                          List<septaTrainPosition>.class);
                    
                    for (septaTrainPosition s : response.positions) {
                        s.destDisplayName = (mapping.containsKey(s.dest) ? mapping.get(s.dest) : s.dest);
                        s.nextstopDisplayName = (mapping.containsKey(s.nextstop) ? mapping.get(s.nextstop) : s.nextstop);
                        s.sourceDisplayName = (mapping.containsKey(s.SOURCE) ? mapping.get(s.SOURCE) : s.SOURCE);
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