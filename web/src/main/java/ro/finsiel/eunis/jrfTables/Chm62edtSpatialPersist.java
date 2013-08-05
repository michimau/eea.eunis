/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtSpatialPersist extends PersistentObject implements HabitatOtherInfo {

    /**
     * This is a database field.
     **/
    private Integer i_idSpatial = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    private String name = null;

    public Chm62edtSpatialPersist() {
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
    public Integer getIdSpatial() {
        return i_idSpatial;
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
     * @param idSpatial
     **/
    public void setIdSpatial(Integer idSpatial) {
        i_idSpatial = idSpatial;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

}
