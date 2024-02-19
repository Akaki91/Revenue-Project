public with sharing class CalculateRevenueSchedule {

    public static List<Revenue_Schedule__c> getRevenueSchedule (
        Revenue_Line_Item__c lineItem, 
        Decimal salesPrice, 
        Decimal quantity
        ) {

        List<Revenue_Schedule__c> revScheduleList = new List<Revenue_Schedule__c>();
        Integer monthCount = 0;

        if(lineItem.Revenue_Schedule_Type__c == 'Monthly') {
            monthCount = 1;
        }
        else if(lineItem.Revenue_Schedule_Type__c == 'Quarterly') {
            monthCount = 3;
        }
        else if(lineItem.Revenue_Schedule_Type__c == 'Half-Yearly') {
            monthCount = 6;
        }
        else if(lineItem.Revenue_Schedule_Type__c == 'Yearly') {
            monthCount = 12;
        }
        else if (lineItem.Revenue_Schedule_Type__c == 'One Time') {
            monthCount = lineItem.Duration__c.intValue();
        }

        for (Integer i = 0; i < lineItem.Duration__c; i++) {
            Date dt = System.Today().toStartOfMonth().addMonths(i);
            
            Revenue_Schedule__c schedule = new Revenue_Schedule__c (
                Revenue_Line_Item__c = lineItem.Id,
                Period_Number__c = i + 1,
                Revenue_Schedule_Date__c = dt,
                Price_Per_Unit__c = 0,
                Quantity__c	= 0
            );

            if (Math.Mod(i, monthCount) == 0) {
                schedule.Price_Per_Unit__c = salesPrice;
                schedule.Quantity__c = quantity;
            }

            revScheduleList.add(schedule);
        }

        return revScheduleList;

	}
}