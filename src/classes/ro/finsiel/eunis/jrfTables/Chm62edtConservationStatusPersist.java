package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

import java.util.Date;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtConservationStatusPersist extends PersistentObject {
  private Integer i_idDc = null;
  private Integer i_idConsStatus = null;
  private String code = null;
  private String description = null;
  private String name = null;
  private Date i_redBookDate = null;
  private Integer i_idConsStatusLink = null;

  /**
   * Creates an new Chm62edtConservationStatusPersist object.
   */
  public Chm62edtConservationStatusPersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getIdDc() {
    return i_idDc;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getCode() {
    return code;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getDescription() {
    return description;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getName() {
    return name;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getIdConsStatus() {
    return i_idConsStatus;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Integer getIdConsStatusLink() {
    return i_idConsStatusLink;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public Date getRedBookDate() {
    return i_redBookDate;
  }

  /**
   * Setter for a database field.
   * @param code New value.
   **/
  public void setCode(String code) {
    this.code = code;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param consCode New value.
   **/
  public void setIdDc(Integer consCode) {
    i_idDc = consCode;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param description New value.
   **/
  public void setDescription(String description) {
    this.description = description;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param name New value.
   **/
  public void setName(String name) {
    this.name = name;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idConsStatus New value.
   **/
  public void setIdConsStatus(Integer idConsStatus) {
    i_idConsStatus = idConsStatus;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idConsStatusLink New value.
   **/
  public void setIdConsStatusLink(Integer idConsStatusLink) {
    i_idConsStatusLink = idConsStatusLink;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param redBookDate New value.
   **/
  public void setRedBookDate(Date redBookDate) {
    i_redBookDate = redBookDate;
    this.markModifiedPersistentState();
  }
}