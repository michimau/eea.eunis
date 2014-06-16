package ro.finsiel.eunis.jrfTables.users;

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for eunis_users.
 * @author finsiel
 **/
public class UserDomain extends AbstractDomain {


  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new UserPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("eunis_users");
    this.addColumnSpec(new StringColumnSpec("USERNAME", "getUsername", "setUsername", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("FIRST_NAME", "getFirstName", "setFirstName", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("LAST_NAME", "getLastName", "setLastName", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("LANG", "getLang", "setLang", "en" ));
    this.addColumnSpec(new StringColumnSpec("EMAIL", "getEMail", "setEMail", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new IntegerColumnSpec("THEME_INDEX", "getThemeIndex", "setThemeIndex", new Integer(0), REQUIRED));
    this.addColumnSpec(new StringColumnSpec("LOGIN_DATE", "getLoginDate", "setLoginDate", DEFAULT_TO_NULL));
  }
}