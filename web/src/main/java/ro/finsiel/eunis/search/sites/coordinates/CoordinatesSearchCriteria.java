package ro.finsiel.eunis.search.sites.coordinates;


import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;

import java.util.Hashtable;


/**
 * Search criteria used for sites->coordinates search.
 * @author finsiel
 */
public class CoordinatesSearchCriteria extends SitesSearchCriteria {
    private float longMin = 0;
    private float longMax = 0;
    private float latMin = 0;
    private float latMax = 0;

    /** Filters applied only to main searches. */
    private String country = null;
    private Integer yearMin = null;
    private Integer yearMax = null;

    /** Mappings from search criteria -> SQL Statement. */
    private Hashtable sqlMappings = null;

    /** Mappings from search criteria -> Human language. */
    private Hashtable humanMappings = null;

    private boolean isMainSearch = false;

    /**
     * Ctor for main search criteria.
     * @param longMin Minimum longitude in minutes.
     * @param longMax Maximum longitude in minutes.
     * @param latMin Minimum latitude in minutes.
     * @param latMax Maximum latitude in minutes.
     * @param yearMin Minimum designation year.
     * @param yearMax Maximum designation year.
     * @param country Country filter.
     */
    public CoordinatesSearchCriteria(float longMin, float longMax, float latMin, float latMax, Integer yearMin, Integer yearMax, String country) {
        this.longMin = longMin;
        this.longMax = longMax;
        this.latMin = latMin;
        this.latMax = latMax;
        this.yearMin = yearMin;
        this.yearMax = yearMax;
        this.country = country;
        isMainSearch = true;
        _initHumanMappings();
        _initSQLMappings();
    }

    /**
     * Second constructor used to construct filter search criterias (search in results).
     * @param criteriaSearch Search string.
     * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
     * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
     */
    public CoordinatesSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
        _initHumanMappings();
        _initSQLMappings();
        isMainSearch = false;
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            this.criteriaSearch = criteriaSearch;
            this.criteriaType = criteriaType;
            this.oper = oper;
        }
    }

    /** This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer res = new StringBuffer();

        if (isMainSearch) {
            res.append(Utilities.writeURLParameter("longMin", longMin));
            res.append(Utilities.writeURLParameter("longMax", longMax));
            res.append(Utilities.writeURLParameter("latMin", latMin));
            res.append(Utilities.writeURLParameter("latMax", latMax));
        }

        if (null != country) {
            // AND C.AREA_NAME_EN='FRANCE'
            res.append(Utilities.writeURLParameter("country", country));
        }
        if ((null != yearMin && yearMin.intValue() > -1)) {
            // AND LEFT(A.DESIGNATION_DATE,4)>=1997 AND LEFT(A.DESIGNATION_DATE,4)<=2000
            res.append(Utilities.writeURLParameter("yearMin", yearMin));
        }
        if ((null != yearMax && yearMax.intValue() > -1)) {
            res.append(Utilities.writeURLParameter("yearMax", yearMax));
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

        if (isMainSearch) {
            sql.append(" ( (1 = 1) ");
            sql.append(" AND ( A.LONGITUDE >= " + longMin + " AND A.LONGITUDE <= " + longMax + " ) ");
            sql.append(" AND ( A.LATITUDE >= " + latMin + " AND A.LATITUDE <= " + latMax + " ) ");
            sql.append(" AND A.LONGITUDE <> 0 AND A.LONGITUDE IS NOT NULL ");
            sql.append(" AND A.LATITUDE <> 0 AND A.LATITUDE IS NOT NULL ");
            sql.append(")");
            if (null != country) {
                // AND C.AREA_NAME_EN='FRANCE'
                sql.append(" AND (C.AREA_NAME_EN='" + country + "')");
            }
            if (null != yearMin && yearMin.intValue() > -1) {
                sql.append(
                        " AND (CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='EMERALD',right(designation_date,4),''), "
                                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURA2000',right(designation_date,4),''), "
                                + "IF(A.source_db='CORINE',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURENET',right(designation_date,4),'')) AS SIGNED) >= " + yearMin + ")"
                                + " AND A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''");
            }
            if (null != yearMax && yearMax.intValue() > -1) {
                sql.append(
                        " AND (CAST(CONCAT(IF(A.source_db='BIOGENETIC',left(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='EMERALD',right(designation_date,4),''), "
                                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURA2000',right(designation_date,4),''), "
                                + "IF(A.source_db='CORINE',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURENET',right(designation_date,4),'')) AS SIGNED) <= " + yearMax + ") "
                                + " AND A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''");
            }
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            if (0 == criteriaType.compareTo(CRITERIA_SOURCE_DB)) {
                sql.append(
                        Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType),
                        SitesSearchUtility.translateSourceDBInvert(criteriaSearch), oper));
            } else {
                sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
            }
        }
        // System.out.println("toSQL(): " + sql);
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

        if (isMainSearch) {
            res.append(Utilities.writeFormParameter("longMin", longMin));
            res.append(Utilities.writeFormParameter("longMax", longMax));
            res.append(Utilities.writeFormParameter("latMin", latMin));
            res.append(Utilities.writeFormParameter("latMax", latMax));
        }

        if (null != country) {
            // AND C.AREA_NAME_EN='FRANCE'
            res.append(Utilities.writeFormParameter("country", country));
        }
        if ((null != yearMin && yearMin.intValue() > -1)) {
            // AND LEFT(A.DESIGNATION_DATE,4)>=1997 AND LEFT(A.DESIGNATION_DATE,4)<=2000
            res.append(Utilities.writeFormParameter("yearMin", yearMin));
        }
        if ((null != yearMax && yearMax.intValue() > -1)) {
            res.append(Utilities.writeFormParameter("yearMax", yearMax));
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
        StringBuffer ret = new StringBuffer();

        if (isMainSearch) {
            ret.append("longitude is between <strong>" + longMin + "</strong> and <strong>" + longMax + "</strong>");
            ret.append(" and latitude is between <strong>" + latMin + "</strong> and <strong>" + latMax + "</strong>");
        } else {
            // Search in results
            if (null != criteriaSearch && null != criteriaType && null != oper) {
                ret.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
            }
        }
        return ret.toString();
    }

    /** Init the mappings used to compose the SQL query. */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_ENGLISH_NAME, "A.NAME ");
        sqlMappings.put(CRITERIA_SOURCE_DB, "A.SOURCE_DB ");
        // sqlMappings.put(CRITERIA_SIZE, "A.AREA ");
        sqlMappings.put(CRITERIA_AREA, "A.AREA ");
        sqlMappings.put(CRITERIA_LENGTH, "A.LENGTH ");
        sqlMappings.put(CRITERIA_COUNTRY, "C.AREA_NAME_EN ");
    }

    /** Init the human mappings so you can represent this object in human language. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_ENGLISH_NAME, "Site name");
        humanMappings.put(CRITERIA_SOURCE_DB, "Database source");
        // humanMappings.put(CRITERIA_SIZE, "Size ");
        humanMappings.put(CRITERIA_AREA, "Area ");
        humanMappings.put(CRITERIA_LENGTH, "Length ");
        humanMappings.put(CRITERIA_COUNTRY, "Country ");
    }
}
