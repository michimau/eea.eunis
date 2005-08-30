package ro.finsiel.eunis.formBeans;

/**
 * Form bean used for Habitat Key navigation.
 * @author finsiel
 */
public class HabitatKeyBean {
  String habCode = "";
  String navMode = "";
  String idQuestion = "";

  /**
   * The link must contain the habCode (the EUNIS habitat code) parameter.
   * @return Eunis habitat code.
   */
  public String getHabCode() {
    return habCode;
  }

  /**
   * The link must contain the habCode (the EUNIS habitat code) parameter.
   * @param habCode Eunis habitat code.
   */
  public void setHabCode(String habCode) {
    this.habCode = habCode;
  }

  /**
   * The link must contain the navMode (the mode of browsing the key search feature).
   * @return The mode of navigation.
   */
  public String getNavMode() {
    return navMode;
  }

  /**
   * The link must contain the navMode (the mode of browsing the key search feature.
   * @param navMode Mode of navigation.
   */
  public void setNavMode(String navMode) {
    this.navMode = navMode;
  }

  /**
   * Specifies the ID of the question that will get displayed.
   * @return ID of the question.
   */
  public String getIdQuestion() {
    return idQuestion;
  }

  /**
   * Specifies the ID of the question that will get displayed.
   * @param idQuestion ID of the question.
   */
  public void setIdQuestion(String idQuestion) {
    this.idQuestion = idQuestion;
  }
}