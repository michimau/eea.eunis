package ro.finsiel.eunis.admin;

public class UniqueID {
    private static long startTime = System.currentTimeMillis();
    private static long id;

    public static synchronized String getUniqueID() {
        return startTime + "-" + id++;
    }
}
