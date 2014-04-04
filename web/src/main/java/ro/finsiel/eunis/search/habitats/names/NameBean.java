package ro.finsiel.eunis.search.habitats.names;

import java.util.Vector;

import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;

/**
 * Form bean used for habitats->names.
 * 
 * @author finsiel
 */
public class NameBean extends AbstractFormBean {
    // These are the main search criterias.
    /**
     * How searched string is related: OPERATOR_CONTAINS/STARTS/IS.
     */
    private String relationOp = null;

    /**
     * Searched string.
     */
    private String searchString = null;

    // These fields below are used when the user adds multiple search filters from the search page.
    /**
     * Additional main relation ops.
     */
    private String[] relationOpExtra = null;

    /**
     * Additional main searched strings.
     */
    private String[] searchStringExtra = null;

    // These are additional fields from first form, which are only one instance (not arrays)
    /**
     * Search type: can be 'eunis' or 'annex'.
     */
    private String database = null;

    /**
     * If non-null search in Scientific names.
     */
    private String useScientific = null;

    /**
     * If non-null search in Names (Common names).
     */
    private String useVernacular = null;

    /**
     * If non-null search in Descriptions.
     */
    private String useDescription = null;

    // These are the show columns fields...Determines which columns are displayed or hidden in the result page
    /**
     * Display / Hide Level column.
     */
    private String showLevel = null;

    /**
     * Display / Hide Code column.
     */
    private String showCode = null;

    /**
     * Display / Hide Scientific name column.
     */
    private String showScientificName = null;

    /**
     * Display / Hide Common name column.
     */
    private String showVernacularName = null;

    /**
     * name was choosen from soundex data.
     */
    private String newName = null;

    /**
     * searched name if name was choosen from soundex data.
     */
    private String oldName = null;

    // First search page.
    /**
     * This is the action done by user in first search page. Possible actions implemented: add, search, delete.
     */
    private String action = null;

    /**
     * Index removed from first page, when user presses the "Delete" button.
     */
    private String deleteIndex = null;

    /**
     * no use soundex at refine search.
     */
    private String noSoundex = null;

    /**
     * Use fuzzy search
     */
    private String fuzzySearch;

    /**
     * Remove an criteria from the extra search criterias (ie when users deletes an search criteria from main search form.
     * 
     * @param index
     *            index to be removed, must be pozitive and &lt getMainSearchCriteriasExtra().length..
     */
    public void removeCriteriaExtra(int index) {
        if (index < 0 && index >= relationOpExtra.length) {
            return;
        }
        String[] relationOpExtra = new String[this.relationOpExtra.length - 1];
        String[] searchStringExtra = new String[this.searchStringExtra.length - 1];

        for (int i = 0; i < relationOpExtra.length; i++) {
            if (i != index) {
                relationOpExtra[i] = this.relationOpExtra[i];
                searchStringExtra[i] = this.searchStringExtra[i];
            }
        }
        this.relationOpExtra = relationOpExtra;
        this.searchStringExtra = searchStringExtra;
    }

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * 
     * @return First criterias used for search (when going from query page to result page)
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;
        Integer database = Utilities.checkedStringToInt(this.database, NamesDomain.SEARCH_EUNIS);
        boolean useScientific = Utilities.checkedStringToBoolean(this.useScientific, false);
        boolean useVernacular = Utilities.checkedStringToBoolean(this.useVernacular, false);
        boolean useDescription = Utilities.checkedStringToBoolean(this.useDescription, false);

        // Main search criteria
        if (null != searchString && null != database && null != relationOp) {
            Integer relationOp = Utilities.checkedStringToInt(this.relationOp, Utilities.OPERATOR_CONTAINS);

            criteria =
                    new NameSearchCriteria(searchString, relationOp, database, useDescription, useScientific, useVernacular, false);
        }
        return criteria;
    }

    /**
     * Retrieve subsequent search criterias used for searching.
     * 
     * @return Subsequent search criteria from main page.
     */
    public AbstractSearchCriteria[] getMainSearchCriteriasExtra() {
        Vector criterias = new Vector();
        Integer database = Utilities.checkedStringToInt(this.database, NamesDomain.SEARCH_EUNIS);
        boolean useScientific = Utilities.checkedStringToBoolean(this.useScientific, true);
        boolean useVernacular = Utilities.checkedStringToBoolean(this.useVernacular, true);
        boolean useDescription = Utilities.checkedStringToBoolean(this.useDescription, true);

        // Extra main search criteria
        if (null != searchStringExtra && null != relationOpExtra) {
            for (int i = 0; i < searchStringExtra.length; i++) {
                Integer _relationOp = Utilities.checkedStringToInt(relationOpExtra[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new NameSearchCriteria(searchStringExtra[i], _relationOp, database, useDescription,
                        useScientific, useVernacular, true));
            }
        }
        AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];

        for (int i = 0; i < criterias.size(); i++) {
            absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
        }
        return absCriterias;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria) in order to
     * use them in searches...
     * 
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        criterias.addElement(getMainSearchCriteria());
        // Search in results criterias
        Integer database = Utilities.checkedStringToInt(this.database, NamesDomain.SEARCH_EUNIS);

        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], NameSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new NameSearchCriteria(criteriaSearch[i], _criteriaType, _oper, database, false));
            }
        }
        AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];

        for (int i = 0; i < criterias.size(); i++) {
            absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
        }
        return absCriterias;
    }

    /**
     * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria) in order to
     * use them in sorting, again...
     * 
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
        Integer database = Utilities.checkedStringToInt(this.database, NamesDomain.SEARCH_EUNIS);

        for (int i = 0; i < sort.length; i++) {
            NameSortCriteria criteria =
                    new NameSortCriteria(Utilities.checkedStringToInt(sort[i], NameSortCriteria.ASCENDENCY_NONE),
                            Utilities.checkedStringToInt(ascendency[i], NameSortCriteria.ASCENDENCY_NONE), database);

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
        StringBuffer url = new StringBuffer();

        url.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
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
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLevel", NameBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showCode", NameBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", NameBean.SHOW.toString()));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showVernacularName", NameBean.SHOW.toString()));
        }
        if (null != fuzzySearch && fuzzySearch.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("fuzzySearch", NameBean.SHOW.toString()));
        }
        return url.toString();
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
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", NameBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", NameBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", NameBean.SHOW.toString()));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularName", NameBean.SHOW.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for relationOp property - Operator for search (Is / Contains / Starts with).
     * 
     * @return value of relationOp
     */
    public String getRelationOp() {
        return relationOp;
    }

    /**
     * Setter for relationOp property - Operator for search (Is / Contains / Starts with).
     * 
     * @param relationOp
     *            new value for relationOp
     */
    public void setRelationOp(String relationOp) {
        this.relationOp = relationOp;
    }

    /**
     * Getter for searchString property - Searched string.
     * 
     * @return value of searchString
     */
    public String getSearchString() {
        return searchString;
    }

    /**
     * Setter for searchString property - Searched string.
     * 
     * @param searchString
     *            new value for searchString
     */
    public void setSearchString(String searchString) {
        if (null != searchString) {
            this.searchString = searchString.trim();
        } else {
            this.searchString = searchString;
        }
    }

    /**
     * Getter for database propety - Database searched (i.e. EUNIS / ANNEX I).
     * 
     * @return value of database
     */
    public String getDatabase() {
        return database;
    }

    /**
     * Setter for database property - Database searched (i.e. EUNIS / ANNEX I).
     * 
     * @param database
     *            new value for database
     */
    public void setDatabase(String database) {
        this.database = database;
    }

    /**
     * Getter for useScientific property - Do the search in scientific names.
     * 
     * @return value of useScientific
     */
    public String getUseScientific() {
        return useScientific;
    }

    /**
     * Setter for useScientific property - Do the search in scientific names.
     * 
     * @param useScientific
     *            new value for useScientific
     */
    public void setUseScientific(String useScientific) {
        this.useScientific = useScientific;
    }

    /**
     * Getter for useVernacular property - Do the search in common names.
     * 
     * @return value of useVernacular
     */
    public String getUseVernacular() {
        return useVernacular;
    }

    /**
     * Setter for useVernacular property - Do the search in common names.
     * 
     * @param useVernacular
     *            new value for useVernacular
     */
    public void setUseVernacular(String useVernacular) {
        this.useVernacular = useVernacular;
    }

    /**
     * Getter for useDescription property - Do the search in descriptions.
     * 
     * @return value of useDescription
     */
    public String getUseDescription() {
        return useDescription;
    }

    /**
     * Setter for useDescription property - Do the search in descriptions.
     * 
     * @param useDescription
     *            new value for useDescription
     */
    public void setUseDescription(String useDescription) {
        this.useDescription = useDescription;
    }

    /**
     * Getter for showLevel propety - Show / Hide Level column.
     * 
     * @return value of showLevel
     */
    public String getShowLevel() {
        return showLevel;
    }

    /**
     * Setter for showLevel property - Show / Hide Level column.
     * 
     * @param showLevel
     *            new value for showLevel
     */
    public void setShowLevel(String showLevel) {
        this.showLevel = showLevel;
    }

    /**
     * Getter for showCode property - Show / Hide Code column.
     * 
     * @return value of showCode
     */
    public String getShowCode() {
        return showCode;
    }

    /**
     * Setter for showCode property - Show / Hide Code column.
     * 
     * @param showCode
     *            new value for showCode
     */
    public void setShowCode(String showCode) {
        this.showCode = showCode;
    }

    /**
     * Getter for showScientificName property - Show / Hide Scientific name column.
     * 
     * @return value of showScientificName property
     */
    public String getShowScientificName() {
        return showScientificName;
    }

    /**
     * Setter for showScientificName property - Show / Hide Scientific name column.
     * 
     * @param showScientificName
     *            new value for showScientificName
     */
    public void setShowScientificName(String showScientificName) {
        this.showScientificName = showScientificName;
    }

    /**
     * Getter for showVernacularName property - Show / Hide Common names column.
     * 
     * @return value of showVernacularName
     */
    public String getShowVernacularName() {
        return showVernacularName;
    }

    /**
     * Setter for showVernacularName property - Show / Hide Common names column.
     * 
     * @param showVernacularName
     *            new value for showVernacularName
     */
    public void setShowVernacularName(String showVernacularName) {
        this.showVernacularName = showVernacularName;
    }

    /**
     * Getter for relationOpExtra property. Not currently used.
     * 
     * @return relationOpExtra.
     */
    public String[] getRelationOpExtra() {
        return relationOpExtra;
    }

    /**
     * Setter for relationOpExtra property. Not currently used.
     * 
     * @param relationOpExtra
     *            relationOpExtra.
     */
    public void setRelationOpExtra(String[] relationOpExtra) {
        this.relationOpExtra = relationOpExtra;
    }

    /**
     * Getter for searchStringExtra property. Not currently used.
     * 
     * @return searchStringExtra.
     */
    public String[] getSearchStringExtra() {
        return searchStringExtra;
    }

    /**
     * Setter for searchStringExtra property. Not currently used.
     * 
     * @param searchStringExtra
     *            searchStringExtra.
     */
    public void setSearchStringExtra(String[] searchStringExtra) {
        this.searchStringExtra = searchStringExtra;
    }

    /**
     * Getter for action property.
     * 
     * @return action.
     */
    public String getAction() {
        return action;
    }

    /**
     * Setter for action property.
     * 
     * @param action
     *            action.
     */
    public void setAction(String action) {
        this.action = action;
    }

    /**
     * Getter for deleteIndex property.
     * 
     * @return deleteIndex.
     */
    public String getDeleteIndex() {
        return deleteIndex;
    }

    /**
     * Setter for deleteIndex property.
     * 
     * @param deleteIndex
     *            deleteIndex.
     */
    public void setDeleteIndex(String deleteIndex) {
        this.deleteIndex = deleteIndex;
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
     * Test method.
     * 
     * @param args
     *            Command line arguments.
     */
    public static void main(String[] args) {
        String[] criteriaSearch = {"first string", "second string", "third string"};
        String[] oper = {"0", "1", "2"};
        String[] criteriaType = {"0", "1", "2"};
        // Initializations
        NameBean bean = new NameBean();

        bean.setCriteriaSearch(criteriaSearch);
        bean.setOper(oper);
        bean.setCriteriaType(criteriaType);
        // Test toSearchCriteria
        AbstractSearchCriteria[] criteria = bean.toSearchCriteria();

        for (int i = 0; i < criteria.length; i++) {
            AbstractSearchCriteria aCrit = criteria[i];
            // System.out.println("Criteria " + i + " : " + aCrit.toHumanString());
        }
        bean.removeCriteriaSearch(1);
        criteria = bean.toSearchCriteria();
        // System.out.println("=======================");
        for (int i = 0; i < criteria.length; i++) {
            AbstractSearchCriteria aCrit = criteria[i];
            // System.out.println("Criteria " + i + " : " + aCrit.toHumanString());
        }
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
     * Getter for fuzzySearch.
     * 
     * @return searchVernacular
     */
    public String getFuzzySearch() {
        return fuzzySearch;
    }

    /**
     * Setter for fuzzySearch.
     * 
     * @param fuzzySearch
     *            fuzzySearch
     */
    public void setFuzzySearch(String fuzzySearch) {
        this.fuzzySearch = fuzzySearch;
    }
}
