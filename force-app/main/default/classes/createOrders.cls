/*****************************
* Name             : createOrders
* Description      : This class creates Order and orderLineItem when opportunity is stage status is closed won.
* Author           : Absyz
* LastModified     : 22/March/2018
*********************************/
public class createOrders {
    
    /************************************************************
* MethodName            : insertOrder
* Description           : Creates order and orderLineItem     
* Input Parameters      : map < id, Opportunity > and List < Opportunity >
* Return                : N/A
************************************************************/   
    public static void insertOrder(map < id, Opportunity > oldOpportunityMap, List < Opportunity > oppList)
    {
        
        Set<Id> oppIdSet = new Set<Id>(); //set of Opportunity Id
        List<Order> ordList = new List<Order>(); //List of inserted orders
        Decimal unitPriceVar; //variable to hold unit price 
        Decimal discountVar; //Variable to hold discount
        Map<Id,Opportunity> optyMap = new Map<Id, Opportunity>();
        Map<Id, QuoteLineItem> QliMap= new Map<Id, QuoteLineItem>();
        for(Opportunity op: oppList){
            
            if(op.StageName == 'Closed Won' && op.StageName!=oldOpportunityMap.get(op.Id).StageName){
                optyMap.put(op.id, op);
            }
        }
        for(QuoteLineItem qli : [Select Tax__c,FinalMarginValue__c,ProductDescription__c,TotalDiscount__c,CostPrice__c,Quote.Quote_Item_Total_Price__c,Quote.TotalMarginValue__c, CustomerPartNumber__c,PrincipalPartNumber__c,Quote.OpportunityId,Quote.Opportunity.ProductFamilyName__c from QuoteLineItem where Quote.OpportunityId IN:optyMap.keySet() AND IsChecked__c= true AND IsOptional__c = false ]){
            QliMap.put(qli.Quote.OpportunityId, qli);
        }
        System.debug('QliMap '+QliMap);
        
        
        //iterating trigger.new
        for(Opportunity oppRec: oppList) {
            //if the opportunity stage name is changed from other value to close won
            if((oppRec.StageName.equals('Closed Won') && Trigger.isInsert) || (Trigger.isUpdate && opprec.StageName!= oldOpportunityMap.get(oppRec.Id).StageName && oppRec.StageName.equals('Closed Won')))
            {                                        
                if(oppRec.AccountId != null)
                {
                    //create order from opportunity details
                    oppIdSet.add(oppRec.Id); //get the Id of opportunity record 
                    Order ordRec= new Order();
                    ordRec.OpportunityId = oppRec.Id;
                    //System.debug('PF '+QliMap.get(oppRec.Id).Quote.Opportunity.ProductFamilyName__c);
                    //ordRec.Tax__c = QliMap.get(oppRec.Id).Tax__c;
                    ordRec.MarginValue__c = QliMap.get(oppRec.Id).Quote.TotalMarginValue__c;
                    
                    //ordRec.ProductDescription__c = QliMap.get(oppRec.Id).ProductDescription__c;
                    //ordRec.CustomerPartNumber__c = QliMap.get(oppRec.Id).CustomerPartNumber__c;
                    //ordRec.PrincipalPartNumber__c = QliMap.get(oppRec.Id).PrincipalPartNumber__c;
                    //ordRec.ProductFamily__c = QliMap.get(oppRec.Id).Quote.Opportunity.ProductFamilyName__c;
                    //ordRec.UnitPrice__c = QliMap.get(oppRec.Id).CostPrice__c;
                    ordRec.QuoteId =oppRec.SyncedQuoteId;
                    ordRec.AccountId = oppRec.AccountId;
                    //ordRec.EndDate=system.Today()+30;
                    ordRec.EffectiveDate =system.Today();
                    ordRec.Status= 'Draft';
                    ordRec.Process_Type__c=opprec.Quote_Process_Type__c;
                    ordRec.Quote_Type__c=opprec.Quote_Type__c;
                    ordRec.Company_Type__c=opprec.Quote_Company_Name__c;
                    //ordRec.Description=opprec.Description;
                    ordRec.Pricebook2Id = oppRec.Pricebook2Id;
                    ordRec.CurrencyIsoCode=oppRec.CurrencyIsoCode;
                    //ordRec.Handling_Price__c=oppRec.Handling_Price__c;
                    ordRec.Principal_Name__c=oppRec.Quote_Principal_Name__c;
                    //ordRec.Taxes_CGST_Amount__c=oppRec.Quote_Taxes_CGST_Amount__c;
                    //ordRec.Taxes_CGST_Percentage__c=oppRec.Quote_Taxes_CGST_Percentage__c;
                    //ordRec.Taxes_IGST_Amount__c=oppRec.Quote_Taxes_IGST_Amount__c;
                    //ordRec.Taxes_IGST_Percentage__c=oppRec.Quote_Taxes_IGST_Percentage__c;
                    //ordRec.Taxes_SGST_Amount__c=oppRec.Quote_Taxes_SGST_Amount__c;
                    ///ordRec.Taxes_SGST_Percentage__c=oppRec.Quote_Taxes_SGST_Percentage__c;
                    //ordRec.Discount_Amount__c=oppRec.Quote_Discount_Amount__c;
                    ordRec.Grand_Total__C=oppRec.Quote_Grand_Total__c;
                    //ordRec.TotalAmount=oppRec.Quote_Final_Price__c;
                    ordList.add(ordRec);
                }
            }
        }
        
        //Check list size
        if(!ordList.isEmpty()) {
            
            insert ordList; //insert order record
            
            system.debug('inserted'+ordList);
            //system.debug('');
            Map<Id, Order> ordMap = new Map<Id, Order>(); //map to have opportunity Id as a key and order record as a value
            List<OrderItem> oiList = new List<OrderItem>();//list of inserted orderlineItem
            
            //iterate over inserted orders
            for(Order ord: ordList) {
                ordMap.put(ord.OpportunityId, ord); //put opportunity Id as a key and order record as a value
            }
            
            //get the opportunityLineItem of opportunity which is in oppIdSet 
            System.debug('oppIdSet '+oppIdSet);
            for(Opportunity opp: [Select Id, AccountId, CloseDate ,(select Id, Name,FinalPrice2__c,cgst__c,sgst__c,igst__c,tax__c,CustomerPartNumber__c,PrincipalPartNumber__c, ProductCode, Pack_Size__c,Unit_of_Measure_UOM__c,Quantity, PricebookEntryId, UnitPrice,TotalPrice,Discount,TotalDiscount__c, OpportunityId,Description,Product_Description__c,Product_Code_f__c,Principal__r.Name,Discount_Amount__c,Final_Price__c,Handling_Price__c,Margin_Amount__c,Principal__c from OpportunityLineItems Where isChecked__c= true AND isOptional__c = false) from Opportunity where Id IN: oppIdSet]) 
            {
                System.debug('opp--'+opp.OpportunityLineItems);
                //get the opportunityLineItem of opportunity
                for(OpportunityLineItem oli: opp.OpportunityLineItems) 
                {
                    //Create orderLineItem with opportunityLineItem details
                    OrderItem oi = new OrderItem();
                    oi.OrderId = ordMap.get(opp.Id).Id;
                    oi.Quantity = oli.Quantity;
                    oi.PricebookEntryId = oli.PricebookEntryId;
                    //oi.unitPriceVar=oli.UnitPrice;
                    //discountVar=oli.Discount;
                    oi.UnitPrice =oli.UnitPrice;
                    oi.Discount__c=oli.TotalDiscount__c;
                    //oi.Description=oli.Description;
                    //oi.TotalPrice=oli.TotalPrice;
                    oi.Product_Code__c= oli.Product_Code_f__c;
                    //oi.Description=oli.Product_Description__c;
    //****** while deploying this class to production, please change the below field to oli.principal__r.Name..since it is a text field in prod.****
                    oi.Principal__c=oli.principal__r.Name;
                    oi.Unit_of_Measure_UOM__c =oli.Unit_of_Measure_UOM__c;
                    oi.Pack_Size__c=oli.Pack_Size__c;
                    //oi.Stage__c='Order Sent';
                    oi.Margin_Amount__c=oli.Margin_Amount__c;
                    oi.Discount_Amount__c=oli.Discount_Amount__c;
                    oi.Final_Price__c=oli.FinalPrice2__c;
                    oi.cgst__c = oli.cgst__c;
                    oi.sgst__c = oli.sgst__c;
                    oi.igst__c = oli.igst__c;
                    oi.Tax__c = oli.tax__c;
                    oi.Description = oli.Description;
                    oi.CustomerPartNumber__c = oli.CustomerPartNumber__c;
                    oi.PrincipalPartNumber__c = oli.PrincipalPartNumber__c;
                    oi.Handling_Price__c=oli.Handling_Price__c;
                    oi.Pack_Size2__c = oli.Unit_of_Measure_UOM__c;
                    
                    oiList.add(oi);
                }
            }
            
            if(!oiList.isEmpty()) {
                insert oiList;
                system.debug(oiList);
            }
        }
    }
    /*
public static void productFamilyValidation(map <id,Opportunity> oldOpportunityMap, List <Opportunity> NewOppList){

for(Opportunity Opp : NewOppList){
String NewProductFamily = Opp.ProductFamilyId__c;
String[] NewFamily = NewProductFamily.split(',');

String OldProductFamily = oldOpportunityMap.get(Opp.Id).ProductFamilyId__c;
String[] OldFamily = OldProductFamily.split(',');

for(String OldF : OldFamily){
if(!NewFamily.contains(OldF))
Opp.addError('Can Not DeActivate The Activated Product Family.');
}
}
}
*/
}