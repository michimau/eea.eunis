/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtNatureObjectPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private String i_type = null;

    private String originalCode = null;

    public Chm62edtNatureObjectPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }

    /**
     * Getter for a database field.
     **/
    public String getType() {
        return i_type;
    }

    /**
     * Setter for a database field.
     * @param idDc
     **/
    public void setIdDc(Integer idDc) {
        i_idDc = idDc;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param type
     **/
    public void setType(String type) {
        i_type = type;
        this.markModifiedPersistentState();
    }

    public String getOriginalCode() {
        return originalCode;
    }

    public void setOriginalCode(String originalCode) {
        this.originalCode = originalCode;
    }
}
