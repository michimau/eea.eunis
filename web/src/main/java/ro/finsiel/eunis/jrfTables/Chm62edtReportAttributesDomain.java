package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;


/**
 * JRF table for chm62edt_report_attributes.
 * @author finsiel
 **/
public class Chm62edtReportAttributesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtReportAttributesPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_report_attributes");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_REPORT_ATTRIBUTES",
                        "getIdReportAttributes", "setIdReportAttributes",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("NAME", "getName", "setName",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("TYPE", "getType", "setType",
                DEFAULT_TO_NULL, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("VALUE", "getValue", "setValue",
                DEFAULT_TO_NULL, REQUIRED));
    }
}
