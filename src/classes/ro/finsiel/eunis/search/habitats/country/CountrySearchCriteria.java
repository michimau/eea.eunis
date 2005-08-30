/**
 * Date: Apr 23, 2003
 * Time: 10:07:02 AM
 */
package ro.finsiel.eunis.search.habitats.country;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.jrfTables.habitats.country.CountryDomain;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.Chm62edtBiogeoregionPersist;

import java.util.Hashtable;

/**
 * Search criteria used for habitats->country.
 * @author finsiel
 */
public class CountrySearchCriteria extends AbstractSearchCriteria {
  /** Used for search in results, to filter after the level. */
  public static final Integer CRITERIA_LEVEL = new Integer(0);
  /** Used for search in results, to filter after the code. */
  public static final Integer CRITERIA_CODE_EUNIS = new Integer(1);
  /** Used for search in results, to filter after the scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(2);
  /** Used for search in results, to filter after the vernacular name.*/
  public static final Integer CRITERIA_NAME = new Integer(3);
  /** Used for search in results, to filter after the ANNEX I code.*/
  public static final Integer CRITERIA_CODE_ANNEX = new Integer(4);

  /** Searched string. */
  private String country = null;
  private String region = null;
  /** Where to search: EUNIS or ANNEX I. */
  private Integer database = null;
  /** SQL mappings for search in results. */
  private Hashtable sqlMappings = null;
  /** Mapping to human language. */
  private Hashtable humanMappings = null;

  private boolean isMainSearch = false;

  /**
   * Ctor. for main search criteria.
   * @param country Country name.
   * @param region Region name.
   * @param database Database.
   */
  public CountrySearchCriteria(String country, String region, Integer database) {
    _initHumanMappings(database);
    _initSQLMappings(database);
    this.country = country;
    this.region = region;
    this.database = database;
    isMainSearch = true;
  }

  /**
   * Ctor. for search in results.
   * @param criteriaSearch Search string.
   * @param criteriaType Type of search.
   * @param oper Relation operator.
   * @param database database.
   */
  public CountrySearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper, Integer database) {
    _initHumanMappings(database);
    _initSQLMappings(database);
    this.criteriaSearch = criteriaSearch;
    this.criteriaType = criteriaType;
    this.oper = oper;
    this.database = database;
    isMainSearch = false;
  }

  /**
   * Init the mappings used to compose the SQL query.
   * @param database Not used.
   */
  private void _initSQLMappings(Integer database) {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable(5);

    sqlMappings.put(CRITERIA_CODE_EUNIS, "A.EUNIS_HABITAT_CODE ");
    sqlMappings.put(CRITERIA_CODE_ANNEX, "A.CODE_2000 ");
    sqlMappings.put(CRITERIA_LEVEL, "A.LEVEL ");
    sqlMappings.put(CRITERIA_NAME, "A.DESCRIPTION ");
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "A.SCIENTIFIC_NAME ");
  }

  /**
   * Init the mappings used to compose the SQL query.
   * @param database Not used.
   */
  private void _initHumanMappings(Integer database) {
    if (null != humanMappings) return;
    humanMappings = new Hashtable(5);

    humanMappings.put(CRITERIA_CODE_EUNIS, "EUNIS code ");
    humanMappings.put(CRITERIA_CODE_ANNEX, "ANNEX I code ");
    humanMappings.put(CRITERIA_LEVEL, "Habitat level ");
    humanMappings.put(CRITERIA_NAME, "English name ");
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");
  }


  /**
   * This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer url = new StringBuffer();
    if (null != database) url.append(Utilities.writeURLParameter("database", database));
    if (isMainSearch()) {
      if (null != country) url.append(Utilities.writeURLParameter("country", country));
      if (null != region) url.append(Utilities.writeURLParameter("region", region));
    } else {
      // Search in results
      if (null != criteriaSearch) url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
      if (null != criteriaType) url.append(Utilities.writeURLParameter("criteriaType", criteriaType));
      if (null != oper) url.append(Utilities.writeURLParameter("oper", oper));
    }
    return url.toString();
  }

  /**
   * Transform this object into an SQL representation.
   * @return SQL string representing this object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();
    // Normal search
    if (isMainSearch()) {
      boolean addANDOperator = false;
      if (!country.equalsIgnoreCase("*") && !country.equalsIgnoreCase("")) {
        Chm62edtCountryPersist _country = CountryUtil.findCountry(country);
        if (null != _country) {
          sql.append(" B.ID_GEOSCOPE='" + _country.getIdGeoscope() + "' ");
          addANDOperator = true;
        }
      }
      if (!region.equalsIgnoreCase("*") && !region.equalsIgnoreCase("")) {
        Chm62edtBiogeoregionPersist _region = CountryUtil.findRegionIDGeoscope(region);
        if (null != _region) {
          if (addANDOperator) sql.append(" AND ");
          sql.append(" B.ID_GEOSCOPE_LINK='" + _region.getIdGeoscope() + "'");
          if (addANDOperator) {
            sql.insert(0, "(");
            sql.append(" ) ");
          }
        }
      }
    }
    // Search in results
    if (!isMainSearch()) {
      sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
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
    StringBuffer form = new StringBuffer();
    if (isMainSearch()) {
      if (null != database) form.append(Utilities.writeFormParameter("database", database));
      if (null != country) form.append(Utilities.writeFormParameter("country", country));
      if (null != region) form.append(Utilities.writeFormParameter("region", region));
    } else {
      // Search in results
      if (null != criteriaSearch) form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
      if (null != criteriaType) form.append(Utilities.writeFormParameter("criteriaType", criteriaType));
      if (null != oper) form.append(Utilities.writeFormParameter("oper", oper));
    }
    return form.toString();
  }

  /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer human = new StringBuffer();
    if (isMainSearch()) {
      if (region.equalsIgnoreCase("*") || region.equalsIgnoreCase("")) {
        human.append(" from all biogeoregions ");
      } else {
        human.append("from biogeoregion " + region);
      }
      human.append(" present in ");
      if (country.equalsIgnoreCase("*") || country.equalsIgnoreCase("")) {
        human.append(" all countries ");
      } else {
        human.append(country);
      }
    } else {
      human.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return human.toString();
  }

  /**
   * Getter for country property.
   * @return country.
   */
  public String getCountry() {
    return country;
  }

  /**
   * Getter for region property.
   * @return region.
   */
  public String getRegion() {
    return region;
  }

  /**
   * This method specifies if this search object is a main search (from main search page) or a search in results.
   * @return true if it's a main search.
   */
  public boolean isMainSearch() {
    return isMainSearch;
  }
}
