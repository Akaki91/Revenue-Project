public with sharing class RevenueForecastViewController {
    @AuraEnabled(cacheable=true)
    public static List<Revenue_Schedule__c> getRevenueSchedule() {

        List<Revenue_Schedule__c> scheduleList = [ SELECT Amount__c, Period_Number__c, Price_Per_Unit__c, 
            Quantity__c, Revenue_Schedule_Date__c, Revenue_Line_Item__c, Revenue_Line_Item__r.Product__r.Family
            FROM Revenue_Schedule__c];

        return scheduleList;
    }

}

