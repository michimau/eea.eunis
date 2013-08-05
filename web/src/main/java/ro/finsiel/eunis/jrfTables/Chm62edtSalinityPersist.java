/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtSalinityPersist extends PersistentObject implements HabitatOtherInfo {

    /**
     * This is a database field.
     **/
    private Integer i_idSalinity = null;

    /**
     * This is a database field.
     **/
    private String i_name = null;

    /**
     * This is a database field.
     **/
    private String i_description = null;

    private String oldCode = null;

    private Short used = null;

    public Chm62edtSalinityPersist() {
        super();
    }

    public String getOldCode() {
        return oldCode;
    }

    public void setOldCode(String oldCode) {
        this.oldCode = oldCode;
    }

    public Short getUsed() {
        return used;
    }

    public void setUsed(Short used) {
        this.used = used;
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
    public Integer getIdSalinity() {
        return i_idSalinity;
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
     * @param idSalinity
     **/
    public void setIdSalinity(Integer idSalinity) {
        i_idSalinity = idSalinity;
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
