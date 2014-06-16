package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_altitude.
 * @author finsiel
 **/
public class Chm62edtAltitudeDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtAltitudePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("chm62edt_altitude");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_ALTITUDE", "getIdAltzone",
                "setIdAltzone", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", null));
        this.addColumnSpec(
                new StringColumnSpec("OLD_CODE", "getOldCode", "setOldCode",
                DEFAULT_TO_EMPTY_STRING));
    }
}
