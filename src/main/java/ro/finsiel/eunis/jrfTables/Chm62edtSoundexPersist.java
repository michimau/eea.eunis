package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.domain.PersistentObject;

/**
 * JRF persistent object.
 * @author finsiel
 **/
public class Chm62edtSoundexPersist extends PersistentObject {
  private String i_Name = null;
  private String i_Phonetic = null;
  private String i_ObjectType = null;

  /**
   * Constructs an new Chm62edtAbundancePersist object.
   */
  public Chm62edtSoundexPersist() {
    super();
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getPhonetic() {
    return i_Phonetic;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getName() {
    return i_Name;
  }

  /**
   * Getter for a database field.
   * @return Field value.
   **/
  public String getObjectType() {
    return i_ObjectType;
  }

  /**
   * Setter for a database field.
   * @param phonetic New value.
   **/
  public void setPhonetic(String phonetic) {
    i_Phonetic = phonetic;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param name New value.
   **/
  public void setName(String name) {
    i_Name = name;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

  /**
   * Setter for a database field.
   * @param objectType New value.
   **/
  public void setObjectType(String objectType) {
    i_ObjectType = objectType;
    // Changing a primary key so we force this to new.
    this.forceNewPersistentState();
  }

}