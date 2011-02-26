package ro.finsiel.eunis.search;


/**
 * Wrapper for References used in main references search (header).
 * @author finsiel
 */
public class ReferencesWrapper {
    private String Author = null;
    private String Year = null;
    private String Title = null;
    private String Editor = null;
    private String Publisher = null;
    private String URL = null;
    private String IdDc = null;

    /**
     * Creates a new ReferencesWrapper object.
     * @param Author Author of publication.
     * @param Year Year of publication.
     * @param Title Title of publication.
     * @param Editor Editor of publication.
     * @param Publisher Publisher.
     * @param URL URL.
     * @param IdDc IDDC.
     */
    public ReferencesWrapper(String Author, String Year, String Title, String Editor, String Publisher, String URL, String IdDc) {
        this.Author = Author;
        this.Year = Year;
        this.Editor = Editor;
        this.Publisher = Publisher;
        this.Editor = Editor;
        this.URL = URL;
        this.Title = Title;
        this.IdDc = IdDc;
    }

    /**
     * Getter for Author property.
     * @return Author.
     */
    public String getAuthor() {
        return Author;
    }

    /**
     * Getter for Year property.
     * @return Year.
     */
    public String getYear() {
        return Year;
    }

    /**
     * Getter for Title property.
     * @return Title.
     */
    public String getTitle() {
        return Title;
    }

    /**
     * Getter for Editor property.
     * @return Editor.
     */
    public String getEditor() {
        return Editor;
    }

    /**
     * Getter for Publisher property.
     * @return Publisher.
     */
    public String getPublisher() {
        return Publisher;
    }

    /**
     * Getter for URL property.
     * @return URL.
     */
    public String getURL() {
        return URL;
    }

    public String getIdDc() {
        return IdDc;
    }

    public void setIdDc(String idDc) {
        IdDc = idDc;
    }
}
