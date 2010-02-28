package ro.finsiel.eunis.formBeans;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.AbstractSortCriteria;

import java.util.Vector;

/**
 * Java bean used for main reference search (header).
 * @author finsiel.
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
  // These are the show columns fields...Determines which columns are displayed or hidden in the result page.
  private String showAuthor = null;
  private String showYear = null;
  private String showTitle = null;
  private String showEditor = null;
  private String showPublisher = null;
  private String showURL = null;

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

    criteria = new ReferencesSearchCriteria(author, relationOpAuthor, date, date1, relationOpDate, title, relationOpTitle, publisher, relationOpPublisher, editor, relationOpEditor);
    return criteria;
  }

  /**
   * This method will transform the request parameters used for search back in search objects (AbstractSearchCriteria).
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
    criterias.addElement(new ReferencesSearchCriteria(author, relationOpAuthor, date, date1, relationOpDate, title, relationOpTitle, publisher, relationOpPublisher, editor, relationOpEditor));
    // Search in results criterias
    if (null != criteriaSearch && null != oper && null != criteriaType) {
      for (int i = 0; i < criteriaSearch.length; i++) {
        Integer _criteriaType = Utilities.checkedStringToInt(criteriaType[i], ReferencesSearchCriteria.CRITERIA_AUTHOR);
        Integer _oper = Utilities.checkedStringToInt(oper[i], Utilities.OPERATOR_CONTAINS);
        criterias.addElement(new ReferencesSearchCriteria(criteriaSearch[i], _criteriaType, _oper));
      }
    }
    AbstractSearchCriteria[] absCriterias = new AbstractSearchCriteria[criterias.size()];
    for (int i = 0; i < criterias.size(); i++) {
      absCriterias[i] = (AbstractSearchCriteria) criterias.get(i);
    }
    //System.out.println("absCriterias.length = " + absCriterias.length);
    return absCriterias;
  }

  /**
   * This method will transform the request parameters used for sorting back in search objects (AbstractSortCriteria)
   * in order to use them in sorting.
   * @return A list of AbstractSearchCriteria objects used to do the sorting.
   */
  public AbstractSortCriteria[] toSortCriteria() {
    if (null == sort || null == ascendency) return new AbstractSortCriteria[0];
    AbstractSortCriteria criterias[] = new AbstractSortCriteria[sort.length];

    for (int i = 0; i < sort.length; i++)
    {
      ReferencesSortCriteria criteria = new ReferencesSortCriteria(
              Utilities.checkedStringToInt(sort[i], AbstractSortCriteria.ASCENDENCY_NONE),
              Utilities.checkedStringToInt(ascendency[i], AbstractSortCriteria.ASCENDENCY_NONE));
      criterias[i] = criteria;
    }
    return criterias; //Note the upcast done here.
  }

  /**
   * This method will transform the request parameters, back to an URL compatible type of request so that
   * one should not manually write the URL.
   * @param classFields Fields to be included in results.
   * @return An URL compatible type of representation(i.e.: param1=val1&param2=val2&param3=val3 etc.
   */
  public String toURLParam(Vector classFields) {
    StringBuffer url = new StringBuffer();
    url.append(toURLParamSuper(classFields));// Add fields of the superclass (DO NOT FORGET!)
    if (classFields.contains("criteriaSearch")) {
      AbstractSearchCriteria[] searchCriterias = toSearchCriteria();
      for (int i = 0; i < searchCriterias.length; i++) {
        AbstractSearchCriteria aSearch = searchCriterias[i];
        url.append(aSearch.toURLParam());
      }
    }

    // Write columns to be displayed
    if (null != showAuthor && showAuthor.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showAuthor", AbstractFormBean.SHOW.toString()));
    if (null != showYear && showYear.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showYear", AbstractFormBean.SHOW.toString()));
    if (null != showTitle && showTitle.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showTitle", AbstractFormBean.SHOW.toString()));
    if (null != showEditor && showEditor.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showEditor", AbstractFormBean.SHOW.toString()));
    if (null != showPublisher && showPublisher.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showPublisher", AbstractFormBean.SHOW.toString()));
    if (null != showURL && showURL.equalsIgnoreCase("true")) url.append(Utilities.writeURLParameter("showURL", AbstractFormBean.SHOW.toString()));
    return url.toString();
  }

  /**
   * This method will transform the request parameters into a form compatible hidden input parameters, for example:
   * &ltINPUT type="hidden" name="paramName" value="paramValue"&gt.
   * @param classFields Fields to be included in result.
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
    if (null != showAuthor && showAuthor.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showAuthor", AbstractFormBean.SHOW.toString()));
    if (null != showYear && showYear.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showYear", AbstractFormBean.SHOW.toString()));
    if (null != showTitle && showTitle.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showTitle", AbstractFormBean.SHOW.toString()));
    if (null != showEditor && showEditor.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showEditor", AbstractFormBean.SHOW.toString()));
    if (null != showPublisher && showPublisher.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showPublisher", AbstractFormBean.SHOW.toString()));
    if (null != showURL && showURL.equalsIgnoreCase("true")) form.append(Utilities.writeFormParameter("showURL", AbstractFormBean.SHOW.toString()));
    return form.toString();
  }

  /**
   * Getter for relationOp property - Operator for search (Is / Contains / Starts with).
   * @return value of relationOp.
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
   * Getter for author property - Searched string.
   * @return value of author
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
   * Getter for showAuthor property.
   * @return showAuthor.
   */
  public String getShowAuthor() {
    return showAuthor;
  }

  /**
   * setter for showAuthor property.
   * @param showAuthor showAuthor.
   */
  public void setShowAuthor(String showAuthor) {
    this.showAuthor = showAuthor;
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
   * Getter for showYear property.
   * @return showYear.
   */
  public String getShowYear() {
    return showYear;
  }

  /**
   * S for showYear property.
   * @param showYear showYear.
   */
  public void setShowYear(String showYear) {
    this.showYear = showYear;
  }

  /**
   * Getter for showTitle property.
   * @return showTitle.
   */
  public String getShowTitle() {
    return showTitle;
  }

  /**
   * Setter for showTitle property.
   * @param showTitle showTitle.
   */
  public void setShowTitle(String showTitle) {
    this.showTitle = showTitle;
  }

  /**
   * Getter for showEditor property.
   * @return showEditor.
   */
  public String getShowEditor() {
    return showEditor;
  }

  /**
   * Setter for showEditor property.
   * @param showEditor showEditor.
   */
  public void setShowEditor(String showEditor) {
    this.showEditor = showEditor;
  }

  /**
   * Getter for showPublisher property.
   * @return showPublisher.
   */
  public String getShowPublisher() {
    return showPublisher;
  }

  /**
   * Setter for showPublisher property.
   * @param showPublisher showPublisher.
   */
  public void setShowPublisher(String showPublisher) {
    this.showPublisher = showPublisher;
  }

  /**
   * Getter for showURL property.
   * @return showURL.
   */
  public String getShowURL() {
    return showURL;
  }

  /**
   * Setter for showURL property.
   * @param showURL showURL.
   */
  public void setShowURL(String showURL) {
    this.showURL = showURL;
  }

  /**
   * Setter for publisher property.
   * @param publisher publisher.
   */
  public void setPublisher(String publisher) {
    this.publisher = publisher;
  }
}