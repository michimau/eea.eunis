package ro.finsiel.eunis.search.habitats.key;

import ro.finsiel.eunis.jrfTables.habitats.key.Chm62edtHabitatKeyNavigationDomain;
import ro.finsiel.eunis.jrfTables.habitats.key.QuestionDomain;
import ro.finsiel.eunis.jrfTables.habitats.key.Chm62edtHabitatKeyNavigationPersist;
import ro.finsiel.eunis.search.Utilities;

import java.util.List;
import java.util.Vector;

/**
 * Class used in habitats->key navigation.
 *
 * Questions for LEVEL X.
 * SELECT DISTINCT ID_QUESTION, QUESTION_LABEL, ID_PAGE
 * FROM CHM62EDT_HABITAT_KEY_NAVIGATION
 * WHERE CHM62EDT_HABITAT_KEY_NAVIGATION.PAGE_LEVEL=1
 *
 * Answers for each question from level X
 * SELECT CHM62EDT_HABITAT_KEY_NAVIGATION.ID_ANSWER, CHM62EDT_HABITAT_KEY_NAVIGATION.ANSWER_LABEL,
 * CHM62EDT_HABITAT_KEY_NAVIGATION.ID_QUESTION_LINK, CHM62EDT_HABITAT_KEY_NAVIGATION.ID_HABITAT_LINK, PAGE_LEVEL
 * FROM CHM62EDT_HABITAT_KEY_NAVIGATION
 * WHERE CHM62EDT_HABITAT_KEY_NAVIGATION.PAGE_LEVEL=1
 * AND CHM62EDT_HABITAT_KEY_NAVIGATION.ID_QUESTION='- 006'
 * AND CHM62EDT_HABITAT_KEY_NAVIGATION.ID_PAGE=1.
 * @author finsiel
 */
public class KeyNavigation {

  /**
   * Creates new KeyNavigation object.
   */
  public KeyNavigation() {
  }

  /**
   * Find all the questions for a specified level.
   * @param level Question level
   * @param pageCode Code of the answers to be retrieved (Each set of questions belong to a specified code)
   * @return A list of objects representing the questions (QuestionPersist objects)
   */
  public List findLevelQuestions(int level, String pageCode) {
    List result = new Vector();
    try {
      result = new QuestionDomain().findLevelQuestions(level, pageCode);
    } catch (Exception _ex) {
      _ex.printStackTrace(System.err);
      result = new Vector();
    }
    if (null == result) result = new Vector();
    return result;
  }

  /**
   * Find the possible answers available for a question.
   * @param level Question level
   * @param idQuestion Question ID
   * @param idPage ID of the page for that question
   * @return An non-null list with Chm62edtHabitatKeyNavigationPersist objects, one for each answer
   */
  public List findQuestionAnswers(int level, String idQuestion, Integer idPage) {
    List result = new Vector();
    try {
      result = new Chm62edtHabitatKeyNavigationDomain().findWhere("PAGE_LEVEL=" + level + " AND ID_QUESTION='" + idQuestion + "' AND ID_PAGE=" + idPage);
    } catch (Exception _ex) {
      _ex.printStackTrace(System.err);
    } finally {
      if (null == result) result = new Vector();
      return result;
    }
  }

  /**
   * Checks if the given answer points to another question (true) or to a habitat (false).
   * @param answer Answer to check
   * @return true if is question, false if answer is a habitat.
   */
  public boolean pointsToQuestion(Chm62edtHabitatKeyNavigationPersist answer) {
    boolean ret = false;
    if (null != answer.getIDQuestionLink() && answer.getIDQuestionLink().equalsIgnoreCase("-->")) {
      ret = true;
    }
    return ret;
  }

  /**
   * This method removes anything is found after the first occurence of " " (space) character.
   * @param additionalInfo String to be processed
   * @return If errors found the original string is returned.
   */
  public String fixAdditionalInfo(String additionalInfo) {
    String res = additionalInfo;
    if (null != additionalInfo && additionalInfo.length() >= 0 && -1 < additionalInfo.lastIndexOf(" ")) {
      res = additionalInfo.substring(0, additionalInfo.indexOf(" "));
    }
    return res;
  }

  /**
   * This method extracts integer number from the ID of the question by removing the code part.
   * See the definition of CHM62EDT_KEY_NAVIGATION for the reference of the column definition.
   * @param questionID ID of the question.
   * @return Numeric ID of the question.
   */
  public String fixQuestionID(String questionID) {
    String ret = questionID;
    if (null != questionID) {
      if (-1 != questionID.lastIndexOf(" ")) {
        ret = questionID.substring(questionID.lastIndexOf(" ") + 1, questionID.length());// Remove code part
      } else {
        ret = questionID.substring(2);
      }
    }
    return ret;
  }

  /**
   * Test method.
   * @param args Command line arguments.
   */
  public static void main(String[] args) {
//    System.out.println(new KeyNavigation().fixAdditionalInfo("A (part)"));
  }
}