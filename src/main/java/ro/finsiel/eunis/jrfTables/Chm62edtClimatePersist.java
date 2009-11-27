package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtClimatePersist extends PersistentObject implements HabitatOtherInfo {
  private Integer i_idClimate = null;
  private String i_name = null;
  private String i_description = null;

  /**
   * Creates an new Chm62edtClimatePersist object.
   */
  public Chm62edtClimatePersist() {
    super();
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
  public Integer getIdClimate() {
    return i_idClimate;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getName() {
    return i_name;
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
   * @param idClimate New value.
   **/
  public void setIdClimate(Integer idClimate) {
    i_idClimate = idClimate;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param name New value.
   **/
  public void setName(String name) {
    i_name = name;
    this.markModifiedPersistentState();
  }
}
