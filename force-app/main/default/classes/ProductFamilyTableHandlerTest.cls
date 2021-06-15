@isTest 
public class ProductFamilyTableHandlerTest {
    static testmethod void updateProductFamily(){
        
    Product_Family__c prodFamily= new Product_Family__c();
        prodFamily.Name='Test';
        insert prodFamily;
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE',isActive=true);
        insert pb22;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 pro2 = new Product2();
        pro2.Name='conn';
      //  pro2.Principal__c=principal.Id;
        
        pro2.Product_Family__c=prodFamily.Id;
        pro2.IsActive=true;
        
        insert pro2;
                
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
        
        ProductFamilyTableHandler.getProductFamily(opp.Id);
        ProductFamilyTableHandler.updateProductFamily(opp.Id,prodFamily.Id,'Test');
        ProductFamilyTableHandler.searchKey('Test');
        
	}
}