package ro.finsiel.eunis.jrfTables.save_criteria;

/**
 * Date: Sep 19, 2003
 * Time: 10:54:22 AM
 */

import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision$ $Date$
 **/
public class EunisGroupSearchDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new EunisGroupSearchPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("eunis_group_search");

    this.addColumnSpec(new StringColumnSpec("CRITERIA_NAME", "getNameCriteria", "setNameCriteria", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("USERNAME", "getUsers", "setUsers", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("FROM_WHERE", "getFromWhere", "setFromWhere", DEFAULT_TO_EMPTY_STRING, REQUIRED));
  }
}
