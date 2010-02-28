/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcIdentifierPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private Integer i_idIdentifier = null;
  /**
   * This is a database field.
   **/
  private String i_identifier = null;

  public DcIdentifierPersist() {
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
  public Integer getIdIdentifier() {
    return i_idIdentifier;
  }

  /**
   * Getter for a database field.
   **/
  public String getIdentifier() {
    return i_identifier;
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
   * @param idIdentifier
   **/
  public void setIdIdentifier(Integer idIdentifier) {
    i_idIdentifier = idIdentifier;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param identifier
   **/
  public void setIdentifier(String identifier) {
    i_identifier = identifier;
    this.markModifiedPersistentState();
  }

}
