package ro.finsiel.eunis.search.sites.neighborhood;


import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;
import ro.finsiel.eunis.search.sites.SitesSearchCriteria;

import java.util.Hashtable;


/**
 * Search criteria used for sites->neighborhood search.
 * @author finsiel
 */
public class NeighborhoodSearchCriteria extends SitesSearchCriteria {

    /** Site name. */
    private String englishName = null;

    /** Relation between scientificName or vernacularName (starts, contains, is).*/
    private Integer relationOp = null;

    /** Range of sites returned. */
    private int radius = 0;

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
     * @param englishName English name.
     * @param relationOp Relation operator.
     * @param radius Search radius.
     * @param country Country filter.
     * @param minDesignationDate Miniumum designation year filter.
     * @param maxDesignationDate Maximum designation year filter.
     */
    public NeighborhoodSearchCriteria(String englishName, Integer relationOp, int radius, String country,
            String minDesignationDate, String maxDesignationDate) {
        _initHumanMappings();
        _initSQLMappings();
        this.country = country;
        this.yearMin = minDesignationDate;
        this.yearMax = maxDesignationDate;
        this.englishName = englishName;
        this.relationOp = relationOp;
        this.radius = radius;
    }

    /**
     * Second constructor used to construct filter search criterias (search in results).
     * @param criteriaSearch Search string.
     * @param criteriaType What we search for. Can be CRITERIA_GROUP/ORDER/SCIENTIFIC_NAME.
     * @param oper Type of relation between criteriaSearch & criteriaType. Can be OPERATOR_IS/CONTAINS/STARTS.
     */
    public NeighborhoodSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_ENGLISH_NAME, "A.NAME ");
        sqlMappings.put(CRITERIA_SOURCE_DB, "A.SOURCE_DB ");
        sqlMappings.put(CRITERIA_SIZE, "A.AREA ");
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
        humanMappings.put(CRITERIA_DESIGN_TYPE, "Designation type");
        humanMappings.put(CRITERIA_SIZE, "Area size ");
        humanMappings.put(CRITERIA_COUNTRY, "Country ");
    }

    /** This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer res = new StringBuffer();

        if (null != englishName && null != relationOp) {
            res.append(Utilities.writeURLParameter("englishName", englishName));
            res.append(Utilities.writeURLParameter("relationOp", relationOp.toString()));
        }
        if (null != country) {
            // AND C.AREA_NAME_EN='FRANCE'
            res.append(Utilities.writeURLParameter("country", country));
        }
        if (null != yearMin) {
            res.append(Utilities.writeURLParameter("yearMin", yearMin));
        }
        if (null != yearMax) {
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

        if (null != englishName && null != relationOp) {
            sql.append("(");
            sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_ENGLISH_NAME), englishName, relationOp));
            sql.append(")");
            if (null != country) {
                // AND C.AREA_NAME_EN='FRANCE'
                sql.append(" AND (C.AREA_NAME_EN='" + country + "')");
            }
            if (null != yearMin) {
                sql.append(" AND (LENGTH(DESIGNATION_DATE > 0)) ");
                sql.append(
                        " AND (CONCAT(IF(A.source_db='BIOGENETIC',left(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='EMERALD',right(designation_date,4),''), "
                                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURA2000',right(designation_date,4),''), "
                                + "IF(A.source_db='CORINE',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURENET',right(designation_date,4),'')) >= " + yearMin + ") "
                                + " AND A.DESIGNATION_DATE IS NOT NULL" + " AND A.DESIGNATION_DATE <> ''");
            }
            if (null != yearMax) {
                sql.append(" AND (LENGTH(DESIGNATION_DATE > 0)) ");
                sql.append(
                        " AND (CONCAT(IF(A.source_db='BIOGENETIC',left(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''), "
                                + "IF(A.source_db='EMERALD',right(designation_date,4),''), "
                                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURA2000',right(designation_date,4),''), "
                                + "IF(A.source_db='CORINE',right(designation_date,4),''), "
                                + "IF(A.source_db='NATURENET',right(designation_date,4),'')) <= " + yearMax + ") "
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

        if (null != englishName && null != relationOp) {
            res.append(Utilities.writeFormParameter("englishName", englishName));
            res.append(Utilities.writeFormParameter("relationOp", relationOp.toString()));
        }
        if (null != country) {
            // AND C.AREA_NAME_EN='FRANCE'
            res.append(Utilities.writeFormParameter("country", country));
        }
        if (null != yearMin) {
            res.append(Utilities.writeFormParameter("yearMin", yearMin));
        }
        if (null != yearMax) {
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

        if (null != englishName && null != relationOp) {
            ret.append(Utilities.prepareHumanString("Site name <strong>", englishName, relationOp) + "</strong>");
        }
        if (null != country) {
            // AND C.AREA_NAME_EN='FRANCE'
            ret.append(", in country <strong>" + country + "</strong>");
        }
        if (null != yearMin) {
            if (null != yearMax) {
                ret.append(" and year between : <strong>" + yearMin + "</strong> and <strong>" + yearMax + "</strong>");
            } else {
                ret.append(" and year greater than <strong>" + yearMin + "</strong>");
            }
        } else if (null != yearMax) {
            ret.append(" and year smaller than <strong>" + yearMax + "</strong>");
        }

        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            if (0 == criteriaType.compareTo(CRITERIA_SOURCE_DB)) {
                ret.append(
                        Utilities.prepareHumanString((String) humanMappings.get(criteriaType),
                        SitesSearchUtility.translateSourceDB(criteriaSearch), oper));
            } else {
                ret.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
            }
        }
        return ret.toString();
    }
}
