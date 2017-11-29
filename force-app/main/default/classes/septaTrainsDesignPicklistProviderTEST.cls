@isTest
public class septaTrainsDesignPicklistProviderTEST {
    @isTest
    public static void testProvider() {
        VisualEditor.DynamicPickListRows rows = new septaTrainsDesignPicklistProvider().getValues();
        List<septaTrainsDataHandler.septaStation> stations = septaTrainsDataHandler.loadData();
        Map<String, String> mapping = septaTrainsDataHandler.getDisplayNameToApiNameMap();

        for (VisualEditor.DataRow r : rows.getDataRows()) {
            System.assertNotEquals(null, r.getValue());
            System.assertNotEquals(null, r.getLabel());

            if (r.getValue() != r.getLabel()) {
                System.assertEquals(mapping.get(r.getLabel()), r.getValue());
            }
        }

        System.assertEquals('Suburban Station', new septaTrainsDesignPicklistProvider().getDefaultValue().getValue());
    }
}
