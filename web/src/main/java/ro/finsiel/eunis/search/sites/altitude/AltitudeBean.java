package ro.finsiel.eunis.search.sites.altitude;


import ro.finsiel.eunis.search.sites.SitesFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for sites->altitude.
 * @author finsiel
 */
public class AltitudeBean extends SitesFormBean {
    private String altitude1 = null;
    private String altitude2 = null;
    private String altitude21 = null;
    private String altitude22 = null;
    private String altitude31 = null;
    private String altitude32 = null;

    private String relationOp = null;
    private String relationOp2 = null;
    private String relationOp3 = null;

    private String showSourceDB = null;
    private String showName = null;
    private String showCoordinates = null;
    private String showDesignationTypes = null;
    private String showSize = null;
    private String showAltitude = null;
    private String showCountry = null;
    private String showYear = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page)
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;

        // Main search criteria
        if (null != altitude1 || null != altitude21 || null != altitude31) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_IS);
            Integer relationOp2 = Utilities.checkedStringToInt(this.relationOp2, Utilities.OPERATOR_IS);
            Integer relationOp3 = Utilities.checkedStringToInt(this.relationOp3, Utilities.OPERATOR_IS);

            criteria = new AltitudeSearchCriteria(altitude1, altitude2, relationOp, altitude21, altitude22, relationOp2, altitude31,
                    altitude32, relationOp3, country);
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

        if (null != altitude1 || null != altitude21 || null != altitude31) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_IS);
            Integer relationOp2 = Utilities.checkedStringToInt(this.relationOp2, Utilities.OPERATOR_IS);
            Integer relationOp3 = Utilities.checkedStringToInt(this.relationOp3, Utilities.OPERATOR_IS);

            criterias.addElement(
                    new AltitudeSearchCriteria(altitude1, altitude2, relationOp, altitude21, altitude22, relationOp2, altitude31,
                    altitude32, relationOp3, country));
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], AltitudeSearchCriteria.CRITERIA_SOURCE_DB);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new AltitudeSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        AltitudeSearchCriteria[] ret = new AltitudeSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (AltitudeSearchCriteria) criterias.get(i);
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
            AltitudeSortCriteria criteria = new AltitudeSortCriteria(
                    Utilities.checkedStringToInt(sort[i], AltitudeSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], AltitudeSortCriteria.ASCENDENCY_NONE));

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
        if (null != showCountry) {
            ret.append(Utilities.writeURLParameter("showCountry", showCountry));
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
        if (null != showAltitude) {
            ret.append(Utilities.writeURLParameter("showAltitude", showAltitude));
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
        if (null != showCountry) {
            ret.append(Utilities.writeFormParameter("showCountry", showCountry));
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
        if (null != showAltitude) {
            ret.append(Utilities.writeFormParameter("showAltitude", showAltitude));
        }
        return ret.toString();
    }

    /**
     * Getter for altitude1 property (mean min altitude).
     * @return altitude1.
     */
    public String getAltitude1() {
        return altitude1;
    }

    /**
     * Setter for altitude1 property (mean min altitude).
     * @param altitude1 altitude1.
     */
    public void setAltitude1(String altitude1) {
        this.altitude1 = (null != altitude1) ? altitude1.trim() : altitude1;
    }

    /**
     * Getter for altitude2 property (mean max altitude).
     * @return altitude2.
     */
    public String getAltitude2() {
        return altitude2;
    }

    /**
     * Setter for altitude2 property (mean max altitude).
     * @param altitude2 altitude2.
     */
    public void setAltitude2(String altitude2) {
        this.altitude2 = (null != altitude2) ? altitude2.trim() : altitude2;
    }

    /**
     * Getter for relationOp property (between mean altitudes).
     * @return relationOp.
     */
    public String getRelationOp() {
        return relationOp;
    }

    /**
     * Setter for relationOp property (between mean altitudes).
     * @param relationOp relationOp.
     */
    public void setRelationOp(String relationOp) {
        this.relationOp = relationOp;
    }

    /**
     * Getter for altitude21 property (min min altitude).
     * @return altitude21.
     */
    public String getAltitude21() {
        return altitude21;
    }

    /**
     * Setter for altitude21 property (min min altitude).
     * @param altitude21 altitude21.
     */
    public void setAltitude21(String altitude21) {
        this.altitude21 = (null != altitude21) ? altitude21.trim() : altitude21;
    }

    /**
     * Getter for altitude22 property (max min altitude).
     * @return altitude22.
     */
    public String getAltitude22() {
        return altitude22;
    }

    /**
     * Setter for altitude22 property (max min altitude).
     * @param altitude22 altitude22.
     */
    public void setAltitude22(String altitude22) {
        this.altitude22 = (null != altitude22) ? altitude22.trim() : altitude22;
    }

    /**
     * Getter for relationOp2 property (between min altitudes).
     * @return relationOp2.
     */
    public String getRelationOp2() {
        return relationOp2;
    }

    /**
     * Setter for relationOp2 property (between min altitudes).
     * @param relationOp2 relationOp2.
     */
    public void setRelationOp2(String relationOp2) {
        this.relationOp2 = relationOp2;
    }

    /**
     * Getter for altitude31 property (min max altitude).
     * @return altitude31.
     */
    public String getAltitude31() {
        return altitude31;
    }

    /**
     * Setter for altitude31 property (min max altitude).
     * @param altitude31 altitude31.
     */
    public void setAltitude31(String altitude31) {
        this.altitude31 = (null != altitude31) ? altitude31.trim() : altitude31;
    }

    /**
     * Getter for altitude32 property (max max altitude).
     * @return altitude32.
     */
    public String getAltitude32() {
        return altitude32;
    }

    /**
     * Setter for altitude32 property (max max altitude).
     * @param altitude32 altitude32.
     */
    public void setAltitude32(String altitude32) {
        this.altitude32 = (null != altitude32) ? altitude32.trim() : altitude32;
    }

    /**
     * Getter for relationOp3 property (between max altitudes).
     * @return relationOp3.
     */
    public String getRelationOp3() {
        return relationOp3;
    }

    /**
     * Setter for relationOp3 property (between max altitudes).
     * @param relationOp3 relationOp3.
     */
    public void setRelationOp3(String relationOp3) {
        this.relationOp3 = relationOp3;
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
     * Getter for showAltitude property.
     * @return showAltitude.
     */
    public String getShowAltitude() {
        return showAltitude;
    }

    /**
     * Setter for showAltitude property.
     * @param showAltitude showAltitude.
     */
    public void setShowAltitude(String showAltitude) {
        this.showAltitude = showAltitude;
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
}
