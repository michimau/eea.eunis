package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtCoverPersist extends PersistentObject implements HabitatOtherInfo {
  private Integer i_idCover = null;
  private String i_name = null;
  private String i_description = null;

  /**
   * Creates an new instance of Chm62edtCoverPersist object.
   */
  public Chm62edtCoverPersist() {
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
  public Integer getIdCover() {
    return i_idCover;
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
   **/  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idCover New value.
   **/  public void setIdCover(Integer idCover) {
    i_idCover = idCover;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param name New value.
   **/  public void setName(String name) {
    i_name = name;
    this.markModifiedPersistentState();
  }
}