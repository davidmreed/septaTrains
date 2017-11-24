({
	handleChange : function(component, event, helper) {
		var selection = component.get('v.selectedEntity');

        if (selection.type === 'TRAIN') {
            component.set('v.selectedTrain', selection);
            component.set('v.selectedStation', null);
        } else if (selection.type === 'STATION') {
            component.set('v.selectedTrain', null);
            component.set('v.selectedStation', selection);
        } else {
            component.set('v.selectedTrain', null);
            component.set('v.selectedStation', null);
        }
	}
})