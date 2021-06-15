@isTest
public class ProductRecordInsert_Test {
    @isTest
    static void prodquote()
    {
        Account acc=new Account(Name='acc1',Account_Alias__c='alias1',CurrencyIsoCode='USD');
        insert acc;
        
        Opportunity opprec=new Opportunity(Name='opp1',CloseDate = System.today(),AccountId=acc.id,Customer_Segment__c='Defence',Priority__c='High',Technology__c='Solar',Territory__c='South India',Location__c='Hyderabad',StageName='Proposal');
        insert opprec;
        
        
        
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opprec.id;
        quoterecord.Company_Types__c='GMS';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.RecordTypeId=quoterecordid;
        insert quoterecord;
        
        Product_Family__c profamily=new Product_Family__c(Name='family1');
        insert profamily;
        
        Product2 p2=new Product2(Name='pro1',ProductCode='procode1',Product_Family__c=profamily.id);
        insert p2;
        
        ProductRecordInsert.prodquote(p2.id,quoterecord.id);
    }
    @isTest
    static void insertfromquote()
    {
        
		//pricebook2 pricebook=[select id from pricebook2 where isstandard=true limit 1]; 
        
        Account acc=new Account(Name='acc1',Account_Alias__c='alias1',CurrencyIsoCode='USD');
        insert acc;        
        
        //pricebook2 pb2=new pricebook2(Name='pricebook1');
        //insert pb2;
        
        Opportunity opprec=new Opportunity(Name='opp1',CloseDate = System.today(),AccountId=acc.id,Customer_Segment__c='Defence',Technology__c='Solar',Territory__c='South India',Location__c='Hyderabad',StageName='Proposal',Priority__c='High');
        insert opprec;
        
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opprec.id;
        quoterecord.Company_Types__c='GMS';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.RecordTypeId=quoterecordid;
        insert quoterecord;
        
        Product_Family__c profamily=new Product_Family__c(Name='family1');
        insert profamily;
        
        Product2 p2=new Product2(Name='pro1',ProductCode='procode1',Product_Family__c=profamily.id);
        insert p2;
        
        
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId '+pricebookId);
        
        Pricebook2 customPB = new Pricebook2(Id=pricebookId, isActive=TRUE);
        upsert customPB;
        
        PricebookEntry pricebookentityid=new PricebookEntry(Product2Id=p2.id,Pricebook2Id=pricebookId,UnitPrice=2500,isActive=TRUE);
        insert pricebookentityid;
        
        Principal__c pri=new Principal__c(Name='Principle1',Email__c='test.123@testing.com');
        insert pri;
        
        ProductRecordInsert.insertfromquote(quoterecord.id,p2.id,pri.name,'20',8,25,92,500.00);
    }
}