/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcDatePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idDc = null;

    /**
     * This is a database field.
     **/
    private Integer i_idDate = null;

    /**
     * This is a database field.
     **/
    private java.sql.Timestamp i_mdate = null;

    /**
     * This is a database field.
     **/
    private java.sql.Timestamp i_created = null;

    /**
     * This is a database field.
     **/
    private java.sql.Timestamp i_valid = null;

    /**
     * This is a database field.
     **/
    private java.sql.Timestamp i_available = null;

    /**
     * This is a database field.
     **/
    private java.sql.Timestamp i_issued = null;

    /**
     * This is a database field.
     **/
    private java.sql.Timestamp i_modified = null;

    public DcDatePersist() {
        super();
    }

    /**
     * Getter for a database field.
     **/
    public java.sql.Timestamp getAvailable() {
        return i_available;
    }

    /**
     * Getter for a database field.
     **/
    public java.sql.Timestamp getCreated() {
        return i_created;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdDate() {
        return i_idDate;
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
    public java.sql.Timestamp getIssued() {
        return i_issued;
    }

    /**
     * Getter for a database field.
     **/
    public java.sql.Timestamp getMdate() {
        return i_mdate;
    }

    /**
     * Getter for a database field.
     **/
    public java.sql.Timestamp getModified() {
        return i_modified;
    }

    /**
     * Getter for a database field.
     **/
    public java.sql.Timestamp getValid() {
        return i_valid;
    }

    /**
     * Setter for a database field.
     * @param available
     **/
    public void setAvailable(java.sql.Timestamp available) {
        i_available = available;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param created
     **/
    public void setCreated(java.sql.Timestamp created) {
        i_created = created;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idDate
     **/
    public void setIdDate(Integer idDate) {
        i_idDate = idDate;
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

    /**
     * Setter for a database field.
     * @param issued
     **/
    public void setIssued(java.sql.Timestamp issued) {
        i_issued = issued;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param mdate
     **/
    public void setMdate(java.sql.Timestamp mdate) {
        i_mdate = mdate;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param modified
     **/
    public void setModified(java.sql.Timestamp modified) {
        i_modified = modified;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param valid
     **/
    public void setValid(java.sql.Timestamp valid) {
        i_valid = valid;
        this.markModifiedPersistentState();
    }

}
