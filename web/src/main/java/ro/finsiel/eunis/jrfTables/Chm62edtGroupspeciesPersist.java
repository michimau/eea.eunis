/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:49 $
 **/
public class Chm62edtGroupspeciesPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idGroupspecies = null;
  /**
   * This is a database field.
   **/
  private String i_commonName = null;
  /**
   * This is a database field.
   **/
  private String i_scientificName = null;
  /**
   * This is a database field.
   **/
  private Short i_selection = null;
  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;

  public Chm62edtGroupspeciesPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getCommonName() {
    return i_commonName;
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
  public Integer getIdGroupspecies() {
    return i_idGroupspecies;
  }

  /**
   * Getter for a database field.
   **/
  public String getScientificName() {
    return i_scientificName;
  }

  /**
   * Getter for a database field.
   **/
  public Short getSelection() {
    return i_selection;
  }

  /**
   * Setter for a database field.
   * @param commonName
   **/
  public void setCommonName(String commonName) {
    i_commonName = commonName;
    this.markModifiedPersistentState();
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
   * @param idGroupspecies
   **/
  public void setIdGroupspecies(Integer idGroupspecies) {
    i_idGroupspecies = idGroupspecies;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
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
   * Setter for a database field.
   * @param selection
   **/
  public void setSelection(Short selection) {
    i_selection = selection;
    this.markModifiedPersistentState();
  }

}
