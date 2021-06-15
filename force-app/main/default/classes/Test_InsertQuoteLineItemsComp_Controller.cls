@isTest
public class Test_InsertQuoteLineItemsComp_Controller {
    static testMethod void testMethod1(){
        id quoteRT = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Standard_Budgetary_GMS').getRecordTypeId();   
        string oppCurrency = 'INR';
        String sKey='Test1';
        Account a=new Account(Name='Test');
        insert a;
        
        Product_Family__c pf = new Product_Family__c();
        pf.Name='Product Family 01';
        insert pf;
        
        Opportunity op=new Opportunity();
        op.Name='TestOpp';
        op.AccountId=a.Id;
        op.StageName='Test';
        op.CloseDate=System.Today().addMonths(1);
        op.Priority__c ='Medium';   
        op.ProductFamilyId__c=pf.id;
        insert op;
        
        
        Product2 p1 = new Product2();
        p1.Name='Test1';
        p1.Productcode='PO16';
        p1.IsActive = true; 
        p1.Product_Family__c=pf.Id;
        insert p1;      
        
        Pricebook2 standardPB = new Pricebook2();
        //standardPB.Id = Test.getStandardPricebookId();
        standardPB.Name='Standard Price Book';          
        //standardPB.IsStandard=true;
        insert standardPB;
        system.debug('IsStandard==='+standardPB.IsStandard);         
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.IsActive = true;
        pbe.Product2ID = p1.Id;
        pbe.Pricebook2Id = standardPB.Id;
        pbe.UnitPrice = 200;        
        pbe.UseStandardPrice = false;
        insert pbe;
        
        Quote q=new Quote();
        q.Name='Test';        
        q.OpportunityId=op.Id; 
        q.RecordTypeId=quoteRT;
        q.QuoteVersion__c='0';
        q.QuoteNumber__c='GBQ/19-20/0694';
        q.Process_Type__c='Standard';
        q.Status='Draft';
        q.Quote_Type__c='Budgetary';
        q.CurrencyIsoCode='USD';
        q.Quote_Start_time__c = system.now();
        q.Date__c=system.today();
        q.Pricebook2Id=standardPB.Id;
        insert q;
        QuoteLineitem q3=new QuoteLineItem();        
        q3.PricebookEntryId=pbe.Id;
        q3.Quantity=1;        
        q3.UnitPrice=pbe.UnitPrice;
        q3.QuoteId=q.Id;
        insert q3;
        List<QuoteLineitem> listQuoteLineitem = new List<QuoteLineitem>();
        
        QuoteLineitem q1=new QuoteLineItem();        
        q1.PricebookEntryId=pbe.Id;
        q1.Quantity=1;        
        q1.UnitPrice=pbe.UnitPrice;
        q1.QuoteId=q.Id;
        listQuoteLineitem.add(q1); 
        
        QuoteLineitem q2=new QuoteLineItem();        
        q2.PricebookEntryId=pbe.Id;
        q2.Quantity=1;        
        q2.UnitPrice=pbe.UnitPrice;
        q2.QuoteId=q.Id;
        
        listQuoteLineitem.add(q2);        
        insert listQuoteLineitem;
        system.debug('listQuoteLineitem'+listQuoteLineitem);
        test.startTest();
        InsertQuoteLineItemsComp_Controller.getQuoteStatus(q.id);
        InsertQuoteLineItemsComp_Controller.getProductDetails(p1.id,oppCurrency);
        InsertQuoteLineItemsComp_Controller.getQuoteLineItems(q.id);
        InsertQuoteLineItemsComp_Controller.getOptyDetails(q.id);
        InsertQuoteLineItemsComp_Controller.getProducts(p1.id);
        InsertQuoteLineItemsComp_Controller.searchKey(sKey,q.id);        
        test.stopTest();
    }
    static testMethod void testMethod2(){
        test.startTest();
        id quoteRT = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Standard_Budgetary_GMS').getRecordTypeId();
        
        Product_Family__c pf = new Product_Family__c();
        pf.Name='Product Family 01';
        insert pf;
        
        Product2 p = new Product2();
        p.Name='Test1';
        p.Productcode='PO16';
        //p.IsActive = true; 
        p.Product_Family__c=pf.id;      
        insert p;  
        
        Pricebook2 standardPB1 = new Pricebook2();
        standardPB1.Id = Test.getStandardPricebookId();
        //standardPB1.Name='Standard Price Book'; 
        standardPB1.IsActive=true;
        update standardPB1;
      
        system.debug('IsStandard==='+standardPB1.IsStandard);
        PriceBookEntry pbeRec = [SELECT Id,UnitPrice, Pricebook2.IsStandard,CurrencyIsoCode FROM PricebookEntry where CurrencyIsoCode = 'USD' limit 1];
        System.debug('pbeRec '+pbeRec);
        pbeRec.isActive = true;
        update pbeRec;
        
        
        Opportunity op=new Opportunity();
        op.Name='TestOpp';
        //op.AccountId=a.Id;
        op.StageName='Test';
        op.CloseDate=System.Today().addMonths(1);
        op.Priority__c ='Medium';
        op.CurrencyIsoCode = pbeRec.CurrencyIsoCode;
        op.Pricebook2Id=standardPB1.Id;
        insert op;
        
        Quote q=new Quote();
        q.Name='Test';                
        q.RecordTypeId=quoteRT;
        q.OpportunityId=op.id;
        q.QuoteVersion__c='1';
        q.QuoteNumber__c='GBQ/19-20/0694';
        q.Process_Type__c='Standard';
        q.Status='Draft';
        q.Quote_Type__c='Budgetary';
        q.CurrencyIsoCode=pbeRec.CurrencyIsoCode;
        q.Quote_Start_time__c = system.now();
        q.Date__c=system.today();
        q.Pricebook2Id=standardPB1.Id;         
        insert q;
        Principal__c pt = new Principal__c();
        pt.name = 'Principal 01';
        pt.Email__c='principal1@absyz.com';
        insert pt;
        List<QuoteLineitem> listQuoteLineitem = new List<QuoteLineitem>();
        QuoteLineitem q4=new QuoteLineItem();        
        q4.PricebookEntryId=pbeRec.Id;
        q4.Quantity=3;        
        q4.UnitPrice=pbeRec.UnitPrice;
        q4.QuoteId=q.id;
        q4.Product2Id=p.id;
        q4.CostPrice__c=2300;
        q4.UOM__c='MG';		
        q4.CostPriceDiscount__c=20;         
        q4.CostPriceDiscountValue__c = 5;
        q4.MarginPercent__c = 7;
        q4.Margin_Amount2__c =300;
        q4.MarginDiscountPercent__c = 3;
        q4.MarginDiscountValue__c = 5;
        q4.Discount_Amount2__c = 400;
        q4.TotalDiscount__c = 700;
        q4.Final_Price2__c = 1000;
        q4.FinalMarginValue__c = 100;
        q4.CustomerPartNumber__c ='C03';
        q4.PrincipalPartNumber__c = 'P03';
        q4.CGST__c = 9;
        q4.SGST__c = 9;
        q4.IGST__c = 10;
        q4.Tax__c = 0.00;
        q4.Principal2__c = pt.id;
        
        
        listQuoteLineitem.add(q4);
        system.debug('listQuoteLineitem===='+listQuoteLineitem.size());
        if(listQuoteLineitem.size()>0){
            insert listQuoteLineitem;
        }        
        InsertQuoteLineItemsComp_Controller.insertQuoteLineItem(listQuoteLineitem,'USD');
        test.stopTest();
    }
    
}