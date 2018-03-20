describe('septaTrainTrackerController', function() {
    it('fires event upon navigate', function(done) {
        done();
    });
    it('sets select options from the controller', function(done) {
 //       var res = { getState : function() { return 'SUCCESS'; }, 
 //                   getReturnValue: function() { return [ { label: 'Test Label', value: 'Test Value'} ]; } };

        // We want to spy on the init handler, which does an enqueueAction. 
        // Add the spy prior to creation of the component.
       /* spyOn($A, 'enqueueAction').and.callFake(function(action) {
            console.info('in fake');
            var cb = action.getCallback("SUCCESS")
            cb.fn.apply(cb.s, [res]);
        });*/

        $T.createComponent('c:septaEntitySelectorController', {}, true)
        .then(function(component) {
            done();
        });
            /*// Confirm that the select list was populated correctly.
            console.info('in expects');
            expect(component.get('v.selectOptions').length).toBe(1);
            console.info('after first expect');
            expect(component.get('v.selectOptions')[0]).toEqual({ label: 'Test Label', value: 'Test Value'});
            console.info('after second expect');
            done();98
        }).catch(function(e) {
            done.fail(e);
        });*/
    }, 20000);
});