package ro.finsiel.eunis.search.sites.size;


import ro.finsiel.eunis.search.sites.SitesFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean for sites->size.
 * @author finsiel
 */
public class SizeBean extends SitesFormBean {
    private String searchType = null;
    private String searchString = null;
    private String searchStringMin = null;
    private String searchStringMax = null;

    private String relationOp = null;

    private String showSourceDB = null;
    private String showName = null;
    private String showDesignationTypes = null;
    private String showCoordinates = null;
    private String showSize = null;
    private String showDesignationYear = null;
    private String showCountry = null;
    private String showLength = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;

        // Main search criteria
        if (null != searchString || (null != searchStringMin && null != searchStringMax)) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
            Integer _searchType = Utilities.checkedStringToInt(this.searchType, SizeSearchCriteria.SEARCH_AREA);

            criteria = new SizeSearchCriteria(_searchType, relationOp, searchString, searchStringMin, searchStringMax, country,
                    yearMin, yearMax);
        }
        return criteria;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        if (null != searchString || (null != searchStringMin && null != searchStringMax)) {
            if (null != relationOp && relationOp.length() > 0) {
                relationOp = relationOp.substring(relationOp.length() - 1);
            } else {
                relationOp = SizeSearchCriteria.SEARCH_AREA.toString();
            }
            ;
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);
            Integer _searchType = Utilities.checkedStringToInt(searchType, SizeSearchCriteria.SEARCH_AREA);
            SizeSearchCriteria _criteria = new SizeSearchCriteria(_searchType, relationOp, searchString, searchStringMin,
                    searchStringMax, country, yearMin, yearMax);

            criterias.addElement(_criteria);
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], new Integer(0));
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new SizeSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        SizeSearchCriteria[] ret = new SizeSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (SizeSearchCriteria) criterias.get(i);
        }
        return ret; // Note the upcast done here.
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
     * @return A list of AbstractSearchCriteria objects used to do the sorting.
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            SizeSortCriteria criteria = new SizeSortCriteria(Utilities.checkedStringToInt(sort[i], SizeSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], SizeSortCriteria.ASCENDENCY_NONE));

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
        StringBuffer ret = new StringBuffer();

        ret.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

        for (int i = 0; i < searchCriterias.length; i++) {
            AbstractSearchCriteria aSearch = searchCriterias[i];

            ret.append(aSearch.toURLParam());
        }
        if (null != showSourceDB) {
            ret.append(Utilities.writeURLParameter("showSourceDB", showSourceDB));
        }
        if (null != showName) {
            ret.append(Utilities.writeURLParameter("showName", showName));
        }
        if (null != showCountry) {
            ret.append(Utilities.writeURLParameter("showCountry", showCountry));
        }
        if (null != showDesignationTypes) {
            ret.append(Utilities.writeURLParameter("showDesignationTypes", showDesignationTypes));
        }
        if (null != showCoordinates) {
            ret.append(Utilities.writeURLParameter("showCoordinates", showCoordinates));
        }
        if (null != showSize) {
            ret.append(Utilities.writeURLParameter("showSize", showSize));
        }
        if (null != showDesignationYear) {
            ret.append(Utilities.writeURLParameter("showDesignationYear", showDesignationYear));
        }
        if (null != showLength) {
            ret.append(Utilities.writeURLParameter("showLength", showLength));
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
        if (null != showName) {
            ret.append(Utilities.writeFormParameter("showName", showName));
        }
        if (null != showCountry) {
            ret.append(Utilities.writeFormParameter("showCountry", showCountry));
        }
        if (null != showDesignationTypes) {
            ret.append(Utilities.writeFormParameter("showDesignationTypes", showDesignationTypes));
        }
        if (null != showCoordinates) {
            ret.append(Utilities.writeFormParameter("showCoordinates", showCoordinates));
        }
        if (null != showSize) {
            ret.append(Utilities.writeFormParameter("showSize", showSize));
        }
        if (null != showDesignationYear) {
            ret.append(Utilities.writeFormParameter("showDesignationYear", showDesignationYear));
        }
        if (null != showLength) {
            ret.append(Utilities.writeFormParameter("showLength", showLength));
        }
        return ret.toString();
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
        this.searchString = (null != searchString) ? searchString.trim() : searchString;
    }

    /**
     * Getter for searchStringMax property.
     * @return searchStringMax.
     */
    public String getSearchStringMax() {
        return searchStringMax;
    }

    /**
     * Setter for searchStringMax property.
     * @param searchStringMax searchStringMax.
     */
    public void setSearchStringMax(String searchStringMax) {
        this.searchStringMax = (null != searchStringMax) ? searchStringMax.trim() : searchStringMax;
    }

    /**
     * Getter for searchStringMin property.
     * @return searchStringMin.
     */
    public String getSearchStringMin() {
        return searchStringMin;
    }

    /**
     * Setter for searchStringMin property.
     * @param searchStringMin searchStringMin.
     */
    public void setSearchStringMin(String searchStringMin) {
        this.searchStringMin = (null != searchStringMin) ? searchStringMin.trim() : searchStringMin;
    }

    /**
     * Getter for searchType property.
     * @return searchType.
     */
    public String getSearchType() {
        return searchType;
    }

    /**
     * Setter for searchType property.
     * @param searchType searchType.
     */
    public void setSearchType(String searchType) {
        this.searchType = searchType;
    }

    /**
     * Getter for showCoordinates property.
     * @return showCoordinates.
     */
    public String getShowCoordinates() {
        return showCoordinates;
    }

    /**
     * Setter for showCoordinates property.
     * @param showCoordinates showCoordinates.
     */
    public void setShowCoordinates(String showCoordinates) {
        this.showCoordinates = showCoordinates;
    }

    /**
     * Getter for showDesignationTypes property.
     * @return showDesignationTypes.
     */
    public String getShowDesignationTypes() {
        return showDesignationTypes;
    }

    /**
     * Setter for showDesignationTypes property.
     * @param showDesignationTypes showDesignationTypes.
     */
    public void setShowDesignationTypes(String showDesignationTypes) {
        this.showDesignationTypes = showDesignationTypes;
    }

    /**
     * Getter for showDesignationYear property.
     * @return showDesignationYear.
     */
    public String getShowDesignationYear() {
        return showDesignationYear;
    }

    /**
     * Setter for showDesignationYear property.
     * @param showDesignationYear showDesignationYear.
     */
    public void setShowDesignationYear(String showDesignationYear) {
        this.showDesignationYear = showDesignationYear;
    }

    /**
     * Getter for showName property.
     * @return showName.
     */
    public String getShowName() {
        return showName;
    }

    /**
     * Setter for showName property.
     * @param showName showName.
     */
    public void setShowName(String showName) {
        this.showName = showName;
    }

    /**
     * Getter for showSize property.
     * @return showSize.
     */
    public String getShowSize() {
        return showSize;
    }

    /**
     * Setter for showSize property.
     * @param showSize showSize.
     */
    public void setShowSize(String showSize) {
        this.showSize = showSize;
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

    /**
     * Getter for showCountry property.
     * @return showCountry.
     */
    public String getShowCountry() {
        return showCountry;
    }

    /**
     * Setter for showCountry property.
     * @param showCountry showCountry.
     */
    public void setShowCountry(String showCountry) {
        this.showCountry = showCountry;
    }

    /**
     * Getter for showLength property.
     * @return showLength.
     */
    public String getShowLength() {
        return showLength;
    }

    /**
     * Setter for showLength property.
     * @param showLength showLength.
     */
    public void setShowLength(String showLength) {
        this.showLength = showLength;
    }
}
