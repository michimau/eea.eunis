package ro.finsiel.eunis.jrfTables.users;

/**
 * Date: Sep 12, 2003
 * Time: 5:08:50 PM
 */

import net.sf.jrf.domain.PersistentObject;


/**
 * Persistent object.
 */
public class RightsPersist extends PersistentObject {
  /** This is a database field. */
  private String rightName = null;
  /** This is a database field. */
  private String description = null;

  /** Default constructor. */
  public RightsPersist() {
    super();
  }

  public String getRightName() {
    return rightName;
  }

  public void setRightName(String rightName) {
    this.rightName = rightName;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

}
