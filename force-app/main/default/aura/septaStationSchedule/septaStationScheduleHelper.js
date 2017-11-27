({
	updateSchedule : function(component, event, helper) {
        // Load the upcoming timetable for the train.
        var action = component.get('c.getStationTimetable');
        var selection = component.get('v.selectedEntity');
        
        if (selection !== null) {
            action.setParam('station', septaStationMapper.convert_display(selection));

            action.setCallback(this, function(result) {
                var j = result.getReturnValue();
    
                if (j === null || j.error !== undefined) {
                    if (j === null) {
                        alert('An unknown error occurred');
                    } else {
                        alert(j.error);
                    }
                } else {
                    for (var e of j.timetable) {
                        e['DisplayName'] = septaStationMapper.convert_api(e.destination);
                    }
                    component.set('v.timetable', j.timetable.filter(function(x) { return !x.trainNumber.startswith('A'); }));
                }            
            });
            
            $A.enqueueAction(action);
        }
	}
})