({
    doInit : function(component, event, helper) {
        component.set('v.columns', [
            { label: 'Station', fieldName: 'station', type: 'string'},
            { label: 'Est. Time', fieldName: 'est_tm', type: 'string'}
        ]);
    },
    
    handleSelection : function(component, event, helper) {
        helper.updateSchedule(component, event, helper);
    }
})