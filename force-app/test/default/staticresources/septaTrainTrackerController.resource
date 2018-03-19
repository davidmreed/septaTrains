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

            var event = component.find('sidebar').find.getEvent("navigateEvent");
            event.setParams({"entity": "TEST"});
            event.fire();

            expect(component.get("v.selectedEntity")).toBe("TEST");
            expect(component.find('mapView').selectEntity).toHaveBeenCalledWith('TEST');
            done();
        }).catch(function(e) {
            done.fail(e);
        });
    });
});