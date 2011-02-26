package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_SPECIES_STATUS.
 * @author finsiel
 **/
public class Chm62edtSpeciesStatusDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSpeciesStatusPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_SPECIES_STATUS");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES_STATUS", "getIdSpeciesStatus",
                "setIdSpeciesStatus", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("SHORT_DEFINITION", "getShortDefinition",
                "setShortDefinition", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("STATUS_CODE", "getStatusCode",
                "setStatusCode", DEFAULT_TO_NULL));
    }
}
