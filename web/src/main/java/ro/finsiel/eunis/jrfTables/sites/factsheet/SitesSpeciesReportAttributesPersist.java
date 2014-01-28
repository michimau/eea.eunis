/**
 * User: root
 * Date: May 22, 2003
 * Time: 3:19:46 PM
 */
package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.PersistentObject;

public class SitesSpeciesReportAttributesPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idNatureObject = null;
  /**
   * This is a database field.
   **/
  private Integer i_idNatureObjectLink = null;
  /**
   * This is a database field.
   **/
  private Integer i_idReportType = null;

  private Integer idReportAttributes = null;

  private String lookupType = null;

  private Integer idDc = null;

  private String IDLookup = null;

  private String speciesScientificName = null;

  private String speciesCommonName = null;

  private Integer idSpecies = null;

  private Integer idSpeciesLink = null;

  private String natura2000Code = null;


  public SitesSpeciesReportAttributesPersist() {
    super();
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

  public String getSpeciesScientificName() {
    return speciesScientificName;
  }

  public void setSpeciesScientificName(String speciesScientificName) {
    this.speciesScientificName = speciesScientificName;
  }

  public String getSpeciesCommonName() {
    if (speciesCommonName != null) {
      return speciesCommonName;
    } else {
      return "";
    }
  }

  public void setSpeciesCommonName(String speciesCommonName) {
    this.speciesCommonName = speciesCommonName;
  }

  public String getIDLookup() {
    return IDLookup;
  }

  public void setIDLookup(String IDLookup) {
    this.IDLookup = IDLookup;
  }

  public Integer getIdDc() {
    return idDc;
  }

  public void setIdDc(Integer idDc) {
    this.idDc = idDc;
  }

  public String getLookupType() {
    return lookupType;
  }

  public void setLookupType(String lookupType) {
    this.lookupType = lookupType;
  }

  public Integer getIdReportAttributes() {
    return idReportAttributes;
  }

  public void setIdReportAttributes(Integer idReportAttributes) {
    this.idReportAttributes = idReportAttributes;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdNatureObject() {
    return i_idNatureObject;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdNatureObjectLink() {
    return i_idNatureObjectLink;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdReportType() {
    return i_idReportType;
  }

    public String getNatura2000Code() {
        return natura2000Code;
    }

    public void setNatura2000Code(String natura2000Code) {
        this.natura2000Code = natura2000Code;
    }

    /**
   * Getter for a database field.
   **/
//  public Short getRelationExist() { return i_relationExist; }

  /**
   * Setter for a database field.
   * @param idNatureObject
   **/
  public void setIdNatureObject(Integer idNatureObject) {
    i_idNatureObject = idNatureObject;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idNatureObjectLink
   **/
  public void setIdNatureObjectLink(Integer idNatureObjectLink) {
    i_idNatureObjectLink = idNatureObjectLink;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idReportType
   **/
  public void setIdReportType(Integer idReportType) {
    i_idReportType = idReportType;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param relationExist
   **/
//  public void setRelationExist(Short relationExist) {
//    i_relationExist = relationExist;
//    this.markModifiedPersistentState();
//  }


}
