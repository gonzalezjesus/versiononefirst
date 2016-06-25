public with sharing class ContactsService
{
    public class CreateContactsBatchable implements Batchable
    {
        public String getQuery()
        {
            return 'SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact)';
        }

        public void execute(List<Account> accounts)
        {
            createContacts(accounts);
        }
    }

    public static void createContacts(List<Account> scope)
    {
        // This is the existing logic we alredy had in the class.
        // Do something here, like create contacts from the given account list
    }
}