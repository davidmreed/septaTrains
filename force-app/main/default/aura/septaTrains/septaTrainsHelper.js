({
	clearMap : function(map) {
        map.eachLayer(function(layer) {
            map.removeLayer(layer);
        });
	},
    
    createStationMapMarker: function(component, data, map) {
        var m = L.marker([data['lat'], data['long']],
                         {'title': data['name'] + ' (' + data['line'] + ')',
                          'icon': L.divIcon()}).addTo(map);
        m.on('click', function(e) {
            var evt = component.getEvent('mapSelection');
            
            evt.setParam('entity', { entity: data['name'], type: 'STATION', data: data });
            evt.setParam('type', 'STATION');
            
            evt.fire();
        });
        
        component.get('v.popupStore')[data['name']] = m;
    },
    
    createTrainMapMarker: function(component, data, map) {
        var m = L.marker([data['lat'], data['lon']],
                         {'title': 'Train #' + data['trainno'] + ' (' + data['line'] + ')' })
            .bindPopup('<p>' +
                '<strong>Train #' + data['trainno'] + '</strong>' +
                       '<br /><span style="text-transform: capitalize;">' + data['service'].toLowerCase() + '</span> ' +
                       data['consist'].split(',').length + '-car train' +
                       ' from <strong>' + septaStationMapper.convert_api(data['SOURCE']) + 
                       '</strong> to <strong>' + septaStationMapper.convert_api(data['dest']) + '</strong>, ' +
                'running on the <strong>' + data['line'] + '</strong> line' +
                '<br />' + 'Next stop <strong>' + septaStationMapper.convert_api(data['nextstop']) + '</strong>' +
                       '<br />' + (data['late'] != 0 ? ('<span style="color: red;">' + data['late'] + ' minute' + (data['late'] == 1 ? '' : 's') + ' late</span>') : 'On time') +
                       '</p>'
        ).addTo(map);
        
        m.on('popupopen', function(e) {
            var evt = component.getEvent('mapSelection');
            
            evt.setParam('entity', { entity: data['trainno'], type: 'TRAIN', data: data });
            
            evt.fire();
        });
        
        component.get('v.popupStore')[data['trainno']] = m;
    },
    
    populateMap : function(component, helper, map) {        
        var e = component.get('c.callSEPTA');
        e.setCallback(this, function(result) {
            var j = JSON.parse(result.getReturnValue());

            for (var t of j) {
    			helper.createTrainMapMarker(component, t, map);
			}
        });
        
        $A.enqueueAction(e);

        for (var t of septaStationLocations) {
            helper.createStationMapMarker(component, t, map);
        }

    }
})