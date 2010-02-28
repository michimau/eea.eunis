package ro.finsiel.eunis.jrfTables.sites.species;

/**
 * Date: May 19, 2003
 * Time: 3:12:03 PM
 */

import net.sf.jrf.domain.PersistentObject;

public class SpeciesPersist extends PersistentObject {
  private String i_idSite = null;
  private String sourceDB = null;
  private Integer idNatureObject = null;
  private String name = null;
  private String longEW = null;
  private String longDeg = null;
  private String longMin = null;
  private String longSec = null;
  private String latNS = null;
  private String latDeg = null;
  private String latMin = null;
  private String latSec = null;
  private String longitude = null;
  private String latitude = null;
  private Integer idSpecies = null;
  private Integer idSpeciesLink = null;
  private String idDesignation = null;
  private Integer idGeoscope = null;


  private String specieScientificName = null;

  public SpeciesPersist() {
    super();
  }

  public String getLatNS() {
    return latNS;
  }

  public void setLatNS(String latNS) {
    this.latNS = latNS;
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

  public String getSpecieScientificName() {
    return specieScientificName;
  }

  public void setSpecieScientificName(String specieScientificName) {
    this.specieScientificName = specieScientificName;
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

