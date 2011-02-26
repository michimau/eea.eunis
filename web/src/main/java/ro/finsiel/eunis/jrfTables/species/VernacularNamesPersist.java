package ro.finsiel.eunis.jrfTables.species;


import net.sf.jrf.domain.PersistentObject;


public class VernacularNamesPersist extends PersistentObject {

    private String lookupType = null;
    private String IDLookup = null;
    private String languageName = null;
    private String languageCode;

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
    private Integer i_idGeoscope = null;

    /**
     * This is a database field.
     **/
    private Integer i_idGeoscopeLink = null;

    /**
     * This is a database field.
     **/
    private Integer i_idReportType = null;

    /**
     * This is a database field.
     **/
    // private String i_referencePeriod = null;
    /**
     * This is a database field.
     **/
    // private Integer i_popMin = null;
    /**
     * This is a database field.
     **/
    // private Integer i_popMax = null;
    /**
     * This is a database field.
     **/
    // private String i_startOfPeriod = null;
    /**
     * This is a database field.
     **/
    // private String i_endOfPeriod = null;
    /**
     * This is a database field.
     **/
    // private String i_vernacularName = null;
    /**
     * This is a database field.
     **/
    // private Short i_selection = null;
    /**
     * This is a database field.
     **/
    // private String i_description = null;
    /**
     * This is a database field.
     **/
    // private String i_comment = null;
    /**
     * This is a database field.
     **/
    // private String i_relationType = null;
    /**
     * This is a database field.
     **/
    // private Short i_relationExistence = null;
    private Integer idReportAttributes = null;
    private String value = null;

    public VernacularNamesPersist() {
        super();
    }

    public Integer getIdReportAttributes() {
        return idReportAttributes;
    }

    public void setIdReportAttributes(Integer idReportAttributes) {
        this.idReportAttributes = idReportAttributes;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    /**
     * Getter for a database field.
     **/
    // public String getComment() { return i_comment; }

    /**
     * Getter for a database field.
     **/
    // public String getDescription() { return i_description; }

    /**
     * Getter for a database field.
     **/
    // public String getEndOfPeriod() { return i_endOfPeriod; }

    /**
     * Getter for a database field.
     **/
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
     * Getter for a database field.
     **/
    // public Integer getPopMax() { return i_popMax; }

    /**
     * Getter for a database field.
     **/
    // public Integer getPopMin() { return i_popMin; }

    /**
     * Getter for a database field.
     **/
    // public String getReferencePeriod() { return i_referencePeriod; }

    /**
     * Getter for a database field.
     **/
    // public Short getRelationExistence() { return i_relationExistence; }

    /**
     * Getter for a database field.
     **/
    // public String getRelationType() { return i_relationType; }

    /**
     * Getter for a database field.
     **/
    // public Short getSelection() { return i_selection; }

    /**
     * Getter for a database field.
     **/
    // public String getStartOfPeriod() { return i_startOfPeriod; }

    /**
     * Getter for a database field.
     **/
    // public String getVernacularName() { return i_vernacularName; }

    /**
     * Setter for a database field.
     * @param comment
     **/
    // public void setComment(String comment) {
    // i_comment = comment;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param description
     **/
    // public void setDescription(String description) {
    // i_description = description;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param endOfPeriod
     **/
    // public void setEndOfPeriod(String endOfPeriod) {
    // i_endOfPeriod = endOfPeriod;
    // this.markModifiedPersistentState();
    // }

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

    /**
     * Setter for a database field.
     * @param popMax
     **/
    // public void setPopMax(Integer popMax) {
    // i_popMax = popMax;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param popMin
     **/
    // public void setPopMin(Integer popMin) {
    // i_popMin = popMin;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param referencePeriod
     **/
    // public void setReferencePeriod(String referencePeriod) {
    // i_referencePeriod = referencePeriod;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param relationExistence
     **/
    // public void setRelationExistence(Short relationExistence) {
    // i_relationExistence = relationExistence;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param relationType
     **/
    // public void setRelationType(String relationType) {
    // i_relationType = relationType;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param selection
     **/
    // public void setSelection(Short selection) {
    // i_selection = selection;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param startOfPeriod
     **/
    // public void setStartOfPeriod(String startOfPeriod) {
    // i_startOfPeriod = startOfPeriod;
    // this.markModifiedPersistentState();
    // }

    /**
     * Setter for a database field.
     * @param vernacularName
     **/
    // public void setVernacularName(String vernacularName) {
    // i_vernacularName = vernacularName;
    // this.markModifiedPersistentState();
    // }

    /**
     * Getter for a joined field.
     **/
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
     * @@param comment
     **/
    public void setLookupType(String comment) {
        lookupType = comment;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a joined  field.
     * @@param comment
     **/
    public void setIDLookup(String comment) {
        IDLookup = comment;
        this.markModifiedPersistentState();
    }

    public String getLanguageName() {
        return languageName;
    }

    public void setLanguageName(String languageName) {
        this.languageName = languageName;
    }

    public String getLanguageCode() {
        return languageCode;
    }

    public void setLanguageCode(String languageCode) {
        this.languageCode = languageCode;
    }
}
