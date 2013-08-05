/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtTemporalPersist extends PersistentObject implements HabitatOtherInfo {

    /**
     * This is a database field.
     **/
    private Integer i_idTemporal = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    private String name = null;

    private Integer used = null;

    public Chm62edtTemporalPersist() {
        super();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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
    public Integer getIdTemporal() {
        return i_idTemporal;
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
     * @param idTemporal
     **/
    public void setIdTemporal(Integer idTemporal) {
        i_idTemporal = idTemporal;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    public Integer getUsed() {
        return used;
    }

    public void setUsed(Integer used) {
        this.used = used;
    }
}
