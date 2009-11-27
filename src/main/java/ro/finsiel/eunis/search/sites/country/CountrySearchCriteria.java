package ro.finsiel.eunis.search.sites.country;

import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;

import java.util.Hashtable;

/**
 * Search criteria used for sites->country search.
 * @author finsiel
 */
public class CountrySearchCriteria extends SitesSearchCriteria {
  private String countryName = null;

  /** Mappings from search criteria -> SQL Statement. */
  private Hashtable sqlMappings = null;
  /** Mappings from search criteria -> Human language. */
  private Hashtable humanMappings = null;

  /**
   * Ctor for main search criteria.
   * @param countryName Country name.
   */
  public CountrySearchCriteria(String countryName) {
    _initHumanMappings();
    _initSQLMappings();
    this.countryName = countryName;
  }

  /**
   * Second constructor used to construct filter search criterias (search in results).
   * @param criteriaSearch Search string.
   * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
   * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
   */
  public CountrySearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable();
    sqlMappings.put(CRITERIA_ENGLISH_NAME, "C.NAME ");
    sqlMappings.put(CRITERIA_SOURCE_DB, "C.SOURCE_DB ");
    sqlMappings.put(CRITERIA_COUNTRY, "J.AREA_NAME_EN ");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_ENGLISH_NAME, "English name");
    humanMappings.put(CRITERIA_SOURCE_DB, "Database source");
    humanMappings.put(CRITERIA_COUNTRY, "Country");
  }


  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 1 params: county then this method should return:
   * country=XXX, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer res = new StringBuffer();
    if (null != countryName) {
      res.append(Utilities.writeURLParameter("countryName", countryName));
    }

    // Search in results
    if (null != criteriaSearch) res.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) res.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
    if (null != oper) res.append(Utilities.writeURLParameter("oper", oper.toString()));
    return res.toString();
  }

  /**
   * Transform this object into an SQL representation.
   * @return SQL string representing this object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();
    if (null != countryName) {
      if (!countryName.equalsIgnoreCase("any")) sql.append(" J.AREA_NAME_EN='" + countryName + "' ");
    }

    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      if (0 == criteriaType.compareTo(CRITERIA_SOURCE_DB)) {
        sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), SitesSearchUtility.translateSourceDBInvert(criteriaSearch), oper));
      } else {
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
    StringBuffer res = new StringBuffer();
    if (null != countryName) {
      res.append(Utilities.writeFormParameter("countryName", countryName));
    }

    // Search in results
    if (null != criteriaSearch) res.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) res.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
    if (null != oper) res.append(Utilities.writeFormParameter("oper", oper.toString()));
    return res.toString();
  }

  /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer ret = new StringBuffer();
    if (null != countryName) {
      if (countryName.equalsIgnoreCase("any"))
        ret.append(" any country ");
      else
        ret.append(" country " + countryName);
    }

    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      ret.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return ret.toString();
  }
}