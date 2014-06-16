package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.column.columnoptions.NullableColumnOption;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.TimestampColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 * This is the JRF Domain class for the WEB_CONTENT table
 */
public class WebContentDomain extends AbstractDomain {

    /**
     * Implements newPersistentObject() from AbstractDomain<br />
     * @return New Persist JRF Object (WebContentPersist)
     */
    public PersistentObject newPersistentObject() {
        return new WebContentPersist();
    }

    /**
     * Implements setup() from AbstractDomain<br />
     * Table definition.
     */
    public void setup() {
        this.setTableName("eunis_web_content");
        this.addColumnSpec(
                new StringColumnSpec("ID_PAGE", "getIDPage", "setIDPage",
                DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new StringColumnSpec("CONTENT", new NullableColumnOption(),
                "getContent", "setContent", null));
        this.addColumnSpec(
                new StringColumnSpec("DESCRIPTION", new NullableColumnOption(),
                "getDescription", "setDescription", null));
        this.addColumnSpec(
                new StringColumnSpec("LANG", "getLang", "setLang", "en"));
        this.addColumnSpec(
                new ShortColumnSpec("LANG_STATUS", new NullableColumnOption(),
                "getLangStatus", "setLangStatus", DEFAULT_TO_ONE));
        this.addColumnSpec(
                new ShortColumnSpec("CONTENT_LENGTH", new NullableColumnOption(),
                "getContentLength", "setContentLength", DEFAULT_TO_ZERO));
        this.addColumnSpec(
                new TimestampColumnSpec("RECORD_DATE", "getRecordDate",
                "setRecordDate", DEFAULT_TO_NOW));
        this.addColumnSpec(
                new StringColumnSpec("RECORD_AUTHOR", new NullableColumnOption(),
                "getRecordAuthor", "setRecordAuthor", null));
    }
}
