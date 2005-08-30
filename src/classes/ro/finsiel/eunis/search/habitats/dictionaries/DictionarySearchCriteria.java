/**
 * Date: Apr 7, 2003
 * Time: 2:05:04 PM
 */
package ro.finsiel.eunis.search.habitats.dictionaries;

import ro.finsiel.eunis.search.AbstractSearchCriteria;

public class DictionarySearchCriteria extends AbstractSearchCriteria {
  public static final Integer CRITERIA_CODE = new Integer(0);
  public static final Integer CRITERIA_LEVEL = new Integer(1);
  public static final Integer CRITERIA_NAME = new Integer(2);
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);

  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    return null;
  }

  /** Transform this object into an SQL representation */
  public String toSQL() {
    return null;
  }

  /**
   * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
   * to say is that I can say about an object for example:
   * < INPUT type='hidden" name="searchCriteria" value="natrix">
   * < INPUT type='hidden" name="oper" value="1">
   * < INPUT type='hidden" name="searchType" value="1">
   * @return Web page FORM representation of the object
   */
  public String toFORMParam() {
    return null;
  }

  /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    return null;
  }

}
