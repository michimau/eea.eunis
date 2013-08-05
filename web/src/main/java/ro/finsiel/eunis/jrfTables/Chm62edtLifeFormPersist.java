package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtLifeFormPersist extends PersistentObject implements HabitatOtherInfo {

    /**
     * This is a database field.
     **/
    private Integer i_idLifeForm = null;

    /**
     * This is a database field.
     **/
    private String i_name = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    private java.sql.Timestamp dateAdded = null;

    public Chm62edtLifeFormPersist() {
        super();
    }

    public java.sql.Timestamp getDateAdded() {
        return dateAdded;
    }

    public void setDateAdded(java.sql.Timestamp dateAdded) {
        this.dateAdded = dateAdded;
    }

    /**
     * Getter for a database field.
     **/
    public String getDescription() {
        return i_description;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdLifeForm() {
        return i_idLifeForm;
    }

    /**
     * Getter for a database field.
     **/
    public String getName() {
        return i_name;
    }

    /**
     * Setter for a database field.
     * @param description
     **/
    public void setDescription(String description) {
        i_description = description;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idLifeForm
     **/
    public void setIdLifeForm(Integer idLifeForm) {
        i_idLifeForm = idLifeForm;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param name
     **/
    public void setName(String name) {
        i_name = name;
        this.markModifiedPersistentState();
    }

}
