({
	updateSchedule : function(component, event, helper) {
        // Load the upcoming timetable for the train.
        var action = component.get('c.getStationTimetable');
        var selection = component.get('v.selectedEntity');
        
        if (selection !== null) {
            action.setParam('station', selection);

            action.setCallback(this, function(result) {
                var j = result.getReturnValue();
    
                if (j.error !== undefined) {
                    alert(j.error);
                } else {
                    component.set('v.timetable', j.timetable);
                }
                component.set('v.loading', false);
            });
            
            component.set('v.loading', true);
            $A.enqueueAction(action);
        }
    }
})