package ro.finsiel.eunis.jrfTables.sites.altitude;

/**
 * Date: May 15, 2003
 * Time: 2:11:54 PM
 */

import net.sf.jrf.domain.PersistentObject;
import ro.finsiel.eunis.search.sites.CoordinatesProvider;

/**
 *
 * @version $Revision$ $Date$
 **/
public class AltitudePersist extends PersistentObject implements CoordinatesProvider {

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
  private String desc = null;

  private String country = null;
  private String iddesign = null;
  private String iso = null;
  private String year = null;

  private String iso2L = null;
  private String longitude = null;
  private String latitude = null;
  private String designSourceDb = null;
  private Integer idGeoscope = null;
  private String idDesignation = null;


  public AltitudePersist() {
    super();
  }

  public String getDesignSourceDb() {
    return designSourceDb;
  }

  public void setDesignSourceDb(String siteName) {
    this.designSourceDb = siteName;
  }

  public String getYear() {
    return year;
  }

  public void setYear(String year) {
    this.year = year;
  }

  public String getIdDesign() {
    return iddesign;
  }

  public void setIdDesign(String idDesignation) {
    this.iddesign = idDesignation;
  }

  public String getIso() {
    return iso;
  }

  public void setIso(String iso) {
    this.iso = iso;
  }

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

  public String getDescription() {
    return desc;
  }

  public void setDescription(String desc) {
    this.desc = desc;
  }

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

  public String getIso2L() {
    return iso2L;
  }

  public void setIso2L(String iso) {
    this.iso2L = iso;
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
