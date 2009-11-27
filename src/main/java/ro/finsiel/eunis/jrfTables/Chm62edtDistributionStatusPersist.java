package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtDistributionStatusPersist extends PersistentObject {
  private Integer id = null;
  private Integer name = null;
  private Integer description = null;
  private Integer idDc = null;

  /**
   * Creates an new instance of Chm62edtDistributionStatusPersist object.
   */
  public Chm62edtDistributionStatusPersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getDescription() {
    return description;
  }

  /**
   * Setter for a database field.
   * @param description New value.
   **/
  public void setDescription(Integer description) {
    this.description = description;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getId() {
    return id;
  }

  /**
   * Setter for a database field.
   * @param id New value.
   **/  public void setId(Integer id) {
    this.id = id;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getIdDc() {
    return idDc;
  }

  /**
   * Setter for a database field.
   * @param idDc New value.
   **/
  public void setIdDc(Integer idDc) {
    this.idDc = idDc;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getName() {
    return name;
  }

  /**
   * Setter for a database field.
   * @param name New value.
   **/
  public void setName(Integer name) {
    this.name = name;
  }
}