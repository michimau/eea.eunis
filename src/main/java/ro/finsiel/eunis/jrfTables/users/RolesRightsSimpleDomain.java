package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_ABUNDANCE.
 * @author finsiel
 **/
public class RolesRightsSimpleDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new RolesRightsSimplePersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("EUNIS_ROLES_RIGHTS");
    this.setTableAlias("A");
    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("RIGHTNAME", "getRightName", "setRightName", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ROLENAME", "getRoleName", "setRoleName", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)
            )
    );
  }
}