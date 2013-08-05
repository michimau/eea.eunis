/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtLegalStatusPersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idLegalStatus = null;

    /**
     * This is a database field.
     **/
    private String i_annex = null;

    /**
     * This is a database field.
     **/
    private Short i_priority = null;

    /**
     * This is a database field.
     **/
    private String i_comment = null;

    /**
     * This is a database field.
     **/
    private String i_legalStatusCode = null;

    public Chm62edtLegalStatusPersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public String getAnnex() {
        return i_annex;
    }

    /**
     * Getter for a database field.
     **/
    public String getComment() {
        return i_comment;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdLegalStatus() {
        return i_idLegalStatus;
    }

    /**
     * Getter for a database field.
     **/
    public String getLegalStatusCode() {
        return i_legalStatusCode;
    }

    /**
     * Getter for a database field.
     **/
    public Short getPriority() {
        return i_priority;
    }

    /**
     * Setter for a database field.
     * @param annex
     **/
    public void setAnnex(String annex) {
        i_annex = annex;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param comment
     **/
    public void setComment(String comment) {
        i_comment = comment;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idLegalStatus
     **/
    public void setIdLegalStatus(Integer idLegalStatus) {
        i_idLegalStatus = idLegalStatus;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param legalStatusCode
     **/
    public void setLegalStatusCode(String legalStatusCode) {
        i_legalStatusCode = legalStatusCode;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param priority
     **/
    public void setPriority(Short priority) {
        i_priority = priority;
        this.markModifiedPersistentState();
    }

}
