package ro.finsiel.eunis.search.habitats.species;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;

/**
 * Search criteria used for habitats->species.
 * @author finsiel
 */
public class SpeciesSearchCriteria extends AbstractSearchCriteria {
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

  /** Species scientific name -> Base criteria was started from species scientific name. */
  public static final Integer SEARCH_SCIENTIFIC_NAME = new Integer(5);
  /** Species scientific name -> Base criteria was started from species group. */
  public static final Integer SEARCH_GROUP = new Integer(6);
  /** Species scientific name -> Base criteria was started from species vernacular name. */
  public static final Integer SEARCH_VERNACULAR = new Integer(7);
  /** Species scientific name -> Base criteria was started from species legal instruments. */
  public static final Integer SEARCH_LEGAL_INSTRUMENTS = new Integer(8);
  /** Species scientific name -> Base criteria was started from species country. */
  public static final Integer SEARCH_COUNTRY = new Integer(9);
  /** Species scientific name -> Base criteria was started from species region. */
  public static final Integer SEARCH_REGION = new Integer(10);

  /** First form - Attribute after which the search is done. */
  private Integer searchAttribute = null;
  /** Searched string. */
  private String scientificName = null;
  /** How searched string is related: OPERATOR_CONTAINS/STARTS/IS. */
  private Integer relationOp = null;

  /** SQL mappings for search in results. */
  private Hashtable sqlMappings = null;
  /** Mapping to human language.*/
  private Hashtable humanMappings = null;

  private boolean isMainCriteria = false;

  /**
   * Default constructor used for first search.
   * @param searchAttribute Search attribute after which the search is done.
   * @param searchString String to be searched
   * @param relationOp Relation (IS/CONTAINS/STARTS)
   */
  public SpeciesSearchCriteria(Integer searchAttribute, String searchString, Integer relationOp) {
    _initSQLMappings();
    _initHumanMappings();
    this.searchAttribute = searchAttribute;
    this.scientificName = searchString;
    this.relationOp = relationOp;
    isMainCriteria = true;
  }

  /**
   * This constructor is used for search in results.
   * @param criteriaSearch String to be searched
   * @param criteriaType Where to search
   * @param oper Relation between criteriaSearch and criteriaType
   */
  public SpeciesSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
    _initSQLMappings();
    _initHumanMappings();
    this.criteriaSearch = criteriaSearch;
    this.criteriaType = criteriaType;
    this.oper = oper;
    isMainCriteria = false;
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initSQLMappings() {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable(5);
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME ");
    sqlMappings.put(CRITERIA_EUNIS_CODE, "H.EUNIS_HABITAT_CODE ");
    sqlMappings.put(CRITERIA_ANNEX_CODE, "H.CODE_2000 ");
    sqlMappings.put(CRITERIA_LEVEL, "H.LEVEL ");
    sqlMappings.put(CRITERIA_NAME, "H.DESCRIPTION ");

    sqlMappings.put(SEARCH_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME ");
    sqlMappings.put(SEARCH_GROUP, "C.ID_GROUP_SPECIES ");
    sqlMappings.put(SEARCH_VERNACULAR, "F.VALUE ");
    sqlMappings.put(SEARCH_LEGAL_INSTRUMENTS, "CONCAT('Annex ', F.ANNEX,' - ',G.ALTERNATIVE)");
    sqlMappings.put(SEARCH_COUNTRY, "E.AREA_NAME_EN");
    sqlMappings.put(SEARCH_REGION, "E.NAME");
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable(5);
    // For search in results
    humanMappings.put(CRITERIA_EUNIS_CODE, "EUNIS code ");
    humanMappings.put(CRITERIA_ANNEX_CODE, "ANNEX code ");
    humanMappings.put(CRITERIA_LEVEL, "Habitat level ");
    humanMappings.put(CRITERIA_NAME, "Vernacular name ");
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "scientific name ");

    humanMappings.put(SEARCH_SCIENTIFIC_NAME, "species scientific name ");
    humanMappings.put(SEARCH_GROUP, "group species name ");
    humanMappings.put(SEARCH_VERNACULAR, "species vernacular name ");
    humanMappings.put(SEARCH_LEGAL_INSTRUMENTS, "legal instrument name ");
    humanMappings.put(SEARCH_COUNTRY, "country name ");
    humanMappings.put(SEARCH_REGION, "biogeographic region name ");
  }

  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer url = new StringBuffer();
    if (null != scientificName) url.append(Utilities.writeURLParameter("scientificName", scientificName));
    if (null != relationOp) url.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
    // Search in results
    if (null != criteriaSearch) url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
    if (null != oper) url.append(Utilities.writeURLParameter("oper", oper.toString()));
    return url.toString();
  }

  /**
   * Transform this object into an SQL representation.
   * @return SQL string representing this object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();
    if (isMainCriteria) {
      String _scientificName = scientificName;
      if (null == _scientificName) {
        relationOp = Utilities.OPERATOR_CONTAINS;
        _scientificName = "%"; // Return all values
      }
      if (searchAttribute.intValue() == SEARCH_GROUP.intValue()) {
        _scientificName = SpeciesSearchUtility.findGroupID(scientificName).toString();
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
    StringBuffer form = new StringBuffer();
    if (null != scientificName) form.append(Utilities.writeFormParameter("scientificName", scientificName));
    if (null != relationOp) form.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
    // Search in results
    if (null != criteriaSearch) form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
    if (null != oper) form.append(Utilities.writeFormParameter("oper", oper.toString()));
    return form.toString();
  }

  /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer human = new StringBuffer();
    if (isMainCriteria) {
      // Normal search
      human.append(Utilities.prepareHumanString((String) humanMappings.get(searchAttribute), scientificName, relationOp));
    } else {
      // Search in results
      human.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return human.toString();
  }

  /**
   * Getter for scientificName property.
   * @return scientificName.
   */
  public String getscientificName() {
    return scientificName;
  }

  /**
   * Getter for relationOp property.
   * @return relationOp.
   */
  public Integer getrelationOp() {
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