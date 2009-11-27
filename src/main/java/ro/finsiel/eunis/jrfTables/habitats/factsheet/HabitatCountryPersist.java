package ro.finsiel.eunis.jrfTables.habitats.factsheet;

import net.sf.jrf.domain.PersistentObject;

public class HabitatCountryPersist extends PersistentObject {


  /**
   * This is a database field.
   **/
  private String i_idHabitat = null;
  /**
   * This is a database field.
   **/
  private Integer i_idNatureObject = null;
  /**
   * This is a database field.
   **/
  private String i_scientificName = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;
  /**
   * This is a database field.
   **/
  private String i_code2000 = null;
  /**
   * This is a database field.
   **/
  private String i_codeAnnex1 = null;
  /**
   * This is a database field.
   **/
  private Short i_priority = null;
  /**
   * This is a database field.
   **/
  private String i_eunisHabitatCode = null;
  /**
   * This is a database field.
   **/
  private String i_classRef = null;
  /**
   * This is a database field.
   **/
  private String i_codePart2 = null;
  /**
   * This is a database field.
   **/
  private Integer i_level = null;

  private String geographicalDistribution = null;

  private String areaNameEn = null;
  private String iso2L = null;
  private String biogeoregionName = null;
  private Integer idReportAttributes = null;


  public HabitatCountryPersist() {
    super();
  }

  public String getIso2L() {
    return iso2L;
  }

  public void setIso2L(String iso2L) {
    this.iso2L = iso2L;
  }

  public String getBiogeoregionName() {
    return biogeoregionName;
  }

  public void setBiogeoregionName(String biogeoregionName) {
    this.biogeoregionName = biogeoregionName;
  }

  public String getAreaNameEn() {
    return areaNameEn;
  }

  public void setAreaNameEn(String areaNameEn) {
    this.areaNameEn = areaNameEn;
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
  public Integer getLevel() {
    if (null == i_level) return new Integer(0);
    return i_level;
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
   * @param level
   **/
  public void setLevel(Integer level) {
    this.i_level = level;
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

  public Integer getIdReportAttributes() {
    return idReportAttributes;
  }

  public void setIdReportAttributes(Integer idReportAttributes) {
    this.idReportAttributes = idReportAttributes;
  }

}
