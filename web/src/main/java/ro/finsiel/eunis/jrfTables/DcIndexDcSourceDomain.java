package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.TimestampJoinColumn;


/**
 * JRF table for DC_INDEX outer join DC_SOURCE outer join DC_DATE outer join DC_TITLE outer join DC_PUBLISHER.
 * @author finsiel
 **/
public class DcIndexDcSourceDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new DcIndexDcSourcePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
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

        IndexSource = new OuterJoinTable("DC_SOURCE", "ID_DC", "ID_DC");
        IndexSource.addJoinColumn(
                new StringJoinColumn("SOURCE", "source", "setSource"));
        IndexSource.addJoinColumn(
                new StringJoinColumn("EDITOR", "editor", "setEditor"));
        IndexSource.addJoinColumn(new StringJoinColumn("URL", "setUrl"));
        this.addJoinTable(IndexSource);

        IndexDate = new OuterJoinTable("DC_DATE", "ID_DC", "ID_DC");
        IndexDate.addJoinColumn(
                new TimestampJoinColumn("CREATED", "created", "setCreated"));
        this.addJoinTable(IndexDate);

        IndexTitle = new OuterJoinTable("DC_TITLE", "ID_DC", "ID_DC");
        IndexTitle.addJoinColumn(
                new StringJoinColumn("TITLE", "title", "setTitle"));
        this.addJoinTable(IndexTitle);

        IndexPublisher = new OuterJoinTable("DC_PUBLISHER", "ID_DC", "ID_DC");
        IndexPublisher.addJoinColumn(
                new StringJoinColumn("PUBLISHER", "publisher", "setPublisher"));
        this.addJoinTable(IndexPublisher);
    }
}
