package ro.finsiel.eunis.jrfTables.species.factsheet;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.DateJoinColumn;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:13 $
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
        OuterJoinTable IndexSource = null;
        OuterJoinTable IndexDate = null;
        OuterJoinTable IndexTitle = null;
        OuterJoinTable IndexPublisher = null;

        this.setTableName("CHM62EDT_NATURE_OBJECT");

        this.addColumnSpec(
                new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject",
                "setIdNatureObject", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("TYPE", "getType", "setType",
                DEFAULT_TO_EMPTY_STRING, REQUIRED));

        Index = new JoinTable("DC_INDEX", "ID_DC", "ID_DC");
        this.addJoinTable(Index);

        IndexSource = new OuterJoinTable("DC_SOURCE", "ID_DC", "ID_DC");
        IndexSource.addJoinColumn(
                new StringJoinColumn("SOURCE", "source", "setSource"));
        IndexSource.addJoinColumn(
                new StringJoinColumn("EDITOR", "editor", "setEditor"));
        Index.addJoinTable(IndexSource);

        IndexDate = new OuterJoinTable("DC_DATE", "ID_DC", "ID_DC");
        IndexDate.addJoinColumn(
                new DateJoinColumn("CREATED", "created", "setCreated"));
        Index.addJoinTable(IndexDate);

        IndexTitle = new OuterJoinTable("DC_TITLE", "ID_DC", "ID_DC");
        IndexTitle.addJoinColumn(
                new StringJoinColumn("TITLE", "title", "setTitle"));
        Index.addJoinTable(IndexTitle);

        IndexPublisher = new OuterJoinTable("DC_PUBLISHER", "ID_DC", "ID_DC");
        IndexPublisher.addJoinColumn(
                new StringJoinColumn("PUBLISHER", "publisher", "setPublisher"));
        Index.addJoinTable(IndexPublisher);
    }

}

