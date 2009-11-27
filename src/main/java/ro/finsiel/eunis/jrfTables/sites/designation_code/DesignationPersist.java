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

  private String longEW = null;
  private String longDeg = null;
  private String longMin = null;
  private String longSec = null;

  private String latDeg = null;
  private String latMin = null;
  private String latNS = null;
  private String latSec = null;


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

  public String getLatNS() {
    return latNS;
  }

  public void setLatNS(String area) {
    this.latNS = area;
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

  public String getLongEW() {
    return longEW;
  }

  public void setLongEW(String longEW) {
    this.longEW = longEW;
  }

  public String getLongDeg() {
    return longDeg;
  }

  public void setLongDeg(String longDeg) {
    this.longDeg = longDeg;
  }

  public String getLongMin() {
    return longMin;
  }

  public void setLongMin(String longMin) {
    this.longMin = longMin;
  }

  public String getLongSec() {
    return longSec;
  }

  public void setLongSec(String longSec) {
    this.longSec = longSec;
  }

  public String getLatDeg() {
    return latDeg;
  }

  public void setLatDeg(String latDeg) {
    this.latDeg = latDeg;
  }

  public String getLatMin() {
    return latMin;
  }

  public void setLatMin(String latMin) {
    this.latMin = latMin;
  }

  public String getLatSec() {
    return latSec;
  }

  public void setLatSec(String latSec) {
    this.latSec = latSec;
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
