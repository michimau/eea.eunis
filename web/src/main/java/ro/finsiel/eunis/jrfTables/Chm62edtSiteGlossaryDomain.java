package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.ByteArrayColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_SITE_GLOSSARY.
 * @author finsiel
 **/
public class Chm62edtSiteGlossaryDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSiteGlossaryPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_SITE_GLOSSARY");
        this.setReadOnly(true);

        this.addColumnSpec(
                new StringColumnSpec("TERM", "getTerm", "setTerm",
                DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new ByteArrayColumnSpec("DEFINITION", "getDefinition",
                "setDefinition", null, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("REFERENCE", "getReference", "setReference",
                DEFAULT_TO_NULL));
    }
}
