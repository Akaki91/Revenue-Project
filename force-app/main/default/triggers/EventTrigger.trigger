trigger EventTrigger on Opportunity_Change__e (after insert) {

    if ( Trigger.isAfter ) {
        if(Trigger.isInsert){
            EventTriggerHandler.afterInsert(Trigger.new);
        }
    }

}