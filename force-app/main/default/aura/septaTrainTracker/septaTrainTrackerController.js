({
    onMapSelect : function(component, event, helper) {
        component.set('v.selectedEntity', event.getParam('entity'));
    },

    onNavigate : function(component, event, helper) {
        var entity = event.getParam('entity');

        component.find('mapView').selectEntity(entity.entity);
        component.set('v.selectedEntity', entity);
    }
})