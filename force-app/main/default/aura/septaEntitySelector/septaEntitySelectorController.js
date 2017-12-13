({
    doInit : function(component, event, helper) {
        var action = component.get('c.getSelectOptions');

        action.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                component.set('v.statusOptions', result.getReturnValue());
            }
        });

        $A.enqueueAction(action);
    },

    handleComboNavigate : function(component, event, helper) {
        var evt = component.getEvent('navigateEvent');
        var entity = event.getParam('value');
        
        evt.setParam('entity', { entity: entity, type: (Number.isNaN(Number(entity)) ? 'STATION' : 'TRAIN') });                    
        evt.fire();

        event.getSource().set('v.value', null);
    }
})
