package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;


/**
 * Created by IntelliJ IDEA.
 * User: cromanescu
 * Date: Sep 29, 2005
 * Time: 3:09:35 PM
 * To change this template use File | Settings | File Templates.
 */
public class EunisISOLanguagesDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new EunisISOLanguagesPersist();
    }

    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("eunis_iso_languages");
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("CODE", "getCode", "setCode",
                DEFAULT_TO_NULL));
    }
}
