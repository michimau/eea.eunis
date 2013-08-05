package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtWaterPersist extends PersistentObject implements HabitatOtherInfo {

    /**
     * This is a database field.
     **/
    private Integer i_idWater = null;

    /**
     * This is a database field.
     **/
    private String i_name = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    public Chm62edtWaterPersist() {
        super();
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
    public Integer getIdWater() {
        return i_idWater;
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
     * @param idWater
     **/
    public void setIdWater(Integer idWater) {
        i_idWater = idWater;
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
