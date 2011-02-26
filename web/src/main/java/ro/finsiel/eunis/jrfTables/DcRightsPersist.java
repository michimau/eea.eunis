/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcRightsPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idRights = null;

    /**
     * This is a database field.
     **/
    private String i_rights = null;

    public DcRightsPersist() {
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
    public Integer getIdRights() {
        return i_idRights;
    }

    /**
     * Getter for a database field.
     **/
    public String getRights() {
        return i_rights;
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
     * @param idRights
     **/
    public void setIdRights(Integer idRights) {
        i_idRights = idRights;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param rights
     **/
    public void setRights(String rights) {
        i_rights = rights;
        this.markModifiedPersistentState();
    }

}
