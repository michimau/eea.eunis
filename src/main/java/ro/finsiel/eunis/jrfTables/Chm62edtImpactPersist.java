package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:50 $
 **/
public class Chm62edtImpactPersist extends PersistentObject implements HabitatOtherInfo {

  /**
   * This is a database field.
   **/
  private Integer i_idImpact = null;
  /**
   * This is a database field.
   **/
  private String i_name = null;
  /**
   * This is a database field.
   **/
  private String i_description = null;

  private String natura2000Code = null;
  private String natura2000Name = null;

  public Chm62edtImpactPersist() {
    super();
  }

  public String getNatura2000Code() {
    return natura2000Code;
  }

  public void setNatura2000Code(String natura2000Code) {
    this.natura2000Code = natura2000Code;
  }

  public String getNatura2000Name() {
    return natura2000Name;
  }

  public void setNatura2000Name(String natura2000Name) {
    this.natura2000Name = natura2000Name;
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
  public Integer getIdImpact() {
    return i_idImpact;
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
   * @param idImpact
   **/
  public void setIdImpact(Integer idImpact) {
    i_idImpact = idImpact;
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
