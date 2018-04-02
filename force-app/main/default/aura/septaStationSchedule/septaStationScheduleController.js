({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Train #', fieldName: 'trainNumber', type: 'string'},
            { label: 'Destination', fieldName: 'destinationDisplayName', type: 'string'},
            { label: 'Departs', fieldName: 'departureTime', type: 'string'},
            { type: 'action', typeAttributes: { rowActions: [ { label: 'Show Train', name: 'showTrain' } ,
                                                              { label: 'Show Dest.', name: 'showDest'  } ] } }
        ]);
        component.set('v.keyField', 'trainNumber');
        component.find()
        
        if (component.get('v.selectedEntity')) {
            helper.updateSchedule(component, event, helper);
            component.set('v.displayName', component.get('v.selectedEntity'));
        }
    },
    
    handleSelection : function(component, event, helper) {
        helper.updateSchedule(component, event, helper);
        component.set('v.displayName', component.get('v.selectedEntity'));
    },

    handleRowEvent : function(component, event, helper) {
        var evt = component.getEvent('navigateEvent');

        if (event.getParam('action') === 'showTrain') {            
            evt.setParam('entity', { entity: event.getParam('row')['trainNumber'], type: 'TRAIN' });                    
        } else {
            evt.setParam('entity', { entity: event.getParam('row')['destinationDisplayName'], type: 'STATION' });                    
        }
        evt.fire();
    }
})