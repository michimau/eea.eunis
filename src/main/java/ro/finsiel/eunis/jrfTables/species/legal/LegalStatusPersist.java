package ro.finsiel.eunis.jrfTables.species.legal;

import net.sf.jrf.domain.PersistentObject;

/**
 * @author finsiel
 * @version 1.0
 * @since 16.01.2003
 */
public class LegalStatusPersist extends PersistentObject {

  /** This is a database field. */
  private Integer i_idLegalStatus = null;
  /** This is a database field. */
  private String i_annex = null;
  /** This is a database field. */
  private Short i_priority = null;
  /** This is a database field. */
  private String i_comment = null;
  /** This is a database field. */
  private String i_legalStatusCode = null;

  // Joined columns
  private Integer idReportType = null;
  private String lookupType = null;

  private Integer idDc = null;
  private Integer idNatureObject = null;

  private String alternative = null;
  private String title = null;

  private String scientificName = null;
  private Integer idSpecies = null;
  private Integer idSpeciesLink = null;

  private String commonName = null;

  private String url = null;

  /**
   *
   */
  public LegalStatusPersist() {
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

  public String getCommonName() {
    return commonName;
  }

  public void setCommonName(String commonName) {
    this.commonName = commonName;
  }

  public Integer getIdReportType() {
    return idReportType;
  }

  public void setIdReportType(Integer idReportType) {
    this.idReportType = idReportType;
  }

  public String getLookupType() {
    return lookupType;
  }

  public void setLookupType(String lookupType) {
    this.lookupType = lookupType;
  }

  public Integer getIdDc() {
    return idDc;
  }

  public void setIdDc(Integer idDc) {
    this.idDc = idDc;
  }

  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    this.idNatureObject = idNatureObject;
  }

  public String getAlternative() {
    return alternative;
  }

  public void setAlternative(String alternative) {
    this.alternative = alternative;
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

  public String getScientificName() {
    return scientificName;
  }

  public void setScientificName(String scientificName) {
    this.scientificName = scientificName;
  }

  public Integer getIdSpecies() {
    return idSpecies;
  }

  public void setIdSpecies(Integer idSpecies) {
    this.idSpecies = idSpecies;
  }

  public Integer getIdSpeciesLink() {
    return idSpeciesLink;
  }

  public void setIdSpeciesLink(Integer idSpeciesLink) {
    this.idSpeciesLink = idSpeciesLink;
  }

}
