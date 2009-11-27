package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class DesignationsSitesRelatedDesignationsPersist extends PersistentObject {
  private String i_idDesignation = null;
  private String idGeoscope = null;
  private String i_cddaSites = null;
  private String i_description = null;
  private String descriptionEn = null;
  private String descriptionFr = null;
  private java.math.BigDecimal i_referenceArea = null;
  private java.math.BigDecimal totalArea = null;
  private String abbreviation = null;
  private String nationalLaw = null;
  private String nationalCategory = null;
  private String nationalLawReference = null;
  private String nationalLawAgency = null;
  private String dataSource = null;
  private java.math.BigDecimal referenceNumber = null;
  private String referenceDate = null;
  private String remark = null;
  private String remarkSource = null;
  private String sourceDb = null;
  private String overlap = null;
  private String overlapType = null;
  private String designatedSite = null;
  private String sourceDB = null;

  /**
   * Creates an new instance of Chm62edtDesignationsPersist object.
   */
  public DesignationsSitesRelatedDesignationsPersist() {
    super();
  }


  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdGeoscope() {
    return idGeoscope;
  }

  /**
   * Setter for a database field.
   * @param IdGeoscope New value.
   **/
  public void setIdGeoscope(String IdGeoscope) {
    this.idGeoscope = IdGeoscope;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getDescriptionEn() {
    if (null == descriptionEn) return "";
    return descriptionEn;
  }

  /**
   * Setter for a database field.
   * @param descriptionEn New value.
   **/
  public void setDescriptionEn(String descriptionEn) {
    this.descriptionEn = descriptionEn;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getDescriptionFr() {
    if (null == descriptionFr) return "";
    return descriptionFr;
  }

  /**
   * Setter for a database field.
   * @param descriptionFr New value.
   **/
  public void setDescriptionFr(String descriptionFr) {
    this.descriptionFr = descriptionFr;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public java.math.BigDecimal getTotalArea() {
    return totalArea;
  }

  /**
   * Setter for a database field.
   * @param totalArea New value.
   **/
  public void setTotalArea(java.math.BigDecimal totalArea) {
    this.totalArea = totalArea;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getAbbreviation() {
    return abbreviation;
  }

  /**
   * Setter for a database field.
   * @param abbreviation New value.
   **/
  public void setAbbreviation(String abbreviation) {
    this.abbreviation = abbreviation;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getNationalCategory() {
    return nationalCategory;
  }

  /**
   * Setter for a database field.
   * @param nationalCategory New value.
   **/
  public void setNationalCategory(String nationalCategory) {
    this.nationalCategory = nationalCategory;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getNationalLawReference() {
    return nationalLawReference;
  }

  /**
   * Setter for a database field.
   * @param nationalLawReference New value.
   **/
  public void setNationalLawReference(String nationalLawReference) {
    this.nationalLawReference = nationalLawReference;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getDataSource() {
    return dataSource;
  }

  /**
   * Setter for a database field.
   * @param DataSource New value.
   **/
  public void setDataSource(String DataSource) {
    this.dataSource = DataSource;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getNationalLaw() {
    return nationalLaw;
  }

  /**
   * Setter for a database field.
   * @param nationalLaw New value.
   **/
  public void setNationalLaw(String nationalLaw) {
    this.nationalLaw = nationalLaw;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getNationalLawAgency() {
    return nationalLawAgency;
  }

  /**
   * Setter for a database field.
   * @param nationalLawAgency New value.
   **/
  public void setNationalLawAgency(String nationalLawAgency) {
    this.nationalLawAgency = nationalLawAgency;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public java.math.BigDecimal getReferenceNumber() {
    return referenceNumber;
  }

  /**
   * Setter for a database field.
   * @param referenceNumber New value.
   **/
  public void setReferenceNumber(java.math.BigDecimal referenceNumber) {
    this.referenceNumber = referenceNumber;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getReferenceDate() {
    return referenceDate;
  }

  /**
   * Setter for a database field.
   * @param referenceDate New value.
   **/
  public void setReferenceDate(String referenceDate) {
    this.referenceDate = referenceDate;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getRemark() {
    return remark;
  }

  /**
   * Setter for a database field.
   * @param remark New value.
   **/
  public void setRemark(String remark) {
    this.remark = remark;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getRemarkSource() {
    return remarkSource;
  }

  /**
   * Setter for a database field.
   * @param remark New value.
   **/
  public void setRemarkSource(String remark) {
    this.remarkSource = remark;
  }


  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getSourceDb() {
    return sourceDb;
  }

  /**
   * Setter for a database field.
   * @param sourceDb New value.
   **/
  public void setSourceDb(String sourceDb) {
    this.sourceDb = sourceDb;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getCddaSites() {
    return i_cddaSites;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getDescription() {
    if (null == i_description) return "";
    return i_description;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdDesignation() {
    return i_idDesignation;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public java.math.BigDecimal getReferenceArea() {
    return i_referenceArea;
  }

  /**
   * Setter for a database field.
   * @param cddaSites New value.
   **/
  public void setCddaSites(String cddaSites) {
    i_cddaSites = cddaSites;
  }

  /**
   * Setter for a database field.
   * @param description New value.
   **/  public void setDescription(String description) {
    i_description = description;
  }

  /**
   * Setter for a database field.
   * @param idDesignation New value.
   **/
  public void setIdDesignation(String idDesignation) {
    i_idDesignation = idDesignation;
  }

  /**
   * Setter for a database field.
   * @param referenceArea New value.
   **/
  public void setReferenceArea(java.math.BigDecimal referenceArea) {
    i_referenceArea = referenceArea;
  }

  public String getOverlap() {
    return overlap;
  }

  public void setOverlap(String overlap) {
    this.overlap = overlap;
  }

  public String getOverlapType() {
    return overlapType;
  }

  public void setOverlapType(String overlapType) {
    this.overlapType = overlapType;
  }

  public String getDesignatedSite() {
    return designatedSite;
  }

  public void setDesignatedSite(String designatedSite) {
    this.designatedSite = designatedSite;
  }

  public String getSourceDB() {
    return sourceDB;
  }

  public void setSourceDB(String sourceDB) {
    this.sourceDB = sourceDB;
  }

}