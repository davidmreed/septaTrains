public with sharing class septaEntitySelectorServerController {
    @AuraEnabled
    public static List<Map<String, String>> getSelectOptions() {
        septaTrainsServerController.septaTrainPositionResponse resp = septaTrainsServerController.getTrainPositions();
        List<septaTrainsDataHandler.septaStation> stations = septaTrainsDataHandler.loadData();
        List<Map<String, String>> selectOptions = new List<Map<String, String>>();

        if (String.isBlank(resp.error)) {
            for (septaTrainsServerController.septaTrainPosition p : resp.positions) {
                selectOptions.add(new Map<String, String>{ 
                    'label' => 'Train #' + p.trainNumber,
                    'value' => p.trainNumber 
                });
            }
        }

        if (stations != null) {
            for (septaTrainsDataHandler.septaStation s : stations) {
                selectOptions.add(new Map<String, String>{ 
                    'label' => s.name,
                    'value' => s.name
                });
            }
        }

        return selectOptions;
    }
}
