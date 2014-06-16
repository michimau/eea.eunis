package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for chm62edt_site_attributes.
 * @author finsiel
 **/
public class Chm62edtSitesAttributesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new Chm62edtSitesAttributesPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("chm62edt_site_attributes");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                        new StringColumnSpec("NAME", "getName", "setName",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("TYPE", "getType", "setType",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("VALUE", "getValue", "setValue",
                DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_TABLE", "getSourceTable",
                "setSourceTable", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_DB", "getSourceDb", "setSourceDb",
                DEFAULT_TO_EMPTY_STRING));
    }
}
