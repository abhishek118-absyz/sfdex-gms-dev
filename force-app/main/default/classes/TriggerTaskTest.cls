@isTest
public class TriggerTaskTest {
    
    public static testMethod void testMethod1(){
        Lead Id = new Lead(FirstName = 'firstName', LastName= 'lastName', Company='company',LeadSource= 'Web',
                          status='New', Company_Alias__c = 'Test', Phone='+916777891012');
         insert Id;
        
        Task tsk = new Task(Subject ='Call', ActivityDate = Date.today(), Description= 'Test', WhoId= Id.Id);
         insert tsk;
        
    }

        
    }