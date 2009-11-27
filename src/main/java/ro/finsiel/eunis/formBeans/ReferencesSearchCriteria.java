package ro.finsiel.eunis.formBeans;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;
import java.util.Vector;

/**
 * Search criteria used for searching in global references function.
 * @author finsiel
 */
public class ReferencesSearchCriteria extends AbstractSearchCriteria {

  /**
   * Refine results by author.
   */
  public static final Integer CRITERIA_AUTHOR = new Integer(0);

  /**
   * Refine results by title.
   */
  public static final Integer CRITERIA_YEAR = new Integer(1);

  /**
   * Refine results by title.
   */
  public static final Integer CRITERIA_TITLE = new Integer(2);

  /**
   * Refine results by editor.
   */
  public static final Integer CRITERIA_EDITOR = new Integer(3);

  /**
   * Refine results by publisher.
   */
  public static final Integer CRITERIA_PUBLISHER = new Integer(4);

  private Integer relationOpAuthor = null;
  private String author = null;
  private Integer relationOpDate = null;
  private String date = null;
  private String date1 = null;
  private Integer relationOpEditor = null;
  private String editor = null;
  private Integer relationOpTitle = null;
  private String title = null;
  private Integer relationOpPublisher = null;
  private String publisher = null;

  /**
   * SQL mappings for search in results.
   */
  private Hashtable sqlMappings = null;

  /**
   * Mapping to human language.
   */
  private Hashtable humanMappings = null;
  private String part = "";

  /**
   * Constructs an new ReferencesSearchCriteria object.
   * @param author Author.
   * @param relationOpAuthor Relation operator for author.
   * @param date First date.
   * @param date1 Last date.
   * @param relationOpDate Relation operator for date.
   * @param title Title.
   * @param relationOpTitle Relation operator for title.
   * @param publisher Publisher.
   * @param relationOpPublisher Relation operator for publisher.
   * @param editor Editor.
   * @param relationOpEditor Relation operator for editor.
   */
  public ReferencesSearchCriteria(String author,
                                  Integer relationOpAuthor,
                                  String date,
                                  String date1,
                                  Integer relationOpDate,
                                  String title,
                                  Integer relationOpTitle,
                                  String publisher,
                                  Integer relationOpPublisher,
                                  String editor,
                                  Integer relationOpEditor)
  {
    _initSQLMappings();
    _initHumanMappings();

    this.relationOpAuthor = relationOpAuthor;
    this.author = author;
    this.relationOpDate = relationOpDate;
    this.date = date;
    this.date1 = date1;
    this.relationOpEditor = relationOpEditor;
    this.editor = editor;
    this.relationOpTitle = relationOpTitle;
    this.title = title;
    this.relationOpPublisher = relationOpPublisher;
    this.publisher = publisher;
  }

  /**
   * Constructs an new ReferencesSearch criteria object. Ctor used for refine search.
   * @param criteriaSearch Filtering string.
   * @param criteriaType Type of filtering.
   * @param oper Relation operator.
   */
  public ReferencesSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
    _initSQLMappings();
    _initHumanMappings();
    this.criteriaSearch = criteriaSearch;
    this.criteriaType = criteriaType;
    this.oper = oper;
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initSQLMappings() {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable();
    sqlMappings.put(CRITERIA_AUTHOR, "SOURCE ");
    sqlMappings.put(CRITERIA_YEAR, "CREATED ");
    sqlMappings.put(CRITERIA_TITLE, "TITLE ");
    sqlMappings.put(CRITERIA_EDITOR, "EDITOR ");
    sqlMappings.put(CRITERIA_PUBLISHER, "PUBLISHER ");
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_AUTHOR, "Author ");
    humanMappings.put(CRITERIA_YEAR, "Year ");
    humanMappings.put(CRITERIA_TITLE, "Title ");
    humanMappings.put(CRITERIA_EDITOR, "Editor ");
    humanMappings.put(CRITERIA_PUBLISHER, "Publisher ");
  }

  /**
   * This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer url = new StringBuffer();

    if (null != author) url.append(Utilities.writeURLParameter("author", author));
    if (null != relationOpAuthor) url.append(Utilities.writeURLParameter("relationOpAuthor", relationOpAuthor.toString()));

    if (null != date) url.append(Utilities.writeURLParameter("date", date));
    if (null != date1) url.append(Utilities.writeURLParameter("date1", date1));
    if (null != relationOpDate) url.append(Utilities.writeURLParameter("relationOpDate", relationOpDate.toString()));

    if (null != title) url.append(Utilities.writeURLParameter("title", title));
    if (null != relationOpTitle) url.append(Utilities.writeURLParameter("relationOpTitle", relationOpTitle.toString()));

    if (null != editor) url.append(Utilities.writeURLParameter("editor", editor));
    if (null != relationOpEditor) url.append(Utilities.writeURLParameter("relationOpEditor", relationOpEditor.toString()));

    if (null != publisher) url.append(Utilities.writeURLParameter("publisher", publisher));
    if (null != relationOpPublisher) url.append(Utilities.writeURLParameter("relationOpPublisher", relationOpPublisher.toString()));

    // Search in results
    if (null != criteriaSearch) url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
    if (null != oper) url.append(Utilities.writeURLParameter("oper", oper.toString()));
    return url.toString();
  }


  /**
   * Transform this object into an SQL representation.
   * @return SQL representation of the object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();

    Vector put_and = new Vector();

    // Main search criteria
    if (null != author && null != relationOpAuthor) {
      if (!author.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareSQLOperator("SOURCE", author, relationOpAuthor));
      }
    }

    if (
            (
            (null != date && !date.equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
            ||
            (null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
            )
            &&
            null != relationOpDate
    ) {

      if (put_and.contains("true")) {
        sql.append(" AND ");
      } else
        put_and.addElement("true");


      if (relationOpDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
        if (date == null || (date != null && date.equalsIgnoreCase("")))
          sql.append(" CREATED <=" + date1 + " ");
        if (date1 == null || (date1 != null && date1.equalsIgnoreCase("")))
          sql.append(" CREATED >=" + date + " ");
        if (date != null && date1 != null && !date.equalsIgnoreCase("") && !date1.equalsIgnoreCase(""))
          sql.append(" CREATED >=" + date + " AND CREATED<=" + date1 + " ");
      } else {
        sql.append(Utilities.prepareSQLOperator("CREATED", date, relationOpDate));
      }
    }


    if (null != title && null != relationOpTitle) {
      if (!title.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareSQLOperator("TITLE", title, relationOpTitle));
      }
    }

    if (null != editor && null != relationOpEditor) {
      if (!editor.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareSQLOperator("EDITOR", editor, relationOpEditor));
      }
    }

    if (null != publisher && null != relationOpPublisher) {
      if (!publisher.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareSQLOperator("PUBLISHER", publisher, relationOpPublisher));
      }
    }

    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
    }

    //System.out.println("sqlcriteria = " + sql);
    return sql.toString();
  }

  /**
   * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
   * to say is that I can say about an object for example:
   * < INPUT type='hidden" name="searchCriteria" value="natrix">
   * < INPUT type='hidden" name="oper" value="1">
   * < INPUT type='hidden" name="searchType" value="1">
   * @return Web page FORM representation of the object
   */
  public String toFORMParam() {
    StringBuffer form = new StringBuffer();

    if (null != author) form.append(Utilities.writeFormParameter("author", author));
    if (null != relationOpAuthor) form.append(Utilities.writeFormParameter("relationOpAuthor", relationOpAuthor.toString()));
    if (null != date) form.append(Utilities.writeFormParameter("date", date));
    if (null != date1) form.append(Utilities.writeFormParameter("date1", date1));
    if (null != relationOpDate) form.append(Utilities.writeFormParameter("relationOpDate", relationOpDate.toString()));
    if (null != title) form.append(Utilities.writeFormParameter("title", title));
    if (null != relationOpTitle) form.append(Utilities.writeFormParameter("relationOpTitle", relationOpTitle.toString()));
    if (null != editor) form.append(Utilities.writeFormParameter("editor", editor));
    if (null != relationOpEditor) form.append(Utilities.writeFormParameter("relationOpEditor", relationOpEditor.toString()));
    if (null != publisher) form.append(Utilities.writeFormParameter("publisher", publisher));
    if (null != relationOpPublisher) form.append(Utilities.writeFormParameter("relationOpPublisher", relationOpPublisher.toString()));

    // Search in results
    if (null != criteriaSearch) form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
    if (null != oper) form.append(Utilities.writeFormParameter("oper", oper.toString()));
    return form.toString();
  }

  /**
   * This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer sql = new StringBuffer();
    //if sql where condition contains another conditions, will be put 'and' before the new condition witch will be
    //attached to the sql where condition
    Vector put_and = new Vector();

    // Main search criteria
    if (null != author && null != relationOpAuthor) {
      if (!author.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareHumanString("Author", author, relationOpAuthor));
      }
    }

    if (
            (
            (null != date && !date.equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
            ||
            (null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
            )
            &&
            null != relationOpDate
    ) {
      if (put_and.contains("true")) {
        sql.append(" AND ");
      } else
        put_and.addElement("true");

      Integer relationOpForDate = relationOpDate;
      if (relationOpDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
        if (date == null || (date != null && date.equalsIgnoreCase("")))
          relationOpForDate = Utilities.OPERATOR_SMALLER_OR_EQUAL;
        if (date1 == null || (date1 != null && date1.equalsIgnoreCase("")))
          relationOpForDate = Utilities.OPERATOR_GREATER_OR_EQUAL;
        if (date != null && date1 != null && !date.equalsIgnoreCase("") && !date1.equalsIgnoreCase(""))
          relationOpForDate = Utilities.OPERATOR_BETWEEN;
      }

      sql.append(Utilities.prepareHumanString("Year", (date == null || date.equalsIgnoreCase("") ? date1 : date), date, date1, relationOpForDate));
    }

    if (null != title && null != relationOpTitle) {
      if (!title.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareHumanString("title", title, relationOpTitle));
      }
    }

    if (null != editor && null != relationOpEditor) {
      if (!editor.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareHumanString("editor", editor, relationOpEditor));
      }
    }

    if (null != publisher && null != relationOpPublisher) {
      if (!publisher.equalsIgnoreCase("")) {
        if (put_and.contains("true")) {
          sql.append(" AND ");
        } else
          put_and.addElement("true");
        sql.append(Utilities.prepareHumanString("publisher", publisher, relationOpPublisher));
      }
    }

    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return sql.toString();

  }

  /**
   * Getter for part property.
   * @return part.
   */
  public String getPart() {
    return part;
  }

  /**
   * Setter for part property.
   * @param part part.
   */
  public void setPart(String part) {
    this.part = part;
  }
}