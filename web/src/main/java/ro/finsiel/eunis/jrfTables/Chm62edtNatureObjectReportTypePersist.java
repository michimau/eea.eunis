/*
 * $Id
 */

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtNatureObjectReportTypePersist extends PersistentObject {

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObject = null;

    /**
     * This is a database field.
     **/
    private Integer i_idNatureObjectLink = null;

    /**
     * This is a database field.
     **/
    private Integer i_idReportType = null;

    private Integer idReportAttributes = null;

    private String lookupType = null;

    private Integer idDc = null;

    private String IDLookup = null;

    private Integer idGeoscope = null;

    public Chm62edtNatureObjectReportTypePersist() {
        super();
    }

    public Integer getIdGeoscope() {
        return idGeoscope;
    }

    public void setIdGeoscope(Integer idGeoscope) {
        this.idGeoscope = idGeoscope;
    }

    public String getIDLookup() {
        return IDLookup;
    }

    public void setIDLookup(String IDLookup) {
        this.IDLookup = IDLookup;
    }

    public Integer getIdDc() {
        return idDc;
    }

    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }

    public String getLookupType() {
        return lookupType;
    }

    public void setLookupType(String lookupType) {
        this.lookupType = lookupType;
    }

    public Integer getIdReportAttributes() {
        return idReportAttributes;
    }

    public void setIdReportAttributes(Integer idReportAttributes) {
        this.idReportAttributes = idReportAttributes;
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
    public Integer getIdNatureObjectLink() {
        return i_idNatureObjectLink;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdReportType() {
        return i_idReportType;
    }

    /**
     * Getter for a database field.
     **/
    // public Short getRelationExist() { return i_relationExist; }

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
     * @param idNatureObjectLink
     **/
    public void setIdNatureObjectLink(Integer idNatureObjectLink) {
        i_idNatureObjectLink = idNatureObjectLink;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idReportType
     **/
    public void setIdReportType(Integer idReportType) {
        i_idReportType = idReportType;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param relationExist
     **/
    // public void setRelationExist(Short relationExist) {
    // i_relationExist = relationExist;
    // this.markModifiedPersistentState();
    // }

}
