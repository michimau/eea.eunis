package ro.finsiel.eunis.jrfTables.species.legal;


import net.sf.jrf.domain.PersistentObject;


/**
 * @author finsiel
 * @version 1.0
 * @since 10.01.2003
 */
public class ScientificLegalPersist extends PersistentObject {

    /** This is a database field. */
    private Integer i_idSpecies = null;

    /** This is a database field. */
    private Integer i_idNatureObject = null;

    /** This is a database field. */
    private String i_scientificName = null;

    /** This is a database field. */
    private Integer i_idSpeciesLink = null;

    /** This is a database field. */
    private Short i_temporarySelect = null;

    /** This is a database field. */
    private Integer i_idGroupspecies = null;

    /** This is a database field. */
    private Integer idNatureObjectReports = null;

    /** This is a database field. */
    private Integer idReportTypeRep = null;

    /** This is a database field. */
    private Integer idDcRep = null;

    /** This is a database field. */
    private Integer idReportType = null;

    /** This is a database field. */
    private String annex = null;

    /** This is a database field. */
    private String alternative = null;

    /** This is a database field. */
    private Integer idLookup = null;
    private String commonName = null;
    private String title = null;
    private String url = null;
    private String comment = null;

    /** Default constructor */
    public ScientificLegalPersist() {
        super();
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    /** Getter for a database field. */
    public Integer getIdGroupspecies() {
        return i_idGroupspecies;
    }

    /** Getter for a database field. */
    public Integer getIdNatureObject() {
        return i_idNatureObject;
    }

    /** Getter for a database field. */
    public Integer getIdSpecies() {
        return i_idSpecies;
    }

    /** Getter for a database field. */
    public Integer getIdSpeciesLink() {
        return i_idSpeciesLink;
    }

    /** Getter for a database field. */
    public String getScientificName() {
        return i_scientificName;
    }

    /** Getter for a database field. */
    public Short getTemporarySelect() {
        return i_temporarySelect;
    }

    /**
     * Setter for a database field.
     * @param idGroupspecies
     **/
    public void setIdGroupspecies(Integer idGroupspecies) {
        i_idGroupspecies = idGroupspecies;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idNatureObject
     **/
    public void setIdNatureObject(Integer idNatureObject) {
        i_idNatureObject = idNatureObject;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSpecies
     **/
    public void setIdSpecies(Integer idSpecies) {
        i_idSpecies = idSpecies;
        // Changing a primary key so we force this to new.
        this.forceNewPersistentState();
    }

    /**
     * Setter for a database field.
     * @param idSpeciesLink
     **/
    public void setIdSpeciesLink(Integer idSpeciesLink) {
        i_idSpeciesLink = idSpeciesLink;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param scientificName
     **/
    public void setScientificName(String scientificName) {
        i_scientificName = scientificName;
        this.markModifiedPersistentState();
    }

    /**
     * Setter for a database field.
     * @param temporarySelect
     **/
    public void setTemporarySelect(Short temporarySelect) {
        i_temporarySelect = temporarySelect;
        this.markModifiedPersistentState();
    }

    public String getAlternative() {
        return alternative;
    }

    public void setAlternative(String alternative) {
        this.alternative = alternative;
    }

    public String getAnnex() {
        return annex;
    }

    public void setAnnex(String annex) {
        this.annex = annex;
    }

    public Integer getIdReportType() {
        return idReportType;
    }

    public void setIdReportType(Integer idReportType) {
        this.idReportType = idReportType;
    }

    public Integer getIdReportTypeRep() {
        return idReportTypeRep;
    }

    public void setIdReportTypeRep(Integer idReportTypeRep) {
        this.idReportTypeRep = idReportTypeRep;
    }

    public Integer getIdNatureObjectReports() {
        return idNatureObjectReports;
    }

    public void setIdNatureObjectReports(Integer idNatureObjectReports) {
        this.idNatureObjectReports = idNatureObjectReports;
    }

    public Integer getIdLookup() {
        return idLookup;
    }

    public void setIdLookup(Integer idLookup) {
        this.idLookup = idLookup;
    }

    public Integer getIdDcRep() {
        return idDcRep;
    }

    public void setIdDcRep(Integer idDcRep) {
        this.idDcRep = idDcRep;
    }

    public String getCommonName() {
        return commonName;
    }

    public void setCommonName(String commonName) {
        this.commonName = commonName;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
