package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.PersistentObject;

/**
 * Date: 03.06.2003
 * Time: 15:01:00
 */
public class RegionsCodesPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String i_idSite = null;
  /**
   * This is a database field.
   **/
  private String i_designationDate = null;
  /**
   * This is a database field.
   **/
  private String i_compilationDate = null;
  /**
   * This is a database field.
   **/
  private String i_updateDate = null;
  /**
   * This is a database field.
   **/
  private String i_area = null;
  /**
   * This is a database field.
   **/
  private String i_natura2000 = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;
  private Integer idNatureObject = null;
  private String respondent = null;
  private String name = null;
  private String manager = null;
  private String complexName = null;
  private String districtName = null;
  private String ownership = null;
  private String quality = null;
  private String vulnerability = null;
  private String history = null;
  private String character = null;
  private String documentation = null;
  private String managementPlan = null;
  private String iucnat = null;
  private String year = null;
  private String proposedDate = null;
  private String confirmedDate = null;
  private String spaDate = null;
  private String sacDate = null;
  private String nationalCode = null;
  private String nuts = null;
  private String length = null;
  private String altMean = null;
  private String altMax = null;
  private String altMin = null;
  private String longitude = null;
  private String latitude = null;
  private String sourceDB = null;
  private String recordUpdate = null;

  private String regionCode = null;
  private String regionName = null;
  private String regionDescription = null;
  private String regionCover = null;

  public RegionsCodesPersist() {
    super();
  }

  public String getRegionCode() {
    if (null == regionCode) return "";
    return regionCode;
  }

  public void setRegionCode(String regionCode) {
    this.regionCode = regionCode;
  }

  public String getRegionName() {
    if (null == regionName) return "";
    return regionName;
  }

  public void setRegionName(String regionName) {
    this.regionName = regionName;
  }

  public String getRegionCover() {
    if (null == regionCover) return "";
    return regionCover;
  }

  public void setRegionCover(String regionCover) {
    this.regionCover = regionCover;
  }

  public Integer getIdNatureObject() {
    return idNatureObject;
  }

  public void setIdNatureObject(Integer idNatureObject) {
    this.idNatureObject = idNatureObject;
  }

  public String getRespondent() {
    return respondent;
  }

  public void setRespondent(String respondent) {
    this.respondent = respondent;
  }

  public String getDesignationDate() {
    return i_designationDate;
  }

  public void setDesignationDate(String designationDate) {
    this.i_designationDate = designationDate;
  }

  public String getUpdateDate() {
    return i_updateDate;
  }

  public void setUpdateDate(String updateDate) {
    this.i_updateDate = updateDate;
  }


  public String getCompilationDate() {
    return i_compilationDate;
  }

  public void setCompilationDate(String compilationDate) {
    this.i_compilationDate = compilationDate;
  }


  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getManager() {
    return manager;
  }

  public void setManager(String manager) {
    this.manager = manager;
  }

  public String getComplexName() {
    return complexName;
  }

  public void setComplexName(String complexName) {
    this.complexName = complexName;
  }

  public String getDistrictName() {
    return districtName;
  }

  public void setDistrictName(String districtName) {
    this.districtName = districtName;
  }

  public String getOwnership() {
    return ownership;
  }

  public void setOwnership(String ownership) {
    this.ownership = ownership;
  }

  public String getQuality() {
    return quality;
  }

  public void setQuality(String quality) {
    this.quality = quality;
  }

  public String getVulnerability() {
    return vulnerability;
  }

  public void setVulnerability(String vulnerability) {
    this.vulnerability = vulnerability;
  }

  public String getHistory() {
    return history;
  }

  public void setHistory(String history) {
    this.history = history;
  }

  public String getCharacter() {
    return character;
  }

  public void setCharacter(String character) {
    this.character = character;
  }

  public String getDocumentation() {
    return documentation;
  }

  public void setDocumentation(String documentation) {
    this.documentation = documentation;
  }

  public String getManagementPlan() {
    return managementPlan;
  }

  public void setManagementPlan(String managementPlan) {
    this.managementPlan = managementPlan;
  }

  public String getIucnat() {
    return iucnat;
  }

  public void setIucnat(String iucnat) {
    this.iucnat = iucnat;
  }

  public String getYear() {
    return year;
  }

  public void setYear(String year) {
    this.year = year;
  }

  public String getProposedDate() {
    return proposedDate;
  }

  public void setProposedDate(String proposedDate) {
    this.proposedDate = proposedDate;
  }

  public String getConfirmedDate() {
    return confirmedDate;
  }

  public void setConfirmedDate(String confirmedDate) {
    this.confirmedDate = confirmedDate;
  }

  public String getSpaDate() {
    return spaDate;
  }

  public void setSpaDate(String spaDate) {
    this.spaDate = spaDate;
  }

  public String getSacDate() {
    return sacDate;
  }

  public void setSacDate(String sacDate) {
    this.sacDate = sacDate;
  }

  public String getNationalCode() {
    return nationalCode;
  }

  public void setNationalCode(String nationalCode) {
    this.nationalCode = nationalCode;
  }

  public String getNuts() {
    return nuts;
  }

  public void setNuts(String nuts) {
    this.nuts = nuts;
  }

  public String getLength() {
    return length;
  }

  public void setLength(String length) {
    this.length = length;
  }

  public String getAltMean() {
    return altMean;
  }

  public void setAltMean(String altMean) {
    this.altMean = altMean;
  }

  public String getAltMax() {
    return altMax;
  }

  public void setAltMax(String altMax) {
    this.altMax = altMax;
  }

  public String getAltMin() {
    return altMin;
  }

  public void setAltMin(String altMin) {
    this.altMin = altMin;
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

  public String getSourceDB() {
    return sourceDB;
  }

  public void setSourceDB(String sourceDB) {
    this.sourceDB = sourceDB;
  }

  public String getRecordUpdate() {
    return recordUpdate;
  }

  public void setRecordUpdate(String recordUpdate) {
    this.recordUpdate = recordUpdate;
  }

  /**
   * Getter for a database field.
   **/
  public String getArea() {
    return i_area;
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
  public String getIdSite() {
    return i_idSite;
  }

  /**
   * Getter for a database field.
   **/
  public String getNatura2000() {
    return i_natura2000;
  }

  /**
   * Setter for a database field.
   * @param area
   **/
  public void setArea(String area) {
    i_area = area;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param description
   **/
  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
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

  /**
   * Setter for a database field.
   * @param natura2000
   **/
  public void setNatura2000(String natura2000) {
    i_natura2000 = natura2000;
    this.markModifiedPersistentState();
  }

	public String getRegionDescription() {
		return regionDescription;
	}
	
	public void setRegionDescription(String regionDescription) {
		this.regionDescription = regionDescription;
		this.markModifiedPersistentState();
	}

}
