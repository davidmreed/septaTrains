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
    
    @AuraEnabled
    public static String getStationLocations() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://www3.septa.org/hackathon/locations/get_locations.php?lon=-75.1649369&lat=39.9537069&radius=500&type=rail_stations');
        req.setMethod('GET');
        
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            return res.getBody();
        }
        
        return '';

    }
}