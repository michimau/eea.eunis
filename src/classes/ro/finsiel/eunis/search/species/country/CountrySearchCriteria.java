package ro.finsiel.eunis.search.species.country;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;

/**
 * This class is used to define an search criteria for the Species->Country/Region type of search.
 * As we already know, this type of search requires to query database for species located in a countryIDGeoscope/regionIDGeoscope pair.
 * Tough either countryIDGeoscope or regionIDGeoscope could be set to the value of 'any' (but not both at the same time) so basically when
 * you do such a search you provide objects of this type to the jrf table wrapper.
 * Note: URL Representation of this object is country=CountryIDGeoscope&region=RegionIDGeoscope...
 * @author finsiel
 */
public class CountrySearchCriteria extends AbstractSearchCriteria {
  /** Defines a search after Country name. */
  public static final Integer CRITERIA_COUNTRY_NAME = new Integer(0);
  /** Defines a search after Group. */
  public static final Integer CRITERIA_GROUP = new Integer(1);
  /** Defines a search after Order.  */
  public static final Integer CRITERIA_ORDER = new Integer(2);
  /** Defines a search after Family. */
  public static final Integer CRITERIA_FAMILY = new Integer(3);
  /** Defines a search after Scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(4);
  /** Defines a search after Country ID Geoscope. */
  public static final Integer CRITERIA_COUNTRY_GEOSCOPE = new Integer(5);
  /** Defines a search after Region ID Geoscope. */
  public static final Integer CRITERIA_REGION_GEOSCOPE = new Integer(6);
  /** Defines a search after Biogeoregion name. */
  public static final Integer CRITERIA_BIOGEOREGION_NAME = new Integer(7);
  /** Defines a search after Country ID Geoscope *AND* Region ID Geoscope. */
  public static final Integer CRITERIA_BOTH_COUNTRY_REGION = new Integer(8);

  /** Map the search criterias to SQL queries. */
  private static Hashtable sqlMappings = null;
  /** Map the search criterias to human readable strings. */
  private static Hashtable humanMappings = null;

  /** Used to search after country/region. */
  private String countryIDGeoscope = "";
  /** Used to search after country/region. */
  private String regionIDGeoscope = "";
  /** Country name in human language. */
  private String countryName = "";
  /** Region name in human language.*/
  private String regionName = "";


  /** Counstruct an new object, providing countryIDGeoscope / regionIDGeoscope pair. It is advisable that you *do not*
   * pass null values for either countryIDGeoscope or regionIDGeoscope.
   * @param countryIDGeoscope Country name (could be any name from CHM62EDT_COUNTRY.AREA_NAME_EN). You can pass
   * 'any' here so that all countries should be searched.
   * @param regionIDGeoscope Biogeoregion name (as stated in CHM62EDT_BIOGEOREGION.NAME). You can pass
   * 'any' here so that all biogeoregions should be searched.
   * Note: Please note, again, that you should not pass here both countryIDGeoscope & regionIDGeoscope to value
   * 'any' as search will return 0 results. (The search is not done).
   * @param countryName Name of the country.
   * @param regionName Bogeographic region name.
   * @deprecated by CountrySearchCriteria(String, String, String, String, Integer)
   */
  public CountrySearchCriteria(String countryIDGeoscope, String regionIDGeoscope, String countryName, String regionName) {
    _initSQLMappings();
    _initHumanMappings();
    this.countryIDGeoscope = countryIDGeoscope;
    this.regionIDGeoscope = regionIDGeoscope;
    this.criteriaType = CRITERIA_REGION_GEOSCOPE;
    this.countryName = countryName;
    this.regionName = regionName;
  }

  /** Counstruct an new object, providing countryIDGeoscope / regionIDGeoscope pair. It is advisable that you *do not*
   * pass null values for either countryIDGeoscope or regionIDGeoscope.
   * @param countryIDGeoscope Country name (could be any name from CHM62EDT_COUNTRY.AREA_NAME_EN). You can pass
   * 'any' here so that all countries should be searched.
   * @param regionIDGeoscope Biogeoregion name (as stated in CHM62EDT_BIOGEOREGION.NAME). You can pass
   * 'any' here so that all biogeoregions should be searched.
   * @param countryName Country name,
   * @param regionName Biogeographic region name.
   * @param criteriaType Sets the criteriaType used to do the search
   * Note: Please note, again, that you should not pass here both countryIDGeoscope & regionIDGeoscope to value
   * 'any' as search will return 0 results. (The search is not done).
   */
  public CountrySearchCriteria(String countryIDGeoscope, String regionIDGeoscope, String countryName, String regionName, Integer criteriaType) {
    _initSQLMappings();
    _initHumanMappings();
    this.countryIDGeoscope = countryIDGeoscope;
    this.regionIDGeoscope = regionIDGeoscope;
    this.criteriaType = criteriaType;
    this.countryName = countryName;
    this.regionName = regionName;
  }

  /** This constructor should be used for search in results, since it gives the other criterias after which search will
   * be done.
   * @param criteriaSearch Name of the searched string...
   * @param oper Type of search (AbstractSearchCriteria.OPERATOR_IS/STARTS/CONTAINS
   * @param criteriaType The column searched: CountrySearchCriteria.CRITERIA_COUNTRY/GROUP/ORDER/FAMILY/SCIENTIFIC_NAME
   */
  public CountrySearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
    _initSQLMappings();
    _initHumanMappings();
    this.criteriaSearch = criteriaSearch;
    this.oper = oper;
    this.criteriaType = criteriaType;
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initSQLMappings() {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable(7);
    sqlMappings.put(CRITERIA_COUNTRY_NAME, "AREA_NAME_EN");
    sqlMappings.put(CRITERIA_FAMILY, "E.NAME");
    sqlMappings.put(CRITERIA_GROUP, "D.COMMON_NAME");
    sqlMappings.put(CRITERIA_ORDER, "F.NAME");
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME");
    sqlMappings.put(CRITERIA_COUNTRY_GEOSCOPE, "B.ID_GEOSCOPE");
    sqlMappings.put(CRITERIA_REGION_GEOSCOPE, "B.ID_GEOSCOPE_LINK");
    sqlMappings.put(CRITERIA_BIOGEOREGION_NAME, "NAME");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable(5);
    humanMappings.put(CRITERIA_COUNTRY_NAME, "Country");
    humanMappings.put(CRITERIA_FAMILY, "Family ");
    humanMappings.put(CRITERIA_GROUP, "Group");
    humanMappings.put(CRITERIA_ORDER, "Order");
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name");
    humanMappings.put(CRITERIA_BIOGEOREGION_NAME, "Biogeoregion name");
  }

  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer url = new StringBuffer();
    if ((0 == criteriaType.compareTo(CRITERIA_COUNTRY_GEOSCOPE)) || 0 == criteriaType.compareTo(CRITERIA_REGION_GEOSCOPE) || 0 == criteriaType.compareTo(CRITERIA_BOTH_COUNTRY_REGION)) {
      if ((countryIDGeoscope.length() > 0) && (regionIDGeoscope.length() > 0)) {
        url.append("country=" + countryIDGeoscope);
        url.append("&region=" + regionIDGeoscope);
      }
    } else {
      if ((criteriaSearch.length() > 0) && (null != criteriaType) && (null != oper)) {
        url.append("criteriaSearch=" + criteriaSearch);
        url.append("&criteriaType=" + criteriaType);
        url.append("&oper=" + oper);
      }
    }
    return url.toString();
  }

  /**
   * Transform this object into an SQL representation.
   * @return SQL string representing this object.
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();
    if (0 == criteriaType.compareTo(CRITERIA_REGION_GEOSCOPE)) {
      if ((countryIDGeoscope.length() > 0) && (regionIDGeoscope.length() > 0)) {
        sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_REGION_GEOSCOPE), regionIDGeoscope, Utilities.OPERATOR_IS));
      }
    } else if (0 == criteriaType.compareTo(CRITERIA_COUNTRY_GEOSCOPE)) {
      if ((countryIDGeoscope.length() > 0) && (regionIDGeoscope.length() > 0)) {
        sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_COUNTRY_GEOSCOPE), countryIDGeoscope, Utilities.OPERATOR_IS));
      }
    } else if (0 == criteriaType.compareTo(CRITERIA_BOTH_COUNTRY_REGION)) {
      if ((countryIDGeoscope.length() > 0) && (regionIDGeoscope.length() > 0)) {
        sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_COUNTRY_GEOSCOPE), countryIDGeoscope, Utilities.OPERATOR_IS));
        sql.append(" AND ");
        sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_REGION_GEOSCOPE), regionIDGeoscope, Utilities.OPERATOR_IS));
      }
    } else {
      sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
    }
    return sql.toString();
  }

  /**
   * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
   * to say is that I can say about an object for example:<br />
   * < INPUT type='hidden" name="searchCriteria" value="natrix">
   * < INPUT type='hidden" name="oper" value="1">
   * < INPUT type='hidden" name="searchType" value="1">.
   * @return Web page FORM representation of the object.
   */
  public String toFORMParam() {
    StringBuffer form = new StringBuffer();
    if ((0 == criteriaType.compareTo(CRITERIA_COUNTRY_GEOSCOPE)) || 0 == criteriaType.compareTo(CRITERIA_REGION_GEOSCOPE) ||
            0 == criteriaType.compareTo(CRITERIA_BOTH_COUNTRY_REGION)) {
      if ((countryIDGeoscope.length() > 0) && (regionIDGeoscope.length() > 0)) {
        form.append(Utilities.writeFormParameter("country", countryIDGeoscope));
        form.append(Utilities.writeFormParameter("region", regionIDGeoscope));
      }
    } else {
      if ((criteriaSearch.length() > 0) && (null != criteriaType) && (null != oper)) {
        form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
        form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
        form.append(Utilities.writeFormParameter("oper", oper.toString()));
      }
    }
    return form.toString();
  }

  /** An human readable representation of this object.
   * @return Representation of this object
   */
  public String toHumanString() {
    StringBuffer str = new StringBuffer();
    boolean addComma = false;
    if (null != countryIDGeoscope && null != regionIDGeoscope &&
            !countryIDGeoscope.equals("") && !regionIDGeoscope.equals("")) {
      str.append("Country is " + countryName + ", Biogeographic region is " + regionName);
    } else {
      if (null != countryIDGeoscope) {
        if (!countryIDGeoscope.equals("")) {
          str.append("Country is " + countryName);
          addComma = true;
        }
      }
      if (null != regionIDGeoscope) {
        if (!regionIDGeoscope.equals("")) {
          if (addComma) str.append(", ");
          str.append("Biogeographic region is " + regionName);
        }
      }
    }
    if (null != criteriaSearch) {
      if (!criteriaSearch.equals("")) {
        str.append(Utilities.prepareHumanString(humanMappings.get(criteriaType).toString(), criteriaSearch, oper));
      }
    }
    return str.toString();
  }

  /**
   * Test method.
   * @param args Command line args
   */
  public static void main(String[] args) {
    CountrySearchCriteria criteria = new CountrySearchCriteria("any", Utilities.OPERATOR_STARTS, CountrySearchCriteria.CRITERIA_COUNTRY_NAME);
//    System.out.println(criteria.toSQL());
  }
}