package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for eunis_roles.
 * @author finsiel
 **/
public class RolesDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new RolesPersist();
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
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_EMPTY_STRING));
  }
}