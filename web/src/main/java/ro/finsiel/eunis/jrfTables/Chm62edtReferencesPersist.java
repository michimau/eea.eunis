package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


public class Chm62edtReferencesPersist extends PersistentObject {

    private Integer IdReference = null;
    private String Author = null;
    private String PublicationDate = null;
    private String Title = null;
    private String TitleAbbrev = null;
    private String Editor = null;
    private String Journal = null;
    private String Book = null;
    private String JournalIssue = null;
    private String Publisher = null;
    private String Isbn = null;
    private String Url = null;

    public Integer getIdReference() {
        if (IdReference == null) {
            return new Integer(0);
        } else {
            return IdReference;
        }
    }

    public void setIdReference(Integer idReference) {
        IdReference = idReference;
    }

    public String getAuthor() {
        if (Author == null) {
            return "";
        } else {
            return Author;
        }
    }

    public void setAuthor(String author) {
        Author = author;
    }

    public String getPublicationDate() {
        if (PublicationDate == null) {
            return "";
        } else {
            return PublicationDate;
        }
    }

    public void setPublicationDate(String publicationDate) {
        PublicationDate = publicationDate;
    }

    public String getTitle() {
        if (Title == null) {
            return "";
        } else {
            return Title;
        }
    }

    public void setTitle(String title) {
        Title = title;
    }

    public String getTitleAbbrev() {
        if (TitleAbbrev == null) {
            return "";
        } else {
            return TitleAbbrev;
        }
    }

    public void setTitleAbbrev(String titleAbbrev) {
        TitleAbbrev = titleAbbrev;
    }

    public String getEditor() {
        if (Editor == null) {
            return "";
        } else {
            return Editor;
        }
    }

    public void setEditor(String editor) {
        Editor = editor;
    }

    public String getJournal() {
        if (Journal == null) {
            return "";
        } else {
            return Journal;
        }
    }

    public void setJournal(String journal) {
        Journal = journal;
    }

    public String getBook() {
        if (Book == null) {
            return "";
        } else {
            return Book;
        }
    }

    public void setBook(String book) {
        Book = book;
    }

    public String getJournalIssue() {
        if (JournalIssue == null) {
            return "";
        } else {
            return JournalIssue;
        }
    }

    public void setJournalIssue(String journalIssue) {
        JournalIssue = journalIssue;
    }

    public String getPublisher() {
        if (Publisher == null) {
            return "";
        } else {
            return Publisher;
        }
    }

    public void setPublisher(String publisher) {
        Publisher = publisher;
    }

    public String getIsbn() {
        if (Isbn == null) {
            return "";
        } else {
            return Isbn;
        }
    }

    public void setIsbn(String isbn) {
        Isbn = isbn;
    }

    public String getUrl() {
        if (Url == null) {
            return "";
        } else {
            return Url;
        }
    }

    public void setUrl(String url) {
        Url = url;
    }

    public Chm62edtReferencesPersist() {
        super();
    }

}
