package ro.finsiel.eunis.jrfTables.species.references;


/**
 * Date: Jul 15, 2003
 * Time: 11:14:50 AM
 */

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.DateJoinColumn;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:17 $
 **/
public class ReferencesJoinDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new ReferencesJoinPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());


        OuterJoinTable IndexSource = null;
        OuterJoinTable IndexDate = null;
        OuterJoinTable IndexTitle = null;
        OuterJoinTable IndexPublisher = null;

        this.setTableName("DC_INDEX");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("COMMENT", "getComment", "setComment",
                DEFAULT_TO_NULL));

        IndexSource = new OuterJoinTable("DC_SOURCE", // table name
                "ID_DC", // customer (main) table column(s)
                "ID_DC");
        IndexSource.addJoinColumn(new StringJoinColumn("SOURCE", // Column Name
                "source", // Alias in case of name conflict
                "setSource")); // Setter method name
        IndexSource.addJoinColumn(new StringJoinColumn("EDITOR", // Column Name
                "editor", // Alias in case of name conflict
                "setEditor")); // Setter method name
        IndexSource.addJoinColumn(new StringJoinColumn("URL", // Column Name
                "setUrl")); // Setter method name

        this.addJoinTable(IndexSource);

        IndexDate = new OuterJoinTable("DC_DATE", // table name
                "ID_DC", // customer (main) table column(s)
                "ID_DC");
        IndexDate.addJoinColumn(new DateJoinColumn("CREATED", // Column Name
                "created", // Alias in case of name conflict
                "setCreated")); // Setter method name

        this.addJoinTable(IndexDate);

        IndexTitle = new OuterJoinTable("DC_TITLE", // table name
                "ID_DC", // customer (main) table column(s)
                "ID_DC");
        IndexTitle.addJoinColumn(new StringJoinColumn("TITLE", // Column Name
                "title", // Alias in case of name conflict
                "setTitle")); // Setter method name

        this.addJoinTable(IndexTitle);

        IndexPublisher = new OuterJoinTable("DC_PUBLISHER", // table name
                "ID_DC", // customer (main) table column(s)
                "ID_DC");
        IndexPublisher.addJoinColumn(new StringJoinColumn("PUBLISHER", // Column Name
                "publisher", // Alias in case of name conflict
                "setPublisher")); // Setter method name

        this.addJoinTable(IndexPublisher);

    }

}
