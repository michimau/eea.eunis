package ro.finsiel.eunis.jrfTables.sites.country;

/**
 * Date: May 26, 2003
 * Time: 11:02:35 AM
 */

import net.sf.jrf.domain.PersistentObject;
import ro.finsiel.eunis.search.sites.CoordinatesProvider;

public class CountryPersist extends PersistentObject implements CoordinatesProvider {

  /**
   * This is a database field.
   **/
  private String i_idSite = null;
  private Integer idNatureObject = null;
  private String name = null;
  private String altMean = null;
  private String altMin = null;
  private String altMax = null;
  private String sourceDB = null;

  private String country = null;
  private String area = null;
  private String year = null;
  private String iso2L = null;
  private String longitude = null;
  private String latitude = null;
  private Integer idGeoscope = null;
  private String idDesignation = null;



  public CountryPersist() {
    super();
  }

  public String getIso2L() {
    return iso2L;
  }

  public void setIso2L(String iso) {
    this.iso2L = iso;
  }
//
//  public String getLatNS() {
//    return latNS;
//  }
//
//  public void setLatNS(String latNS) {
//    this.latNS = latNS;
//  }

  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    this.idNatureObject = idNatureObject;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

//  public String getLongEW() {
//    return longEW;
//  }
//
//  public void setLongEW(String longEW) {
//    this.longEW = longEW;
//  }
//
//  public String getLongDeg() {
//    return longDeg;
//  }
//
//  public void setLongDeg(String longDeg) {
//    this.longDeg = longDeg;
//  }
//
//  public String getLongMin() {
//    return longMin;
//  }
//
//  public void setLongMin(String longMin) {
//    this.longMin = longMin;
//  }
//
//  public String getLongSec() {
//    return longSec;
//  }
//
//  public void setLongSec(String longSec) {
//    this.longSec = longSec;
//  }
//
//  public String getLatDeg() {
//    return latDeg;
//  }
//
//  public void setLatDeg(String latDeg) {
//    this.latDeg = latDeg;
//  }
//
//  public String getLatMin() {
//    return latMin;
//  }
//
//  public void setLatMin(String latMin) {
//    this.latMin = latMin;
//  }
//
//  public String getLatSec() {
//    return latSec;
//  }
//
//  public void setLatSec(String latSec) {
//    this.latSec = latSec;
//  }

  public String getAltMean() {
    return altMean;
  }

  public void setAltMean(String altMean) {
    this.altMean = altMean;
  }

  public String getAltMin() {
    return altMin;
  }

  public void setAltMin(String altMean) {
    this.altMin = altMean;
  }

  public String getAltMax() {
    return altMax;
  }

  public void setAltMax(String altMean) {
    this.altMax = altMean;
  }

  public String getSourceDB() {
    return sourceDB;
  }

  public void setSourceDB(String sourceDB) {
    this.sourceDB = sourceDB;
  }

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getArea() {
    return area;
  }

  public void setArea(String area) {
    this.area = area;
  }

  public String getYear() {
    return year;
  }

  public void setYear(String year) {
    this.year = year;
  }


  /**
   * Getter for a database field.
   **/
  public String getIdSite() {
    return i_idSite;
  }


  /**
   * Setter for a database field.
   * @param idSite
   **/
  public void setIdSite(String idSite) {
    i_idSite = idSite;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
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

    public Integer getIdGeoscope() {
        return idGeoscope;
    }

    public void setIdGeoscope(Integer idGeoscope) {
        this.idGeoscope = idGeoscope;
    }

    public String getIdDesignation() {
        return idDesignation;
    }

    public void setIdDesignation(String idDesignation) {
        this.idDesignation = idDesignation;
    }
}
