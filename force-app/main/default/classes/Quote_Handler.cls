public class Quote_Handler {
    
    public static void UpdateOpportunitylineitem(list<Quotelineitem> triggernew){
        map<string,Quotelineitem> Auto_Number_QotelineItem = new  map<string,Quotelineitem>();
        for(Quotelineitem QLI:Triggernew){
            Auto_Number_QotelineItem.put(QLI.Auto_Number_QotelineItem__c,QLI);
        }
        list<OpportunitylineItem> UpdatelistofOpportunitylineItem = new list<OpportunitylineItem>();
        if(Auto_Number_QotelineItem.size()>0){
            for(opportunitylineitem opplineitem:[select id,Product2Id,Auto_Number_QotelineItem__c ,Principal__c,Discount_Amount__c,Margin_Amount__c,Unit_Price__c,UnitPrice,TotalPrice,Unit_of_Measure_UOM__c 
                                                 
                                                 from opportunitylineitem where Auto_Number_QotelineItem__c in:Auto_Number_QotelineItem.keyset()]){
                                                     if(opplineitem.Product2Id==Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).Product2Id && opplineitem.Auto_Number_QotelineItem__c==Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).Auto_Number_QotelineItem__c ){
                                                         //here we are using an auto number "Auto_Number_QotelineItem__c" to relate the quote line item with the opportunity line item 
                                                         opplineitem.Principal__c=Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).Principal2__c;
                                                         opplineitem.Discount_Amount__c=Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).Discount_Amount2__c;
                                                         opplineitem.Margin_Amount__c=Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).Margin_Amount2__c;
                                                         opplineitem.Unit_Price__c=Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).Unit_Price__c;
                                                         opplineitem.UnitPrice=Auto_Number_QotelineItem.get(opplineitem.Auto_Number_QotelineItem__c).UnitPrice;
                                                         UpdatelistofOpportunitylineItem.add(opplineitem);
                                                     }
                                                 }
        }
        if(UpdatelistofOpportunitylineItem.size()>0){
            //update UpdatelistofOpportunitylineItem;
        }
    }
}