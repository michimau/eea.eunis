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
public class Chm62edtSyntaxaDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new Chm62edtSyntaxaPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_SYNTAXA");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_SYNTAXA", "getIdSyntaxa",
                "setIdSyntaxa", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE_ABBREV", "getSourceAbbrev",
                "setSourceAbbrev", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE", "getSource", "setSource",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));
    }
}
