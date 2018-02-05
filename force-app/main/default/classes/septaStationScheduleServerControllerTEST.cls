@isTest
public class septaStationScheduleServerControllerTEST {    
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
        
        System.assertEquals('2327', r.timetable[0].trainNumber);
        System.assertEquals('Elwyn', r.timetable[0].destinationApiName);
    }
    
    @isTest
    public static void testGetStationTimetableHTTPError() {
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.HTTPErrorMockService());
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals('The SEPTA API returned result code 404', r.error);
        System.assertEquals(null, r.timetable);
    }
    
    @isTest
    public static void testGetStationTimetableAPIError() {
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.JSONErrorMockService());
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals('this is the error message', r.error);
        System.assertEquals(null, r.timetable);
    }

    @isTest
    public static void testGetStationTimetableDevilService() {
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.DevilMockService());
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals('Unable to parse response from SEPTA API.', r.error);
        System.assertEquals(null, r.timetable);
    }

    @isTest
    public static void testExceptionService() {
        septaStationScheduleServerController.septaStationTimetableResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.ExceptionMockService());
        Test.startTest();
        r = septaStationScheduleServerController.getStationTimetable('North Broad St');
        Test.stopTest();
        
        System.assertEquals('Unable to contact the SEPTA API.', r.error);
        System.assertEquals(null, r.timetable);
    }

    @isTest
    public static void testSorting() {
        septaStationScheduleServerController.septaStationTimetableEntry a, b;

        a = new septaStationScheduleServerController.septaStationTimetableEntry();
        b = new septaStationScheduleServerController.septaStationTimetableEntry();

        a.departureDatetime = DateTime.now();
        b.departureDatetime = DateTime.now() - 1;

        System.assertEquals(1, a.compareTo(b));
        System.assertEquals(-1, b.compareTo(a));
        System.assertEquals(0, a.compareTo('test'));

    }
}
