@isTest
public class Principle_Opportunities_Controller_Test {
 static testMethod void testMethod1() 
    { 
        Principal__c pri=new Principal__c(Name='Principle1',Email__c='test.123@testing.com');
        insert pri;
        
        
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
        
        OpportunityLineItem opplineitem=new OpportunityLineItem(Principal__c=principal.id,PriceBookEntryId=customPrice.Id,OpportunityId=opp.Id,Quantity=1.00,UnitPrice=1244.89,Discount=0,TotalPrice=6500);
        
        test.startTest();
       Principle_Opportunities_Controller.Listofprinciplropportunities(principal.Id);
        test.stopTest();
            
    }
}