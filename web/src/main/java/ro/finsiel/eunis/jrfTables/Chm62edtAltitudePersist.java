package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtAltitudePersist extends PersistentObject implements HabitatOtherInfo {
    private Integer i_idAltzone = null;
    private String oldCode = null;
    private String i_name = null;
    private String i_description = null;

    /**
     * Creates an new Chm62edtAltitudePersist object.
     */
    public Chm62edtAltitudePersist() {
        super();
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getOldCode() {
        return oldCode;
    }

    /**
     * Setter for a database field.
     * @param oldCode New value.
     **/
    public void setOldCode(String oldCode) {
        this.oldCode = oldCode;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getDescription() {
        return i_description;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public Integer getIdAltzone() {
        return i_idAltzone;
    }

    /**
     * Getter for a database field.
     * @return Field value.
     **/
    public String getName() {
        return i_name;
    }

    /**
     * Setter for a database field.
     * @param description New value.
     **/
    public void setDescription(String description) {
        i_description = description;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idAltzone New value.
     **/
    public void setIdAltzone(Integer idAltzone) {
        i_idAltzone = idAltzone;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param name New value.
     **/
    public void setName(String name) {
        i_name = name;
        this.markModifiedPersistentState();
    }
}
