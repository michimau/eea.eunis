/**
 * Date: Apr 22, 2003
 * Time: 2:25:47 PM
 */
package ro.finsiel.eunis.jrfTables.habitats.factsheet;

import net.sf.jrf.domain.PersistentObject;

public class HabitatLegalPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String i_idHabitat = "";
  /**
   * This is a database field.
   **/
  private Integer i_idNatureObject = null;
  /**
   * This is a database field.
   **/
  private String i_scientificName = "";
  /**
   * This is a database field.
   **/
  private String i_description = "";
  /**
   * This is a database field.
   **/
  private String i_code2000 = "";
  /**
   * This is a database field.
   **/
  private String i_codeAnnex1 = "";
  /**
   * This is a database field.
   **/
  private Short i_priority = null;
  /**
   * This is a database field.
   **/
  private String i_eunisHabitatCode = "";
  /**
   * This is a database field.
   **/
  private String i_classRef = "";
  /**
   * This is a database field.
   **/
  private String i_codePart2 = "";
  /**
   * This is a database field.
   **/
  private Integer i_habLevel = null;

  private String geographicalDistribution = "";

  // Joined columns
  private String attributesName = "";
  private String attributesValue = "";

  private String habDesignatedCode = "";
  private String legalInstrumentAbbrev = "";
  private String legalInstrument = "";
  private String geoLevel = "";

  private String title = "";
  private String relationType = "";
  private String code = "";
  private String legalName = "";

  private Integer idDc = null;


  public HabitatLegalPersist() {
    super();
  }


  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }

  public String getRelationType() {
    return relationType;
  }

  public void setRelationType(String relationType) {
    this.relationType = relationType;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getLegalName() {
    return legalName;
  }

  public void setLegalName(String legalName) {
    this.legalName = legalName;
  }


  public String getAttributesName() {
    return attributesName;
  }

  public void setAttributesName(String attributesName) {
    this.attributesName = attributesName;
  }

  public String getAttributesValue() {
    return attributesValue;
  }

  public void setAttributesValue(String attributesValue) {
    this.attributesValue = attributesValue;
  }

  public String getHabDesignatedCode() {
    return habDesignatedCode;
  }

  public void setHabDesignatedCode(String habDesignatedCode) {
    this.habDesignatedCode = habDesignatedCode;
  }

  public String getLegalInstrumentAbbrev() {
    return legalInstrumentAbbrev;
  }

  public void setLegalInstrumentAbbrev(String legalInstrumentAbbrev) {
    this.legalInstrumentAbbrev = legalInstrumentAbbrev;
  }

  public String getLegalInstrument() {
    return legalInstrument;
  }

  public void setLegalInstrument(String legalInstrument) {
    this.legalInstrument = legalInstrument;
  }

  public String getGeoLevel() {
    return geoLevel;
  }

  public void setGeoLevel(String geoLevel) {
    this.geoLevel = geoLevel;
  }


  public String getGeographicalDistribution() {
    return geographicalDistribution;
  }

  public void setGeographicalDistribution(String geographicalDistribution) {
    this.geographicalDistribution = geographicalDistribution;
  }


  /**
   * Getter for a database field.
   **/
  public String getClassRef() {
    return i_classRef;
  }

  /**
   * Getter for a database field.
   **/
  public String getCode2000() {
    return i_code2000;
  }

  /**
   * Getter for a database field.
   **/
  public String getCodeAnnex1() {
    return i_codeAnnex1;
  }

  /**
   * Getter for a database field.
   **/
  public String getCodePart2() {
    return i_codePart2;
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
  public Short getPriority() {
    return i_priority;
  }

  /**
   * Getter for a database field.
   **/
  public String getScientificName() {
    return i_scientificName;
  }

  /**
   * Setter for a database field.
   * @param classRef
   **/
  public void setClassRef(String classRef) {
    i_classRef = classRef;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param code2000
   **/
  public void setCode2000(String code2000) {
    i_code2000 = code2000;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param codeAnnex1
   **/
  public void setCodeAnnex1(String codeAnnex1) {
    i_codeAnnex1 = codeAnnex1;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param codePart2
   **/
  public void setCodePart2(String codePart2) {
    i_codePart2 = codePart2;
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
   * @param priority
   **/
  public void setPriority(Short priority) {
    i_priority = priority;
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

    /**
     * get the reference to dc_index
     * @return
     */
    public Integer getIdDc() {
        return idDc;
    }

    /**
     * Set the reference to dc_index
     * @param idDc
     */
    public void setIdDc(Integer idDc) {
        this.idDc = idDc;
    }
}
