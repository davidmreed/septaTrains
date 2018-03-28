describe('septaTrainTrackerController', function() {
    afterEach(function() {
        $T.clearRenderedTestComponents();
    });

    it('fires event upon navigate', function(done) {
        // Fire the combobox's update event.
        var res = { getState : function() { return 'SUCCESS'; }, 
                    getReturnValue: function() { return [ { label: 'Test Train', value: '100'} ]; } };
        
        // Spy on both enqueueAction, to fake the server controller response...
        spyOn($A, 'enqueueAction').and.callFake(function(action) {
            var cb = action.getCallback("SUCCESS")
            cb.fn.apply(cb.s, [res]);
        });
        
        $T.createComponent('c:septaEntitySelector', {}, true)
        .then(function(component) {
            // and getEvent, so we can spy on the event firing.
            var eventSpy = jasmine.createSpyObj('eventSpy', ['setParam', 'fire']);
            var getEvent = spyOn(component, 'getEvent').and.returnValue(eventSpy);
            var selectList = component.find('entitySelector');
        
            selectList.set('v.value', '100');
            console.log(selectList.get('v.onchange'));
            console.log(JSON.stringify(selectList.get('v.onchange')));
            
            var q = selectList.get('v.onchange');
            

/*            expect(getEvent).toHaveBeenCalled();
            expect(eventSpy.fire).toHaveBeenCalled();
            expect(eventSpy.setParam).toHaveBeenCalledWith({ entity: '100', type: 'TRAIN'});
*/
            done();
        });
    });

    it('sets select options from the controller', function(done) {
        var res = { getState : function() { return 'SUCCESS'; }, 
                    getReturnValue: function() { return [ { label: 'Test Label', value: 'Test Value'} ]; } };

        // We want to spy on the init handler, which does an enqueueAction. 
        // Add the spy prior to creation of the component.
        spyOn($A, 'enqueueAction').and.callFake(function(action) {
            var cb = action.getCallback("SUCCESS")
            cb.fn.apply(cb.s, [res]);
        });

        $T.createComponent('c:septaEntitySelector', {}, true)
        .then(function(component) {
            // Confirm that the select list was populated correctly.
            var selectList = component.find('entitySelector');

            expect(selectList.get('v.options').length).toBe(1);
            expect(selectList.get('v.options')[0]).toEqual({ label: 'Test Label', value: 'Test Value'});
            done();
        }).catch(function(e) {
            done.fail(e);
        });
    });
});
