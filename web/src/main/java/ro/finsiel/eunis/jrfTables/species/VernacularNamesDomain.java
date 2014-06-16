package ro.finsiel.eunis.jrfTables.species;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * This class is used to find the common names for a specie in languages...
 */
public class VernacularNamesDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new VernacularNamesPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("chm62edt_reports");
        this.setReadOnly(true);

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
                        NATURAL_PRIMARY_KEY)));

        // Joined tables
        JoinTable reportTypeAttributes = null;

        reportTypeAttributes = new JoinTable("chm62edt_report_attributes F",
                "ID_REPORT_ATTRIBUTES", "ID_REPORT_ATTRIBUTES");
        reportTypeAttributes.addJoinColumn(
                new StringJoinColumn("VALUE", "setValue"));
        this.addJoinTable(reportTypeAttributes);

        JoinTable reportType = new JoinTable("chm62edt_report_type",
                "ID_REPORT_TYPE", "ID_REPORT_TYPE");

        reportType.addJoinColumn(
                new StringJoinColumn("LOOKUP_TYPE", "lookupType",
                "setLookupType"));
        reportType.addJoinColumn(
                new StringJoinColumn("ID_LOOKUP", "IDLookup", "setIDLookup"));
        this.addJoinTable(reportType);

        JoinTable language = new JoinTable("chm62edt_language", "ID_LOOKUP",
                "ID_LANGUAGE");

        language.addJoinColumn(
                new StringJoinColumn("NAME_EN", "languageName",
                "setLanguageName"));
        language.addJoinColumn(
                new StringJoinColumn("CODE", "languageCode", "setLanguageCode"));
        reportType.addJoinTable(language);
    }
}
