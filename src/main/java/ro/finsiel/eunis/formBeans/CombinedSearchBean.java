package ro.finsiel.eunis.formBeans;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.advanced.AdvancedSortCriteria;

import java.util.Vector;
import java.util.StringTokenizer;

/**
 * Form bean used for Combined search function.
 * @author  finsiel
 */
public class CombinedSearchBean extends AbstractFormBean {
  private String searchedNatureObject;
  private String origin;
  private String criteria = null;
  private String showColumns;

  /**
   * Creates an new CombinedSearchBean object.
   */
  public CombinedSearchBean() {
  }

  /**
   * Columns to be displayed within results.
   * @return Vector of String objects.
   */
  public Vector parseShowColumns() {
    Vector columns = new Vector();
    StringTokenizer tok = new StringTokenizer(showColumns, ",");
    while (tok.hasMoreElements()) {
      String element = (String) tok.nextElement();
      columns.addElement(element);
    }
    return columns;
  }

  /**
   * Columns come here separated by commas, for example: "showGroup,showName,showFamily".
   * @return Displayed columns.
   */
  public String getShowColumns() {
    return showColumns;
  }

  /**
   * Setter for showColumns property.
   * @param showColumns Displayed columns.
   */
  public void setShowColumns(String showColumns) {
    this.showColumns = showColumns;
  }

  /**
   * Used in select-columns.jsp to detect where we came from ("Advanced" or "Origin").
   * @return "Advanced" or "Origin"
   */
  public String getOrigin() {
    return origin;
  }

  /**
   * Setter for origin property.
   * @param origin Origin.
   */
  public void setOrigin(String origin) {
    this.origin = origin;
  }

  /**
   * Getter for searchedNatureObject property.
   * @return Searched nature object.
   */
  public String getSearchedNatureObject() {
    return searchedNatureObject;
  }

  /**
   * Setter for searchedNatureObject property.
   * @param searchedNatureObject Searched nature object.
   */
  public void setSearchedNatureObject(String searchedNatureObject) {
    this.searchedNatureObject = searchedNatureObject;
  }

  /**
   * Getter for criteria property.
   * @return Criteria.
   */
  public String getCriteria() {
    return criteria;
  }

  /**
   * Setter for criteria property.
   * @param criteria Criteria.
   */
  public void setCriteria(String criteria) {
    this.criteria = criteria;
  }

  /**
   * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches...
   * @return  objects which are used for search / filter
   */
  public AbstractSearchCriteria[] toSearchCriteria() {
    return new AbstractSearchCriteria[0];
  }

  /**
   * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting, again...
   * @return objects which are used for sorting.
   */
  public AbstractSortCriteria[] toSortCriteria() {
    if (null == sort || null == ascendency) return new AbstractSortCriteria[0];
    AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
    for (int i = 0; i < sort.length; i++) {
      AdvancedSortCriteria criteria = new AdvancedSortCriteria(
              Utilities.checkedStringToInt(sort[i], AdvancedSortCriteria.ASCENDENCY_NONE),
              Utilities.checkedStringToInt(ascendency[i], AdvancedSortCriteria.ASCENDENCY_NONE));
      criterias[i] = criteria;
    }
    return criterias;
  }

  /**
   * This method will transform the request parameters, back to an URL compatible type of request so that
   * one should not manually write the URL.
   * @param classFields Parameters included in result.
   * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<
   */
  public String toURLParam(Vector classFields) {
    StringBuffer url = new StringBuffer();
    url.append(toURLParamSuper(classFields));// Add fields of the superclass (DO NOT FORGET!)
    AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
    for (int i = 0; i < searchCriterias.length; i++) {
      AbstractSearchCriteria aSearch = searchCriterias[i];
      url.append(aSearch.toURLParam());
    }
    if (classFields.contains("criteriaSearch")) {
      url.append(Utilities.writeURLParameter("criteria", criteria));
    }
    url.append(Utilities.writeURLParameter("showColumns", showColumns));
    return url.toString();
  }

  /**
   * This method will transform the request parameters into a form compatible hidden input parameters, for example:
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
   * @param classFields Parameters included in result.
   * @return An form compatible type of representation of request parameters.
   */
  public String toFORMParam(Vector classFields) {
    StringBuffer form = new StringBuffer();
    form.append(toFORMParamSuper(classFields));
    if (classFields.contains("criteriaSearch")) {
      form.append(Utilities.writeFormParameter("criteria", criteria));
    }
    form.append(Utilities.writeFormParameter("showColumns", showColumns));
    return form.toString();
  }
}