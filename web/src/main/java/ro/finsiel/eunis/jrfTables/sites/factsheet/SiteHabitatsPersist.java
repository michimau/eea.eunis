/**
 * User: root
 * Date: May 22, 2003
 * Time: 4:07:43 PM
 */
package ro.finsiel.eunis.jrfTables.sites.factsheet;

import net.sf.jrf.domain.PersistentObject;

public class SiteHabitatsPersist extends PersistentObject {
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

  private String habitatDescription = null;

  private String idHabitat = null;

  private Integer idGeoscope = null;

  private String code2000 = null;

    public String getCode2000() {
        return code2000;
    }

    public void setCode2000(String code2000) {
        this.code2000 = code2000;
    }

    /**
   *
   */
  public SiteHabitatsPersist() {
    super();
  }

  public Integer getIdGeoscope() {
    return idGeoscope;
  }

  public void setIdGeoscope(Integer idGeoscope) {
    this.idGeoscope = idGeoscope;
  }

  public String getIdHabitat() {
    return idHabitat;
  }

  public void setIdHabitat(String idHabitat) {
    this.idHabitat = idHabitat;
  }

  public String getHabitatDescription() {
    return habitatDescription;
  }

  public void setHabitatDescription(String habitatDescription) {
    this.habitatDescription = habitatDescription;
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
