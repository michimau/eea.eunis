package ro.finsiel.eunis.jrfTables.sites.factsheet;

/**
 * Date: Oct 15, 2003
 * Time: 10:39:43 AM
 */

import net.sf.jrf.domain.PersistentObject;

public class SitesDesignationsPersist extends PersistentObject {

  private String idSite = null;
  private String idDesignation = null;
  private String description = null;
  private String descriptionEn = null;
  private String descriptionFr = null;
  private String areaName = null;
  private String dataSource = null;
  private String idGeoscope = null;
  private String nationalCategory = null;

  public SitesDesignationsPersist() {
    super();
  }

  public String getIdSite() {
    return idSite;
  }

  public void setIdSite(String idSite) {
    this.idSite = idSite;
  }

  public String getIdDesignation() {
    return idDesignation;
  }

  public void setIdDesignation(String idDesignation) {
    this.idDesignation = idDesignation;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getDescriptionEn() {
    if (null == descriptionEn) return "";
    return descriptionEn;
  }

  public void setDescriptionEn(String descriptionEn) {
    this.descriptionEn = descriptionEn;
  }

  public String getDescriptionFr() {
    if (null == descriptionFr) return "";
    return descriptionFr;
  }

  public void setDescriptionFr(String descriptionFr) {
    this.descriptionFr = descriptionFr;
  }

  public String getAreaName() {
    return areaName;
  }

  public void setAreaName(String AreaName) {
    this.areaName = AreaName;
  }

  public String getDataSource() {
    return dataSource;
  }

  public void setDataSource(String DataSource) {
    this.dataSource = DataSource;
  }

  public String getIdGeoscope() {
    return idGeoscope;
  }

  public void setIdGeoscope(String IdGeoscope) {
    this.idGeoscope = IdGeoscope;
  }

    public String getNationalCategory() {
        return nationalCategory;
    }

    public void setNationalCategory(String nationalCategory) {
        this.nationalCategory = nationalCategory;
    }
}
