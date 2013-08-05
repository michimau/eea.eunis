/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtInfoQualityPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idInfoQuality = null;

    /**
     * This is a database field.
     **/
    private String i_status = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    public Chm62edtInfoQualityPersist() {
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
    public Integer getIdInfoQuality() {
        return i_idInfoQuality;
    }

    /**
     * Getter for a database field.
     **/
    public String getStatus() {
        return i_status;
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
     * @param idInfoQuality
     **/
    public void setIdInfoQuality(Integer idInfoQuality) {
        i_idInfoQuality = idInfoQuality;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param status
     **/
    public void setStatus(String status) {
        i_status = status;
        this.markModifiedPersistentState();
    }
}
