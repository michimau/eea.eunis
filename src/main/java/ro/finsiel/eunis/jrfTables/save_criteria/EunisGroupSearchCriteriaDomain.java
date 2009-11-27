package ro.finsiel.eunis.jrfTables.save_criteria;

/**
 * Date: Sep 19, 2003
 * Time: 10:59:09 AM
 */

import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;


/**
 *
 * @version $Revision: 1.1.1.1 $ $Date: 2003/12/09 08:34:59 $
 **/
public class EunisGroupSearchCriteriaDomain extends AbstractDomain {


  /**
   **/
  public PersistentObject newPersistentObject() {
    return new EunisGroupSearchCriteriaPersist();
  }

  /**
   **/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("EUNIS_GROUP_SEARCH_CRITERIA");

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(new StringColumnSpec("CRITERIA_NAME", "getNameCriteria", "setNameCriteria", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ID_EUNIS_GROUP_SEARCH_CRITERIA", "getIdGroupSearchCriteria()", "setIdGroupSearchCriteria", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY))
    );

    this.addColumnSpec(new StringColumnSpec("CRITERIA_ATTRIBUTE", "getAttribute", "setAttribute", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("CRITERIA_FORM_FIELD_ATTRIBUTE", "getFormFieldAttribute", "setFormFieldAttribute", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("CRITERIA_OPERATOR", "getOperator", "setOperator", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("CRITERIA_FORM_FIELD_OPERATOR", "getFormFieldOperator", "setFormFieldOperator", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("CRITERIA_FIRST_VALUE", "getFirstValue", "setFirstValue", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("CRITERIA_LAST_VALUE", "getLastValue", "setLastValue", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("CRITERIA_BOOLEAN", "getCriteriaBoolean", "setCriteriaBoolean", DEFAULT_TO_EMPTY_STRING));
  }
}
