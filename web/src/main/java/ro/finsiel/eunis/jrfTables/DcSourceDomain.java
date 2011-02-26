package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for DC_SOURCE.
 * @author finsiel
 **/
public class DcSourceDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new DcSourcePersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());
        this.setTableName("DC_SOURCE");
        this.setReadOnly(true);

        this.addColumnSpec(
                new CompoundPrimaryKeyColumnSpec(
                        new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc",
                        DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY),
                        new IntegerColumnSpec("ID_SOURCE", "getIdSource",
                        "setIdSource", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY)));
        this.addColumnSpec(
                new StringColumnSpec("SOURCE", "getSource", "setSource",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("EDITOR", "getEditor", "setEditor",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("JOURNAL_TITLE", "getJournalTitle",
                "setJournalTitle", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("BOOK_TITLE", "getBookTitle",
                "setBookTitle", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("JOURNAL_ISSUE", "getJournalIssue",
                "setJournalIssue", DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("ISBN", "getIsbn", "setIsbn",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("GEO_LEVEL", "getGeoLevel", "setGeoLevel",
                DEFAULT_TO_NULL));
        this.addColumnSpec(
                new StringColumnSpec("URL", "getUrl", "setUrl", DEFAULT_TO_NULL));
    }
}
