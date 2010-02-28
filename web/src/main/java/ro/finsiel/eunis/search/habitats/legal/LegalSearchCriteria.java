package ro.finsiel.eunis.search.habitats.legal;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;

/**
 * Search criteria used for habitats->legal instruments.
 * @author finsiel
 */
public class LegalSearchCriteria extends AbstractSearchCriteria {
  /** Searching for ANY habitat and ANY text. */
  public static final Integer TYPE_ANY_HAB_ANY_TEXT = new Integer(0);
  /** Searching for A habitat and ANY text. */
  public static final Integer TYPE_A_HAB_ANY_TEXT = new Integer(1);
  /** Searching for ANY habitat and A text. */
  public static final Integer TYPE_ANY_HAB_A_TEXT = new Integer(2);
  /** Searching for A habitat and A text. */
  public static final Integer TYPE_A_HAB_A_TEXT = new Integer(3);
  /** Specifies type of query done by this search. Can have one of the static values above (one starting with "TYPE_").*/
  private Integer queryType = TYPE_ANY_HAB_ANY_TEXT;

  /** Defines a search in results after Scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(0);
  /** Defines a search in results after eunis code. */
  public static final Integer CRITERIA_EUNIS_CODE = new Integer(1);
  /** Defines a search in results after Legal Instruments. */
  public static final Integer CRITERIA_LEGAL_TEXT = new Integer(2);

  /** Type from drop box.*/
  private String habitatType = null;
  /** Scientific name search string.*/
  private String searchString = null;
  /** Lagal text.*/
  private String legalText = null;

  /** Map the search criterias to SQL queries.*/
  private static Hashtable sqlMappings = null;
  /** Map the search criterias to human readable strings.*/
  private static Hashtable humanMappings = null;

  // Do the initializations before everything.
  static {
    _initHumanMappings();
    _initSQLMappings();
  }

  /**
   * Constructor for 'main' search criteria.
   * @param habitatType type of habitat (got from drop list).
   * @param searchString Searched habitat.
   * @param legalText Legal text (got from drop list).
   * @param queryType TYPE_XX defined above.
   */
  public LegalSearchCriteria(String habitatType, String searchString, String legalText, Integer queryType) {
    this.queryType = queryType;
    this.habitatType = habitatType;
    this.searchString = searchString;
    this.legalText = legalText;
  }

  /**
   * Constructor for search in results.
   * @param criteriaSearch Search string.
   * @param criteriaType Search type.
   * @param oper Relation operator between criteriaSearch and criteriaType.
   */
  public LegalSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
    this.criteriaSearch = criteriaSearch;
    this.criteriaType = criteriaType;
    this.oper = oper;
  }


  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer url = new StringBuffer();
    // If it's a main search criteria
    if (null != habitatType && null != searchString && null != legalText) {
      url.append(Utilities.writeURLParameter("habitatType", habitatType));
      url.append(Utilities.writeURLParameter("searchString", searchString));
      url.append(Utilities.writeURLParameter("legalText", legalText));
    }
    // If ti's a search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
      url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
      url.append(Utilities.writeURLParameter("oper", oper.toString()));
    }
    return url.toString();
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
    // If it's a main search criteria
    if (null != habitatType && null != searchString && null != legalText) {
      form.append(Utilities.writeFormParameter("habitatType", habitatType));
      form.append(Utilities.writeFormParameter("searchString", searchString));
      form.append(Utilities.writeFormParameter("legalText", legalText));
    }
    // If ti's a search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
      form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
      form.append(Utilities.writeFormParameter("oper", oper.toString()));
    }
    return form.toString();
  }

  /**
   * Transform this object into an SQL representation.
   * @return SQL string representing this object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();
    // If it's a main search criteria
    if (null != habitatType && null != searchString && null != legalText) {
      sql.append("(");
      sql.append(Utilities.prepareSQLOperator("A.SCIENTIFIC_NAME", searchString, Utilities.OPERATOR_CONTAINS));
      sql.append(" OR ");
      sql.append(Utilities.prepareSQLOperator("A.DESCRIPTION", searchString, Utilities.OPERATOR_CONTAINS));
      sql.append(")");
      // Depending on the search type, further refine the query
      if (0 == queryType.compareTo(TYPE_ANY_HAB_A_TEXT)) {
        sql.append(" AND C.NAME = '" + legalText + "'");
      }
      if (0 == queryType.compareTo(TYPE_A_HAB_A_TEXT)) {
        sql.append("AND A.EUNIS_HABITAT_CODE LIKE '" + habitatType + "%'");
        sql.append("AND C.NAME = '" + legalText + "'");
      }
      if (0 == queryType.compareTo(TYPE_A_HAB_ANY_TEXT)) {
        sql.append("AND A.EUNIS_HABITAT_CODE LIKE '" + habitatType + "%'");
      }
    }
    // If it's a search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
    }
    return sql.toString();
  }

  /** This method supplies a human readable string representation of this object. for example "Country is Romania".
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer human = new StringBuffer();
    // If it's a main search criteria
    if (null != habitatType && null != searchString && null != legalText) {
      human.append(Utilities.prepareHumanString((String) humanMappings.get(CRITERIA_SCIENTIFIC_NAME), searchString, Utilities.OPERATOR_CONTAINS));
    }
    // If ti's a search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      human.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return human.toString();
  }

  /** Init the mappings used to compose the SQL query. */
  private static void _initSQLMappings() {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable();
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "SCIENTIFIC_NAME");
    sqlMappings.put(CRITERIA_EUNIS_CODE, "EUNIS_HABITAT_CODE");
    sqlMappings.put(CRITERIA_LEGAL_TEXT, "C.NAME");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private static void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name");
    humanMappings.put(CRITERIA_EUNIS_CODE, "EUNIS code");
    humanMappings.put(CRITERIA_LEGAL_TEXT, "Legal text");
  }
}