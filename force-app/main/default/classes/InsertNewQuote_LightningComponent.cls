public class InsertNewQuote_LightningComponent {
    @auraenabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        // system.debug('objObject --->' + objObject);
        //system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        //system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    @auraenabled
    public static id insertquoterecord(quote quo,id oppid) {
        //gets the quote and opportunity id
        string recordtypename=quo.Process_Type__c+'_'+quo.Quote_Type__c+'_'+quo.Company_Types__c;
        //  system.debug('recordtypename'+recordtypename);
        //  soql to get the record type
        Id quoterecordid = [select id from Recordtype where SobjectType = 'Quote' and name =:recordtypename ].id;
        quo.RecordTypeId=quoterecordid;
        quo.OpportunityId=oppid;
        insert quo;//insert the quote and return the quote id to the lightning component 
        return quo.id;       
        
    }
    @auraenabled
    public static string getCurrency(string oppId){
        opportunity opp = [Select name,CurrencyIsoCode from opportunity where id=:oppId];
    //    System.debug(opp.CurrencyIsoCode);
        return opp.CurrencyIsoCode;
    }
}