package ro.finsiel.eunis.search.species.references;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;

/**
 * Form bean used for species->books.
 * @author finsiel
 */
public class ReferencesBean extends AbstractFormBean {
  /** First/Second form operator (starts with, is, contains). */
  private String relationOp = null;
  /** First form - Scientific name. */
  private String scientificName = null;


  /** Expand collapse vernacular names. */
  private String expand = null;

  /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches...
   * @return A list of AbstractSearchCriteria objects used to do the search.
   */
  public AbstractSearchCriteria[] toSearchCriteria() {
    Vector criterias = new Vector();
    // Main criteria
    if (null != scientificName && null != relationOp) {
      Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
      criterias.addElement(new ReferencesSearchCriteria(scientificName, relationOp));
    }

    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      for (int i = 0; i < criteriaSearch.length; i++) {
        Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], ReferencesSearchCriteria.CRITERIA_TITLE);
        Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
        criterias.addElement(new ReferencesSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
      }
    }

    ReferencesSearchCriteria[] ret = new ReferencesSearchCriteria[criterias.size()];
    for (int i = 0; i < ret.length; i++) ret[i] = (ReferencesSearchCriteria) criterias.get(i);
    return ret;
  }

  /**
   * This method is used to retrieve the basic criteria used to do the first search.
   * @return First criterias used for search (when going from query page to result page).
   */
  public AbstractSearchCriteria getMainSearchCriteria() {
    Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
    return new ReferencesSearchCriteria(this.scientificName, relationOp);
  }

  /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting, again...
   * @return A list of AbstractSearchCriteria objects used to do the sorting
   */
  public AbstractSortCriteria[] toSortCriteria() {
    if (null == sort || null == ascendency) return new AbstractSortCriteria[0];
    AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
    for (int i = 0; i < sort.length; i++) {
      ReferencesSortCriteria criteria = new ReferencesSortCriteria(
              Utilities.checkedStringToInt(sort[i], ReferencesSortCriteria.ASCENDENCY_NONE),
              Utilities.checkedStringToInt(ascendency[i], ReferencesSortCriteria.ASCENDENCY_NONE));
      criterias[i] = criteria;
    }
    return criterias; //Note the upcast done here.
  }

  /**
   * This method will transform the request parameters, back to an URL compatible type of request so that
   * one should not manually write the URL.
   * @param classFields Fields to be included in parameters.
   * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
   */
  public String toURLParam(Vector classFields) {
    StringBuffer url = new StringBuffer();
    url.append(toURLParamSuper(classFields));// Add fields of the superclass (DO NOT FORGET!)
    AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
    for (int i = 0; i < searchCriterias.length; i++) {
      AbstractSearchCriteria aSearch = searchCriterias[i];
      url.append(aSearch.toURLParam());
    }
    if (null != expand) url.append(Utilities.writeURLParameter("expand", expand));
    return url.toString();
  }

  /**
   * This method will transform the request parameters into a form compatible hidden input parameters, for example.
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
   * @param classFields Fields to be included in parameters.
   * @return An form compatible type of representation of request parameters.
   */
  public String toFORMParam(Vector classFields) {
    StringBuffer form = new StringBuffer();
    form.append(toFORMParamSuper(classFields));
    if (classFields.contains("criteriaSearch")) {
      AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
      for (int i = 0; i < searchCriterias.length; i++) {
        AbstractSearchCriteria aSearch = searchCriterias[i];
        form.append(aSearch.toFORMParam());
      }
    }
    if (null != scientificName) form.append(Utilities.writeFormParameter("scientificName", scientificName));
    if (null != relationOp) form.append(Utilities.writeFormParameter("relationOp", relationOp));
    if (null != expand) form.append(Utilities.writeFormParameter("expand", expand));
    return form.toString();
  }

  /**
   * Getter for relationOp property.
   * @return relationOp.
   */
  public String getRelationOp() {
    return relationOp;
  }

  /**
   * Setter for relationOp property.
   * @param relationOp relationOp.
   */
  public void setRelationOp(String relationOp) {
    this.relationOp = relationOp;
  }

  /**
   * Getter for scientificName property.
   * @return scientificName.
   */
  public String getScientificName() {
    return scientificName;
  }

  /**
   * Setter for scientificName property.
   * @param scientificName scientificName.
   */
  public void setScientificName(String scientificName) {
    this.scientificName = scientificName;
  }

  /**
   * Getter for expand property.
   * @return expand.
   */
  public String getExpand() {
    return expand;
  }

  /**
   * Setter for expand property.
   * @param expand expand.
   */
  public void setExpand(String expand) {
    this.expand = expand;
  }
}