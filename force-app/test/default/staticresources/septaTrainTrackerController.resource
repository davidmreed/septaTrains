describe('septaTrainTrackerController', function() {
    it("sets selected entity upon event receipt", function(done) {
        $T.createComponent("c:septaTrainTracker", {}, true)
        .then(function(component) {
            var event = component.find('mapView').getEvent("mapSelection");
            event.setParams({"entity": "TEST"});
            event.fire();

            expect(component.get("v.selectedEntity")).toBe("TEST");
            done();
        }).catch(function(e) {
            done.fail(e);
        });
    });

    it("updates the map view upon navigate", function(done) {
        $T.createComponent("c:septaTrainTracker", {}, true)
        .then(function(component) {
            spyOn(component.find('mapView'), 'selectEntity');

            var event = component.find('entitySelector').getEvent("navigateEvent");
            var entity = { "entity": "Suburban Station", "type": "STATION" };

            event.setParams({ "entity": entity });
            event.fire();

            expect(component.get("v.selectedEntity")).toEqual(entity);
            expect(component.find('mapView').selectEntity).toHaveBeenCalledWith('Suburban Station');
            done();
        }).catch(function(e) {
            done.fail(e);
        });
    });

});