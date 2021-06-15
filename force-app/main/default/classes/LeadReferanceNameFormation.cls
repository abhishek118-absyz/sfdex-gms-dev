public class LeadReferanceNameFormation {
    public static void NameFormation(List<Lead> oppList)
    {
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth; //april
        Date orgFiscalYearStart = Date.newinstance(system.today().year(), orgFiscalMonth, 1);//2020-04-01
        Date orgFiscalYearEnd = Date.newinstance(system.today().year(), orgFiscalMonth + 11, 31);
        Integer PreviousYear = system.today().year() - 1;
        Integer NextYear = system.today().year() + 1;
        Integer CurrentYear = system.today().year();
        integer OpptyNumber = 1;
        date variable = date.newInstance(system.today().year(), 04, 08);
        list<Lead> oppList1 = new list<Lead>();
        
        oppList1 = [Select id,createddate,Lead_Number__c ,Name,ref_no__c From Lead where 
                    createddate>=:orgFiscalYearStart 
                    and createddate<=:orgFiscalYearEnd order by ref_no__c desc limit 1];
        			system.debug('oppList1'+oppList1);
        			system.debug('oppList'+oppList);
        
        for(Lead opt : oppList)
            
        {
             if (oppList1.size() == 0) 
						 {
                             system.debug('oppList size'+oppList1.size());
                            if(orgFiscalMonth == 4 && variable == system.today())
                            {
                                //system.debug('oppList[0].Opportunity_Number__c before'+oppList[0].Opportunity_Number__c);
                                oppList[0].Lead_Number__c  = 'OP'+'0001'; 
                                //system.debug('oppList[0].Opportunity_Number__c After'+oppList[0].Opportunity_Number__c);
                                OpptyNumber = 1;
								oppList[0].ref_no__c = 1;
                                
                            }
                            
                        }    
            else if(oppList1.size()>0)
            { 
                OpptyNumber = integer.valueof(oppList1[0].ref_no__c) +1;
                opt.ref_no__c = OpptyNumber;
                if(OpptyNumber > 99)
                {
                    opt.Lead_Number__c  = 'OP'+'0'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber > 9 && OpptyNumber < 99){
                    opt.Lead_Number__c  = 'OP'+'00'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber < 10){
                    system.debug('OpptyNumber'+opt.ref_no__c);
                    opt.Lead_Number__c  = 'OP'+'000'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber > 99 && OpptyNumber < 999){
                    opt.Lead_Number__c  ='OP'+string.valueof(opt.ref_no__c); 
                }
                
            }
            
        }
        
        
    }

}