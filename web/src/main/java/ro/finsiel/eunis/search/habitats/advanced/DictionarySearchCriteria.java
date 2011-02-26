/**
 * Date: Apr 7, 2003
 * Time: 2:05:04 PM
 */
package ro.finsiel.eunis.search.habitats.advanced;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.HabitatsSearchUtility;
import ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryDomain;

import java.util.Hashtable;


/**
 * Search criteria for habitats advanced search.
 * @author finsiel
 */
public class DictionarySearchCriteria extends AbstractSearchCriteria {

    /**
     * Search by code.
     */
    public static final Integer CRITERIA_CODE = new Integer(0);

    /**
     * Search by level.
     */
    public static final Integer CRITERIA_LEVEL = new Integer(1);

    /**
     * Search by english name.
     */
    public static final Integer CRITERIA_NAME = new Integer(2);

    /**
     * Search by name.
     */
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);

    private Integer dictionary = null;
    private Integer selectOp = null;
    private String searchValueMin = null;
    private String searchValueMax = null;

    private Integer database = null;

    // these are not written to URL/FORM
    private String tableName = null;
    private String operand = null;
    private String searchValueMinHuman = null;
    private String searchValueMaxHuman = null;

    /** SQL mappings for search in results. */
    private Hashtable sqlMappings = null;

    /** Mapping to human language. */
    private Hashtable humanMappings = null;

    private boolean isMainCriteria = false;

    /**
     * Main constructor.
     * @param dictionary Dictionary.
     * @param selectOp Relation op.
     * @param searchValueMin Min value
     * @param searchValueMax Max value
     * @param database Database.
     */
    public DictionarySearchCriteria(Integer dictionary, Integer selectOp, String searchValueMin, String searchValueMax, Integer database) {
        isMainCriteria = true;
        this.dictionary = dictionary;
        this.selectOp = selectOp;
        this.database = database;

        this.tableName = mapDictionary2Tablename();
        if (selectOp.intValue() == Utilities.OPERATOR_IS.intValue()) {
            this.searchValueMin = searchValueMin;
            this.searchValueMax = (null == searchValueMax) ? "" : searchValueMax;
            operand = "Equal";
        }
        if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
            this.searchValueMin = HabitatsSearchUtility.mapDictionaryTermToID(dictionary, searchValueMin);
            this.searchValueMax = HabitatsSearchUtility.mapDictionaryTermToID(dictionary, searchValueMax);
            this.searchValueMinHuman = searchValueMin;
            this.searchValueMaxHuman = searchValueMax;
            operand = "Between";
        }
    }

    /**
     * This constructor is used for search in results.
     * @param criteriaSearch String to be searched
     * @param criteriaType Where to search
     * @param oper Relation between criteriaSearch and criteriaType
     * @param database What database to use: EUNIS or ANNEX I
     */
    public DictionarySearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper, Integer database) {
        isMainCriteria = false;
        _initSQLMappings(database);
        _initHumanMappings(database);
        this.criteriaSearch = criteriaSearch;
        this.criteriaType = criteriaType;
        this.oper = oper;
        this.database = database;
    }

    /**
     * This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != dictionary && null != selectOp) {
            url.append(Utilities.writeURLParameter("dictionary0", "" + dictionary));
            url.append(Utilities.writeURLParameter("selectOp0", "" + selectOp));
            if (selectOp.intValue() == Utilities.OPERATOR_IS.intValue()) {
                if (null != searchValueMin) {
                    url.append(Utilities.writeURLParameter("searchValueMin0", "" + searchValueMin));
                }
                if (null != searchValueMax) {
                    url.append(Utilities.writeURLParameter("searchValueMax0", "" + searchValueMax));
                }
            }
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                if (null != searchValueMin) {
                    url.append(Utilities.writeURLParameter("searchValueMin0", "" + searchValueMinHuman));
                }
                if (null != searchValueMax) {
                    url.append(Utilities.writeURLParameter("searchValueMax0", "" + searchValueMaxHuman));
                }
            }
        }
        if (null != database) {
            url.append(Utilities.writeURLParameter("database", database.toString()));
        }

        // Search in results
        if (null != criteriaSearch) {
            url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
        }
        if (null != criteriaType) {
            url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
        }
        if (null != oper) {
            url.append(Utilities.writeURLParameter("oper", oper.toString()));
        }
        return url.toString();
    }

    /**
     * Transform this object into an SQL representation.
     * @return SQL string representing this object.
     */
    public String toSQL() {
        StringBuffer ret = new StringBuffer();

        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            ret.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
        }
        return ret.toString();
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

        if (null != dictionary && null != selectOp) {
            form.append(Utilities.writeFormParameter("dictionary0", "" + dictionary));
            form.append(Utilities.writeFormParameter("selectOp0", "" + selectOp));
            if (selectOp.intValue() == Utilities.OPERATOR_IS.intValue()) {
                form.append(Utilities.writeFormParameter("searchValueMin0", "" + searchValueMin));
                form.append(Utilities.writeFormParameter("searchValueMax0", "" + searchValueMax));
            }
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                form.append(Utilities.writeFormParameter("searchValueMin0", "" + searchValueMinHuman));
                form.append(Utilities.writeFormParameter("searchValueMax0", "" + searchValueMaxHuman));
            }
        }
        if (null != database) {
            form.append(Utilities.writeFormParameter("database", database.toString()));
        }

        // Search in results
        if (null != criteriaSearch) {
            form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
        }
        if (null != criteriaType) {
            form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
        }
        if (null != oper) {
            form.append(Utilities.writeFormParameter("oper", oper.toString()));
        }
        return form.toString();
    }

    /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public String toHumanString() {
        StringBuffer str = new StringBuffer();

        if (null != dictionary && null != selectOp) {
            String humanDict = getDictionaryHuman(dictionary.intValue());

            if (0 == selectOp.compareTo(Utilities.OPERATOR_IS)) {
                str.append(Utilities.prepareHumanString(humanDict, "" + dictionary, searchValueMin, searchValueMax, selectOp));
            } else {
                str.append(
                        Utilities.prepareHumanString(humanDict, "" + dictionary, searchValueMinHuman, searchValueMaxHuman, selectOp));
            }
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            str.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
        }
        return str.toString();
    }

    /**
     * Transform dictionary index in human language.
     * @param index Dictionary idnex.
     * @return Dictionary name.
     */
    private static String getDictionaryHuman(int index) {
        String ret = "n/a";

        switch (index) {
        case DictionaryBean.DICT_ALTITUDE:
            ret = "Altitude";
            break;

        case DictionaryBean.DICT_CHEMISTRY:
            ret = "Chemistry";
            break;

        case DictionaryBean.DICT_CLIMATE:
            ret = "Climate";
            break;

        case DictionaryBean.DICT_COVERAGE:
            ret = "Coverage";
            break;

        case DictionaryBean.DICT_HUMIDITY:
            ret = "Humidity";
            break;

        case DictionaryBean.DICT_IMPACT:
            ret = "Impact";
            break;

        case DictionaryBean.DICT_LIGHT:
            ret = "Light";
            break;

        case DictionaryBean.DICT_PH:
            ret = "pH (Acidity)";
            break;

        case DictionaryBean.DICT_LIFEFORM:
            ret = "Life form";
            break;

        case DictionaryBean.DICT_TEMPERATURE:
            ret = "Temperature";
            break;

        case DictionaryBean.DICT_USAGE:
            ret = "Usage";
            break;

        case DictionaryBean.DICT_WATER:
            ret = "Water";
            break;

        case DictionaryBean.DICT_SUBSTRATE:
            ret = "Substrate";
            break;
        }
        return ret;
    }

    /**
     * Transform dictionary into table name.
     * @return Name of the database table.
     */
    public String mapDictionary2Tablename() {
        String results = "";

        try {
            switch (dictionary.intValue()) {
            case DictionaryBean.DICT_ALTITUDE:
                results = "Altitude";
                break;

            case DictionaryBean.DICT_CHEMISTRY:
                results = "Chemistry";
                break;

            case DictionaryBean.DICT_CLIMATE:
                results = "Climate";
                break;

            case DictionaryBean.DICT_COVERAGE:
                results = "Cover";
                break;

            case DictionaryBean.DICT_HUMIDITY:
                results = "Humidity";
                break;

            case DictionaryBean.DICT_IMPACT:
                results = "Impact";
                break;

            case DictionaryBean.DICT_LIGHT:
                results = "LightIntensity";
                break;

            case DictionaryBean.DICT_PH:
                results = "Ph";
                break;

            case DictionaryBean.DICT_LIFEFORM:
                results = "LifeForm";
                break;

            case DictionaryBean.DICT_TEMPERATURE:
                results = "Temperature";
                break;

            case DictionaryBean.DICT_USAGE:
                results = "Usage";
                break;

            case DictionaryBean.DICT_WATER:
                results = "Water";
                break;

            case DictionaryBean.DICT_SUBSTRATE:
                results = "Substrate";
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(System.err);
            results = "";
        } finally {
            return results;
        }
    }

    /**
     * Init the mappings used to compose the SQL query.
     * @param database Database.
     */
    private void _initSQLMappings(Integer database) {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        if (null != database) {
            sqlMappings.put(CRITERIA_CODE, "EUNIS_HABITAT_CODE ");
        }
        if (null != database && 0 == database.compareTo(DictionaryDomain.SEARCH_EUNIS)) {
            sqlMappings.put(CRITERIA_CODE, "EUNIS_HABITAT_CODE ");
        }
        if (null != database && 0 == database.compareTo(DictionaryDomain.SEARCH_ANNEX_I)) {
            sqlMappings.put(CRITERIA_CODE, "CODE_ANNEX1 ");
        }
        if (null == database) {
            sqlMappings.put(CRITERIA_CODE, "EUNIS_HABITAT_CODE ");
        }

        sqlMappings.put(CRITERIA_LEVEL, "LEVEL ");
        sqlMappings.put(CRITERIA_NAME, "DESCRIPTION ");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "SCIENTIFIC_NAME ");
    }

    /**
     * Init the mappings used to compose the SQL query.
     * @param database Database.
     */
    private void _initHumanMappings(Integer database) {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        if (null != database) {
            humanMappings.put(CRITERIA_CODE, "EUNIS code ");
        }
        if (null != database && 0 == database.compareTo(DictionaryDomain.SEARCH_EUNIS)) {
            humanMappings.put(CRITERIA_CODE, "EUNIS code ");
        }
        if (null != database && 0 == database.compareTo(DictionaryDomain.SEARCH_ANNEX_I)) {
            humanMappings.put(CRITERIA_CODE, "ANNEX I code ");
        }
        if (null == database) {
            humanMappings.put(CRITERIA_CODE, "EUNIS code ");
        }
        humanMappings.put(CRITERIA_LEVEL, "Habitat level ");
        humanMappings.put(CRITERIA_NAME, "Vernacular name ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");
    }
}
