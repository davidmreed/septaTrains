({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Train #', fieldName: 'trainNumber', type: 'string'},
            { label: 'Dest.', fieldName: 'DisplayName', type: 'string'},
            { label: 'Departs', fieldName: 'departureTime', type: 'string'}
        ]);
        component.set('v.displayName', septaStationMapper.convert_api(component.get('v.selectedEntity')));
    },
    
    handleSelection : function(component, event, helper) {
        helper.updateSchedule(component, event, helper);
        component.set('v.displayName', septaStationMapper.convert_api(component.get('v.selectedEntity')));
    },
    
    handleStationClick : function(component, event, helper) {
        var train = event.getParam('selectedRows')[0].trainNumber;        
    }
})