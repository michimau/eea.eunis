/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:54 $
 **/
public class DcSourcePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idSource = null;

    /**
     * This is a database field.
     **/
    private String i_source = null;

    /**
     * This is a database field.
     **/
    private String i_editor = null;

    /**
     * This is a database field.
     **/
    private String i_journalTitle = null;

    /**
     * This is a database field.
     **/
    private String i_bookTitle = null;

    /**
     * This is a database field.
     **/
    private String i_journalIssue = null;

    /**
     * This is a database field.
     **/
    private String i_isbn = null;

    /**
     * This is a database field.
     **/
    private String i_geoLevel = null;

    /**
     * This is a database field.
     **/
    private String i_url = null;

    public DcSourcePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getBookTitle() {
        return i_bookTitle;
    }

    /**
     * Getter for a database field.
     **/
    public String getEditor() {
        return i_editor;
    }

    /**
     * Getter for a database field.
     **/
    public String getGeoLevel() {
        return i_geoLevel;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdSource() {
        return i_idSource;
    }

    /**
     * Getter for a database field.
     **/
    public String getIsbn() {
        return i_isbn;
    }

    /**
     * Getter for a database field.
     **/
    public String getJournalIssue() {
        return i_journalIssue;
    }

    /**
     * Getter for a database field.
     **/
    public String getJournalTitle() {
        return i_journalTitle;
    }

    /**
     * Getter for a database field.
     **/
    public String getSource() {
        return i_source;
    }

    /**
     * Getter for a database field.
     **/
    public String getUrl() {
        return i_url;
    }

    /**
     * Setter for a database field.
     * @param bookTitle
     **/
    public void setBookTitle(String bookTitle) {
        i_bookTitle = bookTitle;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param editor
     **/
    public void setEditor(String editor) {
        i_editor = editor;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param geoLevel
     **/
    public void setGeoLevel(String geoLevel) {
        i_geoLevel = geoLevel;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSource
     **/
    public void setIdSource(Integer idSource) {
        i_idSource = idSource;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param isbn
     **/
    public void setIsbn(String isbn) {
        i_isbn = isbn;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param journalIssue
     **/
    public void setJournalIssue(String journalIssue) {
        i_journalIssue = journalIssue;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param journalTitle
     **/
    public void setJournalTitle(String journalTitle) {
        i_journalTitle = journalTitle;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param source
     **/
    public void setSource(String source) {
        i_source = source;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param url
     **/
    public void setUrl(String url) {
        i_url = url;
        this.markModifiedPersistentState();
    }

}
