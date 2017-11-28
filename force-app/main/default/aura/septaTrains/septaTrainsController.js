({
	doInit : function(component, event, helper) {
        component.set('v.popupStore', {});
	},
    
    onScriptsLoaded : function(component, event, helper) {
        var m = L.map(component.find('map').getElement()).setView([39.9537069, -75.1649369], 11);
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
    		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, &copy; <a href="https://carto.com/attribution">CARTO</a>'
        }).addTo(m);
        component.set('v.map', m);

        var call = component.get('c.loadData');
        call.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                component.set('v.stationData', result.getReturnValue());

                helper.populateMap(component, helper, m);                
            } else {
                // FIXME: handle error.
            }
        });

        $A.enqueueAction(call);
    },
    
    doSelectEntity : function(component, event, helper) {
        var store = component.get('popupStore');
        var popup = store.get(event.getParam('entity'));
        
        if (popup) {
            popup.openPopup();
        }
    }
})