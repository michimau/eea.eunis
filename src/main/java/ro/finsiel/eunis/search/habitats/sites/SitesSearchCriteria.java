package ro.finsiel.eunis.search.habitats.sites;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;
import ro.finsiel.eunis.jrfTables.habitats.sites.HabitatsSitesDomain;

import java.util.Hashtable;

/**
 * Search criteria used for habitats->sites.
 * @author finsiel
 */
public class SitesSearchCriteria extends AbstractSearchCriteria {
  /** Used for search in results, to filter after the level. */
  public static final Integer CRITERIA_LEVEL = new Integer(0);
  /** Used for search in results, to filter after the eunis code. */
  public static final Integer CRITERIA_EUNIS_CODE = new Integer(1);
  /** Used for search in results, to filter after the annex code. */
  public static final Integer CRITERIA_ANNEX_CODE = new Integer(2);
  /** Used for search in results, to filter after the scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);
  /** Used for search in results, to filter after the vernacular name. */
  public static final Integer CRITERIA_NAME = new Integer(4);

  /** Site name -> Base criteria was started from site name. */
  public static final Integer SEARCH_NAME = new Integer(5);
  /** Site name -> Base criteria was started from site size. */
  public static final Integer SEARCH_SIZE = new Integer(6);
  /** Site name -> Base criteria was started from site length. */
  public static final Integer SEARCH_LENGTH = new Integer(7);
  /** Site name -> Base criteria was started from site country. */
  public static final Integer SEARCH_COUNTRY = new Integer(8);
  /** Site name -> Base criteria was started from site region. */
  public static final Integer SEARCH_REGION = new Integer(9);

  private Integer searchAttribute = null;
  private String scientificName = null;
  /** Relation between scientificName or vernacularName (starts, contains, is).*/
  private Integer relationOp = null;

  private Hashtable sqlMappings = null;
  private Hashtable humanMappings = null;
  boolean isMainCriteria = false;

  /**
   * Ctor for main search criteria.
   * @param searchAttribute Searched attribute.
   * @param scientificName Value for that attribute.
   * @param relationOp Relation operator between attribute and searched string.
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
   * Second constructor used to construct filter search criterias (search in results).
   * @param criteriaSearch Search string.
   * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
   * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
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

  /** Init the mappings used to compose the SQL query. */
  private void _initSQLMappings() {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable();
    sqlMappings.put(CRITERIA_EUNIS_CODE, "H.EUNIS_HABITAT_CODE ");
    sqlMappings.put(CRITERIA_ANNEX_CODE, "H.CODE_2000 ");
    sqlMappings.put(CRITERIA_LEVEL, "H.LEVEL ");
    sqlMappings.put(CRITERIA_NAME, "H.DESCRIPTION ");
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME ");

    sqlMappings.put(SEARCH_NAME, "C.NAME");
    sqlMappings.put(SEARCH_SIZE, "C.AREA");
    sqlMappings.put(SEARCH_LENGTH, "C.LENGTH");
    sqlMappings.put(SEARCH_COUNTRY, "E.AREA_NAME_EN");
    sqlMappings.put(SEARCH_REGION, "E.NAME");
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_EUNIS_CODE, "EUNIS code ");
    humanMappings.put(CRITERIA_ANNEX_CODE, "ANNEX I code ");
    humanMappings.put(CRITERIA_LEVEL, "Habitat level ");
    humanMappings.put(CRITERIA_NAME, "Vernacular name ");
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");

    humanMappings.put(SEARCH_NAME, "site name");
    humanMappings.put(SEARCH_SIZE, "site size");
    humanMappings.put(SEARCH_LENGTH, "site length");
    humanMappings.put(SEARCH_COUNTRY, "country name");
    humanMappings.put(SEARCH_REGION, "biogeographic region name");
  }


  /** This method must be implementing by inheriting classes and should return the representation of an object as
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
   * Getter for humanMappings property.
   * @return humanMappings.
   */
  public Hashtable getHumanMappings() {
    return humanMappings;
  }
}
