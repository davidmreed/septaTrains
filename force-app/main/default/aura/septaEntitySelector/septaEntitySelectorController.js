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
        // Don't do anything if we change *to* null (otherwise we get recursion)
        if (event.getParam('value') != null) {
            var evt = component.getEvent('navigateEvent');
            var entity = component.get('v.selectedEntity');
            
            evt.setParam('entity', { entity: entity, type: (Number.isNaN(Number(entity)) ? 'STATION' : 'TRAIN') });                    
            evt.fire();

            // Reset ourselves and thereby the combo box.
            component.set('v.selectedEntity', null);
        }
    }
})
