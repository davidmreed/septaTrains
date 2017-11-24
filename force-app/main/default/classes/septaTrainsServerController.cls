public class septaTrainsServerController {
    @AuraEnabled
    public static String callSEPTA() {
        Http http = new Http();
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://www3.septa.org/hackathon/TrainView/');
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            return res.getBody();
        }
        
        return '';
    }
}