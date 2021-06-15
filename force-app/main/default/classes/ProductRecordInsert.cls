public class ProductRecordInsert {
    /*  @AuraEnabled 

public static opportunity oppcurrency(String proid)
{
opportunity opprec=[select id,CurrencyIsoCode from opportunity];
return opprec;

}
@AuraEnabled 

public static Product2 proreord(String proid,String recid)
{
opportunity opprec=[select id,CurrencyIsoCode from opportunity where id=:recid];   
Product2 opp=[select id,name,Available_Product__c,CurrencyIsoCode,(select id,Principal_Name__c,Product_Quantity__c,Price__c,Pack_Size__c,UOM__c,CurrencyIsoCode from Product_Pricings__r where CurrencyIsoCode =: opprec.CurrencyIsoCode) from Product2 where id=:proid];
return opp;
}
@AuraEnabled
public static  void inserrecord(string recid,string proid ,string Principalname,string packsize,integer quantity,double marginprice,double discount,decimal salesprice ){

opportunity opprec=[select id,CurrencyIsoCode from opportunity where id=:recid];   
product2 prod=[select id from product2 where id =: proid];
PricebookEntry pricebookentity=[select id,PRODUCT2ID,CurrencyIsoCode from PricebookEntry where PRODUCT2ID=:prod.id and CurrencyIsoCode=: opprec.CurrencyIsoCode];
Principal__c pri=[select id from Principal__c where name=:Principalname limit 1];
OpportunityLineItem oppline=new OpportunityLineItem();
oppline.Product2Id=prod.id;
oppline.Principal__c=pri.id;
oppline.Discount_Amount__c=discount;
oppline.Quantity=quantity;
oppline.UnitPrice=salesprice;
oppline.Margin_Amount__c=marginprice;
oppline.Unit_of_Measure_UOM__c=packsize;
oppline.OpportunityId=recid;
oppline.PricebookEntryId=pricebookentity.id;
system.debug('oppoline'+oppline);
insert oppline;


}*/
    @AuraEnabled 
    
    public static Product2 prodquote(String proid,String recid)
    {
        system.debug('proid--'+proid);
        system.debug('recid--'+recid);
        quote quoterecord=[select id,opportunityid,isSyncing from quote where id=:recid];
        system.debug('quoterecord--'+quoterecord);
        opportunity opprec=[select id,CurrencyIsoCode from opportunity where id=:quoterecord.opportunityid];
        system.debug('opprec--'+opprec);
        Product2 pro=[select id,name,Available_Product__c,CurrencyIsoCode,(select id,Principal_Name__c,Product_Quantity__c,Price__c,Pack_Size__c,UOM__c,CurrencyIsoCode from Product_Pricings__r where CurrencyIsoCode =: opprec.CurrencyIsoCode) from Product2 where id=:proid];
        pro.CurrencyIsoCode=opprec.CurrencyIsoCode;
        system.debug('opp--'+pro);
		return pro;
    }
    /* @AuraEnabled
public static boolean checkedquotesync(string recid){

system.debug('recid'+recid);
quote quoterecord=[select id,opportunityid,isSyncing from quote where id=:recid];
system.debug('quoterecord'+quoterecord);
return quoterecord.isSyncing;
}
*/
    @AuraEnabled
    public static  void insertfromquote(string recid,string proid ,string Principalname,string packsize,integer quantity,double marginprice,double discount,decimal salesprice ){
        quote quoterecord=[select id,opportunityid,isSyncing,pricebook2id from quote where id=:recid];
        
        //system.debug('quoterecord'+quoterecord);
        opportunity opprec=[select id,CurrencyIsoCode from opportunity where id=:quoterecord.opportunityid];  
        //system.debug('opprec'+opprec);
        
        //product2 prod=[select id from product2 where id =: proid];
        //system.debug('prod'+prod);
        pricebook2 pricebook=[select id from pricebook2 where isstandard=true limit 1];
        
        
         system.debug('pricebook'+pricebook);
        PricebookEntry pricebookentityid=[select id,PRODUCT2ID,CurrencyIsoCode from PricebookEntry where pricebook2id=:pricebook.id and  PRODUCT2ID=:proid and CurrencyIsoCode=: opprec.CurrencyIsoCode limit 1 ];
        //system.debug('pricebookentityid'+pricebookentityid);
        Principal__c pri=[select id from Principal__c where name=:Principalname limit 1];
        //system.debug('pri'+pri);
        quotelineitem quoline=new quotelineitem();
        quoline.PricebookEntryId= pricebookentityid.id;
        quoline.Product2Id=proid;
        quoline.QuoteId=quoterecord.id;
        quoline.Principal2__c=pri.id;
        quoline.Discount_Amount2__c=discount;
        quoline.Quantity=quantity;
        quoline.UnitPrice=salesprice;
        quoline.Unit_Price__c=salesprice;
        quoline.Margin_Amount2__c=marginprice;
        quoline.Unit_of_Measure_UOM2__C=packsize;
        quoline.QuoteId=recid;
        
        //system.debug('quoline'+quoline);
        if(quoterecord.pricebook2id==null ){
            quoterecord.pricebook2id=pricebook.id;
            update quoterecord;
        }
        insert quoline;
        
        
    }
}