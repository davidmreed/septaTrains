@isTest
public class septaStationScheduleServerControllerTEST {
    private class StationTimetableHTTPErrorMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(404);
            r.setBody('');
            
            return r;
        }
    }
    
    private class StationTimetableErrorMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(200);
            r.setBody('{ "error": "this is the error message" }');
            
            return r;
        }
    }
    
    @isTest
    public static void testGetStationTimetableGood() {
        StaticResourceCalloutMock m = new StaticResourceCalloutMock();
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        m.setStatusCode(200);
        m.setStaticResource('septaTrainScheduleTestResponse');
        m.setHeader('Content-Type', 'application/json');

        Test.setMock(HTTPCalloutMock.class, m);
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals(null, r.error);
        System.assertEquals(10, r.timetable.size());
        for (septaStationScheduleServerController.septaStationTimetableEntry e : r.timetable) {
            System.assert(String.isNotBlank(e.trainNumber));
            System.assert(String.isNotBlank(e.destinationDisplayName));
            System.assert(String.isNotBlank(e.destinationApiName));
            System.assert(String.isNotBlank(e.departureTime));
        }
        
        System.assertEquals('222', r.timetable[0].trainNumber);
        System.assertEquals('Norristown', r.timetable[0].destinationApiName);
    }
    
    public static void testGetStationTimetableHTTPError() {
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new StationTimetableHTTPErrorMockService());
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals('The SEPTA API returned result code 404', r.error);
        System.assertEquals(null, r.timetable);
    }
    
    public static void testGetStationTimetableAPIError() {
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new StationTimetableErrorMockService());
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals('this is the error message', r.error);
        System.assertEquals(null, r.timetable);
    }}
