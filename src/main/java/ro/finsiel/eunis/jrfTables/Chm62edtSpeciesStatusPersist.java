/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtSpeciesStatusPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idSpeciesStatus = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;
  /**
   * This is a database field.
   **/
  private String i_shortDefinition = null;
  /**
   * This is a database field.
   **/
  private String i_statusCode = null;

  public Chm62edtSpeciesStatusPersist() {
    super();
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
  public Integer getIdSpeciesStatus() {
    return i_idSpeciesStatus;
  }

  /**
   * Getter for a database field.
   **/
  public String getShortDefinition() {
    return i_shortDefinition;
  }

  /**
   * Getter for a database field.
   **/
  public String getStatusCode() {
    return i_statusCode;
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
   * @param idSpeciesStatus
   **/
  public void setIdSpeciesStatus(Integer idSpeciesStatus) {
    i_idSpeciesStatus = idSpeciesStatus;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param shortDefinition
   **/
  public void setShortDefinition(String shortDefinition) {
    i_shortDefinition = shortDefinition;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param statusCode
   **/
  public void setStatusCode(String statusCode) {
    i_statusCode = statusCode;
    this.markModifiedPersistentState();
  }

}
