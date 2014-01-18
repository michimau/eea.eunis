package ro.finsiel.eunis.jrfTables.sites.habitats;

/**
 * Date: May 19, 2003
 * Time: 10:51:43 AM
 */

import net.sf.jrf.domain.PersistentObject;

public class HabitatPersist extends PersistentObject {
  private String i_idSite = null;
  private String sourceDB = null;
  private Integer idNatureObject = null;
  private String name = null;
  private String longitude = null;
  private String latitude = null;


  private String habitatName = null;
  private String eunisHabitatCode = null;
  private String code2000 = null;
  private String habitatClassCodeCode = null;
  private String idDesignation = null;
  private Integer idGeoscope = null;

  public HabitatPersist() {
    super();
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    this.idNatureObject = idNatureObject;
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


  public String getLongitude() {
    return longitude;
  }

  public void setLongitude(String longitude) {
    this.longitude = longitude;
  }

  public String getLatitude() {
    return latitude;
  }

  public void setLatitude(String latitude) {
    this.latitude = latitude;
  }

  public String getHabitatName() {
    return habitatName;
  }

  public void setHabitatName(String habitatName) {
    this.habitatName = habitatName;
  }

  public String getEunisHabitatCode() {
    return eunisHabitatCode;
  }

  public void setEunisHabitatCode(String eunisHabitatCode) {
    this.eunisHabitatCode = eunisHabitatCode;
  }

  public String getCode2000() {
    return code2000;
  }

  public void setCode2000(String code2000) {
    this.code2000 = code2000;
  }

  public String getHabitatClassCodeCode() {
    return habitatClassCodeCode;
  }

  public void setHabitatClassCodeCode(String habitatClassCodeCode) {
    this.habitatClassCodeCode = habitatClassCodeCode;
  }

    public String getIdDesignation() {
        return idDesignation;
    }

    public void setIdDesignation(String idDesignation) {
        this.idDesignation = idDesignation;
    }

    public Integer getIdGeoscope() {
        return idGeoscope;
    }

    public void setIdGeoscope(Integer idGeoscope) {
        this.idGeoscope = idGeoscope;
    }
}
