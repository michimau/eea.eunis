package ro.finsiel.eunis.jrfTables.users;

/**
 * Date: Sep 10, 2003
 * Time: 2:30:40 PM
 */

import net.sf.jrf.domain.PersistentObject;


public class RolesPersist extends PersistentObject {
  /** This is a database field. */
  private String roleName = null;
  /** This is a database field. */
  private String description = null;

  /** Default constructor */
  public RolesPersist() {
    super();
  }

  public String getRoleName() {
    return roleName;
  }

  public void setRoleName(String roleName) {
    this.roleName = roleName;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

}
