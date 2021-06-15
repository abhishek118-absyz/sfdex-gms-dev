public class changeOwnerClass {
 public static void changeOwner(list<Quote> lstQuote){
     system.debug('lstQuote'+lstQuote);
       for (Quote objQuote : lstQuote){
           system.debug('quote'+objQuote.Name);
            if(objQuote.Name!='' || objQuote.Name!=null){
                objQuote.OwnerID = '0057F000003CcCDQA0';
                system.debug('ownerid'+objQuote.OwnerID);
               // update objQuote;
            }
        }
    }
}