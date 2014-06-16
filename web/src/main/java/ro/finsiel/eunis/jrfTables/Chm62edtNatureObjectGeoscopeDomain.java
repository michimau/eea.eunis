package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_nature_object_geoscope.
 * @author finsiel
 **/
public class Chm62edtNatureObjectGeoscopeDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtNatureObjectGeoscopePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_nature_object_geoscope");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_NATURE_OBJECT",
                        "getIdNatureObject", "setIdNatureObject",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_NATURE_OBJECT_LINK",
                        "getIdNatureObjectLink", "setIdNatureObjectLink",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope",
                        "setIdGeoscope", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_REPORT_ATTRIBUTES",
                        "getIdReportAttributes", "setIdReportAttributes",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
    }
}
