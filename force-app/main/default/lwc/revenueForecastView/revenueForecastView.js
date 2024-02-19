import { LightningElement, wire, track } from 'lwc';
import getData from '@salesforce/apex/RevenueForecastViewController.getRevenueSchedule';

export default class RevenueForecastView extends LightningElement {
    @track columns = [
        { label: 'Product', fieldName: 'product'},
        { label: 'Amount', fieldName: 'amount', type:'currency'},
        { label: 'Quantity', fieldName: 'quantity'},
        { label: 'Total Amount', fieldName: 'totalAmount', type:'currency'},
        { label: 'Total Quantity', fieldName: 'totalQuantity'}
    ];
    error;
    result;
    data;

    @wire(getData)
    wiredData({data, error}){
        if(data){
            this.result = data;
            this.processData(this.result)
        } else if(error){
            this.error = error;
        }
    }

    processData() {
        var data = {};
        var processedData = [];
        var columns = [];
        var acumulator = {}
        this.result.forEach(schedule => {
            let product = schedule.Revenue_Line_Item__r.Product__r.Family;
            if (acumulator[product] == null || acumulator[product].amount === 0) {
                acumulator[product] = {
                    id: schedule.Revenue_Line_Item__c,
                    amount: schedule.Amount__c,
                    quantity: schedule.Quantity__c
                }
            } else if(acumulator[product].id != schedule.Revenue_Line_Item__c) {
                acumulator[product].id = schedule.Revenue_Line_Item__c;
                acumulator[product].amount += schedule.Amount__c;
                acumulator[product].quantity += schedule.Quantity__c;
            }

            if (data[product] == null) {

                data[product] = {
                    amount: acumulator[product].amount,
                    quantity: acumulator[product].quantity,
                    totalAmount: schedule.Amount__c,
                    totalQuantity: schedule.Quantity__c,
                    dates: {
                        [schedule.Revenue_Schedule_Date__c]: schedule.Amount__c
                    }
                }   

            } else {
                data[product].amount = acumulator[product].amount,
                data[product].quantity = acumulator[product].quantity
                data[product].totalAmount += schedule.Amount__c;
                data[product].totalQuantity += schedule.Quantity__c;

                if (data[product].dates.hasOwnProperty([schedule.Revenue_Schedule_Date__c])) {
                    data[product].dates[schedule.Revenue_Schedule_Date__c] += schedule.Amount__c
                } else {
                    data[product].dates[schedule.Revenue_Schedule_Date__c] = schedule.Amount__c
                }        
            }
        });

        for (const key in data) {
            const element = data[key];
            let obj = {
                product: key,
                amount: element.amount,
                quantity: element.quantity,
                totalAmount: element.totalAmount,
                totalQuantity: element.totalQuantity
            }
            
            for (const k in element.dates)  {
                const amount = element.dates[k];

                columns.push({ 
                    label: k, fieldName: k, type: 'currency'
                })

                obj[k] = amount;
            }

            processedData.push(obj)
        }

        this.columns = [...this.columns, ...columns];
        processedData.push(this.calculateTotals(processedData));
        this.data = processedData;
        console.log(JSON.stringify(this.data));
    }

    calculateTotals(array) {
        var calc = {};

        array.forEach(element => {
            for (const x in element)  {
                if (calc.hasOwnProperty(x)) {
                    calc[x] += element[x];
                } else
                   calc[x] = element[x];
                }
        })

        calc.product = 'TOTAL';
        
        return calc;
    }

}