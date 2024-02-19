// Trigger_Config__mdt triggerConfig = Trigger_Config__mdt.getInstance('Opportunity');

// System.debug(mtdt.Is_Active__c);

// List<Opportunity_Change__e> oppUpdateEventList = new List<Opportunity_Change__e>();

// Opportunity_Change__e oppUpd = new Opportunity_Change__e(
//     Opportunity_Id__c = '006ao000000dnvmAAA'
// );

// oppUpdateEventList.add(oppUpd);

// System.debug(oppUpdateEventList);

// EventBus.publish( oppUpdateEventList );


// date firstDate = System.Today().toStartOfMonth();

// System.debug(firstDate);


// List<OpportunityLineItem> oppProductList = [
//             SELECT Id, Product2Id, Product2.Family FROM OpportunityLineItem 
//             WHERE OpportunityId = '006ao000000dnvZAAQ'];

// for (OpportunityLineItem lineItem : oppProductList) {
//     System.debug(lineItem.Product2.Family);
// }
// List<Date> dateList = new List<Date>();

// for (Integer i = 0; i < 5; i++) {
//     Date dt = System.Today().toStartOfMonth().addMonths(i);
//     dateList.add(dt);
// }


// System.debug(dateList);

