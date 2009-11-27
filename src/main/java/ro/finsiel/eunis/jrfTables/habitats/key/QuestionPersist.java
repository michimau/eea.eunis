/**
 * Date: Apr 18, 2003
 * Time: 3:13:19 PM
 */
package ro.finsiel.eunis.jrfTables.habitats.key;

import net.sf.jrf.domain.PersistentObject;

public class QuestionPersist extends PersistentObject {
  private Integer IDPage = null;
  private String IDQuestion = null;
  private String questionLabel = null;
  private String questionExplanation = null;
  private String pageName = null;

  public QuestionPersist() {
    super();
  }

  public Integer getIDPage() {
    return IDPage;
  }

  public void setIDPage(Integer IDPage) {
    this.IDPage = IDPage;
  }

  public String getIDQuestion() {
    return IDQuestion;
  }

  public void setIDQuestion(String IDQuestion) {
    this.IDQuestion = IDQuestion;
  }

  public String getQuestionLabel() {
    return questionLabel;
  }

  public void setQuestionLabel(String questionLabel) {
    this.questionLabel = questionLabel;
  }

  public String getQuestionExplanation() {
    return questionExplanation;
  }

  public void setQuestionExplanation(String questionExplanation) {
    this.questionExplanation = questionExplanation;
  }

  public String getPageName() {
    return pageName;
  }

  public void setPageName(String pageName) {
    this.pageName = pageName;
  }
}

