package ro.finsiel.eunis.jrfTables.species.legal;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * @author finsiel
 * @version 1.0
 * @since 15.01.2003
 */
public class LegalReportsDomain extends AbstractDomain {

    /****/
    public PersistentObject newPersistentObject() {
        return new LegalReportsPersist();
    }

    /****/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_REPORTS");

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_NATURE_OBJECT",
                                "getIdNatureObject", "setIdNatureObject",
                                DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                                        new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope",
                                                "setIdGeoscope", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                                                new IntegerColumnSpec("ID_GEOSCOPE_LINK",
                                                        "getIdGeoscopeLink", "setIdGeoscopeLink",
                                                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                                                        new IntegerColumnSpec("ID_REPORT_TYPE",
                                                                "getIdReportType", "setIdReportType", DEFAULT_TO_ZERO,
                                                                NATURAL_PRIMARY_KEY),
                                                                new IntegerColumnSpec("ID_REPORT_ATTRIBUTES",
                                                                        "getIdReportAttributes", "setIdReportAttributes",
                                                                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
        // Add join tables
        this.setReadOnly(true);
        this.setTableAlias("A");
        JoinTable reportType = null;
        JoinTable legalStatus = null;
        JoinTable dcIndex = null;

        reportType = new JoinTable("CHM62EDT_REPORT_TYPE B", "ID_REPORT_TYPE","ID_REPORT_TYPE");
        this.addJoinTable(reportType);
        legalStatus = new JoinTable("CHM62EDT_LEGAL_STATUS C", "ID_LOOKUP", "ID_LEGAL_STATUS");
        legalStatus.addJoinColumn(new StringJoinColumn("ANNEX", "annex", "setAnnex"));
        reportType.addJoinTable(legalStatus);
        dcIndex = new JoinTable("DC_INDEX D", "ID_DC", "ID_DC");
        dcIndex.addJoinColumn(new StringJoinColumn("ALTERNATIVE", "alternative", "setAlternative"));
        this.addJoinTable(dcIndex);
    }
}
