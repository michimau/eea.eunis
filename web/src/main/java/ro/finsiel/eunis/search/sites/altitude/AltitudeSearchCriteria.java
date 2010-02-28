package ro.finsiel.eunis.search.sites.altitude;

import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;

import java.util.Hashtable;

/**
 * Search criteria used for sites->altitude search.
 * @author finsiel
 */
public class AltitudeSearchCriteria extends SitesSearchCriteria {
  /** Altitude.*/
  private String altitude1 = null;
  private String altitude2 = null;
  /** Relation between scientificName or vernacularName (starts, contains, is).*/
  private Integer relationOp = null;
  private String altitude21 = null;
  private String altitude22 = null;
  /** Relation between scientificName or vernacularName (starts, contains, is).*/
  private Integer relationOp2 = null;
  private String altitude31 = null;
  private String altitude32 = null;
  /** Relation between scientificName or vernacularName (starts, contains, is).*/
  private Integer relationOp3 = null;

  private String country = null;

  /** Mappings from search criteria -> SQL Statement. */
  private Hashtable sqlMappings = null;
  /** Mappings from search criteria -> Human language. */
  private Hashtable humanMappings = null;

  /**
   * Ctor for main search criteria.
   * @param altitude1 Minimum mean altitude.
   * @param altitude2 Maximum mean altitude.
   * @param relationOp Relation operator for mean altitude
   * @param altitude21 Minimum min altitude.
   * @param altitude22 Maximum min altitude.
   * @param relationOp2 Relation operator for min altitude.
   * @param altitude31 Minimum max altitude.
   * @param altitude32 Maximum max altitude.
   * @param relationOp3 Relation operator for altitude.
   * @param country Country filter.
   */
  public AltitudeSearchCriteria(String altitude1, String altitude2, Integer relationOp, String altitude21, String altitude22, Integer relationOp2, String altitude31, String altitude32, Integer relationOp3, String country) {
    _initHumanMappings();
    _initSQLMappings();
    this.altitude1 = altitude1;
    this.altitude2 = altitude2;
    this.relationOp = relationOp;
    this.altitude21 = altitude21;
    this.altitude22 = altitude22;
    this.relationOp2 = relationOp2;
    this.altitude31 = altitude31;
    this.altitude32 = altitude32;
    this.relationOp3 = relationOp3;
    this.country = country;
  }

  /**
   * Second constructor used to construct filter search criterias (search in results).
   * @param criteriaSearch Search string.
   * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
   * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
   */
  public AltitudeSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
    sqlMappings = new Hashtable(7);
    sqlMappings.put(CRITERIA_ALTITUDE_MEAN, "C.ALT_MEAN ");
    sqlMappings.put(CRITERIA_ALTITUDE_MIN, "C.ALT_MIN ");
    sqlMappings.put(CRITERIA_ALTITUDE_MAX, "C.ALT_MAX ");
    sqlMappings.put(CRITERIA_ENGLISH_NAME, "C.NAME ");
    sqlMappings.put(CRITERIA_SOURCE_DB, "C.SOURCE_DB ");
    sqlMappings.put(CRITERIA_COUNTRY, "J.AREA_NAME_EN");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable(7);
    humanMappings.put(CRITERIA_ENGLISH_NAME, "Site name");
    humanMappings.put(CRITERIA_SOURCE_DB, "Database source");
    humanMappings.put(CRITERIA_ALTITUDE_MEAN, "Mean Altitude");
    humanMappings.put(CRITERIA_ALTITUDE_MIN, "Minimum Altitude");
    humanMappings.put(CRITERIA_ALTITUDE_MAX, "Maximum Altitude");
    humanMappings.put(CRITERIA_COUNTRY, "Country");
  }


  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer res = new StringBuffer();
    if (null != altitude1 && null != relationOp) {
      res.append(Utilities.writeURLParameter("altitude1", altitude1));
      res.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
    }
    if (null != altitude2) {
      //altitude between
      res.append(Utilities.writeURLParameter("altitude2", altitude2));
    }

    if (null != altitude21 && null != relationOp2) {
      res.append(Utilities.writeURLParameter("altitude21", altitude21));
      res.append(Utilities.writeURLParameter("relationOp2", relationOp2.toString()));
    }
    if (null != altitude22) {
      //altitude between
      res.append(Utilities.writeURLParameter("altitude22", altitude22));
    }

    if (null != altitude31 && null != relationOp3) {
      res.append(Utilities.writeURLParameter("altitude31", altitude31));
      res.append(Utilities.writeURLParameter("relationOp3", relationOp3.toString()));
    }
    if (null != altitude32) {
      //altitude between
      res.append(Utilities.writeURLParameter("altitude32", altitude32));
    }

    if (null != country) res.append(Utilities.writeURLParameter("country", country));
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
    if (null != altitude1 && null != relationOp) {
      if (null != altitude2) {
        sql.append(" C.ALT_MEAN >= " + altitude1 + " AND C.ALT_MEAN <= " + altitude2);
      } else {
        sql.append(Utilities.prepareSQLOperator(" C.ALT_MEAN", altitude1, relationOp));
      }
      sql.append((sql.length() > 0 ? " AND " : "") + "IF(C.SOURCE_DB = 'Corine',C.ALT_MEAN,'')<> -99");
    }


    if (null != altitude21 && null != relationOp2) {
      if (null != altitude22) {
        sql.append((sql.length() > 0 ? " AND " : "") + " C.ALT_MIN >= " + altitude21 + " AND C.ALT_MIN <= " + altitude22);
      } else {
        sql.append(Utilities.prepareSQLOperator((sql.length() > 0 ? " AND " : "") + " C.ALT_MIN", altitude21, relationOp2));
      }
      sql.append((sql.length() > 0 ? " AND " : "") + "IF(C.SOURCE_DB = 'Corine',C.ALT_MIN,'')<> -99 ");
    }


    if (null != altitude31 && null != relationOp3) {
      if (null != altitude32) {
        sql.append((sql.length() > 0 ? " AND " : "") + " C.ALT_MAX >= " + altitude31 + " AND C.ALT_MAX <= " + altitude32);
      } else {
        sql.append(Utilities.prepareSQLOperator((sql.length() > 0 ? " AND " : "") + " C.ALT_MAX", altitude31, relationOp3));
      }
      sql.append((sql.length() > 0 ? " AND " : "") + "IF(C.SOURCE_DB = 'Corine',C.ALT_MAX,'')<> -99");
    }


    if (null != country) {
      sql.append(Utilities.prepareSQLOperator((sql.length() > 0 ? " AND " : "") + "J.AREA_NAME_EN", country, Utilities.OPERATOR_IS));
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
    if (null != altitude1 && null != relationOp) {
      res.append(Utilities.writeFormParameter("altitude1", altitude1));
      res.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
    }
    if (null != altitude2) {
      //altitude between
      res.append(Utilities.writeFormParameter("altitude2", altitude2));
    }

    if (null != altitude21 && null != relationOp2) {
      res.append(Utilities.writeFormParameter("altitude21", altitude21));
      res.append(Utilities.writeFormParameter("relationOp2", relationOp2.toString()));
    }
    if (null != altitude22) {
      //altitude between
      res.append(Utilities.writeFormParameter("altitude22", altitude22));
    }

    if (null != altitude31 && null != relationOp3) {
      res.append(Utilities.writeFormParameter("altitude31", altitude31));
      res.append(Utilities.writeFormParameter("relationOp3", relationOp3.toString()));
    }
    if (null != altitude32) {
      //altitude between
      res.append(Utilities.writeFormParameter("altitude32", altitude32));
    }

    if (null != country) {
      res.append(Utilities.writeFormParameter("country", country));
    }

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
    if (null != altitude1 && null != relationOp) {
      if (null != altitude2) {
        ret.append(" mean altitude is between <strong>" + altitude1 + "</strong> (m) and <strong>" + altitude2 + "</strong> (m)");
      } else {
        ret.append(Utilities.prepareHumanString("mean altitude <strong>", altitude1, relationOp) + "</strong> (m)");
      }
    }

    if (null != altitude21 && null != relationOp2) {
      if (null != altitude22) {
        ret.append((ret.length() > 0 ? " AND " : "") + " minimum altitude is between <strong>" + altitude21 + "</strong> (m) and <strong>" + altitude22 + "</strong> (m)");
      } else {
        ret.append(Utilities.prepareHumanString((ret.length() > 0 ? " AND " : "") + " minimum altitude <strong>", altitude21, relationOp2) + "</strong> (m)");
      }
    }

    if (null != altitude31 && null != relationOp3) {
      if (null != altitude32) {
        ret.append((ret.length() > 0 ? " AND " : "") + " maximum altitude is between <strong>" + altitude31 + "</strong> (m) and <strong>" + altitude32 + "</strong> (m)");
      } else {
        ret.append(Utilities.prepareHumanString((ret.length() > 0 ? " AND " : "") + " maximum altitude <strong>", altitude31, relationOp3) + "</strong> (m)");
      }
    }

    if (country != null) ret.append((ret.length() > 0 ? " AND " : "") + " country is <strong>" + country + "</strong>");

    // Search in results
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      ret.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return ret.toString();
  }
}
