({
	onMapSelect : function(component, event, helper) {
        component.set('v.selectedType', event.getParam('type'));
        component.set('v.selectedEntity', event.getParam('entity'));
	},
    
    onSidebarNavigate : function(component, event, helper) {
		component.find('mapView').selectEntity(event.getParam('entity'));
    }

})