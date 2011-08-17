package ro.finsiel.eunis.search.habitats.references;


import java.util.Hashtable;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;


/**
 * Search criteria used for habitats->references.
 * @author finsiel
 */
public class ReferencesSearchCriteria extends AbstractSearchCriteria {

    /** Coming from first form (author). */
    public static final Integer CRITERIA_AUTHOR = new Integer(0);

    /** Used in filters, filtering by Date. */
    public static final Integer CRITERIA_DATE = new Integer(1);

    /** Used in filters, filtering by Tilte. */
    public static final Integer CRITERIA_TITLE = new Integer(2);

    /** Used in filters, filtering by Editor. */
    public static final Integer CRITERIA_EDITOR = new Integer(3);

    /** Used in filters, filtering by Publisher. */
    public static final Integer CRITERIA_PUBLISHER = new Integer(4);

    /** Used in filters, filtering by Scientific name. */
    public static final Integer CRITERIA_SCIENTIFIC = new Integer(5);

    /** Scientific name if coming from first form .*/
    private String scientificName = null;

    /** Relation between scientificName or vernacularName (starts, contains, is).*/
    private Integer relationOp = null;

    /* The following fields are used for search in results and defines the criteria used.*/

    /** search string used for search in results. */
    private String criteriaSearch = null;

    /** criteria typeForm used for search in results. */
    private Integer criteriaType = null;

    /** Relation between criteriaSearch and criteriaType. */
    protected Integer oper = null;

    private Hashtable sqlMappings = null;
    private Hashtable humanMappings = null;

    /**
     * Main constructor, when doing initial search for scientific name.
     * @param scientificName Scientific name or vernacular, depending which form we came from.
     * @param relationOp Relation used for search (starts, contains, is). Can be OPERATOR_IS/CONTAINS/STARTS.
     */
    public ReferencesSearchCriteria(String scientificName, Integer relationOp) {
        _initHumanMappings();
        _initSQLMappings();
        this.scientificName = scientificName;
        this.relationOp = relationOp;
    }

    /**
     * Second constructor used to construct filter search criterias (search in results).
     * @param criteriaSearch Search string.
     * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
     * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
     */
    public ReferencesSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
        _initHumanMappings();
        _initSQLMappings();
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            this.criteriaSearch = criteriaSearch;
            this.criteriaType = criteriaType;
            this.oper = oper;
        }

    }

    /**
     * Default constructor, do not use this for normal operations.
     * Instead used the other two constructors.
     */
    public ReferencesSearchCriteria() {
        this.criteriaSearch = null;
        this.criteriaType = null;
        this.oper = null;
        this.scientificName = null;
        this.relationOp = null;
    }

    /** Init the mappings used to compose the SQL query. */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_AUTHOR, "J.SOURCE");
        sqlMappings.put(CRITERIA_DATE, "J.CREATED");
        sqlMappings.put(CRITERIA_TITLE, "J.TITLE");
        sqlMappings.put(CRITERIA_EDITOR, "J.EDITOR");
        sqlMappings.put(CRITERIA_PUBLISHER, "J.PUBLISHER");
        sqlMappings.put(CRITERIA_SCIENTIFIC, "C.SCIENTIFIC_NAME");
    }

    /** Init the human mappings so you can represent this object in human language. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_AUTHOR, "Author ");
        humanMappings.put(CRITERIA_DATE, "Date ");
        humanMappings.put(CRITERIA_TITLE, "Title ");
        humanMappings.put(CRITERIA_EDITOR, "Editor ");
        humanMappings.put(CRITERIA_PUBLISHER, "Publisher ");
        humanMappings.put(CRITERIA_SCIENTIFIC, "Scientific name ");
    }

    /** This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != scientificName && null != relationOp) {
            url.append(Utilities.writeURLParameter("scientificName", scientificName));
            url.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
        }

        if (null != criteriaSearch && null != criteriaType && null != oper) {
            url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
            url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
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

        // Main search criteria

        if (null != scientificName && null != relationOp) {
            sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_SCIENTIFIC), scientificName, relationOp));
        }

        if (null != criteriaSearch && null != criteriaType && null != oper) {
            String _criteria = criteriaSearch;

            sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), _criteria, oper));
        }
        return sql.toString();
    }

    /**
     * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
     * to say is that I can say about an object for example:
     * < INPUT type='hidden" name="searchCriteria" value="natrix">
     * < INPUT type='hidden" name="oper" value="1">
     * < INPUT type='hidden" name="searchType" value="1">.
     * @return Web page FORM representation of the object
     */
    public String toFORMParam() {
        StringBuffer url = new StringBuffer();

        if (null != scientificName && null != relationOp) {
            url.append(Utilities.writeFormParameter("scientificName", scientificName));
            url.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
        }

        if (null != criteriaSearch && null != criteriaType && null != oper) {
            url.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
            url.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
            url.append(Utilities.writeFormParameter("oper", oper.toString()));
        }
        return url.toString();
    }

    /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public String toHumanString() {
        StringBuffer sql = new StringBuffer();

        // Main search criteria
        if (null != scientificName && null != relationOp) {
            sql.append(Utilities.prepareHumanString((String) humanMappings.get(CRITERIA_SCIENTIFIC), scientificName, relationOp));
        }
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            String _criteria = criteriaSearch;

            sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), _criteria, oper));
        }
        return sql.toString();
    }
}
