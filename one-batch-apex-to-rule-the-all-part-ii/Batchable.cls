public interface Batchable 
{
	void execute(List<sObject> records);
	String getQuery();
}