@isTest
public class septaTrainsDataHandlerTEST {
    public static final Integer STATION_COUNT = 155;

    @isTest 
    public static void testLoadData() {
        List<septaTrainsDataHandler.septaStation> stations = septaTrainsDataHandler.loadData();

        System.assertEquals(STATION_COUNT, stations.size());
    }

    @isTest
    public static void testGetApiNameToDisplayNameMap() {
        Map<String, String> mapping = septaTrainsDataHandler.getApiNameToDisplayNameMap();

        System.assertEquals('Temple University', mapping.get('Temple U'));
        System.assertEquals(null, mapping.get('Churchmans Crossing'));
    }

    @isTest
    public static void testGetDisplayNameToApiNameMap() {
        Map<String, String> mapping = septaTrainsDataHandler.getDisplayNameToApiNameMap();

        System.assertEquals('Temple U', mapping.get('Temple University'));
        System.assertEquals(null, mapping.get('Churchmans Crossing'));
    }

}
