package ro.finsiel.eunis.jrfTables.habitats.key;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;

import java.util.List;

public class Chm62edtHabitatKeyNavigationDomain extends AbstractDomain {

  /****/
  public PersistentObject newPersistentObject() {
    return new Chm62edtHabitatKeyNavigationPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("chm62edt_habitat_key_navigation");
    this.setReadOnly(true);
    this.addColumnSpec(new CompoundPrimaryKeyColumnSpec(
            new IntegerColumnSpec("ID_PAGE", "getIdPage", "setIdPage", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY),
            new IntegerColumnSpec("PAGE_LEVEL", "getPageLevel", "setPageLevel", DEFAULT_TO_ZERO),
            new StringColumnSpec("PAGE_NAME", "getPageName", "setPageName", DEFAULT_TO_NULL),
            new StringColumnSpec("ID_QUESTION", "getIDQuestion", "setIDQuestion", DEFAULT_TO_EMPTY_STRING),
            new StringColumnSpec("QUESTION_CODE", "getQuestionCode", "setQuestionCode", DEFAULT_TO_NULL),
            new IntegerColumnSpec("ID_ANSWER", "getIDAnswer", "setIDAnswer", DEFAULT_TO_NULL)
    )
    );

    this.addColumnSpec(new StringColumnSpec("PAGE_NOTES", "getPageNotes", "setPageNotes", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("PAGE_CODE", "getPageCode", "setPageCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("QUESTION_LABEL", "getQuestionLabel", "setQuestionLabel", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("QUESTION_EXPLANATION", "getQuestionExplanation", "setQuestionExplanation", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("POSSIBLE_ANSWERS", "getPossibleAnswers", "setPossibleAnswers", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ANSWER_LABEL", "getAnswerLabel", "setAnswerLabel", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ID_QUESTION_LINK", "getIDQuestionLink", "setIDQuestionLink", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_HABITAT_LINK", "getIDHabitatLink", "setIDHabitatLink", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ADDITIONAL_INFO", "getAdditionalInfo", "setAdditionalInfo", DEFAULT_TO_NULL));
  }
}
