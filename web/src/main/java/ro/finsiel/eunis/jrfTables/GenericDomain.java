package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;


/**
 * JRF table for a generic table with one column definition.
 * @author finsiel
 **/
public class GenericDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new GenericPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_SPECIES"); // Some table name should be specified so I choosed species.
        this.setReadOnly(true);

        this.addColumnSpec(
                new StringColumnSpec("COLUMN1", "getColumn1", "setColumn1",
                DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
    }
}
