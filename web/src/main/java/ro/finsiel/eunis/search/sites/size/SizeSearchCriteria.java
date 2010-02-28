package ro.finsiel.eunis.search.sites.size;

import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;

import java.util.Hashtable;

/**
 * Search criteria used for sites->size search.
 * @author finsiel
 */
public class SizeSearchCriteria extends SitesSearchCriteria {

  /**
   * Search by site area size.
   */
  public static final Integer SEARCH_AREA = new Integer(4);
  /**
   * Search by length.
   */
  public static final Integer SEARCH_LENGTH = new Integer(5);

  /** What do we search: size  / length / either. */
  private Integer searchType = null;
  /** Relation between scientificName or vernacularName (starts, contains, is).*/
  private Integer relationOp = null;

  private String searchString = null;
  private String searchStringMin = null;
  private String searchStringMax = null;

  /** Filters applied only to main searches. */
  private String country = null;
  private String yearMin = null;
  private String yearMax = null;

  /** Mappings from search criteria -> SQL Statement. */
  private Hashtable sqlMappings = null;
  /** Mappings from search criteria -> Human language. */
  private Hashtable humanMappings = null;


  /**
   * Ctor for main search criteria.
   * @param searchType Type of search (area or length).
   * @param relationOp Relation operator.
   * @param searchString Searched string.
   * @param searchStringMin Minimum size (when using between).
   * @param searchStringMax Maximum size when using between).
   * @param country Country filter.
   * @param minDesignationDate Minimum designation year.
   * @param maxDesignationDate Maximum designation year.
   */
  public SizeSearchCriteria(Integer searchType, Integer relationOp, String searchString, String searchStringMin,
                            String searchStringMax, String country, String minDesignationDate, String maxDesignationDate) {
    _initHumanMappings();
    _initSQLMappings();
    this.searchType = searchType;
    this.relationOp = relationOp;
    this.searchString = searchString;
    this.searchStringMin = searchStringMin;
    this.searchStringMax = searchStringMax;
    this.yearMin = minDesignationDate;
    this.yearMax = maxDesignationDate;
    this.country = country;
  }

  /**
   * Second constructor used to construct filter search criterias (search in results).
   * @param criteriaSearch Search string.
   * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
   * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
   */
  public SizeSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
    sqlMappings.put(CRITERIA_SOURCE_DB, "A.SOURCE_DB");
    sqlMappings.put(CRITERIA_ENGLISH_NAME, "A.NAME ");
    sqlMappings.put(CRITERIA_AREA, "A.AREA ");
    sqlMappings.put(CRITERIA_LENGTH, "A.LENGTH ");
    sqlMappings.put(CRITERIA_COUNTRY, "C.AREA_NAME_EN ");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_SOURCE_DB, "Database source");
    humanMappings.put(CRITERIA_ENGLISH_NAME, "Site Name");
    humanMappings.put(CRITERIA_AREA, "Area size ");
    humanMappings.put(CRITERIA_LENGTH, "Length ");
    humanMappings.put(CRITERIA_COUNTRY, "Country ");
  }


  /**
   * This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer res = new StringBuffer();
    if (null != searchType) res.append(Utilities.writeURLParameter("searchType", searchType.toString()));
    if (null != searchString) res.append(Utilities.writeURLParameter("searchString", searchString));
    if (null != relationOp) res.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
    if (null != searchStringMin) res.append(Utilities.writeURLParameter("searchStringMin", searchStringMin));
    if (null != searchStringMax) res.append(Utilities.writeURLParameter("searchStringMax", searchStringMax));
    if (null != country) res.append(Utilities.writeURLParameter("country", country));
    if (null != yearMin) res.append(Utilities.writeURLParameter("yearMin", yearMin));
    if (null != yearMax) res.append(Utilities.writeURLParameter("yearMax", yearMax));
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
    //System.out.println("searchString = " + searchString);
    if (((null != searchString) || (null != searchStringMin && null != searchStringMax)) && null != relationOp) {
      sql.append("(");
      if (0 == SEARCH_AREA.compareTo(searchType)) {
        sql.append(Utilities.prepareSQLOperator("A.AREA", searchString, searchStringMin, searchStringMax, relationOp));
      }
      if (0 == SEARCH_LENGTH.compareTo(searchType)) {
        sql.append(Utilities.prepareSQLOperator("A.LENGTH", searchString, searchStringMin, searchStringMax, relationOp));
      }
      sql.append(")");
      if (null != country) {
        //AND C.AREA_NAME_EN='FRANCE'
        sql.append(" AND (C.AREA_NAME_EN='" + country + "')");
      }
      if (null != yearMin) {
        sql.append(" AND (LENGTH(DESIGNATION_DATE) > 0) ");
        sql.append(" AND (CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(designation_date,4),''), " +
                "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''), " +
                "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''), " +
                "IF(A.source_db='EMERALD',right(designation_date,4),''), " +
                "IF(A.source_db='DIPLOMA',right(designation_date,4),''), " +
                "IF(A.source_db='NATURA2000',right(designation_date,4),''), " +
                "IF(A.source_db='CORINE',right(designation_date,4),''), " +
                "IF(A.source_db='NATURENET',right(designation_date,4),'')) AS SIGNED) >= " + yearMin + ") " +
                " AND A.DESIGNATION_DATE IS NOT NULL" +
                " AND A.DESIGNATION_DATE <> ''");
      }
      if (null != yearMax) {
        sql.append(" AND (LENGTH(DESIGNATION_DATE) > 0) ");
        sql.append(" AND (CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(designation_date,4),''), " +
                "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''), " +
                "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''), " +
                "IF(A.source_db='EMERALD',right(designation_date,4),''), " +
                "IF(A.source_db='DIPLOMA',right(designation_date,4),''), " +
                "IF(A.source_db='NATURA2000',right(designation_date,4),''), " +
                "IF(A.source_db='CORINE',right(designation_date,4),''), " +
                "IF(A.source_db='NATURENET',right(designation_date,4),'')) AS SIGNED) <= " + yearMax + ") " +
                " AND A.DESIGNATION_DATE IS NOT NULL" +
                " AND A.DESIGNATION_DATE <> ''");
      }
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
    if (null != searchType) res.append(Utilities.writeFormParameter("searchType", searchType.toString()));
    if (null != searchString) res.append(Utilities.writeFormParameter("searchString", searchString));
    if (null != relationOp) res.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
    if (null != searchStringMin) res.append(Utilities.writeFormParameter("searchStringMin", searchStringMin));
    if (null != searchStringMax) res.append(Utilities.writeFormParameter("searchStringMax", searchStringMax));
    if (null != country) res.append(Utilities.writeFormParameter("country", country));
    if (null != yearMin) res.append(Utilities.writeFormParameter("yearMin", yearMin));
    if (null != yearMax) res.append(Utilities.writeFormParameter("yearMax", yearMax));
    // Search in results
    if (null != criteriaSearch) res.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
    if (null != criteriaType) res.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
    if (null != oper) res.append(Utilities.writeFormParameter("oper", oper.toString()));
    return res.toString();
  }

  /**
   * This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer ret = new StringBuffer();
    if (((null != searchString) || (null != searchStringMin && null != searchStringMax)) && null != relationOp) {
      if (0 == SEARCH_AREA.compareTo(searchType))
        ret.append(Utilities.prepareHumanString("size <strong>" + (relationOp.intValue() == Utilities.OPERATOR_IS.intValue() ? "" : "is"), searchString, searchStringMin,
                searchStringMax, relationOp) + "</strong> ha");

      if (0 == SEARCH_LENGTH.compareTo(searchType))
        ret.append(Utilities.prepareHumanString("length <strong>" + (relationOp.intValue() == Utilities.OPERATOR_IS.intValue() ? "" : "is"), searchString, searchStringMin,
                searchStringMax, relationOp) + "</strong> m");
    }
    if (null != country) {
      //AND C.AREA_NAME_EN='FRANCE'
      ret.append(", in country <strong>" + country + "</strong>");
    }
    if ( yearMin != null && yearMax != null )
    {
      ret.append( ", and year between: <strong>" + yearMin + "</strong> and <strong>" + yearMax + "</strong>");
    }
    else
    {
      if (null != yearMin)
      {
        ret.append(", and year greater than <strong>" + yearMin + "</strong>");
      }
      if (null != yearMax)
      {
        ret.append(", and year smaller that <strong>" + yearMax + "</strong>");
      }
    }
    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      ret.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return ret.toString();
  }
}