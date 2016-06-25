public class BatchableHandler implements Database.Batchable<sObject> 
{
    private Batchable command;

    public static Id runCommand(Batchable command)
    {
        if (command == null)
            return null; // Or say something relevant

        BatchableHandler batchableHandler = new BatchableHandler(command);
        return Database.executeBatch(batchableHandler);
    }
    
    public BatchableHandler(Batchable command)
    {
        this.command = command;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(command.getQuery());
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        // No error handling by now
        command.execute(scope);
    }
    
    public void finish(Database.BatchableContext BC) {
        // We'll enhance our batch in the future
    }
}