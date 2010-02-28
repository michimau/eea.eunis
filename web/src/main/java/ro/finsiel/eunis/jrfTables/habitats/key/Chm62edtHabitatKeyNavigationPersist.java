package ro.finsiel.eunis.jrfTables.habitats.key;

import net.sf.jrf.domain.PersistentObject;

public class Chm62edtHabitatKeyNavigationPersist extends PersistentObject {
  private Integer idPage = null;
  private Integer pageLevel = null;
  private String pageName = null;
  private String pageNotes = null;
  private String IDQuestion = null;
  private String questionCode = null;
  private String questionLabel = null;
  private String questionExplanation = null;
  private Integer possibleAnswers = null;
  private Integer IDAnswer = null;
  private String answerLabel = null;
  private String IDQuestionLink = null;
  private Integer IDHabitatLink = null;
  private String additionalInfo = null;
  private String pageCode = null;

  public Chm62edtHabitatKeyNavigationPersist() {
    super();
  }


  public Integer getIdPage() {
    return idPage;
  }

  public void setIdPage(Integer idPage) {
    this.idPage = idPage;
  }

  public Integer getPageLevel() {
    return pageLevel;
  }

  public void setPageLevel(Integer pageLevel) {
    this.pageLevel = pageLevel;
  }

  public String getPageName() {
    return pageName;
  }

  public void setPageName(String pageName) {
    this.pageName = pageName;
  }

  public String getPageNotes() {
    return pageNotes;
  }

  public void setPageNotes(String pageNotes) {
    this.pageNotes = pageNotes;
  }

  public String getIDQuestion() {
    return IDQuestion;
  }

  public void setIDQuestion(String IDQuestion) {
    this.IDQuestion = IDQuestion;
  }

  public String getQuestionCode() {
    return questionCode;
  }

  public void setQuestionCode(String questionCode) {
    this.questionCode = questionCode;
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

  public Integer getPossibleAnswers() {
    return possibleAnswers;
  }

  public void setPossibleAnswers(Integer possibleAnswers) {
    this.possibleAnswers = possibleAnswers;
  }

  public Integer getIDAnswer() {
    return IDAnswer;
  }

  public void setIDAnswer(Integer IDAnswer) {
    this.IDAnswer = IDAnswer;
  }

  public String getAnswerLabel() {
    return answerLabel;
  }

  public void setAnswerLabel(String answerLabel) {
    this.answerLabel = answerLabel;
  }

  public String getIDQuestionLink() {
    return IDQuestionLink;
  }

  public void setIDQuestionLink(String IDQuestionLink) {
    this.IDQuestionLink = IDQuestionLink;
  }

  public Integer getIDHabitatLink() {
    return IDHabitatLink;
  }

  public void setIDHabitatLink(Integer IDHabitatLink) {
    this.IDHabitatLink = IDHabitatLink;
  }

  public String getAdditionalInfo() {
    return additionalInfo;
  }

  public void setAdditionalInfo(String additionalInfo) {
    this.additionalInfo = additionalInfo;
  }

  public String getPageCode() {
    return pageCode;
  }

  public void setPageCode(String pageCode) {
    this.pageCode = pageCode;
  }
}
