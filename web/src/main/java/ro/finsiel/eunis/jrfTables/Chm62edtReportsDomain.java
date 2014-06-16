package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * JRF table for chm62edt_reports inner join chm62edt_report_type inner join dc_index.
 * @author finsiel
 **/
public class Chm62edtReportsDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    @Override
    public PersistentObject newPersistentObject() {
        return new Chm62edtReportsPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    @Override
    public void setup() {
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
                                                                NATURAL_PRIMARY_KEY),
                                                                new IntegerColumnSpec("ID_REPORT_ATTRIBUTES",
                                                                        "getIdReportAttributes", "setIdReportAttributes",
                                                                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));

        JoinTable reportType = new JoinTable("chm62edt_report_type",
                "ID_REPORT_TYPE", "ID_REPORT_TYPE");

        reportType.addJoinColumn(
                new StringJoinColumn("LOOKUP_TYPE", "lookupType",
                "setLookupType"));
        reportType.addJoinColumn(
                new StringJoinColumn("ID_LOOKUP", "IDLookup", "setIDLookup"));
        this.addJoinTable(reportType);

        JoinTable dcIndex = new JoinTable("dc_index", "ID_DC", "ID_DC");

        dcIndex.addJoinColumn(new IntegerJoinColumn("REFERENCE", "getReference","setReference"));
        dcIndex.addJoinColumn(new IntegerJoinColumn("REFCD", "getReference", "setRefcd"));
        dcIndex.addJoinColumn(new StringJoinColumn("SOURCE", "source", "setSource"));
        dcIndex.addJoinColumn(new StringJoinColumn("CREATED", "created", "setCreated"));
        dcIndex.addJoinColumn(new StringJoinColumn("ALTERNATIVE", "alternative", "setAlternative"));
        this.addJoinTable(dcIndex);
    }
}
