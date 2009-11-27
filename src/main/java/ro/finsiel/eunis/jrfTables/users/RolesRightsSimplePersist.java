package ro.finsiel.eunis.jrfTables.users;

/**
 * Date: Sep 15, 2003
 * Time: 4:31:50 PM
 */

import net.sf.jrf.domain.PersistentObject;


public class RolesRightsSimplePersist extends PersistentObject {
  /** This is a database field. */
  private String roleName = null;
  /** This is a database field. */
  private String rightName = null;

  /** Default constructor */
  public RolesRightsSimplePersist() {
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

}


