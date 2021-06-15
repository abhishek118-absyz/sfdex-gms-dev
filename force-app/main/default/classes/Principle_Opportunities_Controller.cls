public class Principle_Opportunities_Controller {
     @AuraEnabled
    public static List<OpportunityLineItem> Listofprinciplropportunities(ID principleId){
        system.debug('enter');
        List<OpportunityLineItem> oppsonproducts=[select id,name,OpportunityId,Product2Id,Product2.Name,Opportunity.Name,Principal__c from OpportunityLineItem where Principal__c=:principleId];
          system.debug('oppsonproducts'+oppsonproducts);
        return oppsonproducts;
    }
}