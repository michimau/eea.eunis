package ro.finsiel.eunis.jrfTables.habitats.legal;

import net.sf.jrf.domain.PersistentObject;

/**
 * @author finsiel
 * @since 13.02.2003
 * @version 1.0
 */
public class EUNISLegalPersist extends PersistentObject {
  /** This is a database field. */
  private String i_idHabitat = null;
  /** This is a database field. */
  private Integer i_idNatureObject = null;
  /** This is a database field. */
  private String i_scientificName = null;
  /** This is a database field. */
  private String i_description = null;
  /** This is a database field. */
  private String i_eunisHabitatCode = null;
  /** This is a database field. */
  private Integer i_habLevel = null;

  /** This is a database field. */
  private String lookupType = null;
  /** This is a database field. */
  private String legalName = null;

  private String code2000 = null;

  public String getCode2000() {
    return code2000;
  }

  public void setCode2000(String code2000) {
    this.code2000 = code2000;
  }

  public String getLegalName() {
    return legalName;
  }

  public void setLegalName(String legalName) {
    this.legalName = legalName;
  }

  /**
   * Default constructor
   */
  public EUNISLegalPersist() {
    super();
  }

  /**
   *
   * @return
   */
  public String getLookupType() {
    return lookupType;
  }


  /**
   *
   * @param lookupType
   */
  public void setLookupType(String lookupType) {
    this.lookupType = lookupType;
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
  public String getEunisHabitatCode() {
    return i_eunisHabitatCode;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getHabLevel() {
    if (null == i_habLevel) return new Integer(0);
    return i_habLevel;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdHabitat() {
    return i_idHabitat;
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
  public String getScientificName() {
    return i_scientificName;
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
   * @param eunisHabitatCode
   **/
  public void setEunisHabitatCode(String eunisHabitatCode) {
    i_eunisHabitatCode = eunisHabitatCode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param habLevel
   **/
  public void setHabLevel(Integer habLevel) {
    i_habLevel = habLevel;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idHabitat
   **/
  public void setIdHabitat(String idHabitat) {
    i_idHabitat = idHabitat;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idNatureObject
   **/
  public void setIdNatureObject(Integer idNatureObject) {
    i_idNatureObject = idNatureObject;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param scientificName
   **/
  public void setScientificName(String scientificName) {
    i_scientificName = scientificName;
    this.markModifiedPersistentState();
  }
}