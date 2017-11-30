({
	updateSchedule : function(component, event, helper) {
        // Load the upcoming timetable for the train.
        var action = component.get('c.getTrainTimetable');
        var selection = component.get('v.selectedEntity');
        
        if (selection !== null) {
            action.setParam('train', selection);
            action.setCallback(this, function(result) {
                component.set('v.timetable', result.getReturnValue().timetable);
                component.set('v.loading', false);
            });
            
            component.set('v.loading', true);
            $A.enqueueAction(action);
        }
    }
})