({
	updateSchedule : function(component, event, helper) {
        // Load the upcoming timetable for the train.
        var action = component.get('c.getTrainTimetable');
        var selection = component.get('v.selectedEntity');
        
        if (selection !== null) {
            action.setParam('train', component.get('v.selectedEntity'));
            action.setCallback(this, function(result) {
                var j = JSON.parse(result.getReturnValue());
                var entries = j.filter(function(t) { return t['act_tm'] === 'na' });

                for (var e of entries) {
                    e['DisplayName'] = septaStationMapper.convert_api(e['station']);
                }

                component.set('v.timetable', entries);
            });
            
            $A.enqueueAction(action);
        }
    }
})