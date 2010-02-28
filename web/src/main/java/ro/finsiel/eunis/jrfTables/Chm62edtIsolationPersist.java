package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtIsolationPersist extends PersistentObject {
  private String idIsolation = null;
  private String name = null;
  private String description = null;

  /**
   * Constructs an new Chm62edtIsolationPersist object.
   */
  public Chm62edtIsolationPersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdIsolation() {
    return idIsolation;
  }

  /**
   * Setter for a database field.
   * @param idIsolation New value.
   **/
  public void setIdIsolation(String idIsolation) {
    this.idIsolation = idIsolation;
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