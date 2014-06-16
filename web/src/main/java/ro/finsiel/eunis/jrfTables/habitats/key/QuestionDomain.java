/**
 * Date: Apr 18, 2003
 * Time: 3:13:09 PM
 */
package ro.finsiel.eunis.jrfTables.habitats.key;

import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;

import java.util.List;

/**
 * SELECT DISTINCT ID_QUESTION, QUESTION_LABEL, ID_PAGE FROM chm62edt_habitat_key_navigation WHERE PAGE_LEVEL=1
 */
public class QuestionDomain extends AbstractDomain {
  /****/
  public PersistentObject newPersistentObject() {
    return new QuestionPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("chm62edt_habitat_key_navigation");
    this.setReadOnly(true);
    this.addColumnSpec(new IntegerColumnSpec("ID_PAGE", "getIDPage", "setIDPage", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("ID_QUESTION", "getIDQuestion", "setIDQuestion", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("QUESTION_LABEL", "getQuestionLabel", "setQuestionLabel", DEFAULT_TO_EMPTY_STRING));
    this.addColumnSpec(new StringColumnSpec("QUESTION_EXPLANATION", "getQuestionExplanation", "setQuestionExplanation", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("PAGE_NAME", "getPageName", "setPageName", DEFAULT_TO_EMPTY_STRING));
  }

  /**
   * Find all the questions for a specified level.
   * @param level Question level
   * @param pageCode Code of the answers to be retrieved (Each set of questions belong to a specified code)
   * @return A list of objects representing the questions (QuestionPersist objects)
   * @throws Exception If a database exeception occurs.
   */
  public List findLevelQuestions(int level, String pageCode) throws Exception {
    if (null == pageCode) {
      return findCustom("SELECT DISTINCT ID_PAGE, ID_QUESTION, QUESTION_LABEL, QUESTION_EXPLANATION, PAGE_NAME FROM chm62edt_habitat_key_navigation WHERE PAGE_LEVEL=" + level + " ORDER BY QUESTION_CODE");
    } else {
      return findCustom("SELECT DISTINCT ID_PAGE, ID_QUESTION, QUESTION_LABEL, QUESTION_EXPLANATION, PAGE_NAME FROM chm62edt_habitat_key_navigation WHERE PAGE_LEVEL=" + level + " AND PAGE_CODE='" + pageCode + "' ORDER BY QUESTION_CODE");
    }
  }
}
