package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.column.columnoptions.NullableColumnOption;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * JRF table for eunis_rdf_downloads
 * @author finsiel
 **/
public class EunisRdfDownloadsDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject from AbstractDomain.
     * @return New persistent object (table row).
     */
    public PersistentObject newPersistentObject() {
        return new EunisRdfDownloadsPersist();
    }

    /**
     * Implements setup from AbstractDomain.
     */
    public void setup() {
        this.setTableName("eunis_rdf_downloads");
        this.addColumnSpec(
                new StringColumnSpec("FILE_NAME", "getFileName", "setFileName",
                        DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("TITLE", "getTitle",
                        "setTitle", DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new StringColumnSpec("COMMENT", "getComment", "setComment",
                        DEFAULT_TO_EMPTY_STRING, REQUIRED));
        this.addColumnSpec(
                new TimestampColumnSpec("RECORD_DATE", "getRecordDate",
                        "setRecordDate", DEFAULT_TO_NOW));
        this.addColumnSpec(
                new IntegerColumnSpec("SORT_COLUMN", "getSort", "setSort",
                        DEFAULT_TO_ZERO));
    }
}
