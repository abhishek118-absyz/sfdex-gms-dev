@isTest
public class InsertNewQuote_LightningComponenttest 
{
@isTest
    static void getselectOptions()
    {
        Account acc=new Account(Name='acc1',Account_Alias__c='alias1',CurrencyIsoCode='INR');
        insert acc;
        
        Opportunity opp=new Opportunity(Name='opp1',AccountId=acc.id,CloseDate=System.Today(),Lost_Reason__c='Customer not interested anymore',CurrencyIsoCode='INR',Priority__c='Low',Customer_Segment__c='Space',Technology__c='EV',Territory__c='South India',StageName='Proposal');
        insert opp;
        
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opp.id;
        quoterecord.Company_Types__c='GMS';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.RecordTypeId=quoterecordid;
        quoterecord.Sub_Status__c='Accepted by Principal';
        quoterecord.Status='Draft';
        insert quoterecord;
        
        //Quote qid=new Quote(Name='rtype1',OpportunityId=opp.id,Quote_Type__c='Formal',Principal_Quote_Reference__c='quotetype1');
        //insert qid;
        string fieldname='Quote_Type__c';
        InsertNewQuote_LightningComponent.getselectOptions( quoterecord,fieldname);
    }
    @isTest
    static void insertquoterecord()
    {
        Account acc=new Account(Name='acc1',Account_Alias__c='alias1',CurrencyIsoCode='USD');
        insert acc; 
        
        Opportunity opp=new Opportunity(Name='opp1',AccountId=acc.id,CloseDate=System.Today(),Lost_Reason__c='Customer not interested anymore',CurrencyIsoCode='INR',Priority__c='Low',Customer_Segment__c='Space',Technology__c='EV',Territory__c='South India',StageName='Proposal');
        insert opp;
        
        quote quoterecord=new quote(); 
        quoterecord.Name='abc';
        quoterecord.Process_Type__C='Standard';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.OpportunityId=opp.id;
        quoterecord.Company_Types__c='GMS';
        string recordtypename=quoterecord.Process_Type__C+'_'+quoterecord.Quote_Type__c+'_'+quoterecord.Company_Types__c;
        system.debug('recordtypename'+recordtypename);
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quoterecord.Principal_Quote_Reference__c='abc';
        quoterecord.Quote_Type__c='Formal';
        quoterecord.RecordTypeId=quoterecordid;
        quoterecord.Sub_Status__c='Accepted by Principal';
        quoterecord.Status='Draft';
        //insert quoterecord;
        
        InsertNewQuote_LightningComponent.insertquoterecord(quoterecord,opp.id);
    }
}