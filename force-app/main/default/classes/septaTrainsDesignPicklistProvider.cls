global class septaTrainsDesignPicklistProvider extends VisualEditor.DynamicPickList {
    global override VisualEditor.DataRow getDefaultValue() {
        return new VisualEditor.DataRow('Suburban Station', 'Suburban Station');
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows stationNames = new VisualEditor.DynamicPickListRows();
        // Load station names from JSON.

        for (septaTrainsDataHandler.septaStation s : septaTrainsDataHandler.loadData()) {
            stationNames.addRow(
                new VisualEditor.DataRow(s.name, 
                                         (String.isNotBlank(s.api_name) ? s.api_name : s.name))
            );
        }

        return stationNames;
    }
}