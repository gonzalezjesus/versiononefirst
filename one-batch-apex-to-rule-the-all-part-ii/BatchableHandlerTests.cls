@isTest(SeeAllData=false)
public class BatchableHandlerTests 
{
    private static List<Account> testAccounts;

    @TestSetup static void createAccount()
    {
        Account testAccount = new Account();
        testAccount.Name = 'Scissorhands, Eduard';
        insert testAccount;
    }
    
    // Check that BatchHandler successfully runs a couple of commands 
    @isTest static void batchableHandler_runsAListOfCommands()
    {
        // Given
        NameAssembler commandA = new NameAssembler();
        commandA.AccountNameSuffix = 'Jack';
        NameAssembler commandB = new NameAssembler();
        commandB.AccountNameSuffix = 'Sparrow';
        List<NameAssembler> commands = new List<NameAssembler>{commandA, commandB};

        // When
        Test.startTest();
        BatchableHandler.runCommands(commands);
        Test.stopTest();

        // Then
        assertAccountNamesContain(commandA.AccountNameSuffix);
        assertAccountNamesContain(commandB.AccountNameSuffix);
    }

    private class NameAssembler implements Batchable
    {
        public String AccountNameSuffix {get; set;}

        public NameAssembler()
        {
            AccountNameSuffix = '';
        }

        public String getQuery()
        {
            return 'SELECT Id, Name FROM Account LIMIT 1';
        }

        public void execute(List<Account> accounts)
        {
            for(Account acc : accounts)
                acc.Name += ', ' + AccountNameSuffix;

            update accounts;
        }
    }

    private static void assertAccountNamesContain(String value)
    {
        if (testAccounts == null)
            testAccounts = [SELECT Id, Name FROM Account];

        System.assert(!testAccounts.isEmpty());

        for (Account acc : testAccounts)
            System.assert(acc.Name.contains(value), 'Account Name does not contain: ' + value + '. Current account Name: ' + acc.Name);
    }
}