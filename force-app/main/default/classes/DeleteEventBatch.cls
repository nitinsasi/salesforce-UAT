public class DeleteEventBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext batchContext) {
        String query = 'SELECT Id, Name FROM Event__c WHERE Live__c = true AND End_Date_Time__c < LAST_N_MONTHS:2';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext batchContext, List<sObject> scope) {
        List<Event__c> eventList = (List<Event__c>)scope;
        if (!eventList.isEmpty()) {
            try {
                Database.DeleteResult[] deleteResults = Database.delete(eventList, false);
                for (Database.DeleteResult dr : deleteResults) {
                    if (!dr.isSuccess()) {
                        List<String> errorMessages = new List<String>();
                        for (Database.Error err : dr.getErrors()) {
                            errorMessages.add(err.getMessage());
                        }
                        String errorString = String.join(errorMessages, ', ');
                        TransactionLogHandler.doHandlerExceptionWithErrors(errorString, 'DeleteEventBatch');
                    }
                }
            } catch (Exception ex) {
                TransactionLogHandler.doHandlerException(ex, 'DeleteEventBatch');
            }
        }
    }

    public void finish(Database.BatchableContext batchContext) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setSubject('Batch Processing completed');
List<String> toAddress= new List<String>();
toAddress.add('nitin.sasi@gmail.com');
mail.setToAddresses(toAddress);
mail.setSenderDisplayName('SFDCTEST');
mail.setHtmlBody('The DeleteEventBatch Batch Processing has ben Completed');
List<Messaging.SingleEmailMessage> emails= new List<Messaging.SingleEmailMessage>{mail};
Messaging.sendEmail(emails);
    }
}