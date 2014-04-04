package ro.finsiel.eunis.search.habitats.code;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain;

import java.util.Vector;


/**
 * Form bean used for habitats->code.
 * @author finsiel
 */
public class CodeBean extends AbstractFormBean {

    /** How searched string is related: OPERATOR_CONTAINS/STARTS/IS. */
    private String relationOp = null;

    /** Searched string. */
    private String searchString = null;

    /** This is the database searched. Can be: CodeDomain.SEARCH<_EUNIS, _ANNEX, _BOTH]> .*/
    private String database = null;

    /** This is the classification where to search. Can be a specified code, or: any. */
    private String classificationCode = null;

    // Columns to be displayed
    /** Display / Hide Level column. */
    private String showLevel = null;

    /** Display / Hide Code column. */
    private String showCode = null;

    /** Display / Hide OTHER Code column. */
    private String showOtherCodes = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Common name column. */
    private String showEnglishName = null;
    private String expanded = null;

    /**
     * This method is used to retrieve the basic criteria used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        if (null != searchString && null != relationOp && null != classificationCode) {
            Integer relOp = Utilities.checkedStringToInt(relationOp, Utilities.OPERATOR_CONTAINS);
            Integer _database = Utilities.checkedStringToInt(database, CodeDomain.SEARCH_EUNIS);

            return new CodeSearchCriteria(classificationCode, relOp, searchString, _database);
        }
        return null;
    }

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return  objects which are used for search / filter
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        if (null == database) {
            database = CodeDomain.SEARCH_BOTH.toString();
        }
        criterias.add(getMainSearchCriteria());
        // Search in results criterias
        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], CodeSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
                Integer _database = Utilities.checkedStringToInt(database, CodeDomain.SEARCH_EUNIS);

                criterias.addElement(new CodeSearchCriteria(_criteriaType, _oper, criteriaSearch[i], classificationCode, _database));
            }
        }
        AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];

        for (int i = 0; i < criterias.size(); i++) {
            absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
        }
        return absCriterias;
    }

    /** This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
     * in order to use them in sorting.
     * @return objects which are used for sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
        Integer database = Utilities.checkedStringToInt(this.database, CodeDomain.SEARCH_EUNIS);

        for (int i = 0; i < sort.length; i++) {
            CodeSortCriteria criteria = new CodeSortCriteria(Utilities.checkedStringToInt(sort[i], CodeSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], CodeSortCriteria.ASCENDENCY_NONE), database);

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

        url.append(toURLParamSuper(classFields));
        if (classFields.contains("criteriaSearch")) {
            AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

            for (int i = 0; i < searchCriterias.length; i++) {
                AbstractSearchCriteria aSearch = searchCriterias[i];

                url.append(aSearch.toURLParam());
            }
            // Add also the extra criterias
            AbstractSearchCriteria[] mainCriterias = getMainSearchCriteriasExtra();

            for (int i = 0; i < mainCriterias.length; i++) {
                AbstractSearchCriteria criteria = mainCriterias[i];

                url.append(criteria.toURLParam());
            }
        }
        // Write columns to be displayed
        if (null != expanded && expanded.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("expanded", CodeBean.SHOW.toString()));
        }
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLevel", CodeBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showCode", CodeBean.SHOW.toString()));
        }
        if (null != showOtherCodes && showOtherCodes.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showOtherCodes", CodeBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", CodeBean.SHOW.toString()));
        }
        if (null != showEnglishName && showEnglishName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showEnglishName", CodeBean.SHOW.toString()));
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
            // Add also the extra criterias
            AbstractSearchCriteria[] mainCriterias = getMainSearchCriteriasExtra();

            for (int i = 0; i < mainCriterias.length; i++) {
                AbstractSearchCriteria criteria = mainCriterias[i];

                form.append(criteria.toFORMParam());
            }
        }
        // Write columns to be displayed
        if (null != expanded && expanded.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("expanded", CodeBean.SHOW.toString()));
        }
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", CodeBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", CodeBean.SHOW.toString()));
        }
        if (null != showOtherCodes && showOtherCodes.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showOtherCodes", CodeBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", CodeBean.SHOW.toString()));
        }
        if (null != showEnglishName && showEnglishName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showEnglishName", CodeBean.SHOW.toString()));
        }
        return form.toString();
    }

    // Getters & Setters
    /**
     * Getter for database property.
     * @return database.
     */
    public String getDatabase() {
        return database;
    }

    /**
     * Setter for database property.
     * @param database database.
     */
    public void setDatabase(String database) {
        this.database = database;
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
        this.searchString = searchString;
    }

    /**
     * Getter for classificationCode property.
     * @return classificationCode.
     */
    public String getClassificationCode() {
        return classificationCode;
    }

    /**
     * Setter for classificationCode property.
     * @param classificationCode classificationCode.
     */
    public void setClassificationCode(String classificationCode) {
        this.classificationCode = classificationCode;
    }

    /**
     * Getter for showLevel property.
     * @return showLevel.
     */
    public String getShowLevel() {
        return showLevel;
    }

    /**
     * Setter for showLevel property.
     * @param showLevel showLevel.
     */
    public void setShowLevel(String showLevel) {
        this.showLevel = showLevel;
    }

    /**
     * Getter for showCode property.
     * @return showCode.
     */
    public String getShowCode() {
        return showCode;
    }

    /**
     * Setter for showCode property.
     * @param showCode showCode.
     */
    public void setShowCode(String showCode) {
        this.showCode = showCode;
    }

    /**
     * Getter for showOtherCodes property.
     * @return showOtherCodes.
     */
    public String getShowOtherCodes() {
        return showOtherCodes;
    }

    /**
     * Setter for showOtherCodes property.
     * @param showOtherCodes showOtherCodes.
     */
    public void setShowOtherCodes(String showOtherCodes) {
        this.showOtherCodes = showOtherCodes;
    }

    /**
     * Getter for showScientificName property.
     * @return showScientificName.
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property.
     * @param showScientificName showScientificName.
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showEnglishName property.
     * @return showEnglishName.
     */
    public String getShowEnglishName() {
        return showEnglishName;
    }

    /**
     * Setter for showEnglishName property.
     * @param showEnglishName showEnglishName.
     */
    public void setShowEnglishName(String showEnglishName) {
        this.showEnglishName = showEnglishName;
    }

    /**
     * Getter for expanded property.
     * @return expanded
     */
    public String getExpanded() {
        return expanded;
    }

    /**
     * Setter for expanded property.
     * @param expanded New value
     */
    public void setExpanded(String expanded) {
        this.expanded = expanded;
    }
}
