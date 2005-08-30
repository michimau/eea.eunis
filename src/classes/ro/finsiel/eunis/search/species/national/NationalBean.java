package ro.finsiel.eunis.search.species.national;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.national.NationalSearchCriteria;
import ro.finsiel.eunis.search.species.national.NationalSortCriteria;

import java.util.Vector;

/**
 * Form bean for species->national threat status.
 * @author finsiel
 */
public class NationalBean extends AbstractFormBean {
  /** First/Second form operator (starts with, is, contains). */
  private String idGroup = null;
  /** First form - Scientific name. */
  private String idConservation = null;
  private String idCountry = null;
  private String groupName = null;
  private String countryName = null;
  private String statusName = null;
  private Long indice = new Long(-1);
  /** Expand collapse vernacular names. */
  private String expand = null;

  /** Display / Hide Group column. */
  private String showGroup = null;
  /** Display / Hide Order column. */
  private String showOrder = null;
  /** Display / Hide Family column. */
  private String showFamily = null;
  /** Display / Hide Scientific name column. */
  private String showScientificName = null;
  /** Display / Hide Vernacular names column. */
  private String showVernacularNames = null;
  /** Display / Hide Country column. */
  private String showCountry = null;
  /** Display / Hide Status column. */
  private String showStatus = null;

  /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
   * in order to use them in searches.
   * @return A list of AbstractSearchCriteria objects used to do the search.
   */
  public AbstractSearchCriteria[] toSearchCriteria() {
    Vector criterias = new Vector();
    if (null != groupName && null != statusName && null != countryName) {
      criterias.addElement(new NationalSearchCriteria(groupName, statusName, countryName));
    }
    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      for (int i = 0; i < criteriaSearch.length; i++) {
        Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], NationalSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
        Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
        criterias.addElement(new NationalSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
      }
    }

    NationalSearchCriteria[] ret = new NationalSearchCriteria[criterias.size()];
    for (int i = 0; i < ret.length; i++) ret[i] = (NationalSearchCriteria) criterias.get(i);
    return ret;
  }

  /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting, again.
   * @return A list of AbstractSearchCriteria objects used to do the sorting
   */
  public AbstractSortCriteria[] toSortCriteria() {
    if (null == sort || null == ascendency) return new AbstractSortCriteria[0];
    AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
    for (int i = 0; i < sort.length; i++) {
      NationalSortCriteria criteria = new NationalSortCriteria(
              Utilities.checkedStringToInt(sort[i], NationalSortCriteria.ASCENDENCY_NONE),
              Utilities.checkedStringToInt(ascendency[i], NationalSortCriteria.ASCENDENCY_NONE));
      criterias[i] = criteria;
    }
    return criterias; //Note the upcast done here.
  }


  /**
   * This method is used to retrieve the basic criteria used to do the first search.
   * @return First criterias used for search (when going from query page to result page).
   */
  public AbstractSearchCriteria getMainSearchCriteria() {
    return new NationalSearchCriteria(groupName, statusName, countryName);
  }

  /**
   * Retrieve explanation of main search criteria.
   * @return Human readable string.
   */
  public String getStringMain() {
    String result = "";
    if (null != groupName && null != statusName && null != countryName) {
      if (statusName != null)
        result += " " + statusName;
      else
        result += " any";
      if (countryName != null)
        result += " in " + countryName;
      else
        result += " in any country";
      if (groupName != null)
        result += " and belong to group " + groupName;
      else
        result += " and belong to any group";
    }
    return result;
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

    if (null != groupName) url.append(Utilities.writeURLParameter("groupName", groupName));
    if (null != countryName) url.append(Utilities.writeURLParameter("countryName", countryName));
    if (null != statusName) url.append(Utilities.writeURLParameter("statusName", statusName));
    if (null != expand) url.append(Utilities.writeURLParameter("expand", expand));
    if (null != showGroup && showGroup.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showGroup", AbstractFormBean.SHOW.toString()));
    if (null != showOrder && showOrder.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showOrder", AbstractFormBean.SHOW.toString()));
    if (null != showFamily && showFamily.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showFamily", AbstractFormBean.SHOW.toString()));
    if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showScientificName", AbstractFormBean.SHOW.toString()));
    if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showVernacularNames", AbstractFormBean.SHOW.toString()));

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

    if (null != groupName) form.append(Utilities.writeFormParameter("groupName", groupName));
    if (null != countryName) form.append(Utilities.writeFormParameter("countryName", countryName));
    if (null != statusName) form.append(Utilities.writeFormParameter("statusName", statusName));
    if (null != expand) form.append(Utilities.writeFormParameter("expand", expand));
    if (null != showGroup && showGroup.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showGroup", AbstractFormBean.SHOW.toString()));
    if (null != showCountry && showCountry.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showCountry", AbstractFormBean.SHOW.toString()));
    if (null != showStatus && showStatus.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showStatus", AbstractFormBean.SHOW.toString()));
    if (null != showOrder && showOrder.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showOrder", AbstractFormBean.SHOW.toString()));
    if (null != showFamily && showFamily.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showFamily", AbstractFormBean.SHOW.toString()));
    if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showScientificName", AbstractFormBean.SHOW.toString()));
    if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showVernacularNames", AbstractFormBean.SHOW.toString()));

    return form.toString();
  }

  /**
   * Getter for groupName property.
   * @return groupName.
   */
  public String getGroupName() {
    return groupName;
  }

  /**
   * Setter for groupName property.
   * @param groupName groupName.
   */
  public void setGroupName(String groupName) {
    this.groupName = groupName;
  }

  /**
   * Getter for countryName property.
   * @return countryName.
   */
  public String getCountryName() {
    return countryName;
  }

  /**
   * Setter for countryName property.
   * @param countryName countryName.
   */
  public void setCountryName(String countryName) {
    this.countryName = countryName;
  }

  /**
   * Getter for statusName property.
   * @return statusName.
   */
  public String getStatusName() {
    return statusName;
  }

  /**
   * Setter for statusName property.
   * @param statusName statusName.
   */
  public void setStatusName(String statusName) {
    this.statusName = statusName;
  }

  /**
   * Getter for idGroup property.
   * @return idGroup.
   */
  public String getIdGroup() {
    return idGroup;
  }

  /**
   * Setter for idGroup property.
   * @param idGroup idGroup.
   */
  public void setIdGroup(String idGroup) {
    this.idGroup = idGroup;
  }

  /**
   * Getter for idCountry property.
   * @return idCountry.
   */
  public String getIdCountry() {
    return idCountry;
  }

  /**
   * Setter for idCountry property.
   * @param idCountry idCountry.
   */
  public void setIdCountry(String idCountry) {
    this.idCountry = idCountry;
  }

  /**
   * Getter for idConservation property.
   * @return idConservation.
   */
  public String getIdConservation() {
    return idConservation;
  }

  /**
   * Setter for idConservation property.
   * @param idConservation idConservation.
   */
  public void setIdConservation(String idConservation) {
    this.idConservation = idConservation;
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

  /**
   * Getter for indice property.
   * @return indice.
   */
  public Long getIndice() {
    return indice;
  }

  /**
   * Setter for indice property.
   * @param indice indice.
   */
  public void setIndice(Long indice) {
    this.indice = indice;
  }

  /**
   * Getter for showGroup property - Specifies if Group column will be displayed in resulted table.
   * @return value of showGroup
   */
  public String getShowGroup() {
    return showGroup;
  }

  /**
   * Setter for showGroup property - Specifies if Group column will be displayed in resulted table.
   * @param showGroup new value for showGroup
   */
  public void setShowGroup(String showGroup) {
    this.showGroup = showGroup;
  }

  /**
   * Getter for showOrder property - Specifies if Order column will be displayed in resulted table.
   * @return value of showOrder
   */
  public String getShowOrder() {
    return showOrder;
  }

  /**
   * Setter for showOrder property - Specifies if Order column will be displayed in resulted table.
   * @param showOrder new value for showOrder
   */
  public void setShowOrder(String showOrder) {
    this.showOrder = showOrder;
  }

  /**
   * Getter for showFamily property - Specifies if Family column will be displayed in resulted table.
   * @return value of showFamily
   */
  public String getShowFamily() {
    return showFamily;
  }

  /**
   * Setter for showFamily property - Specifies if Family column will be displayed in resulted table.
   * @param showFamily new value for showFamily
   */
  public void setShowFamily(String showFamily) {
    this.showFamily = showFamily;
  }

  /**
   * Getter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
   * @return value of showScientificName
   */
  public String getShowScientificName() {
    return showScientificName;
  }

  /**
   * Setter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
   * @param showScientificName value of showScientificName
   */
  public void setShowScientificName(String showScientificName) {
    this.showScientificName = showScientificName;
  }

  /**
   * Getter for showVernacularNames property - Specifies if Vernacular Names column will be displayed in resulted table.
   * Note that if this is true, then expand/collapse will be available in page.
   * @return value of showVernacularNames
   */
  public String getShowVernacularNames() {
    return showVernacularNames;
  }

  /**
   * Setter for showVernacularNames property - Specifies if Vernacular Names column will be displayed in resulted table.
   * Note that if this is true, then expand/collapse will be available in page.
   * @param showVernacularNames new value for showVernacularNames
   */
  public void setShowVernacularNames(String showVernacularNames) {
    this.showVernacularNames = showVernacularNames;
  }

    public String getShowCountry() {
        return showCountry;
    }

    public void setShowCountry(String showCountry) {
        this.showCountry = showCountry;
    }

    public String getShowStatus() {
        return showStatus;
    }

    public void setShowStatus(String showStatus) {
        this.showStatus = showStatus;
    }
}