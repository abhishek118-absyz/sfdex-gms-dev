public class ProductFamilyTableHandler {
    
    @AuraEnabled
    public static WrapperClass getProductFamily(Id recId){
        
        System.debug('recId '+recId);
        
        Map<Product_Family__c,boolean> pdtFamilyMap = new Map<Product_Family__c,boolean>();
        WrapperClass wrp = new WrapperClass();
        wrp.opportunityProductFamily = new List<Id>();
        wrp.productFamilyRecord = new List<Product_Family__c>();
        wrp.productFamilyRecord = [Select Name from Product_Family__c ORDER BY Name limit 50000];
        String str = [Select ProductFamilyId__c from Opportunity where id =: recId].ProductFamilyId__c;
        if(str!=null)
            wrp.opportunityProductFamily = str.split(',');
        
        System.debug('wrp '+wrp);
        return wrp;
    }
    
    public class WrapperClass{
        
        @AuraEnabled
        public List<Id> opportunityProductFamily{get;set;}
        @AuraEnabled
        public List<Product_Family__c> productFamilyRecord{get;set;}  
        
    }
    
    @AuraEnabled
    public static void updateProductFamily(Id recId, String productFamId, String productFamName, String productFamoppRefrence){
        system.debug('OpprecId'+recId);
         List<String> oppRefrences=new List<String>();
        Opportunity opp = [Select Name,ProductFamilyId__c,Opportunity_Reference__c, ProductFamilyName__c from Opportunity where id =:recId];
        opp.ProductFamilyId__c = productFamId;
        opp.ProductFamilyName__c = productFamName;
        
        String oppname = opp.Name;
        String oppReference = opp.Opportunity_Reference__c;
        //System.debug('productFamId==='+productFamId);
        if(productFamId!=null){
            String ProductFamilyIds = productFamId; 
            String ProductFamilyNames = productFamName;
            List<String> productFmlyIdsList = ProductFamilyIds.split(',');
            List<String> ProductFamilyNamesList = ProductFamilyNames.split(',');
            List<id> oppidsRelatedtoProductFmly = new list<id>();
            List<String> oppnameRelatedtoProductFmly = new list<String>();
            oppidsRelatedtoProductFmly.addAll(productFmlyIdsList);
            oppnameRelatedtoProductFmly.addAll(ProductFamilyNamesList);
            List<Product_Family__c> productFmlyList = [Select Id,OpportunityId_related_to_product_family__c,Opportunity_Reference__c,Opportunity_Name__c,Opportunity_Count__c,OpportunityName_Reltd_To_Product_Family__c,Name from Product_Family__c where id IN:oppidsRelatedtoProductFmly];
            List<Product_Family__c> updateproductFmlyList = new List<Product_Family__c>();
            for(Product_Family__c pf:productFmlyList){            
                if(productFmlyIdsList.contains(pf.Id)){                    
                    if(pf.OpportunityId_related_to_product_family__c==null){
                        pf.OpportunityId_related_to_product_family__c=+recId;
                        pf.OpportunityName_Reltd_To_Product_Family__c=+oppname;
                       pf.Opportunity_Reference__c=+oppReference;
                     List<String> countOpp1 = pf.OpportunityName_Reltd_To_Product_Family__c.split(',');
                        pf.Opportunity_Count__c=countOpp1.size();
                    } 
                    else if(!pf.OpportunityId_related_to_product_family__c.contains(String.valueOf(recId))){
                        pf.OpportunityId_related_to_product_family__c+= +','+recId;
                        pf.OpportunityName_Reltd_To_Product_Family__c+= +','+oppname;
                        pf.Opportunity_Reference__c=+','+oppReference;
                       List<String> countOpp = pf.OpportunityName_Reltd_To_Product_Family__c.split(',');
                        pf.Opportunity_Count__c=countOpp.size();
                        system.debug('pf.Opportunity_Reference__c'+ pf.Opportunity_Reference__c);
                        
                    }
                    
                    if(!updateproductFmlyList.contains(pf)){
                        updateproductFmlyList.add(pf);                               
                    }
                }                
            }  
            update updateproductFmlyList;
        }                
        update opp;                
    }
    
    @AuraEnabled
    public static list<Product_Family__c> searchKey(String sKey){
        //System.debug('sKey '+sKey);
        String str = '%'+skey+'%';
        return [Select Name from Product_Family__c where name LIKE :str  ORDER BY Name limit 50000];
    }
}