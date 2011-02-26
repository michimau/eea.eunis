package ro.finsiel.eunis.formBeans;


/**
 * Form bean used for newsletter function.
 * @author finsiel
 */
public class NewsletterBean implements java.io.Serializable {
    private String username;
    private String email;
    private String notes;

    /**
     * Creates an new instance of NewsletterBean object.
     */
    public NewsletterBean() {}

    /**
     * Getter for username property.
     * @return username.
     */
    public String getUsername() {
        return username;
    }

    /**
     * Setter for username property.
     * @param value username.
     */
    public void setUsername(String value) {
        username = value;
    }

    /**
     * Getter for email property.
     * @return email.
     */
    public String getEmail() {
        return email;
    }

    /**
     * Setter for email property.
     * @param value email.
     */
    public void setEmail(String value) {
        email = value;
    }

    /**
     * Getter for notes property.
     * @return notes.
     */
    public String getNotes() {
        return notes;
    }

    /**
     * Setter for notes property.
     * @param value notes.
     */
    public void setNotes(String value) {
        notes = value;
    }
}
