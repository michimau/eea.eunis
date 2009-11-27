package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtChemistryPersist extends PersistentObject implements HabitatOtherInfo {
  private Integer i_idChemistry = null;
  private String i_name = null;
  private String i_description = null;

  /**
   * Creates an new Chm62edtChemistryPersist object.
   */
  public Chm62edtChemistryPersist() {
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
  public Integer getIdChemistry() {
    return i_idChemistry;
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
   * @param idChemistry New value.
   **/
  public void setIdChemistry(Integer idChemistry) {
    i_idChemistry = idChemistry;
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