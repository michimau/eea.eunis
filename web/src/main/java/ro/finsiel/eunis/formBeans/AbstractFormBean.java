package ro.finsiel.eunis.formBeans;


import java.util.ArrayList;
import java.util.Vector;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;


/**
 * All Java Beans used in search forms (with <jsp:useBean> should inherit from this abstract class.
 * It implements only the basical requirements, common to all beans:<br />
 * <UL>
 * <LI>- current page - used in virual paginator (aka navigator)
 * <LI>- page size - keep the records displayed per page
 * <LI>- sort criterias - keeps the current sort criterias from request (latter transformed in AbstractSortCriteria)
 * <LI>- sort ascendency - keeps the curent ascendency associated with each sort criteria (used in AbstractSortCriteria)
 * </UL>
 * @author finsiel
 */
public abstract class AbstractFormBean implements java.io.Serializable {

    /**
     * Describes if a column is displayed in results.
     */
    public static final Boolean SHOW = new Boolean(true);

    /**
     * Describes if a column is hidden in results.
     */
    public static final Boolean HIDE = new Boolean(false);

    /**
     * Current page dispayed on the view.
     */
    protected String currentPage = "0";

    /**
     * Is similar name
     */
    protected String newName;

    /**
     * The results displayed per page at once.
     */
    protected String pageSize = "" + AbstractPaginator.DEFAULT_PAGE_SIZE;

    /**
     * Sort criteria.
     */
    protected String sort[] = new String[0];

    /**
     * Ascendency types.
     */
    protected String ascendency[] = new String[0];

    /**
     * Specifies the filter to be deleted when removing a filter from search in results.
     */
    private String removeFilterIndex = null;

    /**
     * This method should be called first in a web page (JSP) in order to fix correctly the filters
     * applied for search in results. If not called the removal of a filter will fail.
     */
    public void prepareFilterCriterias() {
        if (null != getCriteriaSearch()) {
            int removeFilterIndex = Utilities.checkedStringToInt(
                    getRemoveFilterIndex(), -1);

            if (removeFilterIndex - 1 >= 0
                    && removeFilterIndex - 1 < getCriteriaSearch().length) {
                removeCriteriaSearch(removeFilterIndex - 1);
            }
        }
    }

    // Search in results properties. Basically all the searches from EUNIS application have the feature of search in results,
    // so the search in results is declared here, due to duplication of search code in all the beans.
    /**
     * Other search (filters) criterias.
     */
    protected String[] criteriaSearch = null;

    /**
     * Operator IS/CONTAINS/STARTS...
     */
    protected String[] oper = null;

    /**
     * Other types of search.
     */
    protected String[] criteriaType = null;

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

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches...
     * @return  objects which are used for search / filter.
     */
    public abstract AbstractSearchCriteria[] toSearchCriteria();

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting, again...
     * @return objects which are used for sorting.
     */
    public abstract AbstractSortCriteria[] toSortCriteria();

    /**
     * This method will transform the request parameters, back to an URL compatible type of request so that
     * one should not manually write the URL.
     * @param classFields Fields to be included in parameters.
     * @return An URL compatible type of representation(i.e.: >>param1=val1&param2=val2&param3=val3 etc.<<.
     */
    public abstract String toURLParam(Vector classFields);

    /**
     * This method will transform the request parameters into a form compatible hidden input parameters, for example.
     * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
     * @param classFields Fields to be included in parameters.
     * @return An form compatible type of representation of request parameters.
     */
    public abstract String toFORMParam(Vector classFields);

    /**
     * Find a sort criteria and check if was used in previous page. This iterates over all sorts criterias and checks
     * if one was used.
     * @param searchCriteria Criteria searched
     * @return The searched criteria, if found, null otherwise
     */
    public final AbstractSortCriteria lookupSortCriteria(Integer searchCriteria) {
        AbstractSortCriteria[] sortCriteria = toSortCriteria();

        for (int i = 0; i < sortCriteria.length; i++) {
            AbstractSortCriteria criteria = sortCriteria[i];

            if (0 == criteria.getSortCriteria().compareTo(searchCriteria)) {
                return criteria;
            }
        }
        return null;
    }

    /**
     * Method used tho change the ascendency of an object. It uses the following alghoritm: If previous ascendency was
     * set to *none*, is set to *ascending*. If was *ascending* is set to *descending*. If was *descending* is set to \
     * *none*
     * @param criteria  The criteria to be modified
     * @param alter     Set to true if criteria is applied. <br />If alter is false, previous ascendency is returned.
     * No alghoritm is applied.
     * @return The new criteria to be set
     */
    public final Integer changeAscendency(AbstractSortCriteria criteria, boolean alter) {
        if (!alter && null != criteria) {
            if (0
                    == AbstractSortCriteria.ASCENDENCY_ASC.compareTo(
                            criteria.getAscendency())) {
                return AbstractSortCriteria.ASCENDENCY_DESC;
            }
            if (0
                    == AbstractSortCriteria.ASCENDENCY_DESC.compareTo(
                            criteria.getAscendency())) {
                return AbstractSortCriteria.ASCENDENCY_NONE;
            }
            if (0
                    == AbstractSortCriteria.ASCENDENCY_NONE.compareTo(
                            criteria.getAscendency())) {
                return AbstractSortCriteria.ASCENDENCY_ASC;
            }
        }
        if (null == criteria) {
            return AbstractSortCriteria.ASCENDENCY_ASC;
        }
        return criteria.getAscendency();
    }

    /**
     * This method is because I cannot implement here the toURLParam(Vector).The inheriting class would like to override
     * toURLParam() so would never get called. Take the example below, which would not work correcly:<br />
     * <CODE>
     * CountryBean aBean = new CountryBean();// This is an derived object from AbstractFormBean (this)<br />
     * AbstractFormBean anotherBean = (AbstractFormBean)aBean; // Correct due to the inheritance.<br />
     * anotherBean.toURLParam(new Vector());<br />
     * The above line contains the issue. If I implement in AbstractFormBean, the toURLParam(Vector) method, then<br />
     * method toURLParam(Vector) overriden in CountryBean never gets called, so all the effort is useless. So<br />
     * I rather prefer that from the toURLParam(Vector) from CountryBean, you will call the<br />
     * toURLParamSuper(Vector) - this method. If you forget to call, then the params would not be wrote, for this <br />
     * reason you must pay attention when inherit from AbstractFormBean class.<br />
     * </CODE>
     * @param classFields The fields you want returned as HTML FORM fields.
     * @return An representation of this object, as HTML FORM fields.
     */
    protected StringBuffer toURLParamSuper(Vector classFields) {
        StringBuffer url = new StringBuffer();

        if (classFields.contains("currentPage") && null != currentPage) {
            url.append(Utilities.writeURLParameter("currentPage", currentPage));
        }
        if (classFields.contains("pageSize") && null != pageSize) {
            url.append(Utilities.writeURLParameter("pageSize", pageSize));
        }
        if (classFields.contains("sort") && null != sort) {
            url.append(Utilities.writeURLParameter("sort", sort));
        }
        if (classFields.contains("ascendency") && null != ascendency) {
            url.append(Utilities.writeURLParameter("ascendency", ascendency));
        }
        if (classFields.contains("newName") && null != newName) {
            url.append(Utilities.writeURLParameter("newName", "true"));
        }
        // if (null != removeFilterIndex) { url.append(Utilities.writeURLParameter("removeFilterIndex", removeFilterIndex)); }

        return url;
    }

    /**
     * This method is because I cannot implement here the toFORMParam(Vector).The inheriting class would like to override
     * toFORMParam() so would never get called. Take the example below, which would not work correcly:<br />
     * <CODE>
     * CountryBean aBean = new CountryBean();// This is an derived object from AbstractFormBean (this)<br />
     * AbstractFormBean anotherBean = (AbstractFormBean)aBean; // Correct due to the inheritance.<br />
     * anotherBean.toFORMParam(new Vector());<br />
     * The above line contains the issue. If I implement in AbstractFormBean, the toFORMParam(Vector) method, then<br />
     * method toFORMParam(Vector) overriden in CountryBean never gets called, so all the effort is useless. So<br />
     * I rather prefer that from the toFORMParam(Vector) from CountryBean, you will call the<br />
     * toFORMParamSuper(Vector) - this method. If you forget to call, then the params would not be wrote, for this <br />
     * reason you must pay attention when inherit from AbstractFormBean class.<br />
     * </CODE>
     * @param classFields The fields you want returned as HTML FORM fields.
     * @return An representation of this object, as HTML FORM fields.
     */
    protected StringBuffer toFORMParamSuper(Vector classFields) {
        StringBuffer formString = new StringBuffer();

        if (classFields.contains("pageSize") && null != pageSize) {
            formString.append(
                    Utilities.writeFormParameter("pageSize", "" + pageSize));
        }
        if (classFields.contains("currentPage") && null != currentPage) {
            formString.append(
                    Utilities.writeFormParameter("currentPage", "" + currentPage));
        }
        if (classFields.contains("sort") && null != sort) {
            formString.append(Utilities.writeFormParameter("sort", sort));
        }
        if (classFields.contains("ascendency") && null != ascendency) {
            formString.append(
                    Utilities.writeFormParameter("ascendency", ascendency));
        }
        if (classFields.contains("newName") && null != newName) {
            formString.append(Utilities.writeFormParameter("newName", "true"));
        }
        // if (null != removeFilterIndex) { formString.append(Utilities.writeFormParameter("removeFilterIndex", removeFilterIndex)); }
        return formString;
    }

    /**
     * Remove an selected index from the criteriaSearch array.
     * PLEASE NOTE THAT THIS WILL DAMAGE THE CONTENT OF THE BEAN PERMANENTLY. SO BEFORE YOU USED, SAVE TEMPORARILY THE
     * CONTENT OF criteriaSearch, oper & criteriaType THEN RESTORE THEM.
     * @param index Index to be removed. If index out of bounds, nothing removed.
     */
    public void removeCriteriaSearch(int index) {
        if (index >= 0) {
            try {
                ArrayList<String> listCriteriaSearch = new ArrayList<String>();
                ArrayList<String> listOper = new ArrayList<String>();
                ArrayList<String> listCriteriaType = new ArrayList<String>();

                // Initialize the vector: could this be optimized?
                // I use one loop for all three arrays...because always should be either all null/non-null and same size
                if (null != criteriaSearch && null != oper
                        && null != criteriaType) {
                    for (int i = 0; i < criteriaSearch.length; i++) {
                        listCriteriaSearch.add(criteriaSearch[i]);
                        listOper.add(oper[i]);
                        listCriteriaType.add(criteriaType[i]);
                    }
                }
                if (index >= 0 || index < listCriteriaSearch.size()) {
                    listCriteriaSearch.remove(index);
                    listOper.remove(index);
                    listCriteriaType.remove(index);
                }
                // Copy back the values: It seems that if saying oper = (String[])vecOper.toArray(); a ClassCastException occurrs
                criteriaSearch = new String[listCriteriaSearch.size()];
                oper = new String[listOper.size()];
                criteriaType = new String[listCriteriaType.size()];

                for (int i = 0; i < listCriteriaSearch.size(); i++) {
                    criteriaSearch[i] = listCriteriaSearch.get(i);
                    oper[i] = listOper.get(i);
                    criteriaType[i] = listCriteriaType.get(i);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    /**
     * Getter for currentPage property.
     * @return Value of currentPage property.
     */
    public final String getCurrentPage() {
        return currentPage;
    }

    /**
     * Setter for currentPage property.
     * @param currentPage New value for currentPage property.
     */
    public final void setCurrentPage(String currentPage) {
        this.currentPage = currentPage;
    }

    /**
     * Getter for pageSize property.
     * @return Value of pageSize property.
     */
    public final String getPageSize() {
        return pageSize;
    }

    /**
     * Setter for pageSize property.
     * @param pageSize New value for pageSize property.
     */
    public final void setPageSize(String pageSize) {
        this.pageSize = pageSize;
    }

    /**
     * Getter for sort property.
     * @return Value of sort property.
     */
    public final String[] getSort() {
        return sort;
    }

    /**
     * Setter for sort property.
     * @param sort New value for sort property.
     */
    public final void setSort(String[] sort) {
        this.sort = sort;
    }

    /**
     * Getter for ascendency property.
     * @return The value of ascendency property.
     */
    public final String[] getAscendency() {
        return ascendency;
    }

    /**
     * Setter for ascendency property.
     * @param ascendency The new value for ascendency property.
     */
    public final void setAscendency(String[] ascendency) {
        this.ascendency = ascendency;
    }

    /**
     * Getter for criteriaSearch property - Used for search in results.
     * @return value of criteriaSearch.
     */
    public String[] getCriteriaSearch() {
        return criteriaSearch;
    }

    /**
     * Setter for criteriaSearch property - Used for search in results.
     * @param criteriaSearch new value for criteriaSearch.
     */
    public void setCriteriaSearch(String[] criteriaSearch) {
        this.criteriaSearch = (null != criteriaSearch)
                ? Utilities.trimArray(criteriaSearch)
                        : criteriaSearch;
    }

    /**
     * Getter for oper property - Used for search in results, relation betwwn criteriaSearch & criteriaType (is/contains/starts with).
     * @return value of oper.
     */
    public String[] getOper() {
        return oper;
    }

    /**
     * Setter for oper property - Used for search in results, relation betwwn criteriaSearch & criteriaType (is/contains/starts with).
     * @param oper new value for oper.
     */
    public void setOper(String[] oper) {
        this.oper = oper;
    }

    /**
     * Getter for criteriaType property - Used for search in results.
     * @return value of criteriaType.
     */
    public String[] getCriteriaType() {
        return criteriaType;
    }

    /**
     * Setter for criteriaType property - Used for search in results.
     * @param criteriaType new value for criteriaType.
     */
    public void setCriteriaType(String[] criteriaType) {
        this.criteriaType = criteriaType;
    }

    /**
     * Getter for removeFilterIndex property - Used to remove the search in results filters.
     * @return value of removeFilterIndex.
     */
    public String getRemoveFilterIndex() {
        return removeFilterIndex;
    }

    /**
     * Setter for removeFilterIndex property - Used to remove the search in results filters.
     * @param removeFilterIndex new value for removeFilterIndex.
     */
    public void setRemoveFilterIndex(String removeFilterIndex) {
        this.removeFilterIndex = removeFilterIndex;
    }

    public final String getNewName() {
        return newName;
    }

    public final void setNewName(String newName) {
        this.newName = newName;
    }
}
