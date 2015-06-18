package ro.finsiel.eunis.search.sites.species;


import ro.finsiel.eunis.search.SourceDb;
import ro.finsiel.eunis.search.sites.SitesFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Vector;


/**
 * Form bean used for sites->species.
 * @author finsiel
 */
public class SpeciesBean extends SitesFormBean {

    /** Attribute after which the search is done. */
    private String searchAttribute = null;

    /** Attribute value. */
    private String searchString = null;

    /** Relation operator IS/CONTAINS/STARTS etc.*/
    private String relationOp = null;

    /** Displayed columns. */
    private String showSourceDB = null;
    private String showName = null;
    private String showDesignationTypes = null;
    private String showCoordinates = null;
    private String showCoordinateType = null;
    private String showSpecies = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page)
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;

        // Main search criteria
        if (null != searchAttribute && null != searchString) {
            Integer _relationOp = Utilities.checkedStringToInt(relationOp, Utilities.OPERATOR_CONTAINS);
            Integer _searchAttribute = Utilities.checkedStringToInt(searchAttribute, SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);

            criteria = new SpeciesSearchCriteria(_searchAttribute, searchString, _relationOp);
        }
        return criteria;
    }

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches...
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        criterias.addElement(getMainSearchCriteria());
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], SpeciesSearchCriteria.CRITERIA_SOURCE_DB);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new SpeciesSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }
        SpeciesSearchCriteria[] ret = new SpeciesSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (SpeciesSearchCriteria) criterias.get(i);
        }
        return ret; // Note the upcast done here.
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
            SpeciesSortCriteria criteria = new SpeciesSortCriteria(
                    Utilities.checkedStringToInt(sort[i], SpeciesSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], SpeciesSortCriteria.ASCENDENCY_NONE));

            criterias[i] = criteria;
        }
        return criterias;
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
        if (null != showCoordinateType) {
            ret.append(Utilities.writeURLParameter("showCoordinateType", showCoordinateType));
        }
        if (null != showSpecies) {
            ret.append(Utilities.writeURLParameter("showSpecies", showSpecies));
        }
        if (null != searchAttribute) {
            ret.append(Utilities.writeURLParameter("searchAttribute", searchAttribute));
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
        if (null != showCoordinateType) {
            ret.append(Utilities.writeFormParameter("showCoordinateType", showCoordinateType));
        }
        if (null != showSpecies) {
            ret.append(Utilities.writeFormParameter("showSpecies", showSpecies));
        }
        if (null != searchAttribute) {
            ret.append(Utilities.writeFormParameter("searchAttribute", searchAttribute));
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
     * Getter for showSpecies property.
     * @return showSpecies.
     */
    public String getShowSpecies() {
        return showSpecies;
    }

    /**
     * Setter for showSpecies property.
     * @param showSpecies showSpecies.
     */
    public void setShowSpecies(String showSpecies) {
        this.showSpecies = showSpecies;
    }

    /**
     * Getter for showCoordinateType property.
     * @return showCoordinateType.
     */
    public String getShowCoordinateType() {
        return showCoordinateType;
    }

    /**
     * Setter for showCoordinateType property.
     * @param showCoordinateType showCoordinateType.
     */
    public void setShowCoordinateType(String showCoordinateType) {
        this.showCoordinateType = showCoordinateType;
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
