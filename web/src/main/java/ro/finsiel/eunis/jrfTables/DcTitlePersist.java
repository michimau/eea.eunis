/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:54 $
 **/
public class DcTitlePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idTitle = null;

    /**
     * This is a database field.
     **/
    private String i_title = null;

    /**
     * This is a database field.
     **/
    private String i_alternative = null;

    public DcTitlePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getAlternative() {
        return i_alternative;
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
    public Integer getIdTitle() {
        return i_idTitle;
    }

    /**
     * Getter for a database field.
     **/
    public String getTitle() {
        return i_title;
    }

    /**
     * Setter for a database field.
     * @param alternative
     **/
    public void setAlternative(String alternative) {
        i_alternative = alternative;
        this.markModifiedPersistentState();
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
     * @param idTitle
     **/
    public void setIdTitle(Integer idTitle) {
        i_idTitle = idTitle;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param title
     **/
    public void setTitle(String title) {
        i_title = title;
        this.markModifiedPersistentState();
    }

}
