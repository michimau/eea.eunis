package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtFrequenciesPersist extends PersistentObject {
  private Integer i_idFrequencies = null;
  private String i_description = null;
  private String name = null;

  /**
   * Creates an new instance of Chm62edtFrequenciesPersist object.
   */
  public Chm62edtFrequenciesPersist() {
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
  public Integer getIdFrequencies() {
    return i_idFrequencies;
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
   * @param idFrequencies New value.
   **/
  public void setIdFrequencies(Integer idFrequencies) {
    i_idFrequencies = idFrequencies;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }
}