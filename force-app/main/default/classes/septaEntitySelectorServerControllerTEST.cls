@isTest
public with sharing class septaEntitySelectorServerControllerTEST {
    @isTest
    public static void testSeptaEntitySelectorItem() {
        septaEntitySelectorServerController.septaEntitySelectorItem a, b;

        a = new septaEntitySelectorServerController.septaEntitySelectorItem();
        a.label = 'Train #2785';
        a.value = '2785';

        b = new septaEntitySelectorServerController.septaEntitySelectorItem();
        b.label = 'Station';
        b.value = 'Station';

        System.assertEquals(-1, a.compareTo(b));
        System.assertEquals(1, b.compareTo(a));
        System.assertEquals(0, a.compareTo('test'));
    }

    @isTest
    public static void testSeptaEntityServerController() {
        List<septaEntitySelectorServerController.septaEntitySelectorItem> sos;
        StaticResourceCalloutMock m = new StaticResourceCalloutMock();
        
        m.setStatusCode(200);
        m.setStaticResource('septaTrainViewGoodResponse');
        m.setHeader('Content-Type', 'application/json');

        Test.setMock(HTTPCalloutMock.class, m);
        Test.startTest();
        sos = septaEntitySelectorServerController.getSelectOptions();
        Test.stopTest();

        System.assertEquals(septaTrainsServerControllerTEST.POSITION_COUNT + septaTrainsDataHandlerTEST.STATION_COUNT,
                            sos.size());
    }
}
