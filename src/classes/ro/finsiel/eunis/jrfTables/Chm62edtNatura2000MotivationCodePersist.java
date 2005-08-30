package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtNatura2000MotivationCodePersist extends PersistentObject {
  private String idNatura2000MotivationCode = null;
  private String name = null;
  private String description = null;

  /**
   * Constructs an new Chm62edtNatura2000MotivationCodePersist object.
   */
  public Chm62edtNatura2000MotivationCodePersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdNatura2000MotivationCode() {
    return idNatura2000MotivationCode;
  }

  /**
   * Setter for a database field.
   * @param idNatura2000MotivationCode New value.
   **/
  public void setIdNatura2000MotivationCode(String idNatura2000MotivationCode) {
    this.idNatura2000MotivationCode = idNatura2000MotivationCode;
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