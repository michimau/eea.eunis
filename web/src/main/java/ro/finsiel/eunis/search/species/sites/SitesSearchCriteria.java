package ro.finsiel.eunis.search.species.sites;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;


/**
 * Search criteria used for species->sites.
 * @author finsiel
 */
public class SitesSearchCriteria extends AbstractSearchCriteria {

    /** Used in filters, filtering by Group. */
    public static final Integer CRITERIA_GROUP = new Integer(1);

    /** Used in filters, filtering by Order. */
    public static final Integer CRITERIA_ORDER = new Integer(2);

    /** Used in filters, filtering by Family. */
    public static final Integer CRITERIA_FAMILY = new Integer(3);

    /** Used in filters, filtering by Scientific name. */
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(4);

    /** Site name -> Base criteria was started from site name.*/
    public static final Integer SEARCH_NAME = new Integer(5);

    /** Site size -> Base criteria was started from site size.*/
    public static final Integer SEARCH_SIZE = new Integer(6);

    /** Site length -> Base criteria was started from site length.*/
    public static final Integer SEARCH_LENGTH = new Integer(7);

    /** Site country -> Base criteria was started from site's country.*/
    public static final Integer SEARCH_COUNTRY = new Integer(8);

    /** Site region -> Base criteria was started from site region.*/
    public static final Integer SEARCH_REGION = new Integer(9);

    private Integer searchAttribute = null;
    private String scientificName = null;

    /** Relation between scientificName or vernacularName (starts, contains, is).*/
    private Integer relationOp = null;

    private Hashtable sqlMappings = null;
    private Hashtable humanMappings = null;
    boolean isMainCriteria = false;

    /**
     * Main search criteria.
     * @param searchAttribute Type of search.
     * @param scientificName Searched string.
     * @param relationOp Relation operator
     */
    public SitesSearchCriteria(Integer searchAttribute, String scientificName, Integer relationOp) {
        _initHumanMappings();
        _initSQLMappings();
        this.searchAttribute = searchAttribute;
        this.scientificName = scientificName;
        this.relationOp = relationOp;
        isMainCriteria = true;
    }

    /**
     * Search in results criteria.
     * @param criteriaSearch Type of search.
     * @param criteriaType Search string.
     * @param oper Relation operator.
     */
    public SitesSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
        _initHumanMappings();
        _initSQLMappings();
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            this.criteriaSearch = criteriaSearch;
            this.criteriaType = criteriaType;
            this.oper = oper;
        }
        isMainCriteria = false;
    }

    /**
     * Init the mappings used to compose the SQL query.
     */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_GROUP, "I.ID_GROUP_SPECIES");
        sqlMappings.put(CRITERIA_ORDER, "L.NAME");
        sqlMappings.put(CRITERIA_FAMILY, "J.NAME");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME ");

        sqlMappings.put(SEARCH_NAME, "C.NAME");
        sqlMappings.put(SEARCH_SIZE, "C.AREA");
        sqlMappings.put(SEARCH_LENGTH, "C.LENGTH");
        sqlMappings.put(SEARCH_COUNTRY, "E.AREA_NAME_EN");
        sqlMappings.put(SEARCH_REGION, "E.NAME");
    }

    /**
     * Init the human mappings so you can represent this object in human language.
     */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_GROUP, "Group ");
        humanMappings.put(CRITERIA_ORDER, "Order ");
        humanMappings.put(CRITERIA_FAMILY, "Family ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");

        humanMappings.put(SEARCH_NAME, "site name");
        humanMappings.put(SEARCH_SIZE, "site size");
        humanMappings.put(SEARCH_LENGTH, "site length");
        humanMappings.put(SEARCH_COUNTRY, "country name");
        humanMappings.put(SEARCH_REGION, "biogeographic region name");
    }

    /**
     * This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (isMainCriteria) {
            url.append(Utilities.writeURLParameter("searchAttribute", searchAttribute));
            url.append(Utilities.writeURLParameter("scientificName", scientificName));
            url.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
        } else {
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
        String _searchString = scientificName;

        if (isMainCriteria) {
            if (null == _searchString) {
                relationOp = Utilities.OPERATOR_CONTAINS;
                _searchString = "%"; // Return all values
            }
            sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(searchAttribute), _searchString, relationOp));
        } else {
            String _criteria = criteriaSearch;

            // Do the mapping / transform from group name to group ID
            if (0 == criteriaType.compareTo(CRITERIA_GROUP)) {
                _criteria = SpeciesSearchUtility.findGroupID(criteriaSearch).toString();
            }
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

        if (isMainCriteria) {
            url.append(Utilities.writeFormParameter("searchAttribute", searchAttribute));
            url.append(Utilities.writeFormParameter("scientificName", scientificName));
            url.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
        } else {
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

        if (isMainCriteria) {
            sql.append(Utilities.prepareHumanString((String) humanMappings.get(searchAttribute), scientificName, relationOp));
        } else {
            String _criteria = criteriaSearch;

            sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), _criteria, oper));
        }
        return sql.toString();
    }

    /**
     * Getter for humanMappings property. (Map criteria name to human readable description).
     * @return humanMappings.
     */
    public Hashtable getHumanMappings() {
        return humanMappings;
    }
}
