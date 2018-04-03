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
    
    clearTrainPositions : function(component) {
        var map = component.get('v.map');
        var store = component.get('v.popupStore');

        for (const name in store) {
            store[name].remove();
            delete store[name];
        }
	},
    
    createStationMapMarker: function(component, data, map) {
        var m = L.marker([data.lat, data.lng], 
                         {'title': data.name + ' (' + data.line + ')',
                          'icon': L.divIcon()})
                 .bindPopup('<strong>'+ data.name + '</strong>' + ' (' + data.line + ')')
                 .addTo(map)
                 .on('click', function(e) {
                     var evt = component.getEvent('mapSelection');
                    
                     evt.setParam('entity', { entity: data.name, type: 'STATION', data: data });                    
                     evt.fire();
                 });
        
        component.get('v.popupStore')[data.name] = m;
    },
    
    createTrainMapMarker: function(component, data, map) {
        var elem, m, body;

        elem = 'Train #' + data.trainNumber + ' (' + data.line + ')';
        body = document.createElement('p');
        elem = document.createElement('strong');
        elem.appendChild(document.createTextNode('Train #' + data.trainNumber));
        body.appendChild(elem);
        body.appendChild(document.createElement('br'));
        elem = document.createElement('span');
        elem.appendChild(document.createTextNode(data.service.toLowerCase()));
        elem.setAttribute('style', 'text-transform: capitalize;');
        body.appendChild(elem);
        body.appendChild(document.createTextNode(' ' +data.cars.length + '-car train from '));
        elem = document.createElement('strong');
        elem.appendChild(document.createTextNode(data.sourceDisplayName));
        elem.addEventListener('click', function() {
            component.selectEntity(data.sourceDisplayName);

            var evt = component.getEvent('mapSelection');
            
            evt.setParam('entity', { entity: data.sourceDisplayName, type: 'STATION', data: data });
            evt.fire();
        })
        body.appendChild(elem);
        body.appendChild(document.createTextNode(' to '));
        elem = document.createElement('strong');
        elem.appendChild(document.createTextNode(data.destinationDisplayName));
        elem.addEventListener('click', function() {
            component.selectEntity(data.destinationDisplayName);

            var evt = component.getEvent('mapSelection');
            
            evt.setParam('entity', { entity: data.destinationDisplayName, type: 'STATION', data: data });
            evt.fire();
        })
        body.appendChild(elem);
        body.appendChild(document.createTextNode(', running on the '));
        elem = document.createElement('strong');
        elem.appendChild(document.createTextNode(data.line));
        body.appendChild(elem);
        body.appendChild(document.createTextNode(' line.'));
        body.appendChild(document.createElement('br'));
        body.appendChild(document.createTextNode('Next stop '));
        elem = document.createElement('strong');
        elem.appendChild(document.createTextNode(data.nextStopDisplayName));
        elem.addEventListener('click', function() {
            component.selectEntity(data.nextStopDisplayName);

            var evt = component.getEvent('mapSelection');
            
            evt.setParam('entity', { entity: data.nextStopDisplayName, type: 'STATION', data: data });
            evt.fire();
        })
        body.appendChild(elem);
        body.appendChild(document.createElement('br'));
        if (data.minutesLate != 0) {
            elem = document.createElement('span');
            elem.appendChild(document.createTextNode(data.minutesLate + ' minute' + (data.minutesLate == 1 ? '' : 's') + ' late'));
            elem.setAttribute('style', 'color: red;');            
            body.appendChild(elem);
        } else {
            body.appendChild(document.createTextNode('On time'));
        }
        
        m = L.marker([data.lat, data.lng], {'title': 'Train #' + data.trainNumber })
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