@isTest
public class QuoteCloneHandlerTest {
    static testMethod void insertQuote(){
        //Test Data Setup     
        id quoteRT = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Standard_Budgetary_GMS').getRecordTypeId();   
        String recordJSON;
        String ObjectName ='Quote';
        Id quoteRecId; 
        String radioInput ='option1';
        String processInput = 'option1';
        String quoteInput = 'option1';
        
        Account a=new Account(Name='Test');
        insert a;
        
        Opportunity op=new Opportunity();
        op.Name='TestOpp';
        op.AccountId=a.Id;
        op.StageName='Test';
        op.CloseDate=System.Today().addMonths(1);
        op.Priority__c ='Medium';
        insert op;
        Product_Family__c pf = new Product_Family__c();
        pf.Name='Product Family 01';
        insert pf;
        
        Product2 p1 = new Product2();
        p1.Name='TO-8 Can';
        p1.Productcode='PO16';
        p1.IsActive = true; 
        p1.Product_Family__c=pf.Id;
        insert p1;      
        
        Pricebook2 standardPB = new Pricebook2();
        standardPB.Name='Standard Price Book';
        //standardPB.IsStandard=true;
        insert standardPB;
        
        
        
        //Pricebook2 standardPB = [Select Id from Pricebook2 where isStandard=true limit 1];
        system.debug('standardPB==='+standardPB);
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
        
        Quote q2=q.clone(false,false,false,false);        
        recordJSON =json.serialize(q2);
        system.debug('recordJSON==='+recordJSON);
        QuoteLineitem q1=new QuoteLineItem();        
        q1.PricebookEntryId=pbe.Id;
        q1.Quantity=1;        
        q1.UnitPrice=pbe.UnitPrice;
        q1.QuoteId=q.Id;
        insert q1;  
        test.startTest();
        
        QuoteCloneHandler.insertQuote(recordJSON, ObjectName, q.id, radioInput, processInput, quoteInput);
        QuoteCloneHandler.insertQuote(recordJSON, 'Quote', q.id, 'option2', 'option2', 'option2');
        QuoteCloneHandler.relatedQuote(op.id);
        test.stopTest();
    }    
}