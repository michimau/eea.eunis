/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcContributorDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new DcContributorPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("DC_CONTRIBUTOR");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_CONTRIBUTOR",
                        "getIdContributor", "setIdContributor", DEFAULT_TO_ZERO,
                        NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("CONTRIBUTOR", "getContributor",
                "setContributor", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    }

}
