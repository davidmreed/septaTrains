({
    checkLoadingProgress : function(component, event, helper) {
        if (component.get('v.loading')) {
            if (!($A.util.isEmpty(component.get('v.map')) 
                  || $A.util.isEmpty(component.get('v.stationData'))
                  || $A.util.isEmpty(component.get('v.positions')))) {
                helper.populateMapStations(component, helper, component.get('v.map'));
                helper.populateMapTrains(component, helper, component.get('v.map'));
                component.set('v.loading', false);
            }
        }
    },
    
    loadStationData : function(component, event, helper) {
        var call = component.get('c.loadData');
        call.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                component.set('v.stationData', result.getReturnValue());
                helper.checkLoadingProgress(component, event, helper);
            } else {
                // FIXME: handle error.
            }
        });
        
        $A.enqueueAction(call);
    },
    
    loadPositionData : function(component, event, helper) {
        var call = component.get('c.getTrainPositions');
        call.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                component.set('v.positions', result.getReturnValue().positions);
                helper.checkLoadingProgress(component, event, helper);
            } else {
                // FIXME: handle error.
            }
        });
        
        $A.enqueueAction(call);
    },
    
    clearMap : function(map) {
        map.eachLayer(function(layer) {
            map.removeLayer(layer);
        });
	},
    
    createStationMapMarker: function(component, data, map) {
        var m = L.marker([data.lat, data.lng], 
                         {'title': data.name + ' (' + data.line + ')',
                          'icon': L.divIcon()})
                 .addTo(map)
                 .on('click', function(e) {
                     var evt = component.getEvent('mapSelection');
                    
                     evt.setParam('entity', { entity: data.name, type: 'STATION', data: data });                    
                     evt.fire();
                 });
        
        component.get('v.popupStore')[data.name] = m;
    },
    
    createTrainMapMarker: function(component, data, map) {
        var title, m, body;

        title = 'Train #' + data.trainNumber + ' (' + data.line + ')';
        body = '<p>' +
               '<strong>Train #' + data.trainNumber + '</strong>' +
               '<br /><span style="text-transform: capitalize;">' + data.service.toLowerCase() + '</span> ' +
               data.cars.length + '-car train' +
               ' from <strong>' + data.sourceDisplayName + 
               '</strong> to <strong>' + data.destinationDisplayName + '</strong>, ' +
               'running on the <strong>' + data.line + '</strong> line' +
               '<br />' + 'Next stop <strong>' + data.nextStopDisplayName + '</strong>' +
               '<br />' + (data.minutesLate != 0 ? ('<span style="color: red;">' + 
               data.minutesLate + ' minute' + (data.minutesLate == 1 ? '' : 's') + ' late</span>') : 'On time') +
               '</p>';
        
        m = L.marker([data.lat, data.lng], {'title': title })
             .bindPopup(body)
             .addTo(map)
             .on('popupopen', function(e) {
                var evt = component.getEvent('mapSelection');
            
                evt.setParam('entity', { entity: data.trainNumber, type: 'TRAIN', data: data });
                evt.fire();
            });
        
        component.get('v.popupStore')[data.trainNumber] = m;
    },
    
    populateMapStations : function(component, helper, map) {
        for (var t of component.get('v.stationData')) {
            helper.createStationMapMarker(component, t, map);
        }
    },
    
    populateMapTrains : function(component, helper, map) {
        for (var t of component.get('v.positions')) {
            helper.createTrainMapMarker(component, t, map);
        }
    }
})