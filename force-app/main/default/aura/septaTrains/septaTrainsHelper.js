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

        title = 'Train #' + data.trainno + ' (' + data.line + ')';
        body = '<p>' +
               '<strong>Train #' + data.trainno + '</strong>' +
               '<br /><span style="text-transform: capitalize;">' + data.service.toLowerCase() + '</span> ' +
               data.consist.split(',').length + '-car train' +
               ' from <strong>' + data.sourceDisplayName + 
               '</strong> to <strong>' + data.destDisplayName + '</strong>, ' +
               'running on the <strong>' + data.line + '</strong> line' +
               '<br />' + 'Next stop <strong>' + data.nextstopDisplayName + '</strong>' +
               '<br />' + (data.late != 0 ? ('<span style="color: red;">' + 
               data.late + ' minute' + (data.late == 1 ? '' : 's') + ' late</span>') : 'On time') +
               '</p>';
        
        m = L.marker([data.lat, data.lon], {'title': title })
             .bindPopup(body)
             .addTo(map)
             .on('popupopen', function(e) {
                var evt = component.getEvent('mapSelection');
            
                evt.setParam('entity', { entity: data.trainno, type: 'TRAIN', data: data });
                evt.fire();
            });
        
        component.get('v.popupStore')[data.trainno] = m;
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