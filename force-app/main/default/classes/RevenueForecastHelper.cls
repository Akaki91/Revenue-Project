public with sharing class RevenueForecastHelper implements Queueable {
    private List<Id> oppIds;
    private Map<String, String> typeMap = new Map<String, String>{
        'Hardware' => 'One Time',
        'Software' => 'Monthly'
    };
    
    public RevenueForecastHelper( List<Id> oppIdList ) {      
        this.oppIds = oppIdList;
    }

    public void execute(QueueableContext context) {
        List<Revenue_Forecast__c> forecastList = new List<Revenue_Forecast__c>();
        List<Revenue_Line_Item__c> revenueList = new List<Revenue_Line_Item__c>();
        List<Revenue_Schedule__c> scheduleList = new List<Revenue_Schedule__c>();
        Map<Id, List<OpportunityLineItem>> oppProdMap = new Map<Id, List<OpportunityLineItem>>();
        Map<Id, Id> opportToForecast = new Map<Id, Id>();

        Map<Id, OpportunityLineItem> mapOpportunityProduct = new Map<Id, OpportunityLineItem>([
            SELECT Id, Product2Id, Product2.Family, OpportunityId, Quantity, UnitPrice 
            FROM OpportunityLineItem WHERE OpportunityId IN :this.oppIds
        ]);

        if (!mapOpportunityProduct.values().isEmpty()) {
            for (OpportunityLineItem oppProduct : mapOpportunityProduct.values()) {
                if (oppProdMap.get(oppProduct.OpportunityId) == null) {
                    oppProdMap.put(oppProduct.OpportunityId, new List<OpportunityLineItem>{oppProduct});
                } else {
                    oppProdMap.get(oppProduct.OpportunityId).add(oppProduct);
                }
            }

            for (Id oppId : oppProdMap.keySet()) {

                Revenue_Forecast__c forecast = new Revenue_Forecast__c (
                    Opportunity__c = oppId,
                    Revenue_Start_Date__c = System.Today().toStartOfMonth()
                );
        
                forecastList.add(forecast);
            }
            
            insert forecastList;

            for (Revenue_Forecast__c forcst : forecastList) {
                opportToForecast.put(forcst.Opportunity__c, forcst.Id);
            }

            for (OpportunityLineItem oppLineItem : mapOpportunityProduct.values()) {

                Revenue_Line_Item__c lineItem = new Revenue_Line_Item__c (
                    Revenue_Forecast__c = opportToForecast.get(oppLineItem.OpportunityId),
                    Opportunity_Product__c = oppLineItem.Id, 
                    Product__c = oppLineItem.Product2Id,
                    Revenue_Schedule_Type__c = this.typeMap.get(oppLineItem.Product2.Family),
                    Duration__c = 36
                );

                revenueList.add(lineItem);
            }

            insert revenueList;

            for (Revenue_Line_Item__c lineItem : revenueList) {
                Decimal salesPrice = mapOpportunityProduct.get(lineItem.Opportunity_Product__c).UnitPrice;
                Decimal quantity = mapOpportunityProduct.get(lineItem.Opportunity_Product__c).Quantity;
                 
                List<Revenue_Schedule__c> scheduled = CalculateRevenueSchedule.getRevenueSchedule(lineItem, salesPrice, quantity);
                scheduleList.addAll(scheduled);
            }

            for(Object key : map.keySet()) {
                Object item = map.get(key);
                
            }

            insert scheduleList;
        }
    }
        
}