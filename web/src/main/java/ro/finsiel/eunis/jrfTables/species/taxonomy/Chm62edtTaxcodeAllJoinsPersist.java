package ro.finsiel.eunis.jrfTables.species.taxonomy;

/**
 * Date: Apr 15, 2003
 * Time: 10:05:41 AM
 */

import net.sf.jrf.domain.PersistentObject;


public class Chm62edtTaxcodeAllJoinsPersist extends PersistentObject {

  private String name1 = null;
  private String level1 = null;
  private String name2 = null;
  private String level2 = null;
  private String name3 = null;
  private String level3 = null;
  private String name4 = null;
  private String level4 = null;
  private String name5 = null;
  private String level5 = null;
  private String id1 = null;
  private String id2 = null;
  private String id3 = null;
  private String id4 = null;
  private String id5 = null;
  private String idDc1 = null;
  private String idDc2 = null;
  private String idDc3 = null;
  private String idDc4 = null;
  private String idDc5 = null;


  public String getLevel1() {
    return level1;
  }

  public void setLevel1(String level) {
    this.level1 = level;
  }

  public String getLevel2() {
    return level2;
  }

  public void setLevel2(String level) {
    this.level2 = level;
  }

  public String getLevel3() {
    return level3;
  }

  public void setLevel3(String level) {
    this.level3 = level;
  }

  public String getLevel4() {
    return level4;
  }

  public void setLevel4(String level) {
    this.level4 = level;
  }

  public String getLevel5() {
    return level5;
  }

  public void setLevel5(String level) {
    this.level5 = level;
  }

  public String getName1() {
    return name1;
  }

  public void setName1(String name) {
    this.name1 = name;
  }

  public String getName2() {
    return name2;
  }

  public void setName2(String name) {
    this.name2 = name;
  }

  public String getName3() {
    return name3;
  }

  public void setName3(String name) {
    this.name3 = name;
  }

  public String getName4() {
    return name4;
  }

  public void setName4(String name) {
    this.name4 = name;
  }

  public String getName5() {
    return name5;
  }

  public void setName5(String name) {
    this.name5 = name;
  }

  public String getId1() {
    return id1;
  }

  public void setId1(String id) {
    this.id1 = id;
  }

  public String getId2() {
    return id2;
  }

  public void setId2(String id) {
    this.id2 = id;
  }

  public String getId3() {
    return id3;
  }

  public void setId3(String id) {
    this.id3 = id;
  }

  public String getId4() {
    return id4;
  }

  public void setId4(String id) {
    this.id4 = id;
  }

  public String getId5() {
    return id5;
  }

  public void setId5(String id) {
    this.id5 = id;
  }

  public String getIdDc1() {
    return idDc1;
  }

  public void setIdDc1(String idDc) {
    this.idDc1 = idDc;
  }

  public String getIdDc2() {
    return idDc2;
  }

  public void setIdDc2(String idDc) {
    this.idDc2 = idDc;
  }

  public String getIdDc3() {
    return idDc3;
  }

  public void setIdDc3(String idDc) {
    this.idDc3 = idDc;
  }

  public String getIdDc4() {
    return idDc4;
  }

  public void setIdDc4(String idDc) {
    this.idDc4 = idDc;
  }

  public String getIdDc5() {
    return idDc5;
  }

  public void setIdDc5(String idDc) {
    this.idDc5 = idDc;
  }

  /**
   * This is a database field.
   **/
  private String i_idTaxcode = null;
  /**
   * This is a database field.
   **/
  private String i_taxonomicLevel = null;
  /**
   * This is a database field.
   **/
  private String i_taxonomicName = null;
  /**
   * This is a database field.
   **/
  private String i_taxonomicGroup = null;
  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private String i_idTaxcodeLink = null;
  /**
   * This is a database field.
   **/
  private String i_notes = null;

  public Chm62edtTaxcodeAllJoinsPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdDc() {
    return i_idDc;
  }


  /**
   * Getter for a database field.
   **/
  public String getIdTaxcode() {
    return i_idTaxcode;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdTaxcodeLink() {
    return i_idTaxcodeLink;
  }

  /**
   * Getter for a database field.
   **/
  public String getNotes() {
    return i_notes;
  }

  /**
   * Getter for a database field.
   **/
  public String getTaxonomicGroup() {
    return i_taxonomicGroup;
  }

  /**
   * Getter for a database field.
   **/
  public String getTaxonomicLevel() {
    return i_taxonomicLevel;
  }

  /**
   * Getter for a database field.
   **/
  public String getTaxonomicName() {
    return i_taxonomicName;
  }

  /**
   * Setter for a database field.
   * @param idDc
   **/
  public void setIdDc(Integer idDc) {
    i_idDc = idDc;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idTaxcode
   **/
  public void setIdTaxcode(String idTaxcode) {
    i_idTaxcode = idTaxcode;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idTaxcodeLink
   **/
  public void setIdTaxcodeLink(String idTaxcodeLink) {
    i_idTaxcodeLink = idTaxcodeLink;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param notes
   **/
  public void setNotes(String notes) {
    i_notes = notes;
    this.markModifiedPersistentState();
  }


  /**
   * Setter for a database field.
   * @param taxonomicGroup
   **/
  public void setTaxonomicGroup(String taxonomicGroup) {
    i_taxonomicGroup = taxonomicGroup;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param taxonomicLevel
   **/
  public void setTaxonomicLevel(String taxonomicLevel) {
    i_taxonomicLevel = taxonomicLevel;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param taxonomicName
   **/
  public void setTaxonomicName(String taxonomicName) {
    i_taxonomicName = taxonomicName;
    this.markModifiedPersistentState();
  }

}
