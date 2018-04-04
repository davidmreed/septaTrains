@isTest
public class septaTrainsServerControllerTEST {
    public static final Integer POSITION_COUNT = 36;

    @isTest
    public static void testGetTrainPositions() {
        StaticResourceCalloutMock m = new StaticResourceCalloutMock();
        septaTrainsServerController.septaTrainPositionResponse r;
        
        m.setStatusCode(200);
        m.setStaticResource('septaTrainViewGoodResponse');
        m.setHeader('Content-Type', 'application/json');

        Test.setMock(HTTPCalloutMock.class, m);
        Test.startTest();
        r = septaTrainsServerController.getTrainPositions();
        Test.stopTest();
        
        System.assertEquals(null, r.error);
        System.assertEquals(POSITION_COUNT, r.positions.size());
        for (septaTrainsServerController.septaTrainPosition e : r.positions) {
            System.assert(String.isNotBlank(e.lat));
            System.assert(String.isNotBlank(e.lng));
            System.assert(String.isNotBlank(e.trainNumber));
            System.assert(String.isNotBlank(e.service));
            System.assert(String.isNotBlank(e.destinationApiName));
            System.assert(String.isNotBlank(e.destinationDisplayName));
            System.assert(String.isNotBlank(e.nextStopApiName));
            System.assert(String.isNotBlank(e.nextStopDisplayName));
            System.assert(String.isNotBlank(e.line));
            System.assert(e.cars.size() > 0);
            System.assertNotEquals(null, e.minutesLate);
            System.assert(String.isNotBlank(e.sourceApiName));
            System.assert(String.isNotBlank(e.sourceDisplayName));
        }
        
        System.assertEquals('40.073022666667', r.positions[0].lat);
        System.assertEquals('-75.310539166667', r.positions[0].lng);
        System.assertEquals('2357', r.positions[0].trainNumber);
        System.assertEquals('EXP TO FERNWOOD', r.positions[0].service);
        System.assertEquals('Elwyn', r.positions[0].destinationApiName);
        System.assertEquals('Elwyn', r.positions[0].destinationDisplayName);
        System.assertEquals('Conshohocken', r.positions[0].nextStopApiName);
        System.assertEquals('Conshohocken', r.positions[0].nextStopDisplayName);
        System.assertEquals('Manayunk/Norristown', r.positions[0].line);
        System.assertEquals(4, r.positions[0].cars.size());
        System.assertEquals(0, r.positions[0].minutesLate);
        System.assertEquals('Norristown', r.positions[0].sourceApiName);
        System.assertEquals('Elm Street, Norristown', r.positions[0].sourceDisplayName);
    }
    
    @isTest
    public static void testGetTrainPositionsHTTPError() {
        septaTrainsServerController.septaTrainPositionResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.HTTPErrorMockService());
        Test.startTest();
        r = septaTrainsServerController.getTrainPositions();
        Test.stopTest();
        
        System.assertEquals('The SEPTA TrainView API returned error 404.', r.error);
        System.assertEquals(null, r.positions);
    }

    @isTest
    public static void testLoadData() {
        System.assertEquals(septaTrainsDataHandler.loadData().size(), septaTrainsServerController.loadData().size());
    }

    @isTest
    public static void testDevilMockService() {
        septaTrainsServerController.septaTrainPositionResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.DevilMockService());
        Test.startTest();
        r = septaTrainsServerController.getTrainPositions();
        Test.stopTest();
        
        System.assertEquals('Failed to parse response from SEPTA TrainView API.', r.error);
        System.assertEquals(0, r.positions.size()); 
    }

    @isTest
    public static void testExceptionService() {
        septaTrainsServerController.septaTrainPositionResponse r;
        
        Test.setMock(HTTPCalloutMock.class, new septaTrainsMocksTEST.ExceptionMockService());
        Test.startTest();
        r = septaTrainsServerController.getTrainPositions();
        Test.stopTest();
        
        System.assertEquals('Unable to contact the SEPTA TrainView API.', r.error);
        System.assertEquals(null, r.positions);
    }
}
