package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtActivityInfluencePersist extends PersistentObject {
  private String idActivityInfluence = null;
  private String name = null;
  private String description = null;

  /**
   * Constructs an new Chm62edtActivityInfluencePersist object.
   */
  public Chm62edtActivityInfluencePersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getIdActivityInfluence() {
    return idActivityInfluence;
  }

  /**
   * Setter for a database field.
   * @param idActivityInfluence New value.
   **/
  public void setIdActivityInfluence(String idActivityInfluence) {
    this.idActivityInfluence = idActivityInfluence;
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