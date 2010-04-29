package ro.finsiel.eunis.admin;

public class UniqueID {
    private static long id;

    public static synchronized String getUniqueID() {
    	long startTime = System.currentTimeMillis();
    	if(id > 10)
    		id = 0;
        return startTime + "-" + id++;
    }
}
