public class TransactionLogHandler {
    
    public static void doHandlerException(System.Exception ex, String processName) {
        Error_Log__c transactionLog = new Error_Log__c (
            Log_Details__c = ex.getStackTraceString() + 
                ' <br/><strong> message is </strong> ' + ex.getMessage() +
                ' <br/> ' + String.valueOf(ex.getCause()) +
                ' <br/> ' + ex.getTypeName() +
                ' <br/> ' + ex.getLineNumber(),
            Process_Name__c = processName,
            Lod_DateTime__c = System.now() // ✅ Ensure this is the correct field name
        );
        insert transactionLog;
    }
    
    
    
       public static void doHandlerExceptionWithErrors(String errors, String processName) {
        Error_Log__c transactionLog = new Error_Log__c (
            Log_Details__c = errors,
            Process_Name__c = processName,
            Lod_DateTime__c = System.now() // ✅ Ensure this is the correct field name
        );
        insert transactionLog;
    }
}