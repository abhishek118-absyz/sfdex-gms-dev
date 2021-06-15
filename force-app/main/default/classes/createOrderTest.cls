@isTest
public class createOrderTest {
    
    static testmethod void TestcreateOrder()
    {
        //Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        
        
        
        Principal__c principal= new principal__c();
        principal.Name='p';
        principal.Email__c='a@b.com';
        insert principal;
        
        Product_Family__c prodFamily= new Product_Family__c();
        prodFamily.Name='p';
        insert prodFamily;
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE',isActive=true);
        insert pb22;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        
        Product2 pro2 = new Product2();
        pro2.Name='conn';
        pro2.Principal__c=principal.Id;
        
        pro2.Product_Family__c=prodFamily.Id;
        pro2.IsActive=true;
        
        insert pro2;
        
        /*Product2 pro2 = new Product2(Name='BXCD', isActive=true,pr.Principal__c=principal.Id,pr.Product_Family__c=prodFamily.Id);
insert pro2;*/
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = pro2.Id,
            UnitPrice = 10000, IsActive = true);
        // insert standardPrice;
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook1', isActive=true);
        insert customPB1;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = pro2.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(
            Pricebook2Id = customPB1.Id, Product2Id = pro2.Id,
            UnitPrice = 12000, IsActive = true,CurrencyIsoCode = 'USD' );
        insert customPrice1;
        
        
        Account acc= new Account();
        acc.Industry='Agriculture';
        acc.Name='TestAcc';
        acc.Account_Alias__c='alias';
        //acc.CurrencyIsoCode='USD-U.S. Dollar';
        insert acc;
        
        Pricebook2 standardPB1 = new Pricebook2();
        standardPB1.Id = Test.getStandardPricebookId();
        //standardPB1.Name='Standard Price Book'; 
        standardPB1.IsActive=true;
        update standardPB1;
        
        opportunity opp= new opportunity();
        opp.Name='opp';
        opp.StageName='Proposal';
        opp.Pricebook2Id=customPB.Id;
        opp.AccountId=acc.Id;
        opp.CloseDate=System.today();
        opp.Lost_Reason__c='Lost to a Competitor';
        opp.Lost_Reason_Description__c='Test';
        opp.Customer_Segment__c='Space';
        opp.Technology__c='MEMS';
        opp.Priority__c = 'High';
        insert opp;
        
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, Discount = 5,Description = 'tyest',OpportunityId=opp.Id,PriceBookEntryId=customPrice.Id,TotalPrice = 24000);
        
        oppLineItemList.add(OPplineitem2);
               
        
        
        
        OpportunityLineItem OPplineitem21 = new OpportunityLineItem (Quantity=3, OpportunityId=opp.Id,TotalPrice=12000,PriceBookEntryId=customPrice.Id);
        
        oppLineItemList.add(OPplineitem21);
        insert oppLineItemList;
        
        test.startTest();
        
        
        
        PriceBookEntry pbeRec = [SELECT Id,UnitPrice, Pricebook2.IsStandard,CurrencyIsoCode FROM PricebookEntry where CurrencyIsoCode = 'USD' limit 1];
        System.debug('pbeRec '+pbeRec);
        pbeRec.isActive = true;
        update pbeRec;
        
        Opportunity op=new Opportunity();
        op.Name='TestOpp';
        op.AccountId=acc.Id;
        op.StageName='Test';
        op.CloseDate=System.Today().addMonths(1);
        op.Priority__c ='Medium';
        op.CurrencyIsoCode = customPrice1.CurrencyIsoCode;
        op.Pricebook2Id=customPB1.Id;
        insert op;
        
        OpportunityLineItem OPplineitemRec = new OpportunityLineItem (Quantity=2, Discount = 5,Description = 'tyest',OpportunityId=op.Id,PriceBookEntryId=customPrice1.Id,TotalPrice = 24000, isChecked__c= true,isOptional__c = false);
        insert OPplineitemRec;
        
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=op.id;
        quoterecord.Company_Types__c='GMS';
        quoterecord.Clone_the_record__c = '';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.Status='Accepted' ;
        quoterecord.CurrencyIsoCode = pbeRec.CurrencyIsoCode;
        quoterecord.Pricebook2Id=standardPB1.Id;
        quoterecord.RecordTypeId=quoterecordid;
        quoterecord.Comments_Internal__c='test';
      //  quoterecord.TotalMarginValue__c=  '';
        insert quoterecord;
        
        QuoteLineItem QuoteLineItemObj = new QuoteLineItem();
        QuoteLineItemObj.Product2Id  = pro2.Id;
        QuoteLineItemObj.QuoteId=quoterecord.Id;
        QuoteLineItemObj.Quantity=10; 
        QuoteLineItemObj.Description='test';
        QuoteLineItemObj.UnitPrice=12;
        QuoteLineItemObj.OpportunityLineItemId =  OPplineitem2.id;
        QuoteLineItemObj.PricebookEntryId=pbeRec.Id;
        //insert QuoteLineItemObj;
        //
        Principal__c pt = new Principal__c();
        pt.name = 'Principal 01';
        pt.Email__c='principal1@absyz.com';
        insert pt;
        
        QuoteLineitem q4=new QuoteLineItem();        
        q4.PricebookEntryId=pbeRec.Id;
        q4.Quantity=3;        
        q4.UnitPrice=pbeRec.UnitPrice;
        q4.QuoteId=quoterecord.id;
        q4.Product2Id=pro2.id;
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
        q4.IsChecked__c=true;
        q4.IsOptional__c=false;
        q4.CGST__c = 9;
        q4.SGST__c = 9;
        q4.IGST__c = 10;
        q4.Tax__c = 0.00;
        q4.Principal2__c = pt.id;
        insert q4;
        
        op.SyncedQuoteId=quoterecord.id;
        // update opp;
        
        op.StageName='Closed Won';
        //opp.SyncedQuoteId=quttest.id;
        update op;
        
        
        
        order ord= new order();
        ord.OpportunityId=opp.Id;
        ord.AccountId=acc.Id;
        ord.Status='Draft';
       
        ord.EffectiveDate=System.today();
        ord.Pricebook2Id=opp.Pricebook2Id;
        
        insert ord;
        system.debug('test');
        
        OrderItem orLine= new OrderItem();
        orLine.Quantity=OPplineitem2.Quantity;
        orLine.OrderId=ord.Id;
        orLine.PricebookEntryId=OPplineitem2.PricebookEntryId;
        orLine.UnitPrice=200.00;
        insert orLine;
        
        system.debug('test last');
        
        Shipment__c test_delivery_lot= new Shipment__c();
        test_delivery_lot.Delivery_Lot_Number__c='1';
        test_delivery_lot.name='test';
        test_delivery_lot.Order__c=ord.Id;
        test_delivery_lot.Expected_date_of_delivery__c=system.today();
        insert test_delivery_lot;
        Lot_Item__c lotitem=new Lot_Item__c();
        lotitem.Delivery_Lot__c=test_delivery_lot.id;
        lotitem.Order_Product__c=orLine.id;
        lotitem.Quantity_of_Product__c=1;
        insert lotitem;
        lotitem.Quantity_of_Product__c=1;
        update lotitem;
        
        
        
        
        test.stoptest();        
        
        
        
    }
    
    
}