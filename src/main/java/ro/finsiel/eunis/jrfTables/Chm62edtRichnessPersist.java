package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:52 $
 **/
public class Chm62edtRichnessPersist extends PersistentObject implements HabitatOtherInfo {

  /**
   * This is a database field.
   **/
  private Integer i_idRichness = null;
  /**
   * This is a database field.
   **/
  private String i_name = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;

  public Chm62edtRichnessPersist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getDescription() {
    return i_description;
  }

  /**
   * Getter for a database field.
   **/
  public Integer getIdRichness() {
    return i_idRichness;
  }

  /**
   * Getter for a database field.
   **/
  public String getName() {
    return i_name;
  }

  /**
   * Setter for a database field.
   * @param description
   **/
  public void setDescription(String description) {
    i_description = description;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param idRichness
   **/
  public void setIdRichness(Integer idRichness) {
    i_idRichness = idRichness;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param name
   **/
  public void setName(String name) {
    i_name = name;
    this.markModifiedPersistentState();
  }

}
