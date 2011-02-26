package ro.finsiel.eunis.search.sites.coordinates;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesFormBean;

import java.util.Vector;


/**
 * Form bean used for sites->coordinates.
 * @author finsiel
 */
public class CoordinatesBean extends SitesFormBean {
    private String longMin = null;
    private String longMax = null;
    private String latMin = null;
    private String latMax = null;

    private String showSourceDB = null;
    private String showName = null;
    private String showDesignationTypes = null;
    private String showDesignationTitle = null;
    private String showCoordinates = null;
    private String showSize = null;
    private String showDesignationYear = null;
    private String showCountry = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page)
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;
        float longMin = Utilities.checkedStringToFloat(this.longMin, 0F);
        float longMax = Utilities.checkedStringToFloat(this.longMax, 0F);
        float latMin = Utilities.checkedStringToFloat(this.latMin, 0F);
        float latMax = Utilities.checkedStringToFloat(this.latMax, 0F);
        Integer yearMin = Utilities.checkedStringToInt(this.yearMin, new Integer(-1));
        Integer yearMax = Utilities.checkedStringToInt(this.yearMax, new Integer(-1));

        criteria = new CoordinatesSearchCriteria(longMin, longMax, latMin, latMax, yearMin, yearMax, country);
        // Main search criteria
        return criteria;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        criterias.addElement(getMainSearchCriteria());
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], CoordinatesSearchCriteria.CRITERIA_SOURCE_DB);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
                CoordinatesSearchCriteria criteria = new CoordinatesSearchCriteria(criteriaSearch[i], _criteriaType, _oper);

                criterias.addElement(criteria);
            }
        }
        CoordinatesSearchCriteria[] ret = new CoordinatesSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (CoordinatesSearchCriteria) criterias.get(i);
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
            CoordinatesSortCriteria criteria = new CoordinatesSortCriteria(
                    Utilities.checkedStringToInt(sort[i], CoordinatesSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], CoordinatesSortCriteria.ASCENDENCY_NONE));

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
        return ret.toString();
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
     * Getter for showDesignationTitle property.
     * @return showDesignationTitle.
     */
    public String getShowDesignationTitle() {
        return showDesignationTitle;
    }

    /**
     * Setter for showDesignationTitle property.
     * @param showDesignationTitle showDesignationTitle.
     */
    public void setShowDesignationTitle(String showDesignationTitle) {
        this.showDesignationTitle = showDesignationTitle;
    }

    /**
     * Getter for longMin property.
     * @return longMin.
     */
    public String getLongMin() {
        return longMin;
    }

    /**
     * Setter for longMin property.
     * @param longMin longMin.
     */
    public void setLongMin(String longMin) {
        this.longMin = longMin;
    }

    /**
     * Getter for longMax property.
     * @return longMax.
     */
    public String getLongMax() {
        return longMax;
    }

    /**
     * Setter for longMax property.
     * @param longMax longMax.
     */
    public void setLongMax(String longMax) {
        this.longMax = longMax;
    }

    /**
     * Getter for latMin property.
     * @return latMin.
     */
    public String getLatMin() {
        return latMin;
    }

    /**
     * Setter for latMin property.
     * @param latMin latMin.
     */
    public void setLatMin(String latMin) {
        this.latMin = latMin;
    }

    /**
     * Getter for latMax property.
     * @return latMax.
     */
    public String getLatMax() {
        return latMax;
    }

    /**
     * Setter for latMax property.
     * @param latMax latMax.
     */
    public void setLatMax(String latMax) {
        this.latMax = latMax;
    }
}
