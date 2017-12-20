public with sharing class septaEntitySelectorServerController {
    @TestVisible
    private class septaEntitySelectorItem implements Comparable {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public Integer compareTo(Object other) {
            if (other instanceof septaEntitySelectorItem) {
                String otherLabel = ((septaEntitySelectorItem)other).label;
                String otherValue = ((septaEntitySelectorItem)other).value;

                if (label.startsWith('Train') && !otherLabel.startsWith('Train')) {
                    return -1;
                } else if (!label.startsWith('Train') && otherLabel.startsWith('Train')) {
                    return 1;
                }

                return label < otherLabel 
                    ? -1 
                    : (label > otherLabel ? 1 : 0);
            }

            return 0;
        }
    }
    @AuraEnabled
    public static List<septaEntitySelectorItem> getSelectOptions() {
        septaTrainsServerController.septaTrainPositionResponse resp = septaTrainsServerController.getTrainPositions();
        List<septaTrainsDataHandler.septaStation> stations = septaTrainsDataHandler.loadData();
        List<septaEntitySelectorItem> selectOptions = new List<septaEntitySelectorItem>();

        if (String.isBlank(resp.error)) {
            for (septaTrainsServerController.septaTrainPosition p : resp.positions) {
                septaEntitySelectorItem i = new septaEntitySelectorItem();
                i.label = 'Train #' + p.trainNumber;
                i.value = p.trainNumber;

                selectOptions.add(i);
            }
        }

        if (stations != null) {
            for (septaTrainsDataHandler.septaStation s : stations) {
                septaEntitySelectorItem i = new septaEntitySelectorItem();
                i.label = i.value = s.name;

                selectOptions.add(i);
            }
        }

        selectOptions.sort();

        return selectOptions;
    }
}
