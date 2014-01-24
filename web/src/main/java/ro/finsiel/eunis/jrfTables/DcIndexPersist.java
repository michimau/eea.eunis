/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class DcIndexPersist extends PersistentObject {

    private Integer idDc = null;
    private String comment = null;
    private int reference = -1;
    private String created = null;
    private String title = null;
    private String alternative = null;
    private String publisher = null;
    private String source = null;
    private String editor = null;
    private String journalTitle = null;
    private String bookTitle = null;
    private String journalIssue = null;
    private String isbn = null;
    private String url = null;


    public DcIndexPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getComment() {
        return comment;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return idDc;
    }

    public int getReference() {
        return reference;
    }

    /**
     * Setter for a database field.
     * @param comment
     **/
    public void setComment(String comment) {
        this.comment = comment;
        this.markModifiedPersistentState();
    }

    public void setReference(Integer reference) {
        if (reference == null) {
            this.reference = -1;
        } else {
            this.reference = reference;
        }
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        if(created != null && created.length() > 4) {
            created = created.substring(0, 4);
        }
        this.created = created;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAlternative() {
        return alternative;
    }

    public void setAlternative(String alternative) {
        this.alternative = alternative;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getEditor() {
        return editor;
    }

    public void setEditor(String editor) {
        this.editor = editor;
    }

    public String getJournalTitle() {
        return journalTitle;
    }

    public void setJournalTitle(String journalTitle) {
        this.journalTitle = journalTitle;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getJournalIssue() {
        return journalIssue;
    }

    public void setJournalIssue(String journalIssue) {
        this.journalIssue = journalIssue;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public void setReference(int reference) {
        this.reference = reference;
    }

}
