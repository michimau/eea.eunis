/*
 * $Id
*/

package ro.finsiel.eunis.jrfTables;


import net.sf.jrf.domain.PersistentObject;

/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:49 $
 **/
public class Chm62edtHabitatAnnex1Persist extends PersistentObject {

  /**
   * This is a database field.
   **/
  private String i_code2000 = null;
  /**
   * This is a database field.
   **/
  private String i_habitatName = null;

  public Chm62edtHabitatAnnex1Persist() {
    super();
  }

  /**
   * Getter for a database field.
   **/
  public String getCode2000() {
    return i_code2000;
  }

  /**
   * Getter for a database field.
   **/
  public String getHabitatName() {
    return i_habitatName;
  }

  /**
   * Setter for a database field.
   * @param code2000
   **/
  public void setCode2000(String code2000) {
    i_code2000 = code2000;
    this.markModifiedPersistentState();
  }

  /**
   * Setter for a database field.
   * @param habitatName
   **/
  public void setHabitatName(String habitatName) {
    i_habitatName = habitatName;
    this.markModifiedPersistentState();
  }

}
