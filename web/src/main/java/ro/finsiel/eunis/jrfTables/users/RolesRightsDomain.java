package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * JRF table for eunis_roles inner join eunis_roles_rights inner join eunis_rights.
 * @author finsiel
 **/
public class RolesRightsDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new RolesRightsPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("eunis_roles");
    this.setTableAlias("A");
    this.addColumnSpec(new StringColumnSpec("ROLENAME", "getRoleName", "setRoleName", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));

    JoinTable rolesRights = new JoinTable("eunis_roles_rights C", "ROLENAME", "ROLENAME");
    rolesRights.addJoinColumn(new StringJoinColumn("RIGHTNAME", "setRightName"));
    this.addJoinTable(rolesRights);

    JoinTable rights = new JoinTable("eunis_rights E", "RIGHTNAME", "RIGHTNAME");
    rights.addJoinColumn(new StringJoinColumn("DESCRIPTION", "setRightDescription"));
    rolesRights.addJoinTable(rights);
  }
}
