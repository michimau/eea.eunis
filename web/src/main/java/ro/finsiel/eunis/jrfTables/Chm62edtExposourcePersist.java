package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtExposourcePersist extends PersistentObject {
  private Integer i_idExposource = null;
  private String i_description = null;
  private String name = null;

  /**
   * Creates an new instance of Chm62edtExposourcePersist object.
   */
  public Chm62edtExposourcePersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getName() {
    return name;
  }

  /**
   * Setter for a database field.
   * @param name New value.
   **/
  public void setName(String name) {
    this.name = name;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getDescription() {
    return i_description;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getIdExposource() {
    return i_idExposource;
  }


  /**
   * Setter for a database field.
   * @param description New value.
   **/
  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idExposource New value.
   **/
  public void setIdExposource(Integer idExposource) {
    i_idExposource = idExposource;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }
}