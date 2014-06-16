package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_geoscope.
 * @author finsiel
 **/
public class Chm62edtGeoscopeDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtGeoscopePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_geoscope");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope",
                "setIdGeoscope", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_GEOSCOPE_PARENT",
                "getIdGeoscopeParent", "setIdGeoscopeParent", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("AREA_TYPE", "getAreaType", "setAreaType",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
    }
}
