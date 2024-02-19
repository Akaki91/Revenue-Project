public with sharing class OpportunityTriggerHandler {
    
    public static void afterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        publishOppPlatformEvent(newList, oldMap);
    }

    public static void publishOppPlatformEvent(List<Opportunity> updatedOpps, Map<Id, Opportunity> oldOpps) {
        List<Opportunity_Change__e> oppEventList = new List<Opportunity_Change__e>();

        for (Opportunity newRecord : updatedOpps) {
            if ( newRecord.StageName == 'Closed Won' && newRecord.StageName != oldOpps.get(newRecord.Id).StageName){
                Opportunity_Change__e oppEvent = new Opportunity_Change__e(
                    Opportunity_Id__c = newRecord.Id
                );
                oppEventList.add(oppEvent);
            }
        }

        if (!oppEventList.isEmpty()) {
            EventBus.publish( oppEventList );
        }
    }

}