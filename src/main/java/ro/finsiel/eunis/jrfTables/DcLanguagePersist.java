/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class DcLanguagePersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idDc = null;
  /**
   * This is a database field.
   **/
  private Integer i_idLanguage = null;
  /**
   * This is a database field.
   **/
  private String i_language = null;

  public DcLanguagePersist() {
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
  public Integer getIdLanguage() {
    return i_idLanguage;
  }

  /**
   * Getter for a database field.
   **/
  public String getLanguage() {
    return i_language;
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
   * @param idLanguage
   **/
  public void setIdLanguage(Integer idLanguage) {
    i_idLanguage = idLanguage;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param language
   **/
  public void setLanguage(String language) {
    i_language = language;
    this.markModifiedPersistentState();
  }

}
