public class QuoteCloneHandler {
    
    
    /*@AuraEnabled
public static list<contact> getContact(Id recId){
list<Contact> cont = [select name, phone from contact where Accountid=:recId];
return cont;
}*/
    
    @AuraEnabled
    public static object insertQuote(String recordJSON, String ObjectName, Id quoteRecId, String radioInput, String processInput, String quoteInput){	
        
        
        List<QuoteLineItem> qlRecord = new List<QuoteLineItem>();
        List<Quote> updateQuote = new list<Quote>();
        sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
        schema.SObjectType sobjType = Schema.getGlobalDescribe().get(ObjectName);
        Map<String, Schema.sObjectField> sObjectFields = sobjType.getDescribe().fields.getMap();
        Map<String,Id> quoteRecordType = new Map<String,Id>();
        for(Quote qo: [Select recordTypeId, recordType.developerName from Quote]){
            quoteRecordType.put(qo.recordType.developerName, qo.recordTypeId);
        }
        System.debug('quoteRecordType '+quoteRecordType);
        System.debug('processInput '+processInput);
        System.debug('quoteInput '+quoteInput);
        System.debug('Company type '+sObj.get('Company_Types__c'));
        System.debug('sObj '+sObj);
        
        Map<String, Object> objMap = (Map<String, Object>) JSON.deserializeUntyped(recordJSON);
        
        if(processInput == 'option1'){
            sObj.put('Process_Type__c','Standard');
            sObj.put('Status','Draft');
            sObj.put('Technical_Evaluation_required__c','');
            if(quoteInput == 'option1'){
                sObj.put('Quote_Type__c','Budgetary');
                if(objMap.get('Company_Types__c')=='GMS'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Standard_Budgetary_GMS'));
                }else if(objMap.get('Company_Types__c')=='Prolyx'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Standard_Budgetary_Prolyx'));
                }else{
                    sObj.put('RecordTypeId',quoteRecordType.get('GMS'));
                }
            
        }else if(quoteInput == 'option2'){
            sObj.put('Quote_Type__c','Formal');
            if(objMap.get('Company_Types__c')=='GMS'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Standard_Formal_GMS'));
                }else if(objMap.get('Company_Types__c')=='Prolyx'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Standard_Formal_Prolyx'));
                }else{
                    sObj.put('RecordTypeId',quoteRecordType.get('GMS'));
                }

        }
        }else if(processInput == 'option2'){
            System.debug('NonStandaard');
            sObj.put('Process_Type__c','Non-Standard');
            sObj.put('Status','Quote Request sent to Principal');
            sObj.put('Technical_Evaluation_required__c','');
            if(quoteInput == 'option1'){
                System.debug('Budge');
                sObj.put('Quote_Type__c','Budgetary');
                System.debug('NonStdBud Gms '+quoteRecordType.get('Non_Standard_Budgetary_GMS'));
                if(sObj.get('Company_Types__c')=='GMS'){
                    System.debug('GMS***');
                    System.debug('NonStdBud Gms '+quoteRecordType.get('Non_Standard_Budgetary_GMS'));
                    sObj.put('RecordTypeId',quoteRecordType.get('Non_Standard_Budgetary_GMS'));
                }else if(sObj.get('Company_Types__c')=='Prolyx'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Non_Standard_Budgetary_Prolyx'));
                }else{
                    sObj.put('RecordTypeId',quoteRecordType.get('Non_Standard_Budgetary_GMS'));
                }
            
        }else if(quoteInput == 'option2'){
            sObj.put('Quote_Type__c','Formal');
            if(sObj.get('Company_Types__c')=='GMS'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Non_Standard_Formal_GMS'));
                }else if(sObj.get('Company_Types__c')=='Prolyx'){
                    sObj.put('RecordTypeId',quoteRecordType.get('Non_Standard_Formal_Prolyx'));
                }else{
                    sObj.put('RecordTypeId',quoteRecordType.get('Non_Standard_Formal_GMS'));
                }

        }
            //sObj.put('Status','Draft');
            //quo.RecordTypeId = '0127F000000K41IQAS';
            //quo.Process_Type__c= 'Non-Standard';
            //quo.Status = 'Quote Request sent to Principal';
        }
        
        System.debug('rec '+sObj.get('RecordTypeId'));
        System.debug('Sync '+sObj.get('IsSyncing'));
        
        Quote recType = [Select Name,recordtypeId,Pricebook2Id,QuoteNumber__c,QuoteVersion__c from Quote where id=:quoteRecId limit 1];
        system.debug('rectype::: '+recType);
        if(recType!=null){
            //sObj.put('RecordTypeId',recType.recordTypeId);
            sObj.put('Pricebook2Id',recType.Pricebook2Id);
        }
        System.debug('sObj** '+sObj+'sobjType '+sobjType);
        
        System.debug('objMap* '+objMap);
        
        for(String fieldName : objMap.keySet()) {
            if(fieldName == 'QuoteNumber__c' || fieldName=='QuoteVersion__c' || fieldName=='Process_Type__c' || fieldName=='Status'|| fieldName=='Quote_Type__c' || fieldName == 'Technical_Evaluation_required__c')
                continue;
            Object value = objMap.get(fieldName);
            System.debug('fieldName '+fieldName+'Value '+value);
            System.debug('getType '+ sObjectFields.get(fieldName));
            if(sObjectFields.get(fieldName)!=null){
            Schema.DisplayType valueType = sObjectFields.get(fieldName).getDescribe().getType();
            if (value instanceof String && valueType != Schema.DisplayType.String)
            {
                String svalue = (String)value;
                if (valueType == Schema.DisplayType.Date)
                    sObj.put(fieldName, Date.valueOf(svalue));
                else if(valueType == Schema.DisplayType.DateTime) {
                    //DateTime is a special case which we need to handle carefully. It is working in my case you need to handle it.
                    try{
                        String d1 = svalue;
                        list<String> d2 = d1.split('-');
                        list<integer> timeComponent = new list<integer>();
                        timeComponent.add(Integer.valueOf(d2[0]));
                        timeComponent.add(Integer.valueOf(d2[1]));
                        timeComponent.add(Integer.valueOf(d2[2].left(2)));
                        
                        String t = d2[2].substringBetween('T','.');
                        
                        list<String> time1 = t.split(':');
                        timeComponent.add(Integer.valueOf(time1[0]));
                        timeComponent.add(Integer.valueOf(time1[1]));
                        timeComponent.add(Integer.valueOf(time1[2]));
                        
                        Datetime dt = Datetime.newInstance(timeComponent[0],timeComponent[1],timeComponent[2],timeComponent[3],timeComponent[4],timeComponent[5]);
                        sObj.put(fieldName, dt);
                    }
                    catch(exception ex){}
                }
                else if (valueType == Schema.DisplayType.Percent || valueType == Schema.DisplayType.Currency)
                    sObj.put(fieldName, svalue == '' ? null : Decimal.valueOf(svalue));
                else if (valueType == Schema.DisplayType.Double)
                    sObj.put(fieldName, svalue == '' ? null : Double.valueOf(svalue));
                else if (valueType == Schema.DisplayType.Integer)
                    sObj.put(fieldName, Integer.valueOf(svalue));
                //else if (valueType == Schema.DisplayType.De)
                else if (valueType == Schema.DisplayType.Base64)
                    sObj.put(fieldName, Blob.valueOf(svalue));
                else
                    sObj.put(fieldName, svalue);
            }
            else
                sObj.put(fieldName, value);
        }
        }
        insert sObj;
        
        for(QuoteLineItem ql : [Select Discount,ListPrice,OpportunityLineItemId,PricebookEntryId,Product2Id,Quantity,CostPrice__c,Margin_Amount2__c, MarginDiscountPercent__c,
                                MarginDiscountValue__c,MarginPercent__c,FinalMarginValue__c,Final_Price2__c,Discount_Amount2__c,TotalDiscount__c,CGST__c,SGST__c,IGST__c,
                                UOM__c,Principal2__c,CustomerPartNumber__c,PrincipalPartNumber__c,Tax__c,ProductDescription__c,IsChecked__c, CalculationType__c,IsOptional__c,
                                QuoteId,ServiceDate,Subtotal,UnitPrice,Unit_Price__c, CostPriceDiscount__c, CostPriceDiscountValue__c from QuoteLineItem where QuoteId = :quoteRecId]){
                                    
                                    QuoteLineItem newql = new QuoteLineItem();
                                    newql = ql;
                                    newql.id = null;
                                    newql.QuoteId = sObj.id;
                                    newql.CostPrice__c = ql.CostPrice__c;
                                    newql.Margin_Amount2__c = ql.Margin_Amount2__c;
                                    newql.MarginDiscountPercent__c = ql.MarginDiscountPercent__c;
                                    newql.MarginDiscountValue__c = ql.MarginDiscountValue__c;
                                    newql.MarginPercent__c = ql.MarginPercent__c;
                                    newql.FinalMarginValue__c =ql.FinalMarginValue__c;
                                    newql.Final_Price2__c = ql.Final_Price2__c;
                                    newql.Discount_Amount2__c = ql.Discount_Amount2__c;
                                    newql.TotalDiscount__c = ql.TotalDiscount__c;
                                    newql.CostPriceDiscount__c = ql.CostPriceDiscount__c;
                                    newql.CostPriceDiscountValue__c = ql.CostPriceDiscountValue__c;
                                    newql.CGST__c = ql.CGST__c;
                                    newql.SGST__c = ql.SGST__c;
                                    newql.IGST__c = ql.IGST__c;
                                    newql.UOM__c = ql.UOM__c;
                                    newql.Principal2__c = ql.Principal2__c;
                                    newql.CustomerPartNumber__c = ql.CustomerPartNumber__c;
                                    newql.PrincipalPartNumber__c = ql.PrincipalPartNumber__c;
                                    newql.Tax__c = ql.Tax__c;
                                    newql.IsChecked__c = ql.IsChecked__c;
                                    newql.CalculationType__c = ql.CalculationType__c;
                                    newql.IsOptional__c = ql.IsOptional__c;
                                    newql.ProductDescription__c = ql.ProductDescription__c;
                                    newql.Unit_Price__c=ql.Unit_Price__c;
                                    qlRecord.add(newql);
                                }
        System.Debug('qlRecord '+qlRecord);
        if(qlRecord.size()>0){
            insert qlRecord;
        }
        
        Quote quo = [Select Name, QuoteNumber__c, QuoteVersion__c, Process_Type__c, Quote_Type__c  from Quote where id =:sObj.Id limit 1];
        System.debug('quo '+quo);
        
        if(radioInput == 'option1'){
            quo.QuoteNumber__c = quo.Name;
        }else if(radioInput == 'option2'){
            //quo.QuoteNumber__c = recType.QuoteNumber__c;
            System.debug('quo.QuoteVersion__c::: '+recType.QuoteVersion__c);
            quo.QuoteVersion__c = String.valueOf(Integer.valueOf(recType.QuoteVersion__c) + 1);
            System.debug('Version::: '+quo.QuoteVersion__c);
            String quoteName = recType.QuoteNumber__c;
            System.debug('QuoteName::: '+quoteName);
            String[] name = quoteName.split('-');
            
            quo.QuoteNumber__c = name[0] +'-'+name[1]+'-'+quo.QuoteVersion__c;
        }
        system.debug('Final Quote is::: '+quo);
        update quo;
        update recType;
        return sObj.id;
        
    }
    
    //This Method is to get related Quote of an Opportunity.
    @AuraEnabled
    public static list <sObject> relatedQuote(String OpportunityId){
        List <sObject> returnList = new List < sObject > ();
        String sQuery = 'SELECT Id, Name, OpportunityId, Opportunity.Name, IsSyncing, Grand_Total__c, Quote_Type__c, CreatedBy.Name, Quote_Expiration_Date__c,QuoteNumber__c, ExpirationDate, Subtotal, Totalprice,status FROM Quote WHERE OpportunityId =: OpportunityId ORDER BY CreatedDate DESC';
        List <sObject> lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    //Method Ends Here
}