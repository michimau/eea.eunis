package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtRepresentativityPersist extends PersistentObject {
  private String idRepresentativity = null;
  private String name = null;
  private String description = null;

  /**
   * Constructs an new Chm62edtRelativeSurfacePersist object.
   */
  public Chm62edtRepresentativityPersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdRepresentativity() {
    return idRepresentativity;
  }

  /**
   * Setter for a database field.
   * @param idRepresentativity New value.
   **/
  public void setIdRepresentativity(String idRepresentativity) {
    this.idRepresentativity = idRepresentativity;
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