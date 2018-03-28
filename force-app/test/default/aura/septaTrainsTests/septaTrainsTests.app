<aura:application >

    <c:lts_jasmineRunner testFiles="{!join(',', 
        $Resource.septaTrainTrackerController,
        $Resource.septaStationScheduleController,
        $Resource.septaScheduleSidebarController,
        $Resource.septaEntitySelectorController
    )}" />

</aura:application>