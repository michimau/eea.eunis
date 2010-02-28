/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:50 $
 **/
public class Chm62edtMotivationPersist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private Integer i_idMotivation = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;

  private String name = null;

  public Chm62edtMotivationPersist() {
    super();
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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
  public Integer getIdMotivation() {
    return i_idMotivation;
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
   * @param idMotivation
   **/
  public void setIdMotivation(Integer idMotivation) {
    i_idMotivation = idMotivation;
    this.markModifiedPersistentState();
  }

}
