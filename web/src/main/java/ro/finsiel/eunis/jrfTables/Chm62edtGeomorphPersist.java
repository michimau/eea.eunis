package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtGeomorphPersist extends PersistentObject implements HabitatOtherInfo {
    private Integer i_idGeomorph = null;
    private String i_name = null;
    private String i_description = null;
    private String oldCode = null;

    /**
     * Creates an new instance of Chm62edtGeomorphPersist object.
     */
    public Chm62edtGeomorphPersist() {
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
    public Integer getIdGeomorph() {
        return i_idGeomorph;
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
     * @param idGeomorph New value.
     **/
    public void setIdGeomorph(Integer idGeomorph) {
        i_idGeomorph = idGeomorph;
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
