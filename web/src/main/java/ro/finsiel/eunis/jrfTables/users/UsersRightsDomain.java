package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * JRF table for eunis_users inner join eunis_users_roles inner join eunis_roles inner join eunis_roles_rights inner join eunis_rights.
 * @author finsiel
 **/
public class UsersRightsDomain extends AbstractDomain {

  /****/
  public PersistentObject newPersistentObject() {
    return new UsersRightsPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("eunis_users");
    this.setTableAlias("A");
    this.addColumnSpec(new StringColumnSpec("USERNAME", "getUsername", "setUsername", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("FIRST_NAME", "getFierstName", "setFirstName", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("LAST_NAME", "getLastName", "setLastName", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("EMAIL", "getEMail", "setEMail", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new IntegerColumnSpec("THEME_INDEX", "getThemeIndex", "setThemeIndex", null, REQUIRED));

    JoinTable usersRoles = new JoinTable("eunis_users_roles B", "USERNAME", "USERNAME");
    this.addJoinTable(usersRoles);

    JoinTable eunisRoles = new JoinTable("eunis_roles D", "ROLENAME", "ROLENAME");
    usersRoles.addJoinTable(eunisRoles);

    JoinTable rolesRights = new JoinTable("eunis_roles_rights C", "ROLENAME", "ROLENAME");
    rolesRights.addJoinColumn(new StringJoinColumn("RIGHTNAME", "setRightName"));
    eunisRoles.addJoinTable(rolesRights);

    JoinTable eunisRights = new JoinTable("eunis_rights E", "RIGHTNAME", "RIGHTNAME");
    rolesRights.addJoinTable(eunisRights);
  }
}