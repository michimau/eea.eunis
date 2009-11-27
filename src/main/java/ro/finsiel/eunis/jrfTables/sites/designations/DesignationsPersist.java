package ro.finsiel.eunis.jrfTables.sites.designations;

/**
 * Date: Jun 2, 2003
 * Time: 11:07:40 AM
 */

import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:35:01 $
 **/
public class DesignationsPersist extends PersistentObject {

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
  private String sourceDate = null;
  private java.math.BigDecimal referenceNumber = null;
  private String referenceDate = null;
  private String remark = null;
  private String remarkSource = null;
  private String sourceDb = null;
  private String country = null;
  private String dataSet = null;

  public DesignationsPersist() {
    super();
  }


  public String getIdGeoscope() {
    return idGeoscope;
  }

  public void setIdGeoscope(String IdGeoscope) {
    this.idGeoscope = IdGeoscope;
  }

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getDescriptionEn() {
    return descriptionEn;
  }

  public void setDescriptionEn(String descriptionEn) {
    this.descriptionEn = descriptionEn;
  }

  public String getDescriptionFr() {
    return descriptionFr;
  }

  public void setDescriptionFr(String descriptionFr) {
    this.descriptionFr = descriptionFr;
  }

  public java.math.BigDecimal getTotalArea() {
    return totalArea;
  }

  public void setTotalArea(java.math.BigDecimal totalArea) {
    this.totalArea = totalArea;
  }

  public String getAbbreviation() {
    return abbreviation;
  }

  public void setAbbreviation(String abbreviation) {
    this.abbreviation = abbreviation;
  }

  public String getNationalCategory() {
    return nationalCategory;
  }

  public void setNationalCategory(String nationalCategory) {
    this.nationalCategory = nationalCategory;
  }

  public String getNationalLawReference() {
    return nationalLawReference;
  }

  public void setNationalLawReference(String nationalLawReference) {
    this.nationalLawReference = nationalLawReference;
  }

  public String getSourceDate() {
    return sourceDate;
  }

  public void setSourceDate(String sourceDate) {
    this.sourceDate = sourceDate;
  }

  public String getNationalLaw() {
    return nationalLaw;
  }

  public void setNationalLaw(String nationalLaw) {
    this.nationalLaw = nationalLaw;
  }

  public String getNationalLawAgency() {
    return nationalLawAgency;
  }

  public void setNationalLawAgency(String nationalLawAgency) {
    this.nationalLawAgency = nationalLawAgency;
  }

  public java.math.BigDecimal getReferenceNumber() {
    return referenceNumber;
  }

  public void setReferenceNumber(java.math.BigDecimal referenceNumber) {
    this.referenceNumber = referenceNumber;
  }

  public String getReferenceDate() {
    return referenceDate;
  }

  public void setReferenceDate(String referenceDate) {
    this.referenceDate = referenceDate;
  }

  public String getRemark() {
    return remark;
  }

  public void setRemark(String remark) {
    this.remark = remark;
  }

  public String getRemarkSource() {
    return remarkSource;
  }

  public void setRemarkSource(String remark) {
    this.remarkSource = remark;
  }


  public String getSourceDb() {
    return sourceDb;
  }

  public void setSourceDb(String sourceDb) {
    this.sourceDb = sourceDb;
  }

  /**
   * Getter for a database field.
   **/
  public String getCddaSites() {
    return i_cddaSites;
  }

  /**
   * Getter for a database field.
   **/
  public String getDescription() {
    return i_description;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdDesignation() {
    return i_idDesignation;
  }

  /**
   * Getter for a database field.
   **/
  public java.math.BigDecimal getReferenceArea() {
    return i_referenceArea;
  }

  /**
   * Setter for a database field.
   * @param cddaSites
   **/
  public void setCddaSites(String cddaSites) {
    i_cddaSites = cddaSites;
  }

  /**
   * Setter for a database field.
   * @param description
   **/
  public void setDescription(String description) {
    i_description = description;
  }

  /**
   * Setter for a database field.
   * @param idDesignation
   **/
  public void setIdDesignation(String idDesignation) {
    i_idDesignation = idDesignation;
  }

  /**
   * Setter for a database field.
   * @param referenceArea
   **/
  public void setReferenceArea(java.math.BigDecimal referenceArea) {
    i_referenceArea = referenceArea;
  }

  /**
   * Setter for a database field.
   * @param DataSet
   **/
  public void setDataSet(String DataSet) {
    dataSet = DataSet;
  }


  /**
   * Getter for a database field.
   **/
  public String getDataSet() {
    return dataSet;
  }
}
