package ro.finsiel.eunis.search.advanced;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

import java.util.Vector;

/**
 * Form bean used for advanced search.
 * @author finsiel.
 */
public class AdvancedSearchBean extends AbstractFormBean {
  // Form fields used for SPECIES FILTERS

  // Form fields used for HABITATS FILTERS

  // Form fields used for MIXED FILTERS


  /**
   * This method is used to retrieve the basic criteria used to do the first search.
   * @return First criterias used for search (when going from query page to result page).
   */
  public AbstractSearchCriteria getMainSearchCriteria() {
    return null;
  }

  /**
   * Retrieve subsequent search criterias used for searching.
   * @return Subsequent search criteria from main page.
   */
  public AbstractSearchCriteria[] getMainSearchCriteriasExtra() {
    return new AbstractSearchCriteria[0];
  }

  /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches...
   * @return  objects which are used for search / filter
   */
  public AbstractSearchCriteria[] toSearchCriteria() {
    return new AbstractSearchCriteria[0];
  }

  /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting, again...
   * @return objects which are used for sorting
   */
  public AbstractSortCriteria[] toSortCriteria() {
    return new AbstractSortCriteria[0];
  }

  /**
   * This method will transform the request parameters, back to an URL compatible type of request so that
   * one should not manually write the URL.
   * @param classFields Fields to be included in parameters.
   * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
   */
  public String toURLParam(Vector classFields) {
    return null;
  }

  /**
   * This method will transform the request parameters into a form compatible hidden input parameters, for example.
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
   * @param classFields Fields to be included in parameters.
   * @return An form compatible type of representation of request parameters.
   */
  public String toFORMParam(Vector classFields) {
    return null;
  }

}
