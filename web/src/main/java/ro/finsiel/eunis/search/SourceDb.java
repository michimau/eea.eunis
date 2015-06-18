package ro.finsiel.eunis.search;

import java.util.*;

/**
 * Source database object for searches.
 * Replaces the old array implementation
 * https://taskman.eionet.europa.eu/issues/16944
 * User: miahi
 * Date: 6/17/15
 */
public class SourceDb {

    /**
     * All the databases
     */
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

    private Set<Database> databases;

    private SourceDb(){
        databases = new HashSet<>();
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

    public Set<Database> getDatabases() {
        return databases;
    }

    /**
     * Adds a database to the list
     * @param db
     * @return
     */
    public SourceDb add(Database db){
        databases.add(db);
        return this;
    }

    /**
     * Adds the database only if the condition is true
     * @param db
     * @param condition
     * @return Same object, for chaining
     */
    public SourceDb add(Database db, boolean condition){
        if(condition){
            add(db);
        }
        return this;
    }

    /**
     * Empty check
     * @return True if no database is inside
     */
    public boolean isEmpty(){
        return databases.isEmpty();
    }

    /**
     * Removes a database from the list
     * @param db
     * @return Same object, for chaining
     */
    public SourceDb remove(Database db){
        databases.remove(db);
        return this;
    }
}
