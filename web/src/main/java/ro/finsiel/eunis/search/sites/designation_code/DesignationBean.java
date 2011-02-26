package ro.finsiel.eunis.search.sites.designation_code;


import ro.finsiel.eunis.search.sites.SitesFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for sites->designated codes.
 * @author finsiel
 */
public class DesignationBean extends SitesFormBean {
    private String searchString = null;
    private String relationOp = null;
    private String category = null;

    private String showSourceDB = null;
    private String showName = null;
    private String showDesignationTypes = null;
    private String showCoordinates = null;
    private String showSize = null;
    private String showYear = null;
    private String showCountry = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;

        // Main search criteria
        if (null != searchString && null != relationOp && null != category) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);

            criteria = new DesignationSearchCriteria(searchString, relationOp, category);
        }
        return criteria;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        // System.out.println("---"+searchString+","+relationOp+","+category);
        if (null != searchString && null != relationOp && null != category) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);

            criterias.addElement(new DesignationSearchCriteria(searchString, relationOp, category));
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], DesignationSearchCriteria.CRITERIA_SOURCE_DB);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new DesignationSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        DesignationSearchCriteria[] ret = new DesignationSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (DesignationSearchCriteria) criterias.get(i);
        }
        return ret; // Note the upcast done here.
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

        for (int i = 0; i < sort.length; i++) {
            DesignationSortCriteria criteria = new DesignationSortCriteria(
                    Utilities.checkedStringToInt(sort[i], DesignationSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], DesignationSortCriteria.ASCENDENCY_NONE));

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
        if (null != showDesignationTypes) {
            ret.append(Utilities.writeURLParameter("showDesignationTypes", showDesignationTypes));
        }
        if (null != showCoordinates) {
            ret.append(Utilities.writeURLParameter("showCoordinates", showCoordinates));
        }
        if (null != showSize) {
            ret.append(Utilities.writeURLParameter("showSize", showSize));
        }
        if (null != showYear) {
            ret.append(Utilities.writeURLParameter("showYear", showYear));
        }
        if (null != showCountry) {
            ret.append(Utilities.writeURLParameter("showCountry", showCountry));
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
        if (null != showDesignationTypes) {
            ret.append(Utilities.writeFormParameter("showDesignationTypes", showDesignationTypes));
        }
        if (null != showCoordinates) {
            ret.append(Utilities.writeFormParameter("showCoordinates", showCoordinates));
        }
        if (null != showSize) {
            ret.append(Utilities.writeFormParameter("showSize", showSize));
        }
        if (null != showYear) {
            ret.append(Utilities.writeFormParameter("showYear", showYear));
        }
        if (null != showCountry) {
            ret.append(Utilities.writeFormParameter("showCountry", showCountry));
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
        this.searchString = (null != searchString ? searchString.trim() : searchString);
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
     * Getter for showYear property.
     * @return showYear.
     */
    public String getShowYear() {
        return showYear;
    }

    /**
     * Setter for showYear property.
     * @param showYear showYear.
     */
    public void setShowYear(String showYear) {
        this.showYear = showYear;
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
