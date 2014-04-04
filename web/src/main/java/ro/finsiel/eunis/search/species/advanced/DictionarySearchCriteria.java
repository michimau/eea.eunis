package ro.finsiel.eunis.search.species.advanced;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;


/**
 * Search criteria used in advanced search and combined search.
 * @author finsiel
 */
public class DictionarySearchCriteria extends AbstractSearchCriteria {

    /** Coming from first form (scientific name). */
    public static final Integer CRITERIA_SCIENTIFIC = new Integer(0);

    /** Coming from second form (common name). */
    public static final Integer CRITERIA_VERNACULAR = new Integer(1);

    /** Used in filters, filtering by Group. */
    public static final Integer CRITERIA_GROUP = new Integer(2);

    /** Used in filters, filtering by Order. */
    public static final Integer CRITERIA_ORDER = new Integer(3);

    /** Used in filters, filtering by Family. */
    public static final Integer CRITERIA_FAMILY = new Integer(5);

    /** Used in filters, filtering by Scientific name. */
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(4);

    private Integer dictionary = null;
    private Integer selectOp = null;
    private String searchValueMin = null;
    private String searchValueMax = null;

    // these are not written to URL/FORM.
    private String tableName = null;
    private String operand = null;
    private String searchValueMinOriginal = null;
    private String searchValueMaxOriginal = null;

    /** SQL mappings for search in results. */
    private Hashtable sqlMappings = null;

    /** Mapping to human language. */
    private Hashtable humanMappings = null;

    private boolean isMainCriteria = false;

    /**
     * Search criteria.
     * @param dictionary Dictionary
     * @param selectOp Relation operator
     * @param searchValueMin Value / Min value
     * @param searchValueMax Max value if relation is BETWEEN.
     */
    public DictionarySearchCriteria(Integer dictionary, Integer selectOp, String searchValueMin, String searchValueMax) {
        isMainCriteria = true;
        this.dictionary = dictionary;
        this.selectOp = selectOp;

        this.tableName = mapDictionary2Tablename();

        this.searchValueMinOriginal = searchValueMin;
        this.searchValueMaxOriginal = searchValueMax;

        if (selectOp.intValue() == Utilities.OPERATOR_IS.intValue()) {
            this.searchValueMin = searchValueMin;
            this.searchValueMax = (null == searchValueMax) ? "" : searchValueMax;
            operand = "Equal";
        }
        if (selectOp.intValue() == Utilities.OPERATOR_CONTAINS.intValue()) {
            this.searchValueMin = searchValueMin;
            this.searchValueMax = (null == searchValueMax) ? "" : searchValueMax;
            operand = "Contains";
        }
        if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
            this.searchValueMin = searchValueMin;
            this.searchValueMax = (null == searchValueMax) ? "" : searchValueMax;
            operand = "Between";
        }

        if (dictionary.intValue() == DictionaryBean.DICT_GROUP) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()
                    || selectOp.intValue() == Utilities.OPERATOR_CONTAINS.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findGroupID(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findGroupID(searchValueMax).toString();
            }
        }
        if (dictionary.intValue() == DictionaryBean.DICT_NATIONAL_THREAT_STATUS
                || dictionary.intValue() == DictionaryBean.DICT_INTERNATIONAL_THREAT_STATUS) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findIDConservationStatus(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findIDConservationStatus(searchValueMax).toString();
            }
        }
        if (dictionary.intValue() == DictionaryBean.DICT_ABUNDANCE) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findIDAbundance(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findIDAbundance(searchValueMax).toString();
            }
        }
        if (dictionary.intValue() == DictionaryBean.DICT_TREND) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findIDTrend(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findIDTrend(searchValueMax).toString();
            }
        }
        if (dictionary.intValue() == DictionaryBean.DICT_DISTRIBUTION_STATUS) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findIDDistributionStatus(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findIDDistributionStatus(searchValueMax).toString();
            }
        }
        if (dictionary.intValue() == DictionaryBean.DICT_SPECIES_STATUS) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findIDSpeciesStatus(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findIDSpeciesStatus(searchValueMax).toString();
            }
        }
        if (dictionary.intValue() == DictionaryBean.DICT_INFO_QUALITY) {
            if (selectOp.intValue() == Utilities.OPERATOR_BETWEEN.intValue()) {
                this.searchValueMin = SpeciesSearchUtility.findIDInfoQuality(searchValueMin).toString();
                this.searchValueMax = SpeciesSearchUtility.findIDInfoQuality(searchValueMax).toString();
            }
        }
    }

    /**
     * This constructor is used for search in results.
     * @param criteriaSearch String to be searched
     * @param criteriaType Where to search
     * @param oper Relation between criteriaSearch and criteriaType
     */
    public DictionarySearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
        isMainCriteria = false;
        _initSQLMappings();
        _initHumanMappings();
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

        if (null != dictionary && null != selectOp) {
            url.append(Utilities.writeURLParameter("dictionary0", "" + dictionary));
            url.append(Utilities.writeURLParameter("selectOp0", "" + selectOp));
        }
        if (null != searchValueMin) {
            url.append(Utilities.writeURLParameter("searchValueMin0", "" + searchValueMinOriginal));
        }
        if (null != searchValueMax) {
            url.append(Utilities.writeURLParameter("searchValueMax0", "" + searchValueMaxOriginal));
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
            String _criteria = criteriaSearch;

            if (0 == criteriaType.compareTo(CRITERIA_GROUP)) {
                _criteria = SpeciesSearchUtility.findGroupID(criteriaSearch).toString();
            }
            // System.out.println("_criteria:" + _criteria);
            ret.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), _criteria, oper));
        }
        return ret.toString();
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

        if (null != dictionary && null != selectOp) {
            form.append(Utilities.writeFormParameter("dictionary0", "" + dictionary));
            form.append(Utilities.writeFormParameter("selectOp0", "" + selectOp));
        }
        form.append(Utilities.writeFormParameter("searchValueMin0", "" + searchValueMinOriginal));
        form.append(Utilities.writeFormParameter("searchValueMax0", "" + searchValueMaxOriginal));
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
                str.append(
                        Utilities.prepareHumanString(humanDict, "" + dictionary, searchValueMinOriginal, searchValueMaxOriginal,
                        selectOp));
            } else if (0 == selectOp.compareTo(Utilities.OPERATOR_BETWEEN)) {
                str.append(
                        Utilities.prepareHumanString(humanDict, "" + dictionary, searchValueMinOriginal, searchValueMaxOriginal,
                        selectOp));
            } else if (0 == selectOp.compareTo(Utilities.OPERATOR_CONTAINS)) {}
        }
        // Search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            str.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
        }
        return str.toString();
    }

    /**
     * Human representation of dictionary.
     * @param index What information to return (Possible values are: )
     * @return Human readable string.
     */
    private static String getDictionaryHuman(int index) {
        String ret = "n/a";

        switch (index) {
        case DictionaryBean.DICT_SCIENTIFIC_NAME:
            ret = "Scientific name";
            break;

        case DictionaryBean.DICT_VERNACULAR_NAME:
            ret = "Common name";
            break;

        case DictionaryBean.DICT_GROUP:
            ret = "Group";
            break;

        case DictionaryBean.DICT_NATIONAL_THREAT_STATUS:
            ret = "National threat status";
            break;

        case DictionaryBean.DICT_INTERNATIONAL_THREAT_STATUS:
            ret = "International threat status";
            break;

        case DictionaryBean.DICT_COUNTRY:
            ret = "Country";
            break;

        case DictionaryBean.DICT_BIOGEOREGION:
            ret = "Biogeoregion";
            break;

        case DictionaryBean.DICT_ABUNDANCE:
            ret = "Abundance";
            break;

        case DictionaryBean.DICT_LEGAL_STATUS:
            ret = "Legal status";
            break;

        case DictionaryBean.DICT_TREND:
            ret = "Trends";
            break;

        case DictionaryBean.DICT_DISTRIBUTION_STATUS:
            ret = "Distribution";
            break;

        case DictionaryBean.DICT_SPECIES_STATUS:
            ret = "Species status";
            break;

        case DictionaryBean.DICT_INFO_QUALITY:
            ret = "Quality information";
            break;
        }
        return ret;
    }

    /**
     * Map dictionaries to name of the tables.
     * @return Table name.
     */
    public String mapDictionary2Tablename() {
        String ret = "";

        try {
            switch (dictionary.intValue()) {
            case DictionaryBean.DICT_SCIENTIFIC_NAME:
                ret = "ScientificName";
                break;

            case DictionaryBean.DICT_VERNACULAR_NAME:
                ret = "VernacularName";
                break;

            case DictionaryBean.DICT_GROUP:
                ret = "Group";
                break;

            case DictionaryBean.DICT_NATIONAL_THREAT_STATUS:
                ret = "ThreatStatus";
                break;

            case DictionaryBean.DICT_INTERNATIONAL_THREAT_STATUS:
                ret = "InternationalThreatStatus";
                break;

            case DictionaryBean.DICT_COUNTRY:
                ret = "Country";
                break;

            case DictionaryBean.DICT_BIOGEOREGION:
                ret = "Biogeoregion";
                break;

            case DictionaryBean.DICT_ABUNDANCE:
                ret = "Abundance";
                break;

            case DictionaryBean.DICT_LEGAL_STATUS:
                ret = "LegalStatus";
                break;

            case DictionaryBean.DICT_TREND:
                ret = "Trend";
                break;

            case DictionaryBean.DICT_DISTRIBUTION_STATUS:
                ret = "DistributionStatus";
                break;

            case DictionaryBean.DICT_SPECIES_STATUS:
                ret = "SpeciesStatus";
                break;

            case DictionaryBean.DICT_INFO_QUALITY:
                ret = "InfoQuality";
                break;
            }
        } catch (Exception ex) {
            ex.printStackTrace(System.err);
            ret = "";
        } finally {
            return ret;
        }
    }

    /** Init the mappings used to compose the SQL query. */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_SCIENTIFIC, "A.SCIENTIFIC_NAME ");
        sqlMappings.put(CRITERIA_VERNACULAR, "G.VALUE");
        sqlMappings.put(CRITERIA_GROUP, "A.ID_GROUP_SPECIES");
        sqlMappings.put(CRITERIA_ORDER, "D.NAME");
        sqlMappings.put(CRITERIA_FAMILY, "C.NAME");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "A.SCIENTIFIC_NAME ");
    }

    /** Init the mappings used to compose the SQL query .*/
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_SCIENTIFIC, "Scientific name ");
        humanMappings.put(CRITERIA_VERNACULAR, "Common name ");
        humanMappings.put(CRITERIA_GROUP, "Group ");
        humanMappings.put(CRITERIA_ORDER, "Order ");
        humanMappings.put(CRITERIA_FAMILY, "Family ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");
    }
}
