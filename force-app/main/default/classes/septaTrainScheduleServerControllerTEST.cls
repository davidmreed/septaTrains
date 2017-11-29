@isTest
public class septaTrainScheduleServerControllerTEST {
    private class TrainTimetableHTTPErrorMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(404);
            r.setBody('');
            
            return r;
        }
    }
    
    private class TrainTimetableErrorMockService implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse r = new HTTPResponse();
            
            r.setStatusCode(200);
            r.setBody('{ "error": "this is the error message" }');
            
            return r;
        }
    }
    
    @isTest
    public static void testGetTrainTimetableGood() {
        StaticResourceCalloutMock m = new StaticResourceCalloutMock();
        septaTrainScheduleServerController.septaTrainTimetableResponse r;
        
        m.setStatusCode(200);
        m.setStaticResource('septaTrainScheduleGoodResponse');
        m.setHeader('Content-Type', 'application/json');

        Test.setMock(HTTPCalloutMock.class, m);
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('783');
        Test.stopTest();
        
        System.assertEquals(null, r.error);
        System.assertEquals(11, r.timetable.size());
        for (septaTrainScheduleServerController.septaTrainTimetableEntry e : r.timetable) {
            System.assert(String.isNotBlank(e.destinationDisplayName));
            System.assert(String.isNotBlank(e.destinationApiName));
            System.assert(String.isNotBlank(e.arrivalTime));
        }
        
        System.assertEquals('2:58 pm', r.timetable[0].arrivalTime);
        System.assertEquals('Temple U', r.timetable[0].destinationApiName);
        System.assertEquals('Temple University', r.timetable[0].destinationDisplayName);
    }
    
    @isTest
    public static void testGetTrainTimetableHTTPError() {
        septaTrainScheduleServerController.septaTrainTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new TrainTimetableHTTPErrorMockService());
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('11111');
        Test.stopTest();
        
        System.assertEquals('The SEPTA API returned an error.', r.error);
        System.assertEquals(0, r.timetable.size());
    }
    
    @isTest
    public static void testGetTrainTimetableAPIError() {
        septaTrainScheduleServerController.septaTrainTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new TrainTimetableErrorMockService());
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('11111');
        Test.stopTest();
        
        System.assertEquals('this is the error message', r.error);
        System.assertEquals(0, r.timetable.size());
    }}
