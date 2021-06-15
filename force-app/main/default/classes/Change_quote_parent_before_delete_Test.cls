@isTest
public class Change_quote_parent_before_delete_Test {
    @isTest static void quotetest(){
        Account acc=new Account(Name='acc1',Account_Alias__c='alias1',CurrencyIsoCode='USD');
        insert acc;
        
        Opportunity opprec=new Opportunity(Name='opp1',CloseDate = System.today(),AccountId=acc.id,Customer_Segment__c='Defence',Technology__c='Solar',Territory__c='South India',Location__c='Hyderabad',StageName='Proposal',Priority__c ='High');
        insert opprec;
               
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opprec.id;
        quoterecord.Company_Types__c='GMS';
        quoterecord.Clone_the_record__c = 'Yes';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.RecordTypeId=quoterecordid;
        insert quoterecord;
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        QuoteDocument qdoc = new QuoteDocument();
        qdoc.QuoteId = quoterecord.id;
        qdoc.Document = Blob.toPdf('Test Document'); 
        insert qdoc;
        delete quoterecord;
    }
    @isTest static void quotetest1(){
        Account acc=new Account(Name='acc1',Account_Alias__c='alias1',CurrencyIsoCode='USD');
        insert acc;
        
        Opportunity opprec=new Opportunity(Name='opp1',CloseDate = System.today(),AccountId=acc.id,Customer_Segment__c='Defence',Technology__c='Solar',Territory__c='South India',Location__c='Hyderabad',StageName='Proposal',Priority__c='High');
        insert opprec;
               
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opprec.id;
        quoterecord.Company_Types__c='GMS';
        quoterecord.Clone_the_record__c = '';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.Clone_the_record__c='No';
        quoterecord.RecordTypeId=quoterecordid;
        insert quoterecord;
        
        string before = 'Testing base 64 encode';
        Blob beforeblob = Blob.valueOf(before);
        QuoteDocument qdoc = new QuoteDocument();
        qdoc.QuoteId = quoterecord.id;
        qdoc.Document = Blob.toPdf('Test Document'); 
        insert qdoc;
        delete quoterecord;
    }
}