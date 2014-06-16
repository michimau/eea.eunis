package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_nature_object_attributes.
 * @author altnyris
 **/
public class Chm62edtNatureObjectAttributesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtNatureObjectAttributesPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_nature_object_attributes");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_NATURE_OBJECT",
                                "getIdNatureObject", "setIdNatureObject", "-1",
                                NATURAL_PRIMARY_KEY),
                                new StringColumnSpec("NAME", "getName", "setName",
                                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)));

        this.addColumnSpec(
                new StringColumnSpec("OBJECT", "getObject", "setObject",
                        DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("OBJECTLANG", "getObjectLang",
                        "setObjectLang", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("TYPE", "getType",
                        "setType", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    }
}
