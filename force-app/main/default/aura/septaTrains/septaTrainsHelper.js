({
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
                     evt.setParam('type', 'STATION');
                    
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
    
    populateMap : function(component, helper, map) {        
        var e = component.get('c.getTrainPositions');
        e.setCallback(this, function(result) {
            if (result.getState() === 'SUCCESS') {
                for (var t of result.getReturnValue().positions) {
                    helper.createTrainMapMarker(component, t, map);
                }
            } else {
                // FIXME: handle error.
            }
        });
        
        $A.enqueueAction(e);

        for (var t of component.get('v.stationData')) {
            helper.createStationMapMarker(component, t, map);
        }

    }
})