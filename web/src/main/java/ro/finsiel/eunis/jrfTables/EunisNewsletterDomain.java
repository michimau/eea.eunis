package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;


/**
 * JRF table for EUNIS_NEWSLETTER.
 * @author finsiel
 **/
public class EunisNewsletterDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new EunisNewsletterPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("EUNIS_NEWSLETTER");
        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("USERNAME", "getUsername",
                        "setUsername", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("EMAIL", "getEmail", "setEmail",
                        DEFAULT_TO_NULL)));
        this.addColumnSpec(
                new StringColumnSpec("NOTES", "getNotes", "setNotes",
                DEFAULT_TO_NULL));
    }
}
