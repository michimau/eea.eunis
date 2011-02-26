package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.join.JoinTable;
import ro.finsiel.eunis.jrfTables.Chm62edtSpeciesStatusPersist;


/**
 * Date: 20.06.2003
 * Time: 16:45:21
 */
public class SpeciesStatusReportTypeDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new SpeciesStatusReportTypePersist();
    }

    /**
     **/
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

        JoinTable reportType = new JoinTable("CHM62EDT_REPORT_TYPE",
                "ID_SPECIES_STATUS", "ID_LOOKUP");

        this.addJoinTable(reportType);
    }
}
