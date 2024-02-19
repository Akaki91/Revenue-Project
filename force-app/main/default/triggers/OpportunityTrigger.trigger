trigger OpportunityTrigger on Opportunity ( after update ) {
    Trigger_Config__mdt config = Trigger_Config__mdt.getInstance('Opportunity');
    
    if(!config.Is_Active__c){
		return;
	}
    
    if ( Trigger.isAfter ) {
        if(Trigger.isUpdate){
            OpportunityTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}