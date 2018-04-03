public with sharing class septaTrainsDataHandler {
    public class septaStation {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String api_name;
        @AuraEnabled public String line;
        @AuraEnabled public String lat;
        @AuraEnabled public String lng;
        @AuraEnabled public string short_name;
    } 

    public static List<septaStation> loadData() {
        // Fine for this to throw an exception if the static resource is mysteriously not found.
        StaticResource dataStorage = [SELECT Body FROM StaticResource WHERE Name = 'septaStationLocations' LIMIT 1];

        return (List<septaStation>)JSON.deserializeStrict(dataStorage.Body.toString(), List<septaStation>.class);
    }

    public static Map<String, String> getApiNameToDisplayNameMap() {
        List<septaStation> stations = loadData();
        Map<String, String> mapping = new Map<String, String>();

        for (septaStation s : stations) {
            if (String.isNotBlank(s.api_name) && String.isNotBlank(s.name)) {
                mapping.put(s.api_name, s.name);
            }
            if (String.isNotBlank(s.short_name) && String.isNotBlank(s.name)) {
                mapping.put(s.short_name, s.name);
            }
        }

        return mapping;
    }

    public static Map<String, String> getDisplayNameToApiNameMap() {
        List<septaStation> stations = loadData();
        Map<String, String> mapping = new Map<String, String>();

        for (septaStation s : stations) {
            if (String.isNotBlank(s.api_name) && String.isNotBlank(s.name)) {
                mapping.put(s.name, s.api_name);
            }
        }

        return mapping;
    }

}
