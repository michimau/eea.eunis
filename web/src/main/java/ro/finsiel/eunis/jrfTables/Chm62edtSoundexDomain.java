package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_soundex.
 * @author finsiel
 **/
public class Chm62edtSoundexDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSoundexPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_soundex");
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("PHONETIC", "getPhonetic", "setPhonetic",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("OBJECT_TYPE", "getObjectType",
                "setObjectType", DEFAULT_TO_NULL));
    }
}
