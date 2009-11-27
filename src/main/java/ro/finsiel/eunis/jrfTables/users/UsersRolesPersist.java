package ro.finsiel.eunis.jrfTables.users;

/**
 * Date: Sep 10, 2003
 * Time: 3:59:58 PM
 */

import net.sf.jrf.domain.PersistentObject;


public class UsersRolesPersist extends PersistentObject {
  /** This is a database field. */
  private String roleName = null;
  /** This is a database field. */
  private String userName = null;

  /** Default constructor */
  public UsersRolesPersist() {
    super();
  }

  public String getRoleName() {
    return roleName;
  }

  public void setRoleName(String roleName) {
    this.roleName = roleName;
  }

  public String getUserName() {
    return userName;
  }

  public void setUserName(String userName) {
    this.userName = userName;
  }

}


