({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Station', fieldName: 'destinationDisplayName', type: 'string'},
            { label: 'Est. Time', fieldName: 'arrivalTime', type: 'string'},
            { type: 'action', typeAttributes: { rowActions: [ { label: 'Show Station', name: 'showDest'  } ] } }

        ]);
        component.set('v.keyField', 'destinationDisplayName');        
        if (component.get('v.selectedEntity')) {
            helper.updateSchedule(component, event, helper);
        }
    },
    
    handleSelection : function(component, event, helper) {
        helper.updateSchedule(component, event, helper);
    },

    handleRowEvent : function(component, event, helper) {
        var evt = component.getEvent('navigateEvent');

        evt.setParam('entity', { entity: event.getParam('row')['destinationDisplayName'], type: 'STATION' });                    
        evt.fire();
    }
})