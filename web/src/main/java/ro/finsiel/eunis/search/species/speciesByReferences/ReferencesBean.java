package ro.finsiel.eunis.search.species.speciesByReferences;


import ro.finsiel.eunis.formBeans.AbstractFormBean;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.habitats.names.NameSortCriteria;
import ro.finsiel.eunis.search.habitats.names.NameBean;

import java.util.Vector;


/**
 * Form bean used in species-references search.
 * @author finsiel
 */
public class ReferencesBean extends AbstractFormBean {

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

    /** Expand or collapse vernacular names. Only will work if also showVernacularNames is set. */
    private String expand = null;

    // These are the show columns fields...Determines which columns are displayed or hidden in the result page.
    /** Display / Hide Group column. */
    private String showGroup = null;

    /** Display / Hide Order column. */
    private String showOrder = null;

    /** Display / Hide Family column. */
    private String showFamily = null;

    /** Display / Hide Scientific name column. */
    private String showScientificName = null;

    /** Display / Hide Vernacular name column. */
    private String showVernacularName = null;

    /**
     * This method is used to retrieve the basic criterias used to do the first search.
     * @return First criterias used for search (when going from query page to result page).
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
                publisher, relationOpPublisher, editor, relationOpEditor);
        return criteria;
    }

    /**
     * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria)
     * in order to use them in searches...
     * @return A list of AbstractSearchCriteria objects used to do the search.
     */
    public AbstractSearchCriteria[] toSearchCriteria() {
        Vector criterias = new Vector();

        // Main Search
        Integer relationOpAuthor = Utilities.checkedStringToInt(this.relationOpAuthor, Utilities.OPERATOR_CONTAINS);
        Integer relationOpDate = Utilities.checkedStringToInt(this.relationOpDate, Utilities.OPERATOR_IS);
        Integer relationOpTitle = Utilities.checkedStringToInt(this.relationOpTitle, Utilities.OPERATOR_CONTAINS);
        Integer relationOpEditor = Utilities.checkedStringToInt(this.relationOpEditor, Utilities.OPERATOR_CONTAINS);
        Integer relationOpPublisher = Utilities.checkedStringToInt(this.relationOpPublisher, Utilities.OPERATOR_CONTAINS);

        criterias.addElement(
                new ReferencesSearchCriteria(author, relationOpAuthor, date, date1, relationOpDate, title, relationOpTitle,
                publisher, relationOpPublisher, editor, relationOpEditor));
        // Search in results criterias

        if (null != criteriaSearch && null != oper && null != criteriaType) {
            for (int i = 0; i < criteriaSearch.length; i++) {
                Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i],
                        ReferencesSearchCriteria.CRITERIA_SCIENTIFIC_NAME);
                Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);

                criterias.addElement(new ReferencesSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
            }
        }

        AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];

        for (int i = 0; i < criterias.size(); i++) {
            absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
        }
        return absCriterias;
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
            ReferencesSortCriteria criteria = new ReferencesSortCriteria(
                    Utilities.checkedStringToInt(sort[i], NameSortCriteria.ASCENDENCY_NONE),
                    Utilities.checkedStringToInt(ascendency[i], NameSortCriteria.ASCENDENCY_NONE));

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

        if (classFields.contains("expand")) {
            if (null != expand) {
                url.append(Utilities.writeURLParameter("expand", expand));
            }
        }
        // Write columns to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showGroup", NameBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showOrder", NameBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showFamily", NameBean.SHOW.toString()));
        }
        if (null != showScientificName && showScientificName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showScientificName", NameBean.SHOW.toString()));
        }
        if (null != showVernacularName && showVernacularName.equalsIgnoreCase("true")) {
            url.append(Utilities.writeURLParameter("showVernacularName", NameBean.SHOW.toString()));
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
        if (null != expand) {
            form.append(Utilities.writeFormParameter("expand", expand));
        }
        // Write columns to be displayed
        if (null != showGroup && showGroup.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showGroup", NameBean.SHOW.toString()));
        }
        if (null != showOrder && showOrder.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showOrder", NameBean.SHOW.toString()));
        }
        if (null != showFamily && showFamily.equalsIgnoreCase("true")) {
            form.append(Utilities.writeFormParameter("showFamily", NameBean.SHOW.toString()));
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
     * Getter for showGroup propety - Show / Hide Group column.
     * @return value of showGroup
     */
    public String getShowGroup() {
        return showGroup;
    }

    /**
     * Setter for showGroup property - Show / Hide Group column.
     * @param showGroup new value for showGroup
     */
    public void setShowGroup(String showGroup) {
        this.showGroup = showGroup;
    }

    /**
     * Getter for showOrder property - Show / Hide Order column.
     * @return value of showOrder
     */
    public String getShowOrder() {
        return showOrder;
    }

    /**
     * Setter for showOrder property - Show / Hide Order column.
     * @param showOrder new value for showOrder
     */
    public void setShowOrder(String showOrder) {
        this.showOrder = showOrder;
    }

    /**
     * Getter for showFamily property - Show / Hide Family column.
     * @return value of showFamily
     */
    public String getShowFamily() {
        return showFamily;
    }

    /**
     * Setter for showFamily property - Show / Hide Family column.
     * @param showFamily new value for showFamily
     */
    public void setShowFamily(String showFamily) {
        this.showFamily = showFamily;
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
     * Getter for showVernacularName property - Show / Hide Vernacular names column.
     * @return value of showVernacularName
     */
    public String getShowVernacularName() {
        return showVernacularName;
    }

    /**
     * Setter for showVernacularName property - Show / Hide Vernacular names column.
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
     * Setter for expand property - Expand / Collapse vernacular names column.
     * @return value of expand property.
     */
    public String getExpand() {
        return expand;
    }

    /**
     * Setter for expand property - Expand / Collapse vernacular names column.
     * @param expand new value for expand property.
     */
    public void setExpand(String expand) {
        this.expand = expand;
    }

}
