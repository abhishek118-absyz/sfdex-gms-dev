public class InsertQuoteLineItemsComp_Controller {
    
    @AuraEnabled
    public static WrapperClass2 getQuoteStatus(Id quoteId){
        WrapperClass2 WrapperClass2Var = new WrapperClass2();
        WrapperClass2Var.qStatus = [SELECT Id, Status FROM Quote WHERE Id= :quoteId].Status;
        //String quoteStatus = [SELECT Id, Status FROM Quote WHERE Id= :quoteId].Status;
        
        WrapperClass2Var.existingQuoteLineItems = [SELECT CalculationType__c,Tax__c, Product2Id,Product2.Name,IsChecked__c,Quantity,IsOptional__c,Principal2__c,UOM__c,CostPrice__c,
                                                   ProductDescription__c,CostPriceDiscount__c,CostPriceDiscountValue__c,MarginPercent__c,Margin_Amount2__c,MarginDiscountPercent__c,
                                                   MarginDiscountValue__c,UnitPrice,Discount_Amount2__c,TotalDiscount__c,FinalMarginValue__c,Final_Price2__c,CustomerPartNumber__c,
                                                   PrincipalPartNumber__c,Unit_of_Measure_UOM2__c, Principal_Quote_Reference__c,
                                                   CGST__c, SGST__c, IGST__c
                                                   FROM QuoteLineItem 
                                                   WHERE QuoteId =: quoteId];
        
        
        return WrapperClass2Var;
        //return quoteStatus;
    }
    
    public class WrapperClass2{
        @AuraEnabled
        public List<QuoteLineItem> existingQuoteLineItems{get; set;}
        @AuraEnabled
        public String qStatus{get; set;}
    }
    
    @AuraEnabled
    public static WrapperClass getProductDetails(Id prodId, String oppCurrency){
        //System.debug('Input parameters -->>prodId-->>'+prodId);
        WrapperClass WrapperClassVar = new WrapperClass();        
        WrapperClassVar.prodPricing = [SELECT Id, Name, Principal__c, Principal__r.Name, Price__c, Product__c,CGST__c,IGST__c,SGST__c, Product_Quantity__c from Product_Pricing__c where Product__c= :prodId AND CurrencyIsoCode = :oppCurrency];
        //System.debug('WrapperClassVar.prodPricing '+WrapperClassVar.prodPricing);
        WrapperClassVar.prodDetail = [SELECT Id, Name, Product_Type__c, Product_Family__c, Product_Family__r.Name, Description, Product_Code__c, IsActive, CurrencyIsoCode 
                                      FROM Product2 WHERE Id = :prodId];
        
        return WrapperClassVar;
    }
    
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItems(Id quoteId){        
        return [select Id, Product2Id, Product2.Name, Quantity, Sale_Price__c from QuoteLineItem where QuoteId = :quoteId];
    }
    
    
    @AuraEnabled
    public static WrapperClass getOptyDetails(Id quoteId){
        
        List<Id> pfId = new List<Id>();
        
        WrapperClass wrp = new WrapperClass();
        wrp.uomPick = new Map<String, String>();
        wrp.product2Records = new List<Product2>();
        wrp.ExistingProducts = new List<Product2>();
        String str = [Select Opportunity.ProductFamilyId__c from Quote where id =: quoteId].Opportunity.ProductFamilyId__c;
        pfId = str.split(',');
        wrp.productFamilyRecord =  [Select Id, Name from Product_Family__c where Id IN :pfId];
        
        Set<Id> existingQLI = new Set<Id>();        
        wrp.quoteLineItemsId = [Select CalculationType__c,Tax__c,QuoteId, Product2Id,Product2.Name,IsChecked__c,Quantity,IsOptional__c,Principal2__c,UOM__c,CostPrice__c,ProductDescription__c,CostPriceDiscount__c,CostPriceDiscountValue__c,MarginPercent__c,Margin_Amount2__c,MarginDiscountPercent__c,MarginDiscountValue__c,UnitPrice,Discount_Amount2__c,TotalDiscount__c,FinalMarginValue__c,Final_Price2__c,CustomerPartNumber__c,PrincipalPartNumber__c,Unit_of_Measure_UOM2__c,Principal_Quote_Reference__c from QuoteLineItem where quoteId =: quoteId];  
        for(QuoteLineItem qli : wrp.quoteLineItemsId){
            existingQLI.add(qli.Product2Id);
        }
        set<Id> pdtId = new Set<Id>();
        wrp.product2Records = [SELECT Id, Name, (Select id, name from Product_Pricings__r ) FROM Product2
                               WHERE Product_Family__c IN :pfId ORDER BY Name/*AND Id NOT IN :existingQLI*/];
        //System.debug('product2Records'+wrp.product2Records);
       
        wrp.ExistingProducts = [SELECT Id, Name, (Select id, name from Product_Pricings__r ) FROM Product2
                                WHERE Id IN :existingQLI];
        
        //System.debug('ExistingProducts'+wrp.ExistingProducts);
        
        
        
        wrp.quoteDetails = [SELECT Id, Name, Status, OpportunityId, Opportunity.Name, Opportunity.CurrencyIsoCode, Opportunity.ProductFamilyName__c, Opportunity.ProductFamilyId__c FROM Quote
                            WHERE Id= :quoteId];
        Schema.DescribeFieldResult fieldResult = Product_Pricing__c.UOM__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            wrp.uomPick.put(p.getValue(), p.getLabel());
        }
        return wrp;
    }
    
    public class WrapperClass{
        @AuraEnabled
        public List<Product2> product2Records{get;set;}
        @AuraEnabled
        public List<Product2> ExistingProducts{get;set;}
        @AuraEnabled
        public List<Product_Family__c> productFamilyRecord{get;set;}
        @AuraEnabled
        public List<QuoteLineItem> quoteLineItemsId{get;set;}
        @AuraEnabled
        public List<QuoteLineItem> AllquoteLineItemsId{get;set;}
        @AuraEnabled
        public Quote quoteDetails{get;set;}
        @AuraEnabled
        public Map<String, String> uomPick{get;set;}
        @AuraEnabled
        public List<Product_Pricing__c> prodPricing{get;set;}
        @AuraEnabled
        public Product2 prodDetail{get; set;}
    }
    
    @AuraEnabled
    public static List<Product2> getProducts(Id recId){
        //System.debug('recId '+recId);
        List<Product2> prodList = [SELECT Id, Name FROM Product2
                                   WHERE Product_Family__c = :recId AND isActive=true];
        return prodList;
    }
    
    @AuraEnabled
    public static List<Product2> searchKey(String sKey, Id quoteId){
        List<Id> pfId = new List<Id>();
        String productFamily = [Select Opportunity.ProductFamilyId__c from Quote where id =: quoteId].Opportunity.ProductFamilyId__c;
        pfId = productFamily.split(',');
        String str = '%'+skey+'%';
        //To remove existing products as QLI - April 9, 2020
        Set<Id> existingQLI = new Set<Id>();        
        List<QuoteLineItem> existingQLIList = [Select Product2Id from QuoteLineItem where quoteId =: quoteId];
        for(QuoteLineItem qli : existingQLIList){
            existingQLI.add(qli.Product2Id);
        }
        //System.debug('existingQLI size()-->>'+existingQLI.size());
        
        return [Select Name from Product2 
                where isActive=true 
                AND name LIKE :str 
                AND Product_Family__c IN :pfId 
                AND Id NOT IN :existingQLI
                ORDER BY Name limit 40000];
    }
    
    @AuraEnabled
    public static void insertQuoteLineItem(List<QuoteLineItem> quoLi, String oppCurrency){
        //System.debug('quanti '+quoLi);
        
        Map<Id,Id> productPricebookMap = new Map<Id,Id>();
        list<Id> productId = new List<Id>();
        for(Integer i = 0; i< quoLi.size();i++){
            productId.add(quoLi[i].Product2Id);
        }
        
        for(PriceBookEntry pbe : [SELECT Name, Product2.Id,Product2.Name, Product2.ProductCode,PriceBook2.Id, PriceBook2.Name from PriceBookEntry 
                                  where Product2.Id IN : productId AND CurrencyIsoCode = :oppCurrency]){
                                      productPricebookMap.put(pbe.Product2.Id, pbe.Id);
                                  }
        
        pricebook2 pricebook=[select id from pricebook2 where isstandard=true limit 1];   
        //PricebookEntry pricebookentityid=[select id,PRODUCT2ID,CurrencyIsoCode from PricebookEntry where pricebook2id=:pricebook.id and  PRODUCT2ID=:proid and CurrencyIsoCode=: opprec.CurrencyIsoCode limit 1 ];
        
        Decimal gTotal = 0.0000;
        
        Id quoteId;
        List<QuoteLineItem> qliInsert = new List<QuoteLineItem>();
        for(QuoteLineItem ql : quoLi){
            if(ql.Quantity>0){
                QuoteLineItem qli = new QuoteLineItem();
                qli.Quantity = ql.Quantity;
                qli.CostPrice__c = ql.CostPrice__c;
                qli.UOM__c = ql.uom__c;
                qli.QuoteId = ql.QuoteId;
                quoteId = ql.QuoteId;
                qli.UnitPrice = ql.unitPrice;
                qli.Product2Id = ql.Product2Id;
                //qli.ProductDescription__c = ql.Product_Family__c;
                qli.ProductDescription__c = ql.ProductDescription__c;
                qli.CostPriceDiscount__c = ql.CostPriceDiscount__c;
                qli.CostPriceDiscountValue__c = ql.CostPriceDiscountValue__c;
                qli.MarginPercent__c = ql.MarginPercent__c;
                qli.Margin_Amount2__c = ql.Margin_Amount2__c;
                qli.MarginDiscountPercent__c = ql.MarginDiscountPercent__c;
                qli.MarginDiscountValue__c = ql.MarginDiscountValue__c;
                qli.Discount_Amount2__c = ql.Discount_Amount2__c;
                qli.TotalDiscount__c = ql.TotalDiscount__c;
                qli.Final_Price2__c = ql.Final_Price2__c;
                qli.FinalMarginValue__c = ql.FinalMarginValue__c;
                qli.CustomerPartNumber__c = ql.CustomerPartNumber__c;
                qli.PrincipalPartNumber__c = ql.PrincipalPartNumber__c;
                qli.CGST__c = ql.CGST__c;
                qli.SGST__c = ql.SGST__c;
                qli.IGST__c = ql.IGST__c;
                qli.Tax__c = ql.Tax__c;
                qli.Principal2__c = ql.Principal2__c;
                qli.IsChecked__c = ql.IsChecked__c;
                qli.CalculationType__c = ql.CalculationType__c;
                qli.Principal_Quote_Reference__c = ql.Principal_Quote_Reference__c;
                qli.IsOptional__c = ql.IsOptional__c;
                
                if(ql.IsChecked__c){
                    gTotal += ql.Final_Price2__c;
                }
                
                qli.Unit_of_Measure_UOM2__c = ql.Unit_of_Measure_UOM2__c;
                
                //System.debug('PBEID '+productPricebookMap.get(ql.Product2Id));
                qli.PricebookEntryId = productPricebookMap.get(ql.Product2Id);
                //qli.PricebookEntryId = '01u9D000000tGqPQAU';
                qliInsert.add(qli);
                
            }
        }
        //system.debug('qliInsert'+qliInsert.size());
        Quote quoteRec = [Select OpportunityId, Pricebook2Id from Quote where id = :quoteId];
        if(quoteRec!=null){
            if(quoteRec.Pricebook2Id == null){
                quoteRec.Pricebook2Id = pricebook.Id;
                
            }
            if(gTotal!=null){
                quoteRec.QuoteGrandTotal__c = gTotal;
            }
            update quoteRec;
        }
        
        Opportunity opty = [Select Pricebook2Id from Opportunity where id=:quoteRec.OpportunityId];
        opty.Pricebook2Id = pricebook.Id;
        update opty;
        
        List<QuoteLineItem> existingQuoteLineItems = [Select Id from QuoteLineItem where QuoteId=:quoteId];
        Set<Id> qliToDelId = new Set<Id>();
        for(QuoteLineItem qliRec : existingQuoteLineItems){
            qliToDelId.add(qliRec.Id);
        }
        
        if(qliInsert!=null){
            insert qliInsert;
        }
        
        delete existingQuoteLineItems;
        
    }
    
}