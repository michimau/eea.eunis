/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcDescriptionPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private Integer i_idDescription = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;
  /**
   * This is a database field.
   **/
  private String i_toc = null;
  /**
   * This is a database field.
   **/
  private String i_abstract = null;

  public DcDescriptionPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getAbstract() {
    return i_abstract;
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
  public Integer getIdDc() {
    return i_idDc;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdDescription() {
    return i_idDescription;
  }

  /**
   * Getter for a database field.
   **/
  public String getToc() {
    return i_toc;
  }

  /**
   * Setter for a database field.
   * @param abstract
   **/
  public void setAbstract(String value) {
    i_abstract = value;
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
   * @param idDc
   **/
  public void setIdDc(Integer idDc) {
    i_idDc = idDc;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idDescription
   **/
  public void setIdDescription(Integer idDescription) {
    i_idDescription = idDescription;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param toc
   **/
  public void setToc(String toc) {
    i_toc = toc;
    this.markModifiedPersistentState();
  }

}
