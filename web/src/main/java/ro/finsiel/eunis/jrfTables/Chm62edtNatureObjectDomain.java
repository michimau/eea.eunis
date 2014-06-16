package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_nature_object.
 * @author finsiel
 **/
public class Chm62edtNatureObjectDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtNatureObjectPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_nature_object");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("ORIGINAL_CODE", "getOriginalCode",
                "setOriginalCode", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("TYPE", "getType", "setType",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
    }
}
