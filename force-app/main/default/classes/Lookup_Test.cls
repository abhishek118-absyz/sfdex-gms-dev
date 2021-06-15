@isTest
public class Lookup_Test {
    @isTest
static void searchDB()
    {
         Product_Family__c profamily=new Product_Family__c(Name='family1');
        insert profamily;
        
        Product2 p2=new Product2(Name='pro1',ProductCode='procode1',Product_Family__c=profamily.id);
        insert p2;
        
        
        Id pricebookId = Test.getStandardPricebookId();
        system.debug('pricebookId '+pricebookId);
        
        Pricebook2 customPB = new Pricebook2(Id=pricebookId, isActive=TRUE);
        upsert customPB;
        
        PricebookEntry pricebookentityid=new PricebookEntry(Product2Id=p2.id,Pricebook2Id=pricebookId,UnitPrice=2500,isActive=TRUE);
        //insert pricebookentityid;
        
        Principal__c pri=new Principal__c(Name='Principle1',Email__c='seshu.dantuluri@absyz.com');
        insert pri;
        
       string objectName='Product2';
             string   field_API_text='Name';
                    string      field_API_val='ID';
                        integer lim=10;
                      string    field_API_search='Name';
                string searchText='pro1';
        string currencyopp='USD';
        string currencyAPI='CurrencyIsoCode';
            //String objectName, String fld_API_Text, String fld_API_Val,Integer lim,String fld_API_Search,String searchText,string currencyopp,string currencyAPI
        Lookup.searchDB(objectName,field_API_text,field_API_val,lim,field_API_search,searchText,currencyopp,currencyAPI);
    }
}