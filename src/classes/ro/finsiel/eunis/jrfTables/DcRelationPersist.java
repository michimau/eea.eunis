/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcRelationPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private Integer i_idRelation = null;
  /**
   * This is a database field.
   **/
  private String i_relation = null;
  /**
   * This is a database field.
   **/
  private String i_isVersionOf = null;
  /**
   * This is a database field.
   **/
  private String i_hasVersion = null;
  /**
   * This is a database field.
   **/
  private String i_isReplacedBy = null;
  /**
   * This is a database field.
   **/
  private String i_isRequiredBy = null;
  /**
   * This is a database field.
   **/
  private String i_requires = null;
  /**
   * This is a database field.
   **/
  private String i_isPartOf = null;
  /**
   * This is a database field.
   **/
  private String i_hasPart = null;
  /**
   * This is a database field.
   **/
  private String i_isReferencedBy = null;
  /**
   * This is a database field.
   **/
  private String i_References = null;
  /**
   * This is a database field.
   **/
  private String i_isFormatOf = null;
  /**
   * This is a database field.
   **/
  private String i_hasFormat = null;

  public DcRelationPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getHasFormat() {
    return i_hasFormat;
  }

  /**
   * Getter for a database field.
   **/
  public String getHasPart() {
    return i_hasPart;
  }

  /**
   * Getter for a database field.
   **/
  public String getHasVersion() {
    return i_hasVersion;
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
  public Integer getIdRelation() {
    return i_idRelation;
  }

  /**
   * Getter for a database field.
   **/
  public String getIsFormatOf() {
    return i_isFormatOf;
  }

  /**
   * Getter for a database field.
   **/
  public String getIsPartOf() {
    return i_isPartOf;
  }

  /**
   * Getter for a database field.
   **/
  public String getIsReferencedBy() {
    return i_isReferencedBy;
  }

  /**
   * Getter for a database field.
   **/
  public String getIsReplacedBy() {
    return i_isReplacedBy;
  }

  /**
   * Getter for a database field.
   **/
  public String getIsRequiredBy() {
    return i_isRequiredBy;
  }

  /**
   * Getter for a database field.
   **/
  public String getIsVersionOf() {
    return i_isVersionOf;
  }

  /**
   * Getter for a database field.
   **/
  public String getReferences() {
    return i_References;
  }

  /**
   * Getter for a database field.
   **/
  public String getRelation() {
    return i_relation;
  }

  /**
   * Getter for a database field.
   **/
  public String getRequires() {
    return i_requires;
  }

  /**
   * Setter for a database field.
   * @param hasFormat
   **/
  public void setHasFormat(String hasFormat) {
    i_hasFormat = hasFormat;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param hasPart
   **/
  public void setHasPart(String hasPart) {
    i_hasPart = hasPart;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param hasVersion
   **/
  public void setHasVersion(String hasVersion) {
    i_hasVersion = hasVersion;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idDc
   **/
  public void setIdDc(Integer idDc) {
    i_idDc = idDc;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idRelation
   **/
  public void setIdRelation(Integer idRelation) {
    i_idRelation = idRelation;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param isFormatOf
   **/
  public void setIsFormatOf(String isFormatOf) {
    i_isFormatOf = isFormatOf;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param isPartOf
   **/
  public void setIsPartOf(String isPartOf) {
    i_isPartOf = isPartOf;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param isReferencedBy
   **/
  public void setIsReferencedBy(String isReferencedBy) {
    i_isReferencedBy = isReferencedBy;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param isReplacedBy
   **/
  public void setIsReplacedBy(String isReplacedBy) {
    i_isReplacedBy = isReplacedBy;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param isRequiredBy
   **/
  public void setIsRequiredBy(String isRequiredBy) {
    i_isRequiredBy = isRequiredBy;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param isVersionOf
   **/
  public void setIsVersionOf(String isVersionOf) {
    i_isVersionOf = isVersionOf;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param References
   **/
  public void setReferences(String References) {
    i_References = References;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param relation
   **/
  public void setRelation(String relation) {
    i_relation = relation;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param requires
   **/
  public void setRequires(String requires) {
    i_requires = requires;
    this.markModifiedPersistentState();
  }

}
