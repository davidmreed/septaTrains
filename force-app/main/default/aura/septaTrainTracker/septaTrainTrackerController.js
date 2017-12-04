({
    onMapSelect : function(component, event, helper) {
        component.set('v.selectedEntity', event.getParam('entity'));
    },
})