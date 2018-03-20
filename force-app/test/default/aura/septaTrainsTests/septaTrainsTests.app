<aura:application >

    <c:lts_jasmineRunner testFiles="{!join(',', 
        $Resource.septaTrainTrackerController,
        $Resource.septaEntitySelectorController
    )}" />

</aura:application>