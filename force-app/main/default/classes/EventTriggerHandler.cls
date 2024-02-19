public with sharing class EventTriggerHandler {
    
    public static void afterInsert(List<Opportunity_Change__e> newList) {
        createForecast(newList);
    }

    public static void createForecast(List<Opportunity_Change__e> newList) {
        List<Id> oppList = new List<Id>();

        for (Opportunity_Change__e event : newList) {
            oppList.add(event.Opportunity_Id__c);
        }

        if (!oppList.isEmpty()) {
            System.enqueueJob(new RevenueForecastHelper(oppList));
        }
    }
}