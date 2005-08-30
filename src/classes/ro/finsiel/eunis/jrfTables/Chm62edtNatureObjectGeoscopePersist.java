/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:51 $
 **/
public class Chm62edtNatureObjectGeoscopePersist extends PersistentObject {

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
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private Integer i_idGeoscope = null;

  private Integer idReportAttributes = null;

  public Chm62edtNatureObjectGeoscopePersist() {
    super();
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
  public Integer getIdDc() {
    return i_idDc;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdGeoscope() {
    return i_idGeoscope;
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
//  public String getRelation() { return i_relation; }

  /**
   * Getter for a database field.
   **/
//  public Short getRelationExist() { return i_relationExist; }

  /**
   * Getter for a database field.
   **/
//  public Short getSelection() { return i_selection; }

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
   * @param idGeoscope
   **/
  public void setIdGeoscope(Integer idGeoscope) {
    i_idGeoscope = idGeoscope;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

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
   * @param relation
   **/
//  public void setRelation(String relation) {
//    i_relation = relation;
//    this.markModifiedPersistentState();
//  }

  /**
   * Setter for a database field.
   * @param relationExist
   **/
//  public void setRelationExist(Short relationExist) {
//    i_relationExist = relationExist;
//    this.markModifiedPersistentState();
//  }

  /**
   * Setter for a database field.
   * @param selection
   **/
//  public void setSelection(Short selection) {
//    i_selection = selection;
//    this.markModifiedPersistentState();
//  }

}
