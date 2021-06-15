public class OppertunityNameFormation {
    
    public static void NameFormation(List<Opportunity> oppList)
    {
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth; //april
        Date orgFiscalYearStart = Date.newinstance(system.today().year(), orgFiscalMonth, 1);//2020-04-01
        Date orgFiscalYearEnd = Date.newinstance(system.today().year(), orgFiscalMonth + 11, 31);
        Integer PreviousYear = system.today().year() - 1;
        Integer NextYear = system.today().year() + 1;
        Integer CurrentYear = system.today().year();
        integer OpptyNumber = 1;
        date variable = date.newInstance(system.today().year(), 04, 07);
        list<Opportunity> oppList1 = new list<Opportunity>();
        
                oppList1 = [Select id,createddate,Opportunity_Number__c,Name,Opportunity_Reference__c,reference_Number__c From Opportunity where 
                            createddate>=:orgFiscalYearStart 
                            and createddate<=:orgFiscalYearEnd order by createddate desc limit 1];
            system.debug('print opty list'+oppList1);
        for(Opportunity opt : oppList)
        {
            if (oppList1.size() == 0) 
           {
                if(orgFiscalMonth == 4 && variable == system.today())
                {
                    system.debug('POSITIVE RESET'+opt.Name);
                    oppList[0].Opportunity_Number__c = 'OP'+'0001'+'/'+CurrentYear +'-'+NextYear; 
                }
                
                
           }    
                
                else if(oppList1.size()>0)
                     system.debug('print opty below 10 else if part'+oppList1.size());
                    system.debug('print opty below 10 else if part');
             system.debug('ji'+oppList1[0].Name);
            system.debug('ji'+oppList1[0].Opportunity_Number__c);
                {
                    if(integer.valueOf(oppList1[0].Opportunity_Number__c)!=null)
                        system.debug('print opty below 10 if block one');
                    {
                        OpptyNumber = OpptyNumber+1;
                        OpptyNumber = integer.valueOf(oppList1[0].Opportunity_Number__c); 
                        if(orgFiscalMonth != 4 && variable != system.today()){
                            system.debug('print opty below 10 if block');
                            OpptyNumber = integer.valueOf(oppList1[0].Opportunity_Number__c); 
                            if(OpptyNumber > 99){
                                opt.Opportunity_Number__c = 'OP'+'0'+(OpptyNumber);
                            }
                            else if(OpptyNumber > 9 && OpptyNumber < 99){
                                opt.Opportunity_Number__c = 'OP'+'00'+(OpptyNumber);
                            }
                            else if(OpptyNumber < 10){
                                system.debug('print opty below 10');
                                opt.Opportunity_Number__c = 'OP'+'000'+(OpptyNumber);
                            }
                            else if(OpptyNumber > 99 && OpptyNumber < 999){
                                opt.Opportunity_Number__c ='OP'+(OpptyNumber);
                            }
                            
                        }
                        
                        
                    }
                    
                }
                
            }
        }}