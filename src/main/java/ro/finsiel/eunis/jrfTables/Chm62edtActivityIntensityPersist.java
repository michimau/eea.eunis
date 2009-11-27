package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtActivityIntensityPersist extends PersistentObject {
  private String idActivityIntensity = null;
  private String name = null;
  private String description = null;

  /**
   * Constructs an new Chm62edtActivityIntensityPersist object.
   */
  public Chm62edtActivityIntensityPersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdActivityIntensity() {
    return idActivityIntensity;
  }

  /**
   * Setter for a database field.
   * @param idActivityIntensity New value.
   **/
  public void setIdActivityIntensity(String idActivityIntensity) {
    this.idActivityIntensity = idActivityIntensity;
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
    return description;
  }

  /**
   * Setter for a database field.
   * @param description New value.
   **/
  public void setDescription(String description) {
    this.description = description;
  }
}