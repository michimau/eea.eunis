package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtNatura2000ConservationCodePersist extends PersistentObject {
  private String idNatura2000ConservationCode = null;
  private String name = null;
  private String description = null;

  /**
   * Constructs an new Chm62edtNatura2000ConservationCodePersist object.
   */
  public Chm62edtNatura2000ConservationCodePersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdNatura2000ConservationCode() {
    return idNatura2000ConservationCode;
  }

  /**
   * Setter for a database field.
   * @param idNatura2000ConservationCode New value.
   **/
  public void setIdNatura2000ConservationCode(String idNatura2000ConservationCode) {
    this.idNatura2000ConservationCode = idNatura2000ConservationCode;
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