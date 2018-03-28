describe('septaScheduleSidebarController', function() {
    it("sets selected entity upon event receipt", function(done) {
        spyOn($A, 'enqueueAction').and.stub();
        $T.createComponent("c:septaScheduleSidebar", {}, true)
        .then(function(component) {
            component.set('v.selectedEntity', { type: 'TRAIN', entity: '100'});
            expect(component.get('v.selectedTrain')).toBe('100');
            expect(component.get('v.selectedStation')).toBe(null);

            component.set('v.selectedEntity', { type: 'STATION', entity: 'Main Street Station'});
            expect(component.get('v.selectedTrain')).toBe(null);
            expect(component.get('v.selectedStation')).toBe('Main Street Station');

            done();
        }).catch(function(e) {
            done.fail(e);
        });
    });
});
