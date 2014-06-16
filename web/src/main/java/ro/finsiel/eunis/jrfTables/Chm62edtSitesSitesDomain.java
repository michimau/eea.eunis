package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.BigDecimalColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_sites_sites.
 * @author finsiel
 **/
public class Chm62edtSitesSitesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSitesSitesPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("chm62edt_sites_sites");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite",
                        DEFAULT_TO_ZERO, REQUIRED),
                        new StringColumnSpec("ID_SITE_LINK", "getIdSiteLink",
                        "setIdSiteLink", DEFAULT_TO_EMPTY_STRING, REQUIRED),
                        new IntegerColumnSpec("SEQUENCE", "getSequence",
                        "setSequence", DEFAULT_TO_ZERO, REQUIRED),
                        new StringColumnSpec("RELATION_TYPE", "getRelationType",
                        "setRelationType", DEFAULT_TO_EMPTY_STRING, REQUIRED),
                        new BigDecimalColumnSpec("OVERLAP", "getOverlap",
                        "setOverlap", DEFAULT_TO_ZERO, REQUIRED)));
        this.addColumnSpec(
                new IntegerColumnSpec("WITHIN_PROJECT", "getWithinProject",
                "setWithinProject", DEFAULT_TO_ZERO));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_TABLE", "getSourceTable",
                "setSourceTable", DEFAULT_TO_NULL));
    }
}
