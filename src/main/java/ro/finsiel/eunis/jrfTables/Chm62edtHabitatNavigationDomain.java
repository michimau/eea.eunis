package ro.finsiel.eunis.jrfTables;

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;

/**
 * JRF table for CHM62EDT_HABITAT_NAVIGATION.
 * @author finsiel
 **/
public class Chm62edtHabitatNavigationDomain extends AbstractDomain {

  /**
   * Implements newPersistentObject from AbstractDomain.
   * @return New persistent object (table row).
   */
  public PersistentObject newPersistentObject() {
    return new Chm62edtHabitatNavigationPersist();
  }

  /**
   * Implements setup from AbstractDomain.
   */
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_HABITAT_NAVIGATION");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("HABITAT_CATEGORY", "getHabitatCategory", "setHabitatCategory", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ID_QUESTION", "getIdQuestion", "setIdQuestion", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("QUESTION", "getQuestion", "setQuestion", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ANSWER", "getAnswer", "setAnswer", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY)));

    this.addColumnSpec(new StringColumnSpec("ID_QUESTION_PARENT", "getIdQuestionParent", "setIdQuestionParent", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("LEVEL", "getLevel", "setLevel", null));
    this.addColumnSpec(new StringColumnSpec("QUESTION_DESCRIPTION", "getQuestionDescription", "setQuestionDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ID_QUESTION_CHILD", "getIdQuestionChild", "setIdQuestionChild", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NODE", "getNode", "setNode", DEFAULT_TO_NULL));
  }
}