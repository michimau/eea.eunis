/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtMotivationDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new Chm62edtMotivationPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("chm62edt_motivation");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_MOTIVATION", "getIdMotivation",
                "setIdMotivation", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("NAME", "getName", "setName",
                DEFAULT_TO_NULL, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", "getDescription",
                "setDescription", DEFAULT_TO_EMPTY_STRING));
    }

}
