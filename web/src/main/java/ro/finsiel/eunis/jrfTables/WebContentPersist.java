package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

import java.sql.Timestamp;
import java.util.Date;


/**
 * This is the JRF Domain class for the WEB_CONTENT table<br />
 * It encapsulates a row from the table.
 */
public class WebContentPersist extends PersistentObject {
    private String IDPage = "";
    private String content = "";
    private String description = "";
    private String lang = "";
    private Short langStatus = new Short((short) 0);
    private Short contentLength = new Short((short) 1);
    private Timestamp recordDate = new Timestamp(new Date().getTime());
    private String recordAuthor = "";

    /** Default constructor */
    public WebContentPersist() {
        super();
    }

    /**
     * Getted for <code>IDPage</code> property
     * @return IDPage
     */
    public String getIDPage() {
        return IDPage;
    }

    /**
     * Setter for <code>IDPage</code>
     * @param IDPage
     */
    public void setIDPage(final String IDPage) {
        this.IDPage = IDPage;
    }

    /**
     * Getter for <code>content</code> property
     * @return content
     */
    public String getContent() {
        return content;
    }

    /**
     * Setter for <code>content</code>
     * @param content
     */
    public void setContent(final String content) {
        this.content = content;
    }

    /**
     * Getter for <code>recordDate</code> property
     * @return recordDate
     */
    public Timestamp getRecordDate() {
        return recordDate;
    }

    /**
     * Setter for <code>recordDate</code>
     * @param recordDate
     */
    public void setRecordDate(final Timestamp recordDate) {
        this.recordDate = recordDate;
    }

    /**
     * Getter for <code>recordAuthor</code>
     * @return recordAuthor
     */
    public String getRecordAuthor() {
        return recordAuthor;
    }

    /**
     * Setter for <code>recordAuthor</code>
     * @param recordAuthor
     */
    public void setRecordAuthor(final String recordAuthor) {
        this.recordAuthor = recordAuthor;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(final String description) {
        this.description = description;
    }

    public String getLang() {
        return lang;
    }

    public void setLang(final String lang) {
        this.lang = lang;
    }

    public Short getLangStatus() {
        return langStatus;
    }

    public void setLangStatus(final Short langStatus) {
        this.langStatus = langStatus;
    }

    public Short getContentLength() {
        return contentLength;
    }

    public void setContentLength(final Short contentLength) {
        this.contentLength = contentLength;
    }
}
