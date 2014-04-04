package ro.finsiel.eunis.search.species.sites;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for species->sites.
 * @author finsiel
 */
public class SitesBean extends AbstractFormBean {
    private String searchAttribute = null;

    /** First/Second form operator (starts with, is, contains). */
    private String relationOp = null;

    /** First form - Scientific name. */
    private String scientificName = null;

    private Long indice = new Long(-1);

    /** Expand collapse common names. */
    private String expand = null;

    /** Display / Hide Group column. */
    private String showGroup = null;

    /** Display / Hide Order column. */
    private String showOrder = null;

    /** Display / Hide Family column. */
    private String showFamily = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Common names column. */
    private String showVernacularNames = null;

    /** Display / Hide sites names column. */
    private String showSites = null;

    /**
     * This method is used to retrieve the basic criteria used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
        Integer _searchAttribute = Utilities.checkedStringToInt(searchAttribute, Utilities.OPERATOR_CONTAINS);

        return new SitesSearchCriteria(_searchAttribute, this.scientificName, relationOp);
    }

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches...
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        criterias.addElement(getMainSearchCriteria());
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], SitesSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new SitesSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        SitesSearchCriteria[] ret = new SitesSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (SitesSearchCriteria) criterias.get(i);
        }
        return ret;
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting, again...
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            SitesSortCriteria criteria = new SitesSortCriteria(
                    Utilities.checkedStringToInt(sort[i], SitesSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], SitesSortCriteria.ASCENDENCY_NONE));

            criterias[i] = criteria;
        }
        return criterias; // Note the upcast done here.
    }

    /**
     * This method will transform the request parameters, back to an URL compatible type of request so that
     * one should not manually write the URL.
     * @param classFields Fields to be included in parameters.
     * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
     */
    public String toURLParam(Vector classFields) {
        StringBuffer url = new StringBuffer();

        url.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[i];

            url.append(aSearch.toURLParam());
        }

        if (null != searchAttribute) {
            url.append(Utilities.writeURLParameter("searchAttribute", searchAttribute));
        }
        if (null != scientificName) {
            url.append(Utilities.writeURLParameter("scientificName", scientificName));
        }
        if (null != relationOp) {
            url.append(Utilities.writeURLParameter("relationOp", relationOp));
        }
        if (null != expand) {
            url.append(Utilities.writeURLParameter("expand", expand));
        }
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showGroup", AbstractFormBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showOrder", AbstractFormBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showFamily", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showVernacularNames", AbstractFormBean.SHOW.toString()));
        }
        if (null != showSites && showSites.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showSites", AbstractFormBean.SHOW.toString()));
        }

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

        if (null != searchAttribute) {
            form.append(Utilities.writeFormParameter("searchAttribute", searchAttribute));
        }
        if (null != scientificName) {
            form.append(Utilities.writeFormParameter("scientificName", scientificName));
        }
        if (null != relationOp) {
            form.append(Utilities.writeFormParameter("relationOp", relationOp));
        }
        if (null != expand) {
            form.append(Utilities.writeFormParameter("expand", expand));
        }
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showGroup", AbstractFormBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showOrder", AbstractFormBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showFamily", AbstractFormBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", AbstractFormBean.SHOW.toString()));
        }
        if (null != showVernacularNames && showVernacularNames.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularNames", AbstractFormBean.SHOW.toString()));
        }
        if (null != showSites && showSites.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showSites", AbstractFormBean.SHOW.toString()));
        }

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
     * @return value of showScientificName.
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property - Specifies if Scientific Name column will be displayed in resulted table.
     * @param showScientificName value of showScientificName.
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showVernacularNames property - Specifies if Common Names column will be displayed in resulted table.
     * Note that if this is true, then expand/collapse will be available in page.
     * @return value of showVernacularNames
     */
    public String getShowVernacularNames() {
        return showVernacularNames;
    }

    /**
     * Setter for showVernacularNames property - Specifies if Common Names column will be displayed in resulted table.
     * Note that if this is true, then expand/collapse will be available in page.
     * @param showVernacularNames new value for showVernacularNames
     */
    public void setShowVernacularNames(String showVernacularNames) {
        this.showVernacularNames = showVernacularNames;
    }

    /**
     * Getter for searchAttribute property.
     * @return searchAttribute.
     */
    public String getSearchAttribute() {
        return searchAttribute;
    }

    /**
     * Setter for searchAttribute property.
     * @param searchAttribute searchAttribute.
     */
    public void setSearchAttribute(String searchAttribute) {
        this.searchAttribute = searchAttribute;
    }

    /**
     * Getter for showSites.
     * @return showSites
     */
    public String getShowSites() {
        return showSites;
    }

    /**
     * Setter for showSites.
     * @param showSites New value
     */
    public void setShowSites(String showSites) {
        this.showSites = showSites;
    }
}

