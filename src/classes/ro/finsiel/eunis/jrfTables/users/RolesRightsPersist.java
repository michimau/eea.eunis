package ro.finsiel.eunis.jrfTables.users;

/**
 * Date: Sep 11, 2003
 * Time: 12:18:23 PM
 */

import net.sf.jrf.domain.PersistentObject;


public class RolesRightsPersist extends PersistentObject {
  /** This is a database field. */
  private String roleName = null;
  /** This is a database field. */
  private String rightName = null;
  private String rightDescription = null;


  /** Default constructor */
  public RolesRightsPersist() {
    super();
  }

  public String getRoleName() {
    return roleName;
  }

  public void setRoleName(String roleName) {
    this.roleName = roleName;
  }

  public String getRightName() {
    return rightName;
  }

  public void setRightName(String rightName) {
    this.rightName = rightName;
  }

  public String getRightDescription() {
    return rightDescription;
  }

  public void setRightDescription(String rightDescription) {
    this.rightDescription = rightDescription;
  }
}


