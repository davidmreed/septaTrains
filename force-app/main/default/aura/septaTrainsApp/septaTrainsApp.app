<aura:application extends="force:slds">
    <aura:attribute name="selectedEntity" type="Object" access="PUBLIC" />
    
    <aura:handler name="navigateEvent" event="c:navigateEvent" action="{! c.onSidebarNavigate }" />
    <aura:handler name="mapSelection" event="c:navigateEvent" action="{! c.onMapSelect }" />
        
    <lightning:layout horizontalAlign="spread" class="slds-grid slds-grid--frame">
        <lightning:layoutItem size="8" flexibility="grow">
        	<c:septaTrains aura:id="mapView" />
        </lightning:layoutItem>
        <lightning:layoutItem size="4">
            <c:septaScheduleSidebar selectedEntity="{! v.selectedEntity }" />
        </lightning:layoutItem>
    </lightning:layout>
    
</aura:application>