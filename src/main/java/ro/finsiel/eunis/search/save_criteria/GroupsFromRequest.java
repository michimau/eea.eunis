package ro.finsiel.eunis.search.save_criteria;

/**
 * Date: Sep 19, 2003
 * Time: 2:22:40 PM
 */

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/** This class extracts from the HTTP request the groups of attributesNames, formFieldAttributes,
 * formFieldOperators, booleans, operators, firstValues, lastValues.
 * @author finsiel
 */
public class GroupsFromRequest {

  private Vector attributesNames = new Vector();
  private Vector formFieldAttributes = new Vector();
  private Vector formFieldOperators = new Vector();
  private Vector booleans = new Vector();
  private Vector operators = new Vector();
  private Vector firstValues = new Vector();
  private Vector lastValues = new Vector();

  private HttpServletRequest _request = null;


  /** Constructor which takes the HTTP request and generates the groups of attributesNames, formFieldAttributes,
   * formFieldOperators, booleans, operators, firstValues, lastValues.
   * @param request HTTP request
   */
  public GroupsFromRequest(HttpServletRequest request) {
    _request = request;
    Vector attributes = extractAttributesParams(_request);
    setValuesGroups(_request, attributes);
  }


  /** Vector with request parameters names witch contain 'attributesNames' string.
   * @param request HTTP request
   * @return Vector with request parameters names witch contain 'attributesNames' string.
   */
  private Vector extractAttributesParams(HttpServletRequest request) {
    Vector ret = new Vector();
    if (null == request) return ret;
    Enumeration en = request.getParameterNames();
    while (en.hasMoreElements()) {
      String paramName = (String) en.nextElement();
      if (-1 != paramName.lastIndexOf("attributesNames")) {
        ret.addElement(paramName);
      }
    }
    SortVector sorter = new SortVector();
    sorter.sort(ret, SortVector.SORT_DESCENDING);
    return ret;
  }


  /**
   * Get values for all paramters request.
   * @param request HTTP request
   * @param attributes Vector with request parameters names witch contain 'attributesNames' string
   */
  private void setValuesGroups(HttpServletRequest request, Vector attributes) {
    for (int i = 0; i < attributes.size(); i++) {
      String attribute = (String) attributes.get(i);
      String prefix = attribute.substring(1, 2);

      attributesNames.addElement(request.getParameter("_" + prefix + "attributesNames"));
      formFieldAttributes.addElement(request.getParameter("_" + prefix + "formFieldAttributes"));
      formFieldOperators.addElement(request.getParameter("_" + prefix + "formFieldOperators"));
      operators.addElement(request.getParameter("_" + prefix + "operators"));
      booleans.addElement(request.getParameter("_" + prefix + "booleans"));
      firstValues.addElement(request.getParameter("_" + prefix + "firstValues"));
      lastValues.addElement(request.getParameter("_" + prefix + "lastValues"));
    }
  }

  /** Number of groups stored.
   * @return Groups stored
   */
  public int countItems() {
    return attributesNames.size();
  }

  /**
   * Get attributesNames vector.
   * @return attributesNames vector
   */
  public Vector getAttributes() {
    return attributesNames;
  }

  /**
   * Get formFieldAttributes vector.
   * @return formFieldAttributes vector
   */
  public Vector getFormFieldAttributes() {
    return formFieldAttributes;
  }

  /**
   * Get formFieldOperators vector.
   * @return formFieldOperators vector
   */
  public Vector getFormFieldOperators() {
    return formFieldOperators;
  }

  /**
   * Get booleans vector.
   * @return booleans vector
   */
  public Vector getBooleans() {
    return booleans;
  }

  /**
   * Get operators vector.
   * @return operators vector
   */
  public Vector getOperators() {
    return operators;
  }

  /**
   * Get firstValues vector.
   * @return firstValues vector
   */
  public Vector getFirstValues() {
    return firstValues;
  }

  /**
   * Get lastValues vector.
   * @return lastValues vector
   */
  public Vector getLastValues() {
    return lastValues;
  }

  /** Class to support the sorting of an given array of Objects<br />
   * In order to do a sorting, you class will  provide a valid
   * <code>toString()</code>
   * method in order to extract the criteria after which sorting is done.
   */
  public static class SortVector {
    /** Elements in the list are sorted in <i>reverse natural sorting order</i>. */
    public static final boolean SORT_ASCENDING = false;
    /** Elements in the list that are sorted in <i>natural sorting order</i>.*/
    public static final boolean SORT_DESCENDING = true;

    /** Creates a new instance of Compare. */
    public SortVector() {
    }

    /** Method used to sort a given Vector.
     * @param data Vector of objects to be sorted. Remember that
     * their toString method must return a valid comparison
     * @param order Must be either <code>SortList.SORT_ASCENDIG</code>
     * or <code>SortList.SORT_DESCENDING</code>If other specified,
     * no sorting is done
     * @return The sorted Vector. Warning, this functions alters the
     * content of the input <code>data</code> parameter, so if you
     * want to preserve the original order, then do a copy before calling
     * this method.
     * @throws java.lang.ClassCastException - if the list contains elements that are not
     * mutually comparable (i.e. compare a String with an Int)
     * @throws java.lang.UnsupportedOperationException - if the specified list's list-iterator
     * does not support the set operation.
     */
    public Vector sort(Vector data, boolean order) throws ClassCastException, UnsupportedOperationException {
      StringComparator comp = new StringComparator();
      if (SORT_DESCENDING == order) comp.reverseOrder();
      Collections.sort(data, comp);
      return data;
    }

    /**
     * String comparator class.
     */
    public static class StringComparator implements Comparator {
      boolean ascending = true;

      /**
       * Reverse order for sorting operation.
       */
      public void reverseOrder() {
        ascending = false;
      }

      /**
       * Compare two string elements.
       * @param element1 first element
       * @param element2 second element
       * @return the value <code>0</code> if the argument string is equal to
       *          this string; a value less than <code>0</code> if this string
       *          is lexicographically less than the string argument; and a
       *          value greater than <code>0</code> if this string is
       *          lexicographically greater than the string argument.
       */
      public int compare(Object element1, Object element2) {
        try {
          String lower1 = ((String) element1).toLowerCase();
          String lower2 = ((String) element2).toLowerCase();
          int res = lower1.compareTo(lower2);
          res = (!ascending) ? res : (-1) * res;
          return res;
        } catch (ClassCastException ex) {
          ex.printStackTrace();
          return 0;
        }
      }
    }
  }


}
