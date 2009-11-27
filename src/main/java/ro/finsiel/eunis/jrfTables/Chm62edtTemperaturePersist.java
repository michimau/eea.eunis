package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:53 $
 **/
public class Chm62edtTemperaturePersist extends PersistentObject implements HabitatOtherInfo {

  /**
   * This is a database field.
   **/
  private Integer i_idTemperature = null;
  /**
   * This is a database field.
   **/
  private String i_name = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;

  public Chm62edtTemperaturePersist() {
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
  public Integer getIdTemperature() {
    return i_idTemperature;
  }

  /**
   * Getter for a database field.
   **/
  public String getName() {
    return i_name;
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
   * @param idTemperature
   **/
  public void setIdTemperature(Integer idTemperature) {
    i_idTemperature = idTemperature;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param name
   **/
  public void setName(String name) {
    i_name = name;
    this.markModifiedPersistentState();
  }

}
