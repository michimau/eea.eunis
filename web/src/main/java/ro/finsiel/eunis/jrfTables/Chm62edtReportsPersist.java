package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class Chm62edtReportsPersist extends PersistentObject {

    private String lookupType = null;
    private String IDLookup = null;

    private Integer i_idNatureObject = null;
    private Integer i_idDc = null;
    private Integer reference = null;
    private String source;
    private String created;

    public Integer getReference() {
        return reference;
    }

    public void setReference(Integer reference) {
        this.reference = reference;
    }

    public Integer getRefcd() {
        return refcd;
    }

    public void setRefcd(Integer refcd) {
        this.refcd = refcd;
    }

    private Integer refcd = null;
    private Integer i_idGeoscope = null;
    private Integer i_idGeoscopeLink = null;
    private Integer i_idReportType = null;
    private Integer idReportAttributes = null;

    public Chm62edtReportsPersist() {
        super();
    }

    public Integer getIdReportAttributes() {
        return idReportAttributes;
    }

    public void setIdReportAttributes(Integer idReportAttributes) {
        this.idReportAttributes = idReportAttributes;
    }

    public Integer getIdDc() {
        return i_idDc;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdGeoscope() {
        return i_idGeoscope;
    }

    /**
     * Getter for a database field.
     **/
    public Integer getIdGeoscopeLink() {
        return i_idGeoscopeLink;
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
    public Integer getIdReportType() {
        return i_idReportType;
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
     * @param idGeoscope
     **/
    public void setIdGeoscope(Integer idGeoscope) {
        i_idGeoscope = idGeoscope;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idGeoscopeLink
     **/
    public void setIdGeoscopeLink(Integer idGeoscopeLink) {
        i_idGeoscopeLink = idGeoscopeLink;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
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
     * @param idReportType
     **/
    public void setIdReportType(Integer idReportType) {
        i_idReportType = idReportType;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    public String getIDLookup() {
        return IDLookup;
    }

    /**
     * Getter for a joined  field.
     **/
    public String getLookupType() {
        return lookupType;
    }

    /**
     * Setter for a joined field.
     * @param comment
     **/
    public void setLookupType(String comment) {
        lookupType = comment;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a joined  field.
     * @param comment
     **/
    public void setIDLookup(String comment) {
        IDLookup = comment;
        this.markModifiedPersistentState();
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getCreated() {
        return created;
    }

    public void setCreated(String created) {
        this.created = created;
    }
}
