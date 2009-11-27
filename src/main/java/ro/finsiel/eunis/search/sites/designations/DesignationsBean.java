package ro.finsiel.eunis.search.sites.designations;

import ro.finsiel.eunis.search.sites.SitesFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;

/**
 * Form bean used for sites->designations.
 * @author finsiel
 */
public class DesignationsBean extends SitesFormBean {
  private String searchString = null;
  private String relationOp = null;
  private String category = null;

  private String showSourceDB = null;
  private String showDesignation = null;
  private String showDesignationEn = null;
  private String showDesignationFr = null;
  private String showAbreviation = null;
  private String showSource = null;
  private String showIso = null;

  /**
   * This method is used to retrieve the basic criterias used to do the first search.
   * @return First criterias used for search (when going from query page to result page)
   */
  public AbstractSearchCriteria getMainSearchCriteria() {
    AbstractSearchCriteria criteria = null;
    // Main search criteria
    if (null != category) {
      Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
      criteria = new DesignationsSearchCriteria(searchString, relationOp, category);
    }
    return criteria;
  }

  /**
   * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches...
   * @return  objects which are used for search / filter
   */
  public AbstractSearchCriteria[] toSearchCriteria() {
    Vector criterias = new Vector();
    if (null != category) {
      Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
      criterias.addElement(new DesignationsSearchCriteria(searchString, relationOp, category));
    }
    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      for (int i = 0; i < criteriaSearch.length; i++) {
        Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], DesignationsSearchCriteria.CRITERIA_SOURCE_DB);
        Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
        criterias.addElement(new DesignationsSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
      }
    }
    DesignationsSearchCriteria[] ret = new DesignationsSearchCriteria[criterias.size()];
    for (int i = 0; i < ret.length; i++) ret[i] = (DesignationsSearchCriteria) criterias.get(i);
    return ret; //Note the upcast done here.
  }

  /**
   * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting.
   * @return A list of AbstractSearchCriteria objects used to do the sorting
   */
  public AbstractSortCriteria[] toSortCriteria() {
    if (null == sort || null == ascendency) return new AbstractSortCriteria[0];
    AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
    for (int i = 0; i < sort.length; i++) {
      DesignationsSortCriteria criteria = new DesignationsSortCriteria(
              Utilities.checkedStringToInt(sort[i], DesignationsSortCriteria.ASCENDENCY_NONE),
              Utilities.checkedStringToInt(ascendency[i], DesignationsSortCriteria.ASCENDENCY_NONE));
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
    StringBuffer ret = new StringBuffer();
    ret.append(toURLParamSuper(classFields));// Add fields of the superclass (DO NOT FORGET!)
    AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
    for (int i = 0; i < searchCriterias.length; i++) {
      AbstractSearchCriteria aSearch = searchCriterias[i];
      ret.append(aSearch.toURLParam());
    }

    if (null != showSourceDB) {
      ret.append(Utilities.writeURLParameter("showSourceDB", showSourceDB));
    }
    if (null != showDesignation) {
      ret.append(Utilities.writeURLParameter("showDesignation", showDesignation));
    }
    if (null != showDesignationEn) {
      ret.append(Utilities.writeURLParameter("showDesignationEn", showDesignationEn));
    }
    if (null != showDesignationFr) {
      ret.append(Utilities.writeURLParameter("showDesignationFr", showDesignationFr));
    }
    if (null != showAbreviation) {
      ret.append(Utilities.writeURLParameter("showAbreviation", showAbreviation));
    }
    if (null != showSource) {
      ret.append(Utilities.writeURLParameter("showSource", showSource));
    }
    if (null != showIso) {
      ret.append(Utilities.writeURLParameter("showIso", showIso));
    }
    return ret.toString();
  }

  /**
   * This method will transform the request parameters into a form compatible hidden input parameters, for example.
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
   * @param classFields Fields to be included in parameters.
   * @return An form compatible type of representation of request parameters.
   */
  public String toFORMParam(Vector classFields) {
    StringBuffer ret = new StringBuffer();
    ret.append(toFORMParamSuper(classFields));
    if (classFields.contains("criteriaSearch")) {
      AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
      for (int i = 0; i < searchCriterias.length; i++) {
        AbstractSearchCriteria aSearch = searchCriterias[i];
        ret.append(aSearch.toFORMParam());
      }
    }

    if (null != showSourceDB) {
      ret.append(Utilities.writeFormParameter("showSourceDB", showSourceDB));
    }
    if (null != showDesignation) {
      ret.append(Utilities.writeFormParameter("showDesignation", showDesignation));
    }
    if (null != showDesignationEn) {
      ret.append(Utilities.writeFormParameter("showDesignationEn", showDesignationEn));
    }
    if (null != showDesignationFr) {
      ret.append(Utilities.writeFormParameter("showDesignationFr", showDesignationFr));
    }
    if (null != showAbreviation) {
      ret.append(Utilities.writeFormParameter("showAbreviation", showAbreviation));
    }
    if (null != showSource) {
      ret.append(Utilities.writeFormParameter("showSource", showSource));
    }
    if (null != showIso) {
      ret.append(Utilities.writeFormParameter("showIso", showIso));
    }
    return ret.toString();
  }

  /**
   * Getter for searchString property.
   * @return searchString.
   */
  public String getSearchString() {
    return searchString;
  }

  /**
   * Setter for searchString property.
   * @param searchString searchString.
   */
  public void setSearchString(String searchString) {
    this.searchString = searchString;
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
   * Getter for category property.
   * @return category.
   */
  public String getCategory() {
    return category;
  }

  /**
   * Setter for category property.
   * @param category category.
   */
  public void setCategory(String category) {
    this.category = category;
  }

  /**
   * Getter for showDesignation property.
   * @return showDesignation.
   */
  public String getShowDesignation() {
    return showDesignation;
  }

  /**
   * Getter for showDesignationEn property.
   * @return showDesignationEn.
   */
  public String getShowDesignationEn() {
    return showDesignationEn;
  }

  /**
   * Getter for showDesignationFr property.
   * @return showDesignationFr.
   */
  public String getShowDesignationFr() {
    return showDesignationFr;
  }

  /**
   * Setter for showDesignation property.
   * @param showDesignation showDesignation.
   */
  public void setShowDesignation(String showDesignation) {
    this.showDesignation = showDesignation;
  }

  /**
   * Setter for showDesignation property.
   * @param showDesignationEn showDesignation.
   */
  public void setShowDesignationEn(String showDesignationEn) {
    this.showDesignationEn = showDesignationEn;
  }

  /**
   * Setter for showDesignationFr property.
   * @param showDesignationFr showDesignationFr.
   */
  public void setShowDesignationFr(String showDesignationFr) {
    this.showDesignationFr = showDesignationFr;
  }

  /**
   * Getter for showAbreviation property.
   * @return showAbreviation.
   */
  public String getShowAbreviation() {
    return showAbreviation;
  }

  /**
   * Setter for showAbreviation property.
   * @param showAbreviation showAbreviation.
   */
  public void setShowAbreviation(String showAbreviation) {
    this.showAbreviation = showAbreviation;
  }

  /**
   * Getter for showIso property.
   * @return showIso.
   */
  public String getShowIso() {
    return showIso;
  }

  /**
   * Setter for showIso property.
   * @param showIso showIso.
   */
  public void setShowIso(String showIso) {
    this.showIso = showIso;
  }

  /**
   * Getter for showSource property.
   * @return showSource.
   */
  public String getShowSource() {
    return showSource;
  }

  /**
   * Setter for showSource property.
   * @param showSource showSource.
   */
  public void setShowSource(String showSource) {
    this.showSource = showSource;
  }

  /**
   * Getter for showSourceDB property.
   * @return showSourceDB.
   */
  public String getShowSourceDB() {
    return showSourceDB;
  }

  /**
   * Setter for showSourceDB property.
   * @param showSourceDB showSourceDB.
   */
  public void setShowSourceDB(String showSourceDB) {
    this.showSourceDB = showSourceDB;
  }
}