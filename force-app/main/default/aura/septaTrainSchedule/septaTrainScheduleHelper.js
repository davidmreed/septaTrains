({
	updateSchedule : function(component, event, helper) {
        // Load the upcoming timetable for the train.
        var action = component.get('c.getTrainTimetable');
        var selection = component.get('v.selectedEntity');
        
        if (selection !== null) {
            action.setParam('train', component.get('v.selectedEntity'));
            action.setCallback(this, function(result) {
                var j = JSON.parse(result.getReturnValue());
                
                component.set('v.timetable', j.filter(function(t) { return t['act_tm'] === 'na' }));
            });
            
            $A.enqueueAction(action);
        }
    }
})