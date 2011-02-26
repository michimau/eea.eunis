package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


public class EunisNewsletterPersist extends PersistentObject {

    private String username = null;
    private String email = null;
    private String notes = null;

    public EunisNewsletterPersist() {
        super();
    }

    public String getNotes() {
        return this.notes;
    }

    public String getEmail() {
        return this.email;
    }

    public String getUsername() {
        return this.username;
    }

    public void setUsername(final String username) {
        this.username = username;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    public void setNotes(final String notes) {
        this.notes = notes;
        this.markModifiedPersistentState();
    }

    public void setEmail(final String email) {
        this.email = email;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }
}
