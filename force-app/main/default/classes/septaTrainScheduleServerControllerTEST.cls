@isTest
public class septaTrainScheduleServerControllerTEST {    
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
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.HTTPErrorMockService());
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('11111');
        Test.stopTest();
        
        System.assertEquals('The SEPTA API returned an error.', r.error);
        System.assertEquals(0, r.timetable.size());
    }
    
    @isTest
    public static void testGetTrainTimetableAPIError() {
        septaTrainScheduleServerController.septaTrainTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.JSONErrorMockService());
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('11111');
        Test.stopTest();
        
        System.assertEquals('this is the error message', r.error);
        System.assertEquals(0, r.timetable.size());
    }

    @isTest
    public static void testGetTrainTimetableDevilService() {
        septaTrainScheduleServerController.septaTrainTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.DevilMockService());
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('11111');
        Test.stopTest();
        
        System.assertEquals('Unable to parse response from SEPTA API.', r.error);
        System.assertEquals(0, r.timetable.size());
    }

    @isTest
    public static void testGetTrainTimetableExceptionService() {
        septaTrainScheduleServerController.septaTrainTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.ExceptionMockService());
        Test.startTest();
        r = septaTrainScheduleServerController.getTrainTimetable('11111');
        Test.stopTest();
        
        System.assertEquals('Unable to contact SEPTA API.', r.error);
        System.assertEquals(null, r.timetable);
    }
}
