package ro.finsiel.eunis.jrfTables.save_criteria;

import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;

/**
 * Date: Sep 22, 2003
 * Time: 12:53:57 PM
 */
public class CriteriasForUsersDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new CriteriasForUsersPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("EUNIS_GROUP_SEARCH");

    this.addColumnSpec(new StringColumnSpec("CRITERIA_NAME", "getNameCriteria", "setNameCriteria", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("USERNAME", "getUsers", "setUsers", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("FROM_WHERE", "getFromWhere", "setFromWhere", DEFAULT_TO_EMPTY_STRING, REQUIRED));

    JoinTable join1 = new JoinTable("EUNIS_GROUP_SEARCH_CRITERIA", "CRITERIA_NAME", "CRITERIA_NAME");
    join1.addJoinColumn(new StringJoinColumn("CRITERIA_FORM_FIELD_ATTRIBUTE", "setCriteriaFormFieldAttribute"));
    join1.addJoinColumn(new StringJoinColumn("CRITERIA_FORM_FIELD_OPERATOR", "setCriteriaFormFieldOperator"));
    join1.addJoinColumn(new StringJoinColumn("CRITERIA_ATTRIBUTE", "setCriteriaAttribute"));
    join1.addJoinColumn(new StringJoinColumn("CRITERIA_OPERATOR", "setCriteriaOperator"));
    join1.addJoinColumn(new StringJoinColumn("CRITERIA_FIRST_VALUE", "setCriteriaFirstValue"));
    join1.addJoinColumn(new StringJoinColumn("CRITERIA_LAST_VALUE", "setCriteriaLastValue"));
    this.addJoinTable(join1);
  }
}
