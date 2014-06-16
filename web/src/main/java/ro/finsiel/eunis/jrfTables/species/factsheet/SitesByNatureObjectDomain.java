package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;


/**
 * Date: Oct 2, 2003
 * Time: 1:32:40 PM
 */
public class SitesByNatureObjectDomain extends AbstractDomain {

    /** Cache the results of a count to avoid overhead queries for counting */
    public SitesByNatureObjectDomain() {}

    /****/
    public PersistentObject newPersistentObject() {
        return new SitesByNatureObjectPersist();
    }

     /****/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("chm62edt_sites");
        this.setReadOnly(true);
        this.setTableAlias("C");

        this.addColumnSpec(
                new StringColumnSpec("ID_SITE", "getIDSite", "setIDSite",
                DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude",
                DEFAULT_TO_NULL));
        // FROM chm62edt_country
        this.addColumnSpec(
                new StringColumnSpec("AREA_NAME_EN", "getAreaNameEn",
                "setAreaNameEn", DEFAULT_TO_NULL));
    }
}
