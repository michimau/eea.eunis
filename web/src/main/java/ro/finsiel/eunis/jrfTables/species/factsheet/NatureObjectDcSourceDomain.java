package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.DateJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;


/**
 *
 * @version $Revision$ $Date$
 **/
public class NatureObjectDcSourceDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new NatureObjectDcSourcePersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        JoinTable Index = null;

        this.setTableName("chm62edt_nature_object");

        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                        "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_NULL));
        this.addColumnSpec(new StringColumnSpec("TYPE", "getType", "setType", DEFAULT_TO_EMPTY_STRING, REQUIRED));

        Index = new JoinTable("dc_index", "ID_DC", "ID_DC");
        Index.addJoinColumn(new StringJoinColumn("SOURCE", "source", "setSource"));
        Index.addJoinColumn(new StringJoinColumn("EDITOR", "editor", "setEditor"));
        Index.addJoinColumn(new DateJoinColumn("CREATED", "created", "setCreated"));
        Index.addJoinColumn(new StringJoinColumn("TITLE", "title", "setTitle"));
        Index.addJoinColumn(new StringJoinColumn("PUBLISHER", "publisher", "setPublisher"));
        this.addJoinTable(Index);
    }

}

