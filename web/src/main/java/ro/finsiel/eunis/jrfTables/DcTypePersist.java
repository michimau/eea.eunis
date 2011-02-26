/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:54 $
 **/
public class DcTypePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idType = null;

    /**
     * This is a database field.
     **/
    private String i_type = null;

    public DcTypePersist() {
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
    public Integer getIdType() {
        return i_idType;
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
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idType
     **/
    public void setIdType(Integer idType) {
        i_idType = idType;
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

}
