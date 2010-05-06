package eionet.eunis.dto;

import java.io.Serializable;

import org.simpleframework.xml.Attribute;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

/**
 * Site factsheet dto object.
 * 
 * @author Aleksandr Ivanov
 * <a href="mailto:aleksandr.ivanov@tietoenator.com">contact</a>
 */
@Root(name = "Site")
public class SiteFactsheetDto implements Serializable {
	
	private static final String RDF_URL_MAPPING = "http://eunis.eea.europa.eu/sites/";
	
	/**
	 * serial.
	 */
	private static final long serialVersionUID = 1L;
	
	@Element(name = "hasDesignation", required = false)
	private ResourceDto idDesignation;
	@Element(name = "hasSource", required = false)
	private ResourceDto idDc;
	@Element(required = false)
	private String idSite;
	@Element(required = false)
	private String idNatureObject;
	@Element(required = false)
	private String designation;
	@Element(required = false)
	private String respondent;
	@Element(required = false)
	private String name;
	@Element(required = false)
	private String manager;
	@Element(required = false)
	private String complexName;
	@Element(required = false)
	private String districtName;
	@Element(required = false)
	private String ownership;
	@Element(required = false)
	private String history;
	@Element(required = false)
	private String character;
	@Element(required = false)
	private String description;
	@Element(required = false)
	private String managementPlan;
	@Element(required = false)
	private String iucnat;
	@Element(required = false)
	private String designationDate;
	@Element(required = false)
	private String compilationDate;
	@Element(required = false)
	private String proposedDate;
	@Element(required = false)
	private String confirmedDate;
	@Element(required = false)
	private String updateDate;
	@Element(required = false)
	private String spaDate;
	@Element(required = false)
	private String sacDate;
	@Element(required = false)
	private String nationalCode;
	@Element(required = false)
	private String natura2000;
	@Element(required = false)
	private String nuts;
	@Element(required = false)
	private String area;
	@Element(required = false)
	private String length;
	@Element(required = false)
	private String longEw;
	@Element(required = false)
	private String longDeg;
	@Element(required = false)
	private String longMin;
	@Element(required = false)
	private String longSec;
	@Element(required = false)
	private String latNs;
	@Element(required = false)
	private String latDeg;
	@Element(required = false)
	private String latMin;
	@Element(required = false)
	private String latSec;
	@Element(required = false)
	private String altMean;
	@Element(required = false)
	private String altMax;
	@Element(required = false)
	private String altMin;
	@Element(required = false)
	private String longitude;
	@Element(required = false)
	private String latitude;
	@Element(required = false)
	private String sourceDb;
	
	/**
	 * @return the rdfAbout
	 */
	@Attribute(name="rdf:about")
	public String getRdfAbout() {
		return RDF_URL_MAPPING + idSite;
	}
	
	/**
	 * @return the idsite
	 */
	public String getIdSite() {
		return idSite;
	}

	/**
	 * @param idsite the idsite to set
	 */
	public void setIdSite(String idsite) {
		this.idSite = idsite;
	}

	/**
	 * @return the idNatureObject
	 */
	public String getIdNatureObject() {
		return idNatureObject;
	}

	/**
	 * @param idNatureObject the idNatureObject to set
	 */
	public void setIdNatureObject(String idNatureObject) {
		this.idNatureObject = idNatureObject;
	}

	/**
	 * @return the idDesignation
	 */
	public String getDesignation() {
		return designation;
	}

	/**
	 * @param idDesignation the idDesignation to set
	 */
	public void setDesignation(String idDesignation) {
		this.designation = idDesignation;
	}
 
	/**
	 * @return the respondent
	 */
	public String getRespondent() {
		return respondent;
	}

	/**
	 * @param respondent the respondent to set
	 */
	public void setRespondent(String respondent) {
		this.respondent = respondent;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}

	/**
	 * @return the manager
	 */
	public String getManager() {
		return manager;
	}

	/**
	 * @param manager the manager to set
	 */
	public void setManager(String manager) {
		this.manager = manager;
	}

	/**
	 * @return the complexName
	 */
	public String getComplexName() {
		return complexName;
	}

	/**
	 * @param complexName the complexName to set
	 */
	public void setComplexName(String complexName) {
		this.complexName = complexName;
	}

	/**
	 * @return the districtName
	 */
	public String getDistrictName() {
		return districtName;
	}

	/**
	 * @param districtName the districtName to set
	 */
	public void setDistrictName(String districtName) {
		this.districtName = districtName;
	}

	/**
	 * @return the ownership
	 */
	public String getOwnership() {
		return ownership;
	}

	/**
	 * @param ownership the ownership to set
	 */
	public void setOwnership(String ownership) {
		this.ownership = ownership;
	}

	/**
	 * @return the history
	 */
	public String getHistory() {
		return history;
	}

	/**
	 * @param history the history to set
	 */
	public void setHistory(String history) {
		this.history = history;
	}

	/**
	 * @return the character
	 */
	public String getCharacter() {
		return character;
	}

	/**
	 * @param character the character to set
	 */
	public void setCharacter(String character) {
		this.character = character;
	}

	/**
	 * @return the description
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return the managementPlan
	 */
	public String getManagementPlan() {
		return managementPlan;
	}

	/**
	 * @param managementPlan the managementPlan to set
	 */
	public void setManagementPlan(String managementPlan) {
		this.managementPlan = managementPlan;
	}

	/**
	 * @return the iucnat
	 */
	public String getIucnat() {
		return iucnat;
	}

	/**
	 * @param iucnat the iucnat to set
	 */
	public void setIucnat(String iucnat) {
		this.iucnat = iucnat;
	}

	/**
	 * @return the designationDate
	 */
	public String getDesignationDate() {
		return designationDate;
	}

	/**
	 * @param designationDate the designationDate to set
	 */
	public void setDesignationDate(String designationDate) {
		this.designationDate = designationDate;
	}

	/**
	 * @return the compilationDate
	 */
	public String getCompilationDate() {
		return compilationDate;
	}

	/**
	 * @param compilationDate the compilationDate to set
	 */
	public void setCompilationDate(String compilationDate) {
		this.compilationDate = compilationDate;
	}

	/**
	 * @return the proposedDate
	 */
	public String getProposedDate() {
		return proposedDate;
	}

	/**
	 * @param proposedDate the proposedDate to set
	 */
	public void setProposedDate(String proposedDate) {
		this.proposedDate = proposedDate;
	}

	/**
	 * @return the confirmedDate
	 */
	public String getConfirmedDate() {
		return confirmedDate;
	}

	/**
	 * @param confirmedDate the confirmedDate to set
	 */
	public void setConfirmedDate(String confirmedDate) {
		this.confirmedDate = confirmedDate;
	}

	/**
	 * @return the updateDate
	 */
	public String getUpdateDate() {
		return updateDate;
	}

	/**
	 * @param updateDate the updateDate to set
	 */
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	/**
	 * @return the spaDate
	 */
	public String getSpaDate() {
		return spaDate;
	}

	/**
	 * @param spaDate the spaDate to set
	 */
	public void setSpaDate(String spaDate) {
		this.spaDate = spaDate;
	}

	/**
	 * @return the sacDate
	 */
	public String getSacDate() {
		return sacDate;
	}

	/**
	 * @param sacDate the sacDate to set
	 */
	public void setSacDate(String sacDate) {
		this.sacDate = sacDate;
	}

	/**
	 * @return the nationalCode
	 */
	public String getNationalCode() {
		return nationalCode;
	}

	/**
	 * @param nationalCode the nationalCode to set
	 */
	public void setNationalCode(String nationalCode) {
		this.nationalCode = nationalCode;
	}

	/**
	 * @return the natura2000
	 */
	public String getNatura2000() {
		return natura2000;
	}

	/**
	 * @param natura2000 the natura2000 to set
	 */
	public void setNatura2000(String natura2000) {
		this.natura2000 = natura2000;
	}

	/**
	 * @return the nuts
	 */
	public String getNuts() {
		return nuts;
	}

	/**
	 * @param nuts the nuts to set
	 */
	public void setNuts(String nuts) {
		this.nuts = nuts;
	}

	/**
	 * @return the area
	 */
	public String getArea() {
		return area;
	}

	/**
	 * @param area the area to set
	 */
	public void setArea(String area) {
		this.area = area;
	}

	/**
	 * @return the length
	 */
	public String getLength() {
		return length;
	}

	/**
	 * @param length the length to set
	 */
	public void setLength(String length) {
		this.length = length;
	}

	/**
	 * @return the longEw
	 */
	public String getLongEw() {
		return longEw;
	}

	/**
	 * @param longEw the longEw to set
	 */
	public void setLongEw(String longEw) {
		this.longEw = longEw;
	}

	/**
	 * @return the longDeg
	 */
	public String getLongDeg() {
		return longDeg;
	}

	/**
	 * @param longDeg the longDeg to set
	 */
	public void setLongDeg(String longDeg) {
		this.longDeg = longDeg;
	}

	/**
	 * @return the longMin
	 */
	public String getLongMin() {
		return longMin;
	}

	/**
	 * @param longMin the longMin to set
	 */
	public void setLongMin(String longMin) {
		this.longMin = longMin;
	}

	/**
	 * @return the longSec
	 */
	public String getLongSec() {
		return longSec;
	}

	/**
	 * @param longSec the longSec to set
	 */
	public void setLongSec(String longSec) {
		this.longSec = longSec;
	}

	/**
	 * @return the latNs
	 */
	public String getLatNs() {
		return latNs;
	}

	/**
	 * @param latNs the latNs to set
	 */
	public void setLatNs(String latNs) {
		this.latNs = latNs;
	}

	/**
	 * @return the latDeg
	 */
	public String getLatDeg() {
		return latDeg;
	}

	/**
	 * @param latDeg the latDeg to set
	 */
	public void setLatDeg(String latDeg) {
		this.latDeg = latDeg;
	}

	/**
	 * @return the latMin
	 */
	public String getLatMin() {
		return latMin;
	}

	/**
	 * @param latMin the latMin to set
	 */
	public void setLatMin(String latMin) {
		this.latMin = latMin;
	}

	/**
	 * @return the latSec
	 */
	public String getLatSec() {
		return latSec;
	}

	/**
	 * @param latSec the latSec to set
	 */
	public void setLatSec(String latSec) {
		this.latSec = latSec;
	}

	/**
	 * @return the altMean
	 */
	public String getAltMean() {
		return altMean;
	}

	/**
	 * @param altMean the altMean to set
	 */
	public void setAltMean(String altMean) {
		this.altMean = altMean;
	}

	/**
	 * @return the altMax
	 */
	public String getAltMax() {
		return altMax;
	}

	/**
	 * @param altMax the altMax to set
	 */
	public void setAltMax(String altMax) {
		this.altMax = altMax;
	}

	/**
	 * @return the altMin
	 */
	public String getAltMin() {
		return altMin;
	}

	/**
	 * @param altMin the altMin to set
	 */
	public void setAltMin(String altMin) {
		this.altMin = altMin;
	}

	/**
	 * @return the longitude
	 */
	public String getLongitude() {
		return longitude;
	}

	/**
	 * @param longitude the longitude to set
	 */
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	/**
	 * @return the latitude
	 */
	public String getLatitude() {
		return latitude;
	}

	/**
	 * @param latitude the latitude to set
	 */
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}

	/**
	 * @return the sourceDb
	 */
	public String getSourceDb() {
		return sourceDb;
	}

	/**
	 * @param sourceDb the sourceDb to set
	 */
	public void setSourceDb(String sourceDb) {
		this.sourceDb = sourceDb;
	}

	/**
	 * @return the idDesignation
	 */
	public ResourceDto getIdDesignation() {
		return idDesignation;
	}

	/**
	 * @param idDesignation the idDesignation to set
	 */
	public void setIdDesignation(ResourceDto idDesignation) {
		this.idDesignation = idDesignation;
	}

	/**
	 * @return the idDc
	 */
	public ResourceDto getIdDc() {
		return idDc;
	}

	/**
	 * @param idDc the idDc to set
	 */
	public void setIdDc(ResourceDto idDc) {
		this.idDc = idDc;
	}

}
