package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_HABITAT_GLOSSARY.
 * @author finsiel
 **/
public class Chm62edtHabitatGlossaryDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatGlossaryPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_HABITAT_GLOSSARY");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("TERM", "getTerm", "setTerm",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("SOURCE", "getSource", "setSource",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("DEFINITION", "getDefinition",
                "setDefinition", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("REFERENCE", "getReference", "setReference",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("MODIFIED_DATE", "getModifiedDate",
                "setModifiedDate", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));
    }
}
