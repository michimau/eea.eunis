package eionet.eunis.dto;

/**
 * Document DTO object.
 * 
 * @author altnyris
 */
public class ReferenceDTO {

    /**
     * serial.
     */
    private static final long serialVersionUID = 1L;

    private String idRef;
    private String title;
    private String alternative;
    private String author;
    private String year;

    public String getIdRef() {
        return idRef;
    }

    public void setIdRef(String idRef) {
        this.idRef = idRef;
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

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }


}
