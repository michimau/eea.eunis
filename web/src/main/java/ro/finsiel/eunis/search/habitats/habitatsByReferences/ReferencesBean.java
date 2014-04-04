package ro.finsiel.eunis.search.habitats.habitatsByReferences;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefDomain;

import java.util.Vector;


/**
 * Form bean used for habitats->references.
 * @author finsiel
 */
public class ReferencesBean extends AbstractFormBean {
    // These are the main search criterias
    /** How searched string is related: OPERATOR_CONTAINS/STARTS/IS. */
    private String relationOpAuthor = null;
    private String author = null;
    private String relationOpDate = null;
    private String date = null;
    private String date1 = null;
    private String relationOpEditor = null;
    private String editor = null;
    private String relationOpTitle = null;
    private String title = null;
    private String relationOpPublisher = null;
    private String publisher = null;

    // These are additional fields from first form, which are only one instance (not arrays).
    /** Search type: can be 'eunis' or 'annex'. */
    private String database = null;

    /** Source type: can be 'source' or 'other information'. */
    private String source = null;

    // These are the show columns fields...Determines which columns are displayed or hidden in the result page.
    /** Display / Hide Level column. */
    private String showLevel = null;

    /** Display / Hide Code column. */
    private String showCode = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Common name column. */
    private String showVernacularName = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page)
     */
    public AbstractSearchCriteria getMainSearchCriteria() {
        AbstractSearchCriteria criteria = null;

        // Main search criteria

        Integer relationOpAuthor;
        Integer relationOpDate;
        Integer relationOpEditor;
        Integer relationOpTitle;
        Integer relationOpPublisher;

        relationOpAuthor = Utilities.checkedStringToInt(this.relationOpAuthor, Utilities.OPERATOR_CONTAINS);
        relationOpDate = Utilities.checkedStringToInt(this.relationOpDate, Utilities.OPERATOR_IS);
        relationOpTitle = Utilities.checkedStringToInt(this.relationOpTitle, Utilities.OPERATOR_CONTAINS);
        relationOpEditor = Utilities.checkedStringToInt(this.relationOpEditor, Utilities.OPERATOR_CONTAINS);
        relationOpPublisher = Utilities.checkedStringToInt(this.relationOpPublisher, Utilities.OPERATOR_CONTAINS);

        criteria = new ReferencesSearchCriteria(author, relationOpAuthor, date, date1, relationOpDate, title, relationOpTitle,
                publisher, relationOpPublisher, editor, relationOpEditor,
                Utilities.checkedStringToInt(this.database, Utilities.EUNIS_HABITAT),
                Utilities.checkedStringToInt(this.source, RefDomain.SOURCE));
        return criteria;
    }

    /** This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches.
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        // Main Search
        Integer database = Utilities.checkedStringToInt(this.database, RefDomain.SEARCH_EUNIS);
        Integer source = Utilities.checkedStringToInt(this.source, RefDomain.SOURCE);

        Integer relationOpAuthor = Utilities.checkedStringToInt(this.relationOpAuthor, Utilities.OPERATOR_CONTAINS);
        Integer relationOpDate = Utilities.checkedStringToInt(this.relationOpDate, Utilities.OPERATOR_IS);
        Integer relationOpTitle = Utilities.checkedStringToInt(this.relationOpTitle, Utilities.OPERATOR_CONTAINS);
        Integer relationOpEditor = Utilities.checkedStringToInt(this.relationOpEditor, Utilities.OPERATOR_CONTAINS);
        Integer relationOpPublisher = Utilities.checkedStringToInt(this.relationOpPublisher, Utilities.OPERATOR_CONTAINS);

        criterias.addElement(
                new ReferencesSearchCriteria(author, relationOpAuthor, date, date1, relationOpDate, title, relationOpTitle,
                publisher, relationOpPublisher, editor, relationOpEditor, database, source));
        // Search in results criterias

        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i],
                        ReferencesSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new ReferencesSearchCriteria(criteriaSearch[i], _criteriaType, _oper, database, source));
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
     * @return A list of AbstractSearchCriteria objects used to do the sorting
     */
    public AbstractSortCriteria[] toSortCriteria() {
        if (null == sort || null == ascendency) {
            return new AbstractSortCriteria[0];
        }
        AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];
        Integer database = Utilities.checkedStringToInt(this.database, RefDomain.SEARCH_EUNIS);

        for (int i = 0; i < sort.length; i++) {
            ReferencesSortCriteria criteria = new ReferencesSortCriteria(
                    Utilities.checkedStringToInt(sort[i], ReferencesSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], ReferencesSortCriteria.ASCENDENCY_NONE));

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

        url.append(toURLParamSuper(classFields)); // Add fields of the superclass (DO NOT FORGET!)
        if (classFields.contains("criteriaSearch")) {
            AbstractSearchCriteria[] searchCriterias = toSearchCriteria();

            for (int i = 0; i < searchCriterias.length; i++) {
                AbstractSearchCriteria aSearch = searchCriterias[i];

                url.append(aSearch.toURLParam());
            }
        }
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showLevel", ReferencesBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showCode", ReferencesBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", ReferencesBean.SHOW.toString()));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showVernacularName", ReferencesBean.SHOW.toString()));
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
        // Write columns to be displayed
        if (null != showLevel && showLevel.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showLevel", ReferencesBean.SHOW.toString()));
        }
        if (null != showCode && showCode.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showCode", ReferencesBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showScientificName", ReferencesBean.SHOW.toString()));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showVernacularName", ReferencesBean.SHOW.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for relationOp property - Operator for search (Is / Contains / Starts with).
     * @return value of relationOp
     */
    public String getRelationOpAuthor() {
        return relationOpAuthor;
    }

    /**
     * Setter for relationOp property - Operator for search (Is / Contains / Starts with).
     * @param relationOp new value for relationOp
     */
    public void setRelationOpAuthor(String relationOp) {
        this.relationOpAuthor = relationOp;
    }

    /**
     * Setter for author property.
     * @param author author.
     */
    public void setAuthor(String author) {
        this.author = author;
    }

    /**
     * Getter for searchString property - Searched string.
     * @return value of searchString
     */
    public String getAuthor() {
        return author;
    }

    /**
     * Setter for searchString property - Searched string.
     * @param searchString new value for searchString
     */
    public void setSearchString(String searchString) {
        if (null != searchString) {
            this.author = searchString.trim();
        } else {
            this.author = searchString;
        }
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
     * @param showCode new value for showCode
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
     * Getter for relationOpDate property.
     * @return relationOpDate.
     */
    public String getRelationOpDate() {
        return relationOpDate;
    }

    /**
     * Setter for relationOpDate property.
     * @param relationOpDate relationOpDate.
     */
    public void setRelationOpDate(String relationOpDate) {
        this.relationOpDate = relationOpDate;
    }

    /**
     * Getter for date property.
     * @return date.
     */
    public String getDate() {
        return date;
    }

    /**
     * Setter for date property.
     * @param date date.
     */
    public void setDate(String date) {
        this.date = date;
    }

    /**
     * Getter for date1 property.
     * @return date1.
     */
    public String getDate1() {
        return date1;
    }

    /**
     * Setter for date1 property.
     * @param date1 date1.
     */
    public void setDate1(String date1) {
        this.date1 = date1;
    }

    /**
     * Getter for relationOpEditor property.
     * @return relationOpEditor.
     */
    public String getRelationOpEditor() {
        return relationOpEditor;
    }

    /**
     * Setter for relationOpEditor property.
     * @param relationOpEditor relationOpEditor.
     */
    public void setRelationOpEditor(String relationOpEditor) {
        this.relationOpEditor = relationOpEditor;
    }

    /**
     * Getter for editor property.
     * @return editor.
     */
    public String getEditor() {
        return editor;
    }

    /**
     * Setter for editor property.
     * @param editor editor.
     */
    public void setEditor(String editor) {
        this.editor = editor;
    }

    /**
     * Getter for relationOpTitle property.
     * @return relationOpTitle.
     */
    public String getRelationOpTitle() {
        return relationOpTitle;
    }

    /**
     * Setter for relationOpTitle property.
     * @param relationOpTitle relationOpTitle.
     */
    public void setRelationOpTitle(String relationOpTitle) {
        this.relationOpTitle = relationOpTitle;
    }

    /**
     * Getter for title property.
     * @return title.
     */
    public String getTitle() {
        return title;
    }

    /**
     * Setter for title property.
     * @param title title.
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Getter for relationOpPublisher property.
     * @return relationOpPublisher.
     */
    public String getRelationOpPublisher() {
        return relationOpPublisher;
    }

    /**
     * Setter for relationOpPublisher property.
     * @param relationOpPublisher relationOpPublisher.
     */
    public void setRelationOpPublisher(String relationOpPublisher) {
        this.relationOpPublisher = relationOpPublisher;
    }

    /**
     * Getter for publisher property.
     * @return publisher.
     */
    public String getPublisher() {
        return publisher;
    }

    /**
     * Setter for publisher property.
     * @param publisher publisher.
     */
    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    /**
     * Getter for source property.
     * @return source.
     */
    public String getSource() {
        return source;
    }

    /**
     * Setter for source property.
     * @param source source.
     */
    public void setSource(String source) {
        this.source = source;
    }

    /**
     * Test method.
     * @param args Command line arguments.
     */
    public static void main(String[] args) {
        String[] criteriaSearch = { "first string", "second string", "third string"};
        String[] oper = { "0", "1", "2"};
        String[] criteriaType = { "0", "1", "2"};
        // Initializations
        ReferencesBean bean = new ReferencesBean();

        bean.setCriteriaSearch(criteriaSearch);
        bean.setOper(oper);
        bean.setCriteriaType(criteriaType);
        // Test toSearchCriteria
        AbstractSearchCriteria[] criteria = bean.toSearchCriteria();

        for (int i = 0; i < criteria.length; i++) {
            AbstractSearchCriteria aCrit = criteria[i];

        }
        bean.removeCriteriaSearch(1);
        criteria = bean.toSearchCriteria();
        // System.out.println("=======================");
        for (int i = 0; i < criteria.length; i++) {
            AbstractSearchCriteria aCrit = criteria[i];
            // System.out.println("Criteria " + i + " : " + aCrit.toHumanString());
        }
    }
}
