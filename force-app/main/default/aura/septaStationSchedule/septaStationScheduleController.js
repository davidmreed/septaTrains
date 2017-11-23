({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Train #', fieldName: 'trainNumber', type: 'string'},
            { label: 'Dest.', fieldName: 'destination', type: 'string'},
            { label: 'Departs', fieldName: 'departureTime', type: 'string'}
        ]);
    },
    
    handleSelection : function(component, event, helper) {
        helper.updateSchedule(component, event, helper);
    },
    
    handleStationClick : function(component, event, helper) {
        var train = event.getParam('selectedRows')[0].trainNumber;        
    }
})