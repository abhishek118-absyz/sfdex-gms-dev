public class OrderNumberFormation {
    public static void NameFormation(List<Order> oppList)
    {
        Integer orgFiscalMonth = [SELECT FiscalYearStartMonth FROM Organization].FiscalYearStartMonth; //april
        Date orgFiscalYearStart = Date.newinstance(system.today().year(), orgFiscalMonth, 1);//2020-04-01
        Date orgFiscalYearEnd = Date.newinstance(system.today().year(), orgFiscalMonth + 11, 31);
        Integer PreviousYear = system.today().year() - 1;
        Integer NextYear = system.today().year() + 1;
        Integer CurrentYear = system.today().year();
        integer OpptyNumber = 1;
        date variable = date.newInstance(system.today().year(), 04, 12);
        list<Order> oppList1 = new list<Order>();
        
        oppList1 = [Select id,createddate,ref_no__c,Order_Serial_Number__c,Order_RefNumber__c From Order where 
                    createddate>=:orgFiscalYearStart 
                    and createddate<=:orgFiscalYearEnd order by ref_no__c desc limit 1];
        			system.debug('oppList1'+oppList1);
        			system.debug('oppList'+oppList);
        
        for(Order opt : oppList)
            
        {
             if (oppList1.size() == 0) 
						 {
                             system.debug('oppList size'+oppList1.size());
                            if(orgFiscalMonth == 4 && variable == system.today())
                            {
                                
                                oppList[0].Order_Serial_Number__c = '00000001'; 
                                oppList[0].Order_RefNumber__c = '0001';
                               
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
                    opt.Order_Serial_Number__c = '00000'+string.valueof(opt.ref_no__c); 
                    opt.Order_RefNumber__c = '0'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber > 9 && OpptyNumber < 99){
                    opt.Order_Serial_Number__c = '000000'+string.valueof(opt.ref_no__c); 
                    opt.Order_RefNumber__c = '00'+string.valueof(opt.ref_no__c); 
                }
                else if(OpptyNumber < 10){
                    system.debug('OpptyNumber'+opt.ref_no__c);
                    opt.Order_Serial_Number__c = '0000000'+string.valueof(opt.ref_no__c); 
                    opt.Order_RefNumber__c = '000'+string.valueof(opt.ref_no__c); 
                }
                
                else if(OpptyNumber > 99 && OpptyNumber < 999){
                    opt.Order_Serial_Number__c = string.valueof(opt.ref_no__c); 
                     opt.Order_RefNumber__c = string.valueof(opt.ref_no__c);
                }
                
            }
            
        }
        
        
    }

}