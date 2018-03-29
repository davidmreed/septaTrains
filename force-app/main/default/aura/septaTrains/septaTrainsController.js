({
	doInit : function(component, event, helper) {
        component.set('v.popupStore', {});
        helper.loadStationData(component, event, helper);
        helper.loadPositionData(component, event, helper);

        var interval = window.setInterval(
            $A.getCallback(function() {
                component.reload();
            }), 60000
        );

        component.set('v.refreshTimer', interval);
	},
    
    onScriptsLoaded : function(component, event, helper) {
        var m = L.map(component.find('map').getElement(), {zoomControl: true,zoom:1,zoomAnimation:false,fadeAnimation:true,markerZoomAnimation:true}).setView([39.9537069, -75.1649369], 11);
        L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
    		attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>, &copy; <a href="https://carto.com/attribution">CARTO</a>'
        }).addTo(m);
        component.set('v.map', m);
        helper.checkLoadingProgress(component, event, helper);
    },
    
    doSelectEntity : function(component, event, helper) {
        var store = component.get('v.popupStore');
        var marker = store[event.getParam('arguments').entity];
        var map = component.get('v.map');

        if (marker) {
            map.panTo(marker.getLatLng());
            marker.openPopup();
        }
    },

    reload : function(component, event, helper) {
        if (!component.get('v.loading')) {
            component.set('v.loading', true);
            helper.clearTrainPositions(component);
            helper.loadPositionData(component, event, helper);
        }
    }
})