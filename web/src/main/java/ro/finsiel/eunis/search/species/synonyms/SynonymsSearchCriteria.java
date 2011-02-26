package ro.finsiel.eunis.search.species.synonyms;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;


/**
 * Search criteria used for species->synonyms.
 * @author finsiel
 */
public class SynonymsSearchCriteria extends AbstractSearchCriteria {

    /** Used in filters, filtering by Group. */
    public static final Integer CRITERIA_GROUP = new Integer(2);

    /** Used in filters, filtering by Scientific name. */
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(4);

    /** Used for coming from first page.*/
    public static final Integer CRITERIA_SCIENTIFIC_NAME_PRIM = new Integer(5);
    // /** Used in filters, filtering by Order. */
    // public static final Integer CRITERIA_ORDER = new Integer(6);
    // /** Used in filters, filtering by Family. */
    // public static final Integer CRITERIA_FAMILY = new Integer(7);


    private String scientificName = null;

    /** Relation between scientificName or vernacularName (starts, contains, is). */
    private Integer relationOp = null;
    private String groupName = null;

    private Hashtable sqlMappings = null;
    private Hashtable humanMappings = null;

    /**
     * New main search criteria.
     * @param scientificName Scientific name.
     * @param relationOp Relation operator.
     * @param groupName Name of the group.
     */
    public SynonymsSearchCriteria(String scientificName, Integer relationOp, String groupName) {
        _initHumanMappings();
        _initSQLMappings();
        this.scientificName = scientificName;
        this.relationOp = relationOp;
        this.groupName = groupName;
    }

    /**
     * New search in results object.
     * @param criteriaSearch Search criteria.
     * @param criteriaType Type of search.
     * @param oper Relation operator.
     */
    public SynonymsSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
        _initHumanMappings();
        _initSQLMappings();
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            this.criteriaSearch = criteriaSearch;
            this.criteriaType = criteriaType;
            this.oper = oper;
        }

    }

    /** Init the mappings used to compose the SQL query. */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable(2);
        sqlMappings.put(CRITERIA_GROUP, "E.COMMON_NAME");
        // sqlMappings.put(CRITERIA_ORDER, "G.NAME");
        // sqlMappings.put(CRITERIA_FAMILY, "F.NAME");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "D.SCIENTIFIC_NAME ");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME_PRIM, "C.SCIENTIFIC_NAME ");

    }

    /** Init the human mappings so you can represent this object in human language. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable(2);
        humanMappings.put(CRITERIA_GROUP, "Group ");
        // humanMappings.put(CRITERIA_ORDER, "Order ");
        // humanMappings.put(CRITERIA_FAMILY, "Family ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Synonym name ");
    }

    /**
     * This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != scientificName && null != relationOp && null != groupName) {
            url.append(Utilities.writeURLParameter("scientificName", scientificName));
            url.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
            url.append(Utilities.writeURLParameter("groupName", groupName));
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

        // Coming from form 1
        if (null != scientificName && null != relationOp && null != groupName) {
            sql.append(
                    Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_SCIENTIFIC_NAME_PRIM), scientificName, relationOp));
            if (!groupName.equals("0")) {
                sql.append(" AND ");
                sql.append(Utilities.prepareSQLOperator("C.ID_GROUP_SPECIES", groupName, Utilities.OPERATOR_IS));
            }
        }
        // Search in results
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
     * < INPUT type='hidden" name="searchType" value="1">
     * @return Web page FORM representation of the object
     */
    public String toFORMParam() {
        StringBuffer url = new StringBuffer();

        if (null != scientificName && null != relationOp && null != groupName) {
            url.append(Utilities.writeFormParameter("scientificName", scientificName));
            url.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
            url.append(Utilities.writeFormParameter("groupName", groupName));
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

        // Coming from form 1
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            String _criteria = criteriaSearch;

            sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), _criteria, oper));
        }
        return sql.toString();
    }
}
