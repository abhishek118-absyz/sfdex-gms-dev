@isTest
public class synfromquoteline_to_oppline_Test
{ 
    //@testsetup
    static testmethod void TestcreateOrder()
    {
        //Pricebook2 standardPB = [select name, isactive from Pricebook2 where IsStandard = true limit 1];
        
        test.startTest(); 
        
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
        
        //Id pricebookId = Test.getStandardPricebookId();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = pro2.Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        
        Account acc= new Account();
        acc.Industry='Agriculture';
        acc.Name='TestAcc';
        acc.Account_Alias__c='alias';
        //acc.CurrencyIsoCode='USD-U.S. Dollar';
        insert acc;
        
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
        opp.Priority__c='High';
        opp.Amount = 4500;
        
        opp.Type__c='Equipment';
        insert opp;
        
        OpportunityLineItem opplineitem=new OpportunityLineItem(PriceBookEntryId=customPrice.Id,OpportunityId=opp.Id,Quantity=1.00,UnitPrice=1244.89,Discount=0,TotalPrice=6500);
        
        
        //insert opplineitem ;
        
        List<OpportunityLineItem> oppLineItemList = new List<OpportunityLineItem>();
        OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=2, Discount = 5,Description = 'tyest',OpportunityId=opp.Id,PriceBookEntryId=customPrice.Id,TotalPrice = 24000);
        
        oppLineItemList.add(OPplineitem2);
        Insert oppLineItemList;       
        
        // OpportunityLineItem OPplineitem21 = new OpportunityLineItem (Quantity=3, OpportunityId=opp.Id,TotalPrice=12000,PriceBookEntryId=customPrice.Id);
        
        //  oppLineItemList.add(OPplineitem21);
        
        
        quote quoterecord=new quote(); 
        //quoterecord.OpportunityId=opp.Id;
        quoterecord.Name='abc';
        
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opp.id;
        quoterecord.Company_Types__c='GMS';
        quoterecord.Status='Accepted';
        quoterecord.Clone_the_record__c = '';
        quoterecord.Pricebook2Id=customPB.id;
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.Comments_Internal__c='test';
        quoterecord.RecordTypeId=quoterecordid;
        //quoterecord.IsSyncing='true';
        insert quoterecord;
        
        quotelineitem quotline=new quotelineitem(Product2Id=pro2.Id,Principal2__c=principal.id,
                                                 UnitPrice=2525,Discount_Amount2__c=0,quoteid=quoterecord.id,
                                                 Margin_Amount2__c=0,Unit_of_Measure_UOM2__c='1 L',
                                                 PricebookEntryId=customPrice.Id,quantity=2);
        insert quotline;
        
         quotline.Margin_Amount2__c  =1000;
        update quotline;
        
        //Opportunity opp2= new Opportunity(); 
        // opp2.iD=opp.id;
        //id ids=quoterecord.id;
        opp.SyncedQuoteId=quoterecord.id;
        
        
        //Opportunity.SyncedQuoteId
        update opp; 
        system.debug('Opp.issync'+opp.SyncedQuoteId);
        update quoterecord;
        system.debug('quoterecord'+quoterecord.IsSyncing);
        test.stoptest();   
    }
  /*  @isTEst
    public static  void test1() { 
        for (Quote q : quotes) { 
            system.assert(q.isSyncing); 
            update q;
            system.debug('q.isSyncing'+q);
            
        }
        
    } 
    public static List<Quote> getQuotes() { return [ SELECT IsSyncing FROM Quote ]; }*/
}