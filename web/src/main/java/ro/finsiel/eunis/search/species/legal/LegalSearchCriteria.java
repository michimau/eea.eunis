package ro.finsiel.eunis.search.species.legal;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;


/**
 * Note that this class, resembles a 'generic' search criteria used by both types of search (the two forms from the
 * species-legal.jsp), due to memory allocation, and for simplicity (not splitting in multiple classes). Also this
 * class is used for search in results.
 * @author finsiel
 */
public class LegalSearchCriteria extends AbstractSearchCriteria {

    /** Defines a search after a scientific name of species from a group (first form). */
    public static final Integer CRITERIA_SPECIES = new Integer(0);

    /** Defines a search after all species from a group referenced by a legal text (second form). */
    public static final Integer CRITERIA_LEGAL = new Integer(1);

    /** Defines a search after Group (used for search in results). */
    public static final Integer CRITERIA_GROUP = new Integer(2);

    /** Defines a search after Scientific name (used for search in results). */
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);

    /** The group where we are searching (could be a valid name or 'any'). */
    private String groupName;

    /** The scientific name we are searching for. */
    private String scientificName;

    /** The legal text referenced by a group (could be a valid name or 'any'. */
    private String legalText;

    /** Type (form where I come from I or II). */
    private Integer typeForm = null;

    /** Map the search criterias to SQL queries. */
    private static Hashtable sqlMappings = null;

    /** Map the search criterias to human readable strings. */
    private static Hashtable humanMappings = null;

    /**
     * Uniquely identifies the annex
     */
    private String dcId = null;

    /**
     * Basic constructor (one which does the first search...) rest are only for search in results.
     * @param groupName Group name
     * @param sciNameOrLegal Is scientific name of legal Text, depending on value of typeOfSearch (form where coming from)
     * @param annex Annex used for search...(see Domain corresponding to this search - ANNEX column).
     * @param typeForm can be CRITERIA_SPECIES/CRITERIA_LEGAL depending where coming from (either form 1 or 2)
     */
    public LegalSearchCriteria(String groupName, String sciNameOrLegal, String annex, Integer typeForm) {
        _initHumanMappings();
        _initSQLMappings();
        if (null == typeForm) {
            return;
        }
        // first form
        if (CRITERIA_SPECIES.intValue() == typeForm.intValue()) {
            this.groupName = groupName;
            this.scientificName = sciNameOrLegal;
        }
        // second form
        if (CRITERIA_LEGAL.intValue() == typeForm.intValue()) {
            this.groupName = groupName;
            this.legalText = sciNameOrLegal;
            this.dcId = annex;
        }
        this.typeForm = typeForm;
    }

    /**
     * 2nd constructor used for search in results.
     * @param criteriaSearch Search string.
     * @param criteriaType Type of search.
     * @param oper Relation operator.
     * @param type What form we come from.
     */
    public LegalSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper, Integer type) {
        _initSQLMappings();
        _initHumanMappings();
        this.criteriaSearch = criteriaSearch;
        this.criteriaType = criteriaType;
        this.oper = oper;
        this.typeForm = type;
    }

    /** Init the mappings used to compose the SQL query. */
    private void _initSQLMappings() {
        if (null != sqlMappings) {
            return;
        }
        sqlMappings = new Hashtable();
        sqlMappings.put(CRITERIA_SPECIES, "B.LOOKUP_TYPE = 'LEGAL_STATUS' AND E.SCIENTIFIC_NAME ");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "E.SCIENTIFIC_NAME");
        sqlMappings.put(CRITERIA_GROUP, "E.ID_GROUP_SPECIES");
    }

    /** Init the human mappings so you can represent this object in human language. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_SPECIES, "Any group and Scientific name ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");
        humanMappings.put(CRITERIA_GROUP, "Group ");
    }

    /** This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != scientificName) {
            url.append(Utilities.writeURLParameter("scientificName", scientificName));
        }
        if (null != legalText) {
            url.append(Utilities.writeURLParameter("legalText", legalText));
        }
        if (null != dcId) {
            url.append(Utilities.writeURLParameter("dcId", dcId));
        }
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
            url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
            url.append(Utilities.writeURLParameter("oper", oper.toString()));
        }
        return url.toString();
    }

    /**
     * Transform this object into an SQL representation.
     * @return SQL string representing this object.
     */
    public String toSQL() {
        StringBuffer result = new StringBuffer();

        if (null != groupName && null != scientificName) {
            if (0 == typeForm.compareTo(CRITERIA_SPECIES)) {
                // form 1
                if (groupName.equalsIgnoreCase("any")) {
                    // first case ('Any group')
                    result.append(
                            Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_SPECIES), scientificName,
                            Utilities.OPERATOR_CONTAINS));
                } else {
                    // second case (not 'Any group')
                    // Here I can't use anymore the sqlMappings because there are two parameters to be set, so I handcrafted the query...
                    // Also note that default operator is OPERATOR_CONTAINS! ("...LIKE + scientificName..." below)
                    result.append(
                            "E.SCIENTIFIC_NAME LIKE '%" + scientificName + "%' AND E.ID_GROUP_SPECIES = '" + groupName
                            + "' AND B.LOOKUP_TYPE = 'LEGAL_STATUS'");
                }
            }
        }
        // form 2
        // System.out.println("groupName = " + groupName);
        // System.out.println("legalText = " + legalText);
        // System.out.println("annex = " + annex);
        if (null != groupName && null != dcId) {
            if (0 == typeForm.compareTo(CRITERIA_LEGAL)) {
                if(!dcId.equalsIgnoreCase("any")) {
                    result.append("A.ID_DC='" + dcId + "' AND ");
                }
                if (!groupName.equalsIgnoreCase("any")) {
                    result.append("E.ID_GROUP_SPECIES='" + groupName + "' AND ");
                }

                result.append("LOOKUP_TYPE='LEGAL_STATUS'");

            } else {
                if (groupName.equalsIgnoreCase("any")) {
                    // first case ('Any group')
                    result.append("LOOKUP_TYPE='LEGAL_STATUS'");
                } else {
                    // second case (not 'Any group')
                    result.append("LOOKUP_TYPE='LEGAL_STATUS' AND E.ID_GROUP_SPECIES='" + groupName + "'");
                }
            }
        }
        if (null != criteriaSearch && null != criteriaType && null != oper && null != typeForm) {
            String transCriteria = criteriaSearch;

            if (0 == criteriaType.compareTo(CRITERIA_GROUP)) {
                transCriteria = SpeciesSearchUtility.findGroupID(criteriaSearch).toString();
            }
            result.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), transCriteria, oper));
        }
        return result.toString();
    }

    /**
     * This method implements a procedure from morphing the object into an web page FORM representation. What I meant
     * to say is that I can say about an object for example:
     * < INPUT typeForm='hidden" name="searchCriteria" value="natrix">
     * < INPUT typeForm='hidden" name="oper" value="1">
     * < INPUT typeForm='hidden" name="searchType" value="1">.
     * @return Web page FORM representation of the object
     */
    public String toFORMParam() {
        StringBuffer result = new StringBuffer();

        if (null != groupName && null != scientificName) {
            // form 1
            if (0 == typeForm.compareTo(CRITERIA_SPECIES)) {
                // first case ('Any group')
                result.append(Utilities.writeFormParameter("scientificName", scientificName));
            }
        }
        // form 2
        if (null != groupName && null != legalText) {
            if (0 == typeForm.compareTo(CRITERIA_LEGAL)) {
                result.append(Utilities.writeFormParameter("legalText", legalText));
            }
        }
        // If this object is a search in results
        if (null != criteriaSearch && null != criteriaType && null != oper) {
            result.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
            result.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
            result.append(Utilities.writeFormParameter("oper", oper.toString()));
        }
        return result.toString();
    }

    /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public String toHumanString() {
        StringBuffer result = new StringBuffer();

        if (null != groupName && null != scientificName) {
            // form 1
            if (0 == typeForm.compareTo(CRITERIA_SPECIES)) {
                // first case ('Any group')
                result.append(
                        Utilities.prepareHumanString((String) humanMappings.get(CRITERIA_SPECIES), scientificName,
                        Utilities.OPERATOR_CONTAINS));
            }
        }
        // form 2
        if (null != groupName && null != legalText) {
            if (0 == typeForm.compareTo(CRITERIA_LEGAL)) {}
        }
        if (null != criteriaSearch && null != criteriaType && null != oper && null != typeForm) {
            result.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
        }
        return result.toString();
    }
}
