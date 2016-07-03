/* Note that this class has been replaced by the BatchableHandler framework */
public class CreateContactsBatch implements Database.Batchable<sObject>
{
    public CreateContactsBatch() {}
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator('SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)');
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        ContactsService.createContacts(scope);
    }
    
    public void finish(Database.BatchableContext BC) {
        // Send a summary
    }   
}