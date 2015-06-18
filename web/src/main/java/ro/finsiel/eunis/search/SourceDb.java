package ro.finsiel.eunis.search;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: miahi
 * Date: 6/17/15
 * Time: 3:45 PM
 */
public class SourceDb {

    public static enum Database {
        NATURA2000("Natura2000"),
        CORINE("Corine"),
        DIPLOMA("Diploma"),
        CDDA_NATIONAL("CDDA_National"),
        CDDA_INTERNATIONAL("CDDA_International"),
        BIOGENETIC("Biogenetic"),
        NATURENET("NatureNet"),
        EMERALD("Emerald");

        private final String databaseName;

        Database(String databaseName){
            this.databaseName = databaseName;
        }

        public String getDatabaseName() {
            return databaseName;
        }
    }

    private List<Database> databaseList;


    private SourceDb(){
        databaseList = new ArrayList<>();
    }

    /**
     * Creates a SourceDb object with no databases
     */
    public static SourceDb noDatabase(){
        return new SourceDb();
    }

    /**
     * Creates a SourceDb object with all the databases
     * @return
     */
    public static SourceDb allDatabases(){
        SourceDb sdb = new SourceDb();
        for(Database d : Database.values()){
            sdb.add(d);
        }
        return sdb;
    }

    /**
     * Legacy support, creates an object from the old way the source DB was implemented
     * @param source
     * @return
     * @deprecated
     */
    public static SourceDb fromArray(boolean[] source){
        SourceDb sdb = new SourceDb();
        if(source.length == 8){
            if(source[0]) sdb.add(Database.NATURA2000);
            if(source[1]) sdb.add(Database.CORINE);
            if(source[2]) sdb.add(Database.DIPLOMA);
            if(source[3]) sdb.add(Database.CDDA_NATIONAL);
            if(source[4]) sdb.add(Database.CDDA_INTERNATIONAL);
            if(source[5]) sdb.add(Database.BIOGENETIC);
            if(source[6]) sdb.add(Database.NATURENET);
            if(source[7]) sdb.add(Database.EMERALD);
        } else {
            return null;
        }
        return sdb;
    }

    public List<Database> getDatabaseList() {
        return databaseList;
    }

    public SourceDb add(Database db){
        databaseList.add(db);
        return this;
    }

    public boolean isEmpty(){
        return databaseList.isEmpty();
    }

    public SourceDb remove(Database db){
        databaseList.remove(db);
        return this;
    }
}
