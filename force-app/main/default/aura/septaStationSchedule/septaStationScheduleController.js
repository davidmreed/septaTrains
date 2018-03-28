({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Train #', fieldName: 'trainNumber', type: 'string'},
            { label: 'Dest.', fieldName: 'destinationDisplayName', type: 'string'},
            { label: 'Departs', fieldName: 'departureTime', type: 'string'}
        ]);
        component.set('v.keyField', 'trainNumber');
        
        if (component.get('v.selectedEntity')) {
            helper.updateSchedule(component, event, helper);
            component.set('v.displayName', component.get('v.selectedEntity'));
        }
    },
    
    handleSelection : function(component, event, helper) {
        helper.updateSchedule(component, event, helper);
        component.set('v.displayName', component.get('v.selectedEntity'));
    }
})