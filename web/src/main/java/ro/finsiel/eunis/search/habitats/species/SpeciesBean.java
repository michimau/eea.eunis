package ro.finsiel.eunis.search.habitats.species;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.habitats.species.SpeciesSearchCriteria;
import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.species.ScientificNameDomain;

import java.util.Vector;


/**
 * Form bean used for habitats-species search.
 * @author finsiel
 */
public class SpeciesBean extends AbstractFormBean {

    /** Attribute after which the search is done. */
    private String searchAttribute = null;

    /** operator (starts with, is, contains). */
    private String relationOp = null;

    /** Attribute value. */
    private String scientificName = null;

    private Long indice = new Long(-1);

    /** Expand collapse common names. */
    private String expand = null;

    /** Search type: can be 'eunis' or 'annex'. */
    private String database = null;

    /** Display / Hide Level column. */
    private String showLevel = null;

    /** Display / Hide Code column. */
    private String showCode = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Common name column. */
    private String showVernacularName = null;

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        criterias.addElement(getMainSearchCriteria());
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], SpeciesSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new SpeciesSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }

        SpeciesSearchCriteria[] ret = new SpeciesSearchCriteria[criterias.size()];

        for (int i = 0; i < ret.length; i++) {
            ret[i] = (SpeciesSearchCriteria) criterias.get(i);
        }
        return ret;
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
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
        return criterias; // Note the upcast done here.
    }

    /**
     * This method is used to retrieve the basic criteria used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        SpeciesSearchCriteria mainSearchCriteria = null;

        if (null != scientificName && null != relationOp && null != searchAttribute) {
            Integer _searchAttribute = Utilities.checkedStringToInt(searchAttribute, SpeciesSearchCriteria.SEARCH_SCIENTIFIC_NAME);
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);

            mainSearchCriteria = new SpeciesSearchCriteria(_searchAttribute, scientificName, relationOp);
        } else {
            System.out.println(
                    SpeciesBean.class.getName() + "::getMainSearchCriteria() will return null result." + " scientificName="
                    + scientificName + ", relationOp=" + relationOp + ", searchAttribute=" + searchAttribute
                    + ". None of the attributes can't be null.");
            mainSearchCriteria = null;
        }
        return mainSearchCriteria;
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

        if (null != expand) {
            url.append(Utilities.writeURLParameter("expand", expand));
        }
        if (null != showLevel) {
            url.append(Utilities.writeURLParameter("showLevel", showLevel));
        }
        if (null != showCode) {
            url.append(Utilities.writeURLParameter("showCode", showCode));
        }
        if (null != showScientificName) {
            url.append(Utilities.writeURLParameter("showScientificName", showScientificName));
        }
        if (null != showVernacularName) {
            url.append(Utilities.writeURLParameter("showVernacularName", showVernacularName));
        }
        if (null != database) {
            url.append(Utilities.writeURLParameter("database", database));
        }
        if (null != searchAttribute) {
            url.append(Utilities.writeURLParameter("searchAttribute", searchAttribute));
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
        if (null != scientificName) {
            form.append(Utilities.writeFormParameter("scientificName", scientificName));
        }
        if (null != relationOp) {
            form.append(Utilities.writeFormParameter("relationOp", relationOp));
        }
        if (null != expand) {
            form.append(Utilities.writeFormParameter("expand", expand));
        }
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", SpeciesBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", SpeciesBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", SpeciesBean.SHOW.toString()));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularName", SpeciesBean.SHOW.toString()));
        }
        if (null != database) {
            form.append(Utilities.writeFormParameter("database", database.toString()));
        }
        if (null != searchAttribute) {
            form.append(Utilities.writeFormParameter("searchAttribute", searchAttribute));
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
     * Getter for database propety - Database searched (i.e. EUNIS / ANNEX I).
     * @return value of database
     */
    public String getDatabase() {
        return database;
    }

    /**
     * Setter for database property - Database searched (i.e. EUNIS / ANNEX I).
     * @param database new value for database
     */
    public void setDatabase(String database) {
        this.database = database;
    }

    /**
     * Getter for showLevel propety - Show / Hide Level column.
     * @return value of showLevel
     */
    public String getShowLevel() {
        return showLevel;
    }

    /**
     * Setter for showLevel property - Show / Hide Level column.
     * @param showLevel new value for showLevel
     */
    public void setShowLevel(String showLevel) {
        this.showLevel = showLevel;
    }

    /**
     * Getter for showCode property - Show / Hide Code column.
     * @return value of showCode
     */
    public String getShowCode() {
        return showCode;
    }

    /**
     * Setter for showCode property - Show / Hide Code column.
     * @param showCode new value for showCode.
     */
    public void setShowCode(String showCode) {
        this.showCode = showCode;
    }

    /**
     * Getter for showScientificName property - Show / Hide Scientific name column.
     * @return value of showScientificName property
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property - Show / Hide Scientific name column.
     * @param showScientificName new value for showScientificName
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showVernacularName property - Show / Hide Common names column.
     * @return value of showVernacularName
     */
    public String getShowVernacularName() {
        return showVernacularName;
    }

    /**
     * Setter for showVernacularName property - Show / Hide Common names column.
     * @param showVernacularName new value for showVernacularName
     */
    public void setShowVernacularName(String showVernacularName) {
        this.showVernacularName = showVernacularName;
    }

    /**
     * Getter for searchAttribute property.
     * @return Value of searchAttribute
     */
    public String getSearchAttribute() {
        return searchAttribute;
    }

    /**
     * Setter for searchAttribute property.
     * @param searchAttribute new value of searchAttribute
     */
    public void setSearchAttribute(String searchAttribute) {
        this.searchAttribute = searchAttribute;
    }
}

