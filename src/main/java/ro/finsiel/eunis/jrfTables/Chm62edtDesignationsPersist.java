package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;
import java.math.BigDecimal;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtDesignationsPersist extends PersistentObject {
  private String idDesignation = null;
  private String idGeoscope = null;
  private Integer idDc = null;
  private String cddaSites = null;
  private String description = null;
  private String descriptionEn = null;
  private String descriptionFr = null;
  private String OriginalDataSource = null;
  private java.math.BigDecimal referenceArea = null;
  private java.math.BigDecimal totalArea = null;
  private String nationalLaw = null;
  private String nationalCategory = null;
  private String nationalLawReference = null;
  private String nationalLawAgency = null;
  private String dataSource = null;
  private java.math.BigDecimal referenceNumber = null;
  private Integer totalNumber = null;
  private String referenceDate = null;
  private String remark = null;
  private String remarkSource = null;

  /**
   * Creates an new instance of Chm62edtDesignationsPersist object.
   */
  public Chm62edtDesignationsPersist() {
    super();
  }

    public String getIdDesignation() {
        return idDesignation;
    }

    public void setIdDesignation(String idDesignation) {
        this.idDesignation = idDesignation;
    }

    public String getIdGeoscope() {
        return idGeoscope;
    }

    public void setIdGeoscope(String idGeoscope) {
        this.idGeoscope = idGeoscope;
    }

    public Integer getIdDc() {
        return idDc;
    }

    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }

    public String getCddaSites() {
        return cddaSites;
    }

    public void setCddaSites(String cddaSites) {
        this.cddaSites = cddaSites;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public String getOriginalDataSource() {
        return OriginalDataSource;
    }

    public void setOriginalDataSource(String originalDataSource) {
        OriginalDataSource = originalDataSource;
    }

    public BigDecimal getReferenceArea() {
        return referenceArea;
    }

    public void setReferenceArea(BigDecimal referenceArea) {
        this.referenceArea = referenceArea;
    }

    public BigDecimal getTotalArea() {
        return totalArea;
    }

    public void setTotalArea(BigDecimal totalArea) {
        this.totalArea = totalArea;
    }

    public String getNationalLaw() {
        return nationalLaw;
    }

    public void setNationalLaw(String nationalLaw) {
        this.nationalLaw = nationalLaw;
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

    public String getNationalLawAgency() {
        return nationalLawAgency;
    }

    public void setNationalLawAgency(String nationalLawAgency) {
        this.nationalLawAgency = nationalLawAgency;
    }

    public String getDataSource() {
        return dataSource;
    }

    public void setDataSource(String dataSource) {
        this.dataSource = dataSource;
    }

    public BigDecimal getReferenceNumber() {
        return referenceNumber;
    }

    public void setReferenceNumber(BigDecimal referenceNumber) {
        this.referenceNumber = referenceNumber;
    }

    public Integer getTotalNumber() {
        return totalNumber;
    }

    public void setTotalNumber(Integer totalNumber) {
        this.totalNumber = totalNumber;
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

    public void setRemarkSource(String remarkSource) {
        this.remarkSource = remarkSource;
    }

}