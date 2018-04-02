({
    handleNavigateClick : function(component, event, helper) {
        var evt = component.getEvent('rowHandlerEvent');

        evt.setParam('row', event.getParam('row'));
        evt.setParam('action', event.getParam('action').name);

        evt.fire();
    }
})