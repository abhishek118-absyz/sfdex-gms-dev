public class QuoteNameFormation {
public static void NameFormation(List<Quote> oppList)
    
    {
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth; //april
        Date orgFiscalYearStart = Date.newinstance(system.today().year(), orgFiscalMonth, 1);//2020-04-01
        Date orgFiscalYearEnd = Date.newinstance(system.today().year(), orgFiscalMonth + 11, 31);
        Integer PreviousYear = system.today().year() - 1;
        Integer NextYear = system.today().year() + 1;
        Integer CurrentYear = system.today().year();
        integer OpptyNumber = 1;
        date variable = date.newInstance(system.today().year(), 04, 12);
        list<quote> oppList1 = new list<quote>();
        system.debug('Quote trigger is working');
        
        oppList1 = [Select id,createddate,ref_no__c From quote where 
                    createddate>=:orgFiscalYearStart 
                    and createddate<=:orgFiscalYearEnd order by ref_no__c desc limit 1];
             system.debug('Quote trigger is working'+oppList1);			
        
        for(quote opt : oppList)
            
        {
             if (oppList1.size() == 0) 
						 {
                             system.debug('oppList size');
                            if(orgFiscalMonth == 4 && variable == system.today())
                            {
                                //system.debug('oppList[0].Opportunity_Number__c before'+oppList[0].Opportunity_Number__c);
                                oppList[0].Quote_Reference_No__c = '0001'; 
                                //system.debug('oppList[0].Opportunity_Number__c After'+oppList[0].Opportunity_Number__c);
                                OpptyNumber = 1;
								opt.ref_no__c = 1;
                                
                            }
                            
                        }    
            else if(oppList1.size()>0)
                
            { 
                system.debug(' else if oppList size'+ oppList1[0].ref_no__c);
                OpptyNumber = integer.valueof(oppList1[0].ref_no__c) +1;
                opt.ref_no__c = OpptyNumber;
                if(OpptyNumber > 99)
                {
                    opt.Quote_Reference_No__c = '0'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber > 9 && OpptyNumber < 99){
                    opt.Quote_Reference_No__c = '00'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber < 10){
                    system.debug('Before'+opt.Quote_Reference_No__c);
                    opt.Quote_Reference_No__c = '000'+string.valueof(opt.ref_no__c); 
                    system.debug('After 1'+opt.Quote_Reference_No__c);
                }
                else if(OpptyNumber > 99 && OpptyNumber < 999){
                    opt.Quote_Reference_No__c = string.valueof(opt.ref_no__c); 
                }
                
            }
            
        }
        
        
    }
}