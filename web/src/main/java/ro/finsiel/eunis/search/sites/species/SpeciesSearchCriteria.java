package ro.finsiel.eunis.search.sites.species;


import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;


/**
 * Search criteria used for sites->species search.
 * @author finsiel
 */
public class SpeciesSearchCriteria extends SitesSearchCriteria {

    /**
     * Search by species scientific name.
     */
    public static final Integer SEARCH_SCIENTIFIC_NAME = new Integer(5);

    /**
     * Search by species group.
     */
    public static final Integer SEARCH_GROUP = new Integer(6);

    /**
     * Search by species vernacular name.
     */
    public static final Integer SEARCH_VERNACULAR = new Integer(7);

    /**
     * Search by species legal instruments.
     */
    public static final Integer SEARCH_LEGAL_INSTRUMENTS = new Integer(8);

    /**
     * Search by country where species are found.
     */
    public static final Integer SEARCH_COUNTRY = new Integer(9);

    /**
     * Search by region where species are found.
     */
    public static final Integer SEARCH_REGION = new Integer(10);

    private Integer searchAttribute = null;
    private String searchString = null;

    private Integer relationOp = null;

    private boolean isMainCriteria = false;

    /** Mappings from search criteria -> SQL Statement. */
    private Hashtable sqlMappings = null;

    /** Mappings from search criteria -> Human language. */
    private Hashtable humanMappings = null;

    /**
     * Ctor for main search criteria.
     * @param searchAttribute Search attribute (what info specifies search string).
     * @param searchString Searched string.
     * @param relationOp Relation between searchAttribute and searchString.
     */
    public SpeciesSearchCriteria(Integer searchAttribute, String searchString, Integer relationOp) {
        _initHumanMappings();
        _initSQLMappings();
        this.searchAttribute = searchAttribute;
        this.searchString = searchString;
        this.relationOp = relationOp;
        isMainCriteria = true;
    }

    /**
     * Second constructor used to construct filter search criterias (search in results).
     * @param criteriaSearch Search string
     * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME
     * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
     */
    public SpeciesSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
        _initHumanMappings();
        _initSQLMappings();
        this.criteriaSearch = criteriaSearch;
        this.criteriaType = criteriaType;
        this.oper = oper;
        isMainCriteria = false;
    }

    /** Init the mappings used to compose the SQL query. */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();

        sqlMappings.put(CRITERIA_ENGLISH_NAME, "H.NAME ");
        sqlMappings.put(CRITERIA_SOURCE_DB, "H.SOURCE_DB ");

        sqlMappings.put(SEARCH_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME ");
        sqlMappings.put(SEARCH_GROUP, "C.ID_GROUP_SPECIES ");
        sqlMappings.put(SEARCH_VERNACULAR, "F.VALUE ");
        sqlMappings.put(SEARCH_LEGAL_INSTRUMENTS, "CONCAT('Annex ', F.ANNEX,' - ',G.ALTERNATIVE)");
        sqlMappings.put(SEARCH_COUNTRY, "E.AREA_NAME_EN");
        sqlMappings.put(SEARCH_REGION, "E.NAME");
    }

    /** Init the human mappings so you can represent this object in human language. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_ENGLISH_NAME, "Site name");
        humanMappings.put(CRITERIA_SOURCE_DB, "Database source");

        humanMappings.put(SEARCH_SCIENTIFIC_NAME, "species scientific name ");
        humanMappings.put(SEARCH_GROUP, "species group name ");
        humanMappings.put(SEARCH_VERNACULAR, "species vernacular name ");
        humanMappings.put(SEARCH_LEGAL_INSTRUMENTS, "legal instrument name ");
        humanMappings.put(SEARCH_COUNTRY, "country name ");
        humanMappings.put(SEARCH_REGION, "biogeographic region name ");
    }

    /**
     * This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer res = new StringBuffer();

        if (isMainCriteria) {
            res.append(Utilities.writeURLParameter("searchAttribute", searchAttribute));
            res.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
            res.append(Utilities.writeURLParameter("searchString", searchString));
        }
        // Search in results
        if (null != criteriaSearch) {
            res.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
        }
        if (null != criteriaType) {
            res.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
        }
        if (null != oper) {
            res.append(Utilities.writeURLParameter("oper", oper.toString()));
        }
        return res.toString();
    }

    /**
     * Transform this object into an SQL representation.
     * @return SQL string representing this object.
     */
    public String toSQL() {
        StringBuffer sql = new StringBuffer();

        if (isMainCriteria) {
            String _scientificName = searchString;

            if (null == _scientificName) {
                relationOp = Utilities.OPERATOR_CONTAINS;
                _scientificName = "%"; // Return all values
            }
            if (searchAttribute.intValue() == SEARCH_GROUP.intValue()) {
                _scientificName = SpeciesSearchUtility.findGroupID(searchString).toString();
            }
            sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(searchAttribute), _scientificName, relationOp));
        } else {
            String _criteria = criteriaSearch;

            // Do the mapping / transform from group name to group ID
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
        StringBuffer res = new StringBuffer();

        if (isMainCriteria) {
            res.append(Utilities.writeFormParameter("searchAttribute", searchAttribute));
            res.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
            res.append(Utilities.writeFormParameter("searchString", searchString));
        }
        // Search in results
        if (null != criteriaSearch) {
            res.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
        }
        if (null != criteriaType) {
            res.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
        }
        if (null != oper) {
            res.append(Utilities.writeFormParameter("oper", oper.toString()));
        }
        return res.toString();
    }

    /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public String toHumanString() {
        StringBuffer human = new StringBuffer();

        if (isMainCriteria) {
            // Normal search
            if (searchAttribute.intValue() == SEARCH_GROUP.intValue()) {
                human.append(
                        Utilities.prepareHumanString((String) humanMappings.get(searchAttribute), searchString,
                        Utilities.OPERATOR_IS));
            } else {
                human.append(Utilities.prepareHumanString((String) humanMappings.get(searchAttribute), searchString, relationOp));
            }
        } else {
            // Search in results
            human.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
        }
        return human.toString();
    }

    /**
     * Getter for searchString property.
     * @return searchString.
     */
    public String getSearchString() {
        return searchString;
    }

    /**
     * Getter for relationOp property.
     * @return relationOp.
     */
    public Integer getRelationOp() {
        return relationOp;
    }

    /**
     * Getter for humanMappings property.
     * @return humanMappings.
     */
    public Hashtable getHumanMappings() {
        return humanMappings;
    }
}
