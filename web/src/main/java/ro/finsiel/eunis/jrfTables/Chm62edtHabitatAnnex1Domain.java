package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_habitat_ANNEX1.
 * @author finsiel
 **/
public class Chm62edtHabitatAnnex1Domain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtHabitatAnnex1Persist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_habitat_ANNEX1");
        this.setReadOnly(true);

        this.addColumnSpec(
                new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000",
                DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("HABITAT_NAME", "getHabitatName",
                "setHabitatName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    }
}
