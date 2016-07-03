public class BatchableHandler implements Database.Batchable<sObject>
{
    private List<Batchable> commands;

    public static Id runCommands(List<Batchable> commands)
    {
        List<Batchable> nonNullCommands = cloneNonNulls(commands);
        if (nonNullCommands.isEmpty())
            return null; // Or say something relevant

        BatchableHandler batchableHandler = new BatchableHandler(nonNullCommands);
        return Database.executeBatch(batchableHandler);
    }
    
    private BatchableHandler(List<Batchable> commands)
    {
        this.commands = commands;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(commands[0].getQuery());
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        // No error handling by now
        commands[0].execute(scope);
    }
    
    public void finish(Database.BatchableContext BC) 
    {
        if (commands.size() > 1)
        {
            commands.remove(0);
            runCommands(commands);
        }
        // else, notify user everithing is done!
    }

    private static List<Batchable> cloneNonNulls(List<Batchable> commands)
    {
        List<Batchable> nonNullCommands = new List<Batchable>();

        if (commands != null)
            for (Batchable command : commands)
                if (command != null)
                    nonNullcommands.add(command);

        return nonNullCommands;
    }
}
