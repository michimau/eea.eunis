package ro.finsiel.eunis.search.species.habitats;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;

/**
 * Search criteria for species->habitats threat status.
 * @author finsiel
 */
public class HabitateSearchCriteria extends AbstractSearchCriteria {
  /** Pick english name, show species. */
  public static final Integer SEARCH_HABITAT_NAME = new Integer(0);
  /** Pick habitat code, show species. */
  public static final Integer SEARCH_HABITAT_CODE = new Integer(0);

  /** Used in filters, filtering by Group. */
  public static final Integer CRITERIA_GROUP = new Integer(2);
  /** Used in filters, filtering by Order. */
  public static final Integer CRITERIA_ORDER = new Integer(3);
  /** Used in filters, filtering by Family. */
  public static final Integer CRITERIA_FAMILY = new Integer(5);
  /** Used in filters, filtering by Scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(4);

  /** English name -> Base criteria was started from english name. */
  public static final Integer SEARCH_NAME = new Integer(5);
  /** Code -> Base criteria was started from code. */
  public static final Integer SEARCH_CODE = new Integer(6);
  /** Legal instruments -> Base criteria was started from legal instruments. */
  public static final Integer SEARCH_LEGAL_INSTRUMENTS = new Integer(7);
  /** Country name -> Base criteria was started from country name. */
  public static final Integer SEARCH_COUNTRY = new Integer(8);
  /** Region name -> Base criteria was started from region name. */
  public static final Integer SEARCH_REGION = new Integer(9);

  private Integer searchAttribute = null;
  private String scientificName = null;
  /** Relation between scientificName or vernacularName (starts, contains, is).*/
  private Integer relationOp = null;

  private Hashtable sqlMappings = null;
  private Hashtable humanMappings = null;

  private boolean isMainCriteria = false;

  /**
   * Constructor for main search object.
   * @param searchAttribute Where to look.
   * @param scientificName Search string.
   * @param relationOp Relation operator.
   */
  public HabitateSearchCriteria(Integer searchAttribute, String scientificName, Integer relationOp) {
    _initHumanMappings();
    _initSQLMappings();
    this.searchAttribute = searchAttribute;
    this.scientificName = scientificName;
    this.relationOp = relationOp;
    isMainCriteria = true;
  }


  /**
   * Constructor for search in results object.
   * @param criteriaSearch Search string.
   * @param criteriaType What type of information to search.
   * @param oper Relation operator.
   */
  public HabitateSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
    sqlMappings.put(CRITERIA_GROUP, "I.COMMON_NAME");
    sqlMappings.put(CRITERIA_ORDER, "L.NAME");
    sqlMappings.put(CRITERIA_FAMILY, "J.NAME");
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME ");

    sqlMappings.put(SEARCH_LEGAL_INSTRUMENTS, "E.NAME");
    sqlMappings.put(SEARCH_COUNTRY, "E.AREA_NAME_EN");
    sqlMappings.put(SEARCH_REGION, "E.NAME");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_GROUP, "Group ");
    humanMappings.put(CRITERIA_ORDER, "Order ");
    humanMappings.put(CRITERIA_FAMILY, "Family ");
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");

    humanMappings.put(SEARCH_NAME, "Habitat type name or description ");
    humanMappings.put(SEARCH_CODE, "Habitat type code ");
    humanMappings.put(SEARCH_LEGAL_INSTRUMENTS, "Legal instrument name ");
    humanMappings.put(SEARCH_COUNTRY, "Country name ");
    humanMappings.put(SEARCH_REGION, "Biogeographic region name ");
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
      if (searchAttribute.intValue() == SEARCH_NAME.intValue()) {
        sql.append("(");
        sql.append(Utilities.prepareSQLOperator("C.SCIENTIFIC_NAME", _searchString, relationOp));
        sql.append(" OR " + Utilities.prepareSQLOperator("C.DESCRIPTION", _searchString, relationOp));
        sql.append(" OR " + Utilities.prepareSQLOperator("K.DESCRIPTION", _searchString, relationOp));
        sql.append(")");
      } else if (searchAttribute.intValue() == SEARCH_CODE.intValue()) {
        sql.append("(");
        sql.append(Utilities.prepareSQLOperator("C.EUNIS_HABITAT_CODE", _searchString, relationOp));
        sql.append(" OR " + Utilities.prepareSQLOperator("C.CODE_2000", _searchString, relationOp));
        sql.append(" OR " + Utilities.prepareSQLOperator("D.CODE", _searchString, relationOp));
        sql.append(")");
      } else {
        sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(searchAttribute), _searchString, relationOp));
      }
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
   * < INPUT type='hidden" name="searchType" value="1">
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
 public String getScientificName() {
    return scientificName;
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