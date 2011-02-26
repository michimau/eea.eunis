package ro.finsiel.eunis.search.species.speciesByReferences;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;
import java.util.Vector;


/**
 * Search criteria usef for species->references.
 * @author finsiel
 */
public class ReferencesSearchCriteria extends AbstractSearchCriteria {

    /** Used for search in results, to filter after the group. */
    public static final Integer CRITERIA_GROUP = new Integer(0);

    /** Used for search in results, to filter after the order. */
    public static final Integer CRITERIA_ORDER = new Integer(1);

    /** Used for search in results, to filter after the family. */
    public static final Integer CRITERIA_FAMILY = new Integer(2);

    /** Used for search in results, to filter after the scientific name. */
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);

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

    /** SQL mappings for search in results. */
    private Hashtable sqlMappings = null;

    /** Mapping to human language. */
    private Hashtable humanMappings = null;
    private String part = "";

    /**
     * Main search criteria.
     * @param author Author
     * @param relationOpAuthor Relation operator
     * @param date Start date
     * @param date1 End date
     * @param relationOpDate Relation operator
     * @param title Title
     * @param relationOpTitle Relation operator
     * @param publisher Publisher
     * @param relationOpPublisher Relation operator
     * @param editor Editor
     * @param relationOpEditor Relation operator
     */
    public ReferencesSearchCriteria(String author, Integer relationOpAuthor, String date, String date1, Integer relationOpDate, String title, Integer relationOpTitle, String publisher, Integer relationOpPublisher, String editor, Integer relationOpEditor) {
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
     * Search in results criteria.
     * @param criteriaSearch Search string.
     * @param criteriaType Type of search.
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
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_GROUP, "A.COMMON_NAME ");
        sqlMappings.put(CRITERIA_ORDER, "B.NAME ");
        sqlMappings.put(CRITERIA_FAMILY, "C.NAME ");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME ");
    }

    /** Init the mappings used to compose the SQL query. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_GROUP, "Group name ");
        humanMappings.put(CRITERIA_ORDER, "Order name ");
        humanMappings.put(CRITERIA_FAMILY, "Family name ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");
    }

    /** This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != author) {
            url.append(Utilities.writeURLParameter("author", author));
        }
        if (null != relationOpAuthor) {
            url.append(Utilities.writeURLParameter("relationOpAuthor", relationOpAuthor.toString()));
        }

        if (null != date) {
            url.append(Utilities.writeURLParameter("date", date));
        }
        if (null != date1) {
            url.append(Utilities.writeURLParameter("date1", date1));
        }
        if (null != relationOpDate) {
            url.append(Utilities.writeURLParameter("relationOpDate", relationOpDate.toString()));
        }

        if (null != title) {
            url.append(Utilities.writeURLParameter("title", title));
        }
        if (null != relationOpTitle) {
            url.append(Utilities.writeURLParameter("relationOpTitle", relationOpTitle.toString()));
        }

        if (null != editor) {
            url.append(Utilities.writeURLParameter("editor", editor));
        }
        if (null != relationOpEditor) {
            url.append(Utilities.writeURLParameter("relationOpEditor", relationOpEditor.toString()));
        }

        if (null != publisher) {
            url.append(Utilities.writeURLParameter("publisher", publisher));
        }
        if (null != relationOpPublisher) {
            url.append(Utilities.writeURLParameter("relationOpPublisher", relationOpPublisher.toString()));
        }

        // Search in results
        if (null != criteriaSearch) {
            url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
        }
        if (null != criteriaType) {
            url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
        }
        if (null != oper) {
            url.append(Utilities.writeURLParameter("oper", oper.toString()));
        }
        return url.toString();
    }

    /**
     * Transform this object into an SQL representation.
     * @return SQL string representing this object.
     */
    public String toSQL() {
        StringBuffer sql = new StringBuffer();

        if (part.equalsIgnoreCase("ReferencesPart")) {
            // if sql where condition contains another conditions, will be put 'and' before the new condition witch will be
            // attached to the sql where condition
            Vector put_and = new Vector();

            // Main search criteria
            if (null != author && null != relationOpAuthor) {
                if (!author.equalsIgnoreCase("")) {
                    if (put_and.contains("true")) {
                        sql.append(" AND ");
                    } else {
                        put_and.addElement("true");
                    }
                    sql.append(Utilities.prepareSQLOperator("D.SOURCE", author, relationOpAuthor));
                }
            }

            if (
                    (
                    (null != date && !date.equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
                    || (null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
                    )
                            && null != relationOpDate
                            ) {

                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }

                if (relationOpDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
                    if (date == null || (date != null && date.equalsIgnoreCase(""))) {
                        sql.append(" E.CREATED <=" + date1 + " ");
                    }
                    if (date1 == null || (date1 != null && date1.equalsIgnoreCase(""))) {
                        sql.append(" E.CREATED >=" + date + " ");
                    }
                    if (date != null && date1 != null && !date.equalsIgnoreCase("") && !date1.equalsIgnoreCase("")) {
                        sql.append(" E.CREATED >=" + date + " AND E.CREATED<=" + date1 + " ");
                    }
                } else {
                    sql.append(Utilities.prepareSQLOperator("E.CREATED", date, relationOpDate));
                }
            }

            if (null != title && null != relationOpTitle) {
                if (!title.equalsIgnoreCase("")) {
                    if (put_and.contains("true")) {
                        sql.append(" AND ");
                    } else {
                        put_and.addElement("true");
                    }
                    sql.append(Utilities.prepareSQLOperator("F.TITLE", title, relationOpTitle));
                }
            }

            if (null != editor && null != relationOpEditor) {
                if (!editor.equalsIgnoreCase("")) {
                    if (put_and.contains("true")) {
                        sql.append(" AND ");
                    } else {
                        put_and.addElement("true");
                    }
                    sql.append(Utilities.prepareSQLOperator("D.EDITOR", editor, relationOpEditor));
                }
            }

            if (null != publisher && null != relationOpPublisher) {
                if (!publisher.equalsIgnoreCase("")) {
                    if (put_and.contains("true")) {
                        sql.append(" AND ");
                    } else {
                        put_and.addElement("true");
                    }
                    sql.append(Utilities.prepareSQLOperator("G.PUBLISHER", publisher, relationOpPublisher));
                }
            }

        } else {
            // Search in results
            if (null != criteriaSearch && null != criteriaType && null != oper) {
                sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
            }
        }
        return sql.toString();

    }

    /**
     * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
     * to say is that I can say about an object for example:
     * < INPUT type='hidden" name="searchCriteria" value="natrix">
     * < INPUT type='hidden" name="oper" value="1">
     * < INPUT type='hidden" name="searchType" value="1">.
     * @return Web page FORM representation of the object.
     */
    public String toFORMParam() {
        StringBuffer form = new StringBuffer();

        if (null != author) {
            form.append(Utilities.writeFormParameter("author", author));
        }
        if (null != relationOpAuthor) {
            form.append(Utilities.writeFormParameter("relationOpAuthor", relationOpAuthor.toString()));
        }
        if (null != date) {
            form.append(Utilities.writeFormParameter("date", date));
        }
        if (null != date1) {
            form.append(Utilities.writeFormParameter("date1", date1));
        }
        if (null != relationOpDate) {
            form.append(Utilities.writeFormParameter("relationOpDate", relationOpDate.toString()));
        }
        if (null != title) {
            form.append(Utilities.writeFormParameter("title", title));
        }
        if (null != relationOpTitle) {
            form.append(Utilities.writeFormParameter("relationOpTitle", relationOpTitle.toString()));
        }
        if (null != editor) {
            form.append(Utilities.writeFormParameter("editor", editor));
        }
        if (null != relationOpEditor) {
            form.append(Utilities.writeFormParameter("relationOpEditor", relationOpEditor.toString()));
        }
        if (null != publisher) {
            form.append(Utilities.writeFormParameter("publisher", publisher));
        }
        if (null != relationOpPublisher) {
            form.append(Utilities.writeFormParameter("relationOpPublisher", relationOpPublisher.toString()));
        }

        // Search in results
        if (null != criteriaSearch) {
            form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
        }
        if (null != criteriaType) {
            form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
        }
        if (null != oper) {
            form.append(Utilities.writeFormParameter("oper", oper.toString()));
        }
        return form.toString();
    }

    /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */


    /**
     * This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public String toHumanString() {
        StringBuffer sql = new StringBuffer();
        // if sql where condition contains another conditions, will be put 'and' before the new condition witch will be
        // attached to the sql where condition
        Vector put_and = new Vector();

        // Main search criteria
        if (null != author && null != relationOpAuthor) {
            if (!author.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareHumanString("Author", author, relationOpAuthor));
            }
        }

        if (
                (
                (null != date && !date.equalsIgnoreCase("") && !date.equalsIgnoreCase("null"))
                || (null != date1 && !date1.equalsIgnoreCase("") && !date1.equalsIgnoreCase("null"))
                )
                        && null != relationOpDate
                        ) {
            if (put_and.contains("true")) {
                sql.append(" AND ");
            } else {
                put_and.addElement("true");
            }

            Integer relationOpForDate = relationOpDate;

            if (relationOpDate.compareTo(Utilities.OPERATOR_BETWEEN) == 0) {
                if (date == null || (date != null && date.equalsIgnoreCase(""))) {
                    relationOpForDate = Utilities.OPERATOR_SMALLER_OR_EQUAL;
                }
                if (date1 == null || (date1 != null && date1.equalsIgnoreCase(""))) {
                    relationOpForDate = Utilities.OPERATOR_GREATER_OR_EQUAL;
                }
                if (date != null && date1 != null && !date.equalsIgnoreCase("") && !date1.equalsIgnoreCase("")) {
                    relationOpForDate = Utilities.OPERATOR_BETWEEN;
                }
            }

            sql.append(
                    Utilities.prepareHumanString("Year", (date == null || date.equalsIgnoreCase("") ? date1 : date), date, date1,
                    relationOpForDate));
        }

        if (null != title && null != relationOpTitle) {
            if (!title.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareHumanString("Title", title, relationOpTitle));
            }
        }

        if (null != editor && null != relationOpEditor) {
            if (!editor.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareHumanString("Editor", editor, relationOpEditor));
            }
        }

        if (null != publisher && null != relationOpPublisher) {
            if (!publisher.equalsIgnoreCase("")) {
                if (put_and.contains("true")) {
                    sql.append(" AND ");
                } else {
                    put_and.addElement("true");
                }
                sql.append(Utilities.prepareHumanString("Publisher", publisher, relationOpPublisher));
            }
        }

        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
        }
        return sql.toString();

    }

    /**
     * Setter for part property.
     * @param part part.
     */
    public void setPart(String part) {
        this.part = part;
    }
}
