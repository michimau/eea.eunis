package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.DateJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 * JRF table for chm62edt_reports inner join dc_index
 * @author finsiel
 **/
public class Chm62edtReportsDcSourceDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtReportsDcSourcePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        JoinTable Index = null;

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

        Index = new JoinTable("dc_index", "ID_DC", "ID_DC");
        Index.addJoinColumn(new StringJoinColumn("SOURCE", "source", "setSource"));
        Index.addJoinColumn(new StringJoinColumn("EDITOR", "editor", "setEditor"));
        Index.addJoinColumn(new DateJoinColumn("CREATED", "created", "setCreated"));
        Index.addJoinColumn(new StringJoinColumn("TITLE", "title", "setTitle"));
        Index.addJoinColumn(new StringJoinColumn("PUBLISHER", "publisher", "setPublisher"));
        this.addJoinTable(Index);
    }

    /**
     * Wrapper for SELECT COUNT(*) FROM dc_index
     * @param sqlWhere WHERE condition.
     * @return Long.
     */
    public Long countWhere(String sqlWhere) {
        return this.findLong("SELECT count(*) FROM dc_index " + sqlWhere);
    }
}
