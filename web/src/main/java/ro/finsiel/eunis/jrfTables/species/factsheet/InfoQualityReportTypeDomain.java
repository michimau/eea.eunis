package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.join.JoinTable;


public class InfoQualityReportTypeDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new InfoQualityReportTypePersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_INFO_QUALITY");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_INFO_QUALITY", "getIdInfoQuality",
                "setIdInfoQuality", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("STATUS", "getStatus", "setStatus",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_EMPTY_STRING, REQUIRED));

        JoinTable reportType = new JoinTable("CHM62EDT_REPORT_TYPE",
                "ID_INFO_QUALITY", "ID_LOOKUP");

        this.addJoinTable(reportType);
    }
}
