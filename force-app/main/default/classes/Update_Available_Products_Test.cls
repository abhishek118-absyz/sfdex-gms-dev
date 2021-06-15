@isTest
public class Update_Available_Products_Test {
   @isTest
    static void method1(){
        Product_Family__c profamily=new Product_Family__c(Name='family1');
        insert profamily;
        
       // Product_Family__c profamily1=new Product_Family__c(Name='family2');
        //insert profamily1;
        
        Product2 p2=new Product2(Name='pro1',ProductCode='procode1',Product_Family__c=profamily.id);
        insert p2;
        
       // Product2 p3=new Product2(Name='pro2',ProductCode='procode2',Product_Family__c=profamily1.id);
        //insert p3;
       
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId '+pricebookId);
        
        Pricebook2 customPB = new Pricebook2(Id=pricebookId, isActive=TRUE);
        upsert customPB;
        
        PricebookEntry pricebookentityid=new PricebookEntry(Product2Id=p2.id,Pricebook2Id=pricebookId,UnitPrice=2500,isActive=TRUE);
        //insert pricebookentityid;
        
        Principal__c pri=new Principal__c(Name='Principle1',Email__c='test.123@testing.com');
        insert pri;
        
        Product_Pricing__c pp = new Product_Pricing__c();
        pp.Product__c = p2.id;
        pp.Price__c = 500;
        pp.Principal__c=pri.id;
        pp.Pack_Size__c = 2;
        pp.UOM__c='No.';
        insert pp;
      //  pp.Product__c = p3.id;
        delete pp;
            }
}