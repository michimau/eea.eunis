package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtDepthPersist extends PersistentObject implements HabitatOtherInfo {
  private Integer i_idDepth = null;
  private String i_description = null;
  private String name = null;


  /**
   * Creates an new instance of Chm62edtDepthPersist object.
   */
  public Chm62edtDepthPersist() {
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
  public Integer getIdDepth() {
    return i_idDepth;
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
   * @param idDepth New value.
   **/  public void setIdDepth(Integer idDepth) {
    i_idDepth = idDepth;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
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
}