package ro.finsiel.eunis.jrfTables.sites.designation_code;

/**
 * Date: May 22, 2003
 * Time: 10:00:23 AM
 */

import net.sf.jrf.domain.PersistentObject;
import ro.finsiel.eunis.search.sites.CoordinatesProvider;

public class DesignationPersist extends PersistentObject implements CoordinatesProvider {

  private String siteName = null;
  private String i_idSite = null;
  private Integer idNatureObject = null;

  private String sourceDB = null;
  private String desc = null;
  private String descEn = null;
  private String descFr = null;
  private String i_designationDate = null;
  private String length = null;
  private String i_area = null;
  private String iddesign = null;
  private String geoscope = null;

  private String country = null;
  private String longitude = null;
  private String latitude = null;
  private String designSourceDb = null;

  public DesignationPersist() {
    super();
  }

  public String getDesignSourceDb() {
    return designSourceDb;
  }

  public void setDesignSourceDb(String siteName) {
    this.designSourceDb = siteName;
  }

  public String getIdDesign() {
    return iddesign;
  }

  public void setIdDesign(String iddesign) {
    this.iddesign = iddesign;
  }

  public String getGeoscope() {
    return geoscope;
  }

  public void setGeoscope(String Geoscope) {
    this.geoscope = Geoscope;
  }

  public String getArea() {
    return i_area;
  }

  public void setArea(String area) {
    this.i_area = area;
  }

  public String getLength() {
    return length;
  }

  public void setLength(String length) {
    this.length = length;
  }

  public String getDesignationDate() {
    return i_designationDate;
  }

  public void setDesignationDate(String designationDate) {
    this.i_designationDate = designationDate;
  }

  public String getName() {
    return siteName;
  }

  public void setName(String siteName) {
    this.siteName = siteName;
  }


  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    this.idNatureObject = idNatureObject;
  }

  public String getDescriptionSites() {
    return desc;
  }

  public void setDescriptionSites(String desc) {
    this.desc = desc;
  }

  public String getDescriptionSitesEn() {
    return descEn;
  }

  public void setDescriptionSitesEn(String desc) {
    this.descEn = desc;
  }

  public String getDescriptionSitesFr() {
    return descFr;
  }

  public void setDescriptionSitesFr(String desc) {
    this.descFr = desc;
  }

  public String getSourceDB() {
    return sourceDB;
  }

  public void setSourceDB(String sourceDB) {
    this.sourceDB = sourceDB;
  }

  public String getIdSite() {
    return i_idSite;
  }

  public void setIdSite(String idSite) {
    this.i_idSite = idSite;
  }

  public String getLatitude() {
    return latitude;
  }

  public String getLongitude() {
    return longitude;
  }

  public void setLongitude(String longitude) {
    this.longitude = longitude;
  }

  public void setLatitude(String latitude) {
    this.latitude = latitude;
  }

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

}
