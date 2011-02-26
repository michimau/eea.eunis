package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for CHM62EDT_SITES_RELATED_DESIGNATIONS.
 * @author finsiel
 **/
public class Chm62edtSitesRelatedDesignationsDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSitesRelatedDesignationsPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("CHM62EDT_SITES_RELATED_DESIGNATIONS");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("ID_DESIGNATION",
                        "getIdDesignation", "setIdDesignation",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("SEQUENCE", "getSequence",
                        "setSequence", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("OVERLAP_TYPE", "getOverlapType",
                "setOverlapType", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("OVERLAP", "getOverlap", "setOverlap",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("DESIGNATED_SITE", "getDesignatedSite",
                "setDesignatedSite", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_DB", "getSourceDb", "setSourceDb",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_TABLE", "getSourceTable",
                "setSourceTable", DEFAULT_TO_EMPTY_STRING));
    }
}
