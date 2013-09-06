package ro.finsiel.eunis.search.sites.names;

import java.util.Vector;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesFormBean;

/**
 * Form bean used for sites->names.
 * 
 * @author finsiel
 */
public class NameBean extends SitesFormBean {
    private String englishName = null;
    private String relationOp = null;
    private String noSoundex = null;
    private String showSourceDB = null;
    private String showName = null;
    private String showDesignationTypes = null;
    private String showCoordinates = null;
    private String showSize = null;
    private String showDesignationYear = null;
    private String showCountry = null;
    private String showYear = null;
    private String fuzzySearch;

    /** name was choosen from soundex data. */
    private String newName = null;

    /** searched name if name was choosen from soundex data. */
    private String oldName = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * 
     * @return First criterias used for search (when going from query page to result page)
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;

        // Main search criteria
        if (null != englishName && null != relationOp) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);

            criteria = new NameSearchCriteria(englishName, relationOp, country, yearMin, yearMax);
        }
        return criteria;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria). in order
     * to use them in searches...
     * 
     * @return objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        if (null != englishName && null != relationOp) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);

            criterias.addElement(new NameSearchCriteria(englishName, relationOp, country, yearMin, yearMax));
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], NameSearchCriteria.CRITERIA_SOURCE_DB);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new NameSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        NameSearchCriteria[] ret = new NameSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (NameSearchCriteria) criterias.get(i);
        }
        return ret; // Note the upcast done here.
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria) in order to
     * use them in sorting.
     * 
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
        
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }

        for (int i = 0; i < sort.length; i++) {
            NameSortCriteria criteria =
                    new NameSortCriteria(Utilities.checkedStringToInt(sort[i], NameSortCriteria.ASCENDENCY_NONE),
                            Utilities.checkedStringToInt(ascendency[i], NameSortCriteria.ASCENDENCY_NONE));

            criterias[i] = criteria;
        }
        return criterias; // Note the upcast done here.
    }

    /**
     * This method will transform the request parameters, back to an URL compatible type of request so that one should not manually
     * write the URL.
     * 
     * @param classFields
     *            Fields to be included in parameters.
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
        if (null != fuzzySearch && fuzzySearch.equalsIgnoreCase("true")) {
            ret.append(Utilities.writeURLParameter("fuzzySearch", NameBean.SHOW.toString()));
        }

        return ret.toString();
    }

    /**
     * This method will transform the request parameters into a form compatible hidden input parameters, for example. &ltINPUT
     * type="hidden" name="paramName" value="paramValue"&gt.
     * 
     * @param classFields
     *            Fields to be included in parameters.
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
        if (null != fuzzySearch){
            ret.append(Utilities.writeFormParameter("fuzzySearch", fuzzySearch));
        }
        return ret.toString();
    }

    /**
     * Getter for englishName property.
     * 
     * @return englishName.
     */
    public String getEnglishName() {
        return englishName;
    }

    /**
     * Setter for englishName property.
     * 
     * @param englishName
     *            englishName.
     */
    public void setEnglishName(String englishName) {
        this.englishName = (null != englishName) ? englishName.trim() : englishName;
    }

    /**
     * Getter for relationOp property.
     * 
     * @return relationOp.
     */
    public String getRelationOp() {
        return relationOp;
    }

    /**
     * Setter for relationOp property.
     * 
     * @param relationOp
     *            relationOp.
     */
    public void setRelationOp(String relationOp) {
        this.relationOp = relationOp;
    }

    /**
     * Getter for showDesignationTypes property.
     * 
     * @return showDesignationTypes.
     */
    public String getShowDesignationTypes() {
        return showDesignationTypes;
    }

    /**
     * Setter for showDesignationTypes property.
     * 
     * @param showDesignationTypes
     *            showDesignationTypes.
     */
    public void setShowDesignationTypes(String showDesignationTypes) {
        this.showDesignationTypes = showDesignationTypes;
    }

    /**
     * Getter for showDesignationYear property.
     * 
     * @return showDesignationYear.
     */
    public String getShowDesignationYear() {
        return showDesignationYear;
    }

    /**
     * Setter for showDesignationYear property.
     * 
     * @param showDesignationYear
     *            showDesignationYear.
     */
    public void setShowDesignationYear(String showDesignationYear) {
        this.showDesignationYear = showDesignationYear;
    }

    /**
     * Getter for showCoordinates property.
     * 
     * @return showCoordinates.
     */
    public String getShowCoordinates() {
        return showCoordinates;
    }

    /**
     * Setter for showCoordinates property.
     * 
     * @param showCoordinates
     *            showCoordinates.
     */
    public void setShowCoordinates(String showCoordinates) {
        this.showCoordinates = showCoordinates;
    }

    /**
     * Getter for showName property.
     * 
     * @return showName.
     */
    public String getShowName() {
        return showName;
    }

    /**
     * Setter for showName property.
     * 
     * @param showName
     *            showName.
     */
    public void setShowName(String showName) {
        this.showName = showName;
    }

    /**
     * Getter for showSize property.
     * 
     * @return showSize.
     */
    public String getShowSize() {
        return showSize;
    }

    /**
     * Setter for showSize property.
     * 
     * @param showSize
     *            showSize.
     */
    public void setShowSize(String showSize) {
        this.showSize = showSize;
    }

    /**
     * Getter for showSourceDB property.
     * 
     * @return showSourceDB.
     */
    public String getShowSourceDB() {
        return showSourceDB;
    }

    /**
     * Setter for showSourceDB property.
     * 
     * @param showSourceDB
     *            showSourceDB.
     */
    public void setShowSourceDB(String showSourceDB) {
        this.showSourceDB = showSourceDB;
    }

    /**
     * Getter for showCountry property.
     * 
     * @return showCountry.
     */
    public String getShowCountry() {
        return showCountry;
    }

    /**
     * Setter for showCountry property.
     * 
     * @param showCountry
     *            showCountry.
     */
    public void setShowCountry(String showCountry) {
        this.showCountry = showCountry;
    }

    /**
     * Getter for oldName property - Specifies searched name if name was chossen from soundex table.
     * 
     * @return value of oldName property.
     */
    public String getOldName() {
        return oldName;
    }

    /**
     * Setter for oldName property - Specifies searched name if name was chossen from soundex table.
     * 
     * @param oldName
     *            New value
     */
    public void setOldName(String oldName) {
        this.oldName = oldName;
    }

    /**
     * Getter.
     * 
     * @return showYear
     */
    public String getShowYear() {
        return showYear;
    }

    /**
     * Setter.
     * 
     * @param showYear
     *            New value
     */
    public void setShowYear(String showYear) {
        this.showYear = showYear;
    }

    /**
     * Getter.
     * 
     * @return noSoundex
     */
    public String getNoSoundex() {
        return noSoundex;
    }

    /**
     * Setter.
     * 
     * @param noSoundex
     *            New value
     */
    public void setNoSoundex(String noSoundex) {
        this.noSoundex = noSoundex;
    }

    /**
     * Getter.
     * 
     * @return fuzzySearch
     */
    public String getFuzzySearch() {
        return fuzzySearch;
    }

    /**
     * Setter.
     * 
     * @param fuzzySearch
     *            New value
     */
    public void setFuzzySearch(String fuzzySearch) {
        this.fuzzySearch = fuzzySearch;
    }
}
