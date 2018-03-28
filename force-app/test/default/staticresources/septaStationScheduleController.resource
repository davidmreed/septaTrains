describe('septaStationScheduleController', function() {
    afterEach(function() {
        $T.clearRenderedTestComponents();
    });

    it("sets schedule and display name upon selection", function(done) {
        var res = { 
                      getState : function() { return 'SUCCESS'; }, 
                      getReturnValue: function() { 
                          return { timetable: [ { trainNumber: '100', destinationDisplayName: 'Wawa', departureTime: '10:00 am' } ] }; 
                      } 
                  };

        spyOn($A, 'enqueueAction').and.callFake(function(action) {
            var cb = action.getCallback("SUCCESS")
            cb.fn.apply(cb.s, [res]);
        });

        $T.createComponent("c:septaStationSchedule", {}, true)
        .then(function(component) {
            component.set('v.selectedEntity', 'Main Street Station');

            expect(component.get('v.displayName')).toBe('Main Street Station');
            expect(component.get('v.timetable')).toEqual([ { trainNumber: '100', destinationDisplayName: 'Wawa', departureTime: '10:00 am' } ]);

            done();
        }).catch(function(e) {
            done.fail(e);
        });
    });
});
