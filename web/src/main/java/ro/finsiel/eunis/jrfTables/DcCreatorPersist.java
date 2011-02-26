 /*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcCreatorPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idCreator = null;

    /**
     * This is a database field.
     **/
    private String i_creator = null;

    public DcCreatorPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getCreator() {
        return i_creator;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdCreator() {
        return i_idCreator;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Setter for a database field.
     * @param creator
     **/
    public void setCreator(String creator) {
        i_creator = creator;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idCreator
     **/
    public void setIdCreator(Integer idCreator) {
        i_idCreator = idCreator;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
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

}
