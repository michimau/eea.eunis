package ro.finsiel.eunis.search.species.internationalthreatstatus;


import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;


/**
 * Search criteria for species->international threat status.
 * @author finsiel
 */
public class InternationalthreatstatusSearchCriteria extends AbstractSearchCriteria {

    /** Used in filters, filtering by Group.*/
    public static final Integer CRITERIA_GROUP = new Integer(0);

    /** Used in filters, filtering by Order.*/
    public static final Integer CRITERIA_ORDER = new Integer(1);

    /** Used in filters, filtering by Family.*/
    public static final Integer CRITERIA_FAMILY = new Integer(2);

    /** Used in filters, filtering by Scientific name.*/
    public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);

    private Integer idGroup = null;
    private Integer idCountry = null;

    /** Relation between scientificName or vernacularName (starts, contains, is).*/
    private Integer idConservation = null;

    private Hashtable sqlMappings = null;
    private Hashtable humanMappings = null;

    /**
     * Constructor for main search object.
     * @param idGroup ID_GROUP
     * @param idCountry ID_COUNTRY
     * @param idConservation Id conservation.
     */
    public InternationalthreatstatusSearchCriteria(Integer idGroup, Integer idCountry, Integer idConservation) {
        _initHumanMappings();
        _initSQLMappings();
        this.idGroup = idGroup;
        this.idConservation = idConservation;
        this.idCountry = idCountry;
    }

    /**
     * Constructor for search in results object.
     * @param criteriaSearch Search string.
     * @param criteriaType What type of information to search.
     * @param oper Relation operator.
     */
    public InternationalthreatstatusSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
        sqlMappings.put(CRITERIA_GROUP, "C.ID_GROUP_SPECIES");
        sqlMappings.put(CRITERIA_ORDER, "J.NAME");
        sqlMappings.put(CRITERIA_FAMILY, "I.NAME");
        sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME ");
    }

    /** Init the human mappings so you can represent this object in human language. */
    private void _initHumanMappings() {
        if (null != humanMappings) {
            return;
        }
        humanMappings = new Hashtable();
        humanMappings.put(CRITERIA_GROUP, "Group ");
        humanMappings.put(CRITERIA_ORDER, "Order ");
        humanMappings.put(CRITERIA_FAMILY, "Family ");
        humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name ");
    }

    /** This method must be implementing by inheriting classes and should return the representation of an object as
     * an URL, for example if implementing class has 2 params: county/region then this method should return:
     * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
     * @return An URL compatible representation of this object.
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != idGroup && null != idCountry && null != idConservation) {
            url.append(Utilities.writeURLParameter("idGroup", idGroup.toString()));
            url.append(Utilities.writeURLParameter("idCountry", idCountry.toString()));
            url.append(Utilities.writeURLParameter("idConservation", idConservation.toString()));
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
        StringBuffer sql = new StringBuffer();

        if (null != idGroup && null != idCountry && null != idConservation) {
            if ((idGroup.intValue() != -1) && (idConservation.intValue() != -1)) {
                sql.append(
                        "F.ID_COUNTRY = " + idCountry + " AND C.ID_GROUP_SPECIES=" + idGroup + " AND H.ID_CONSERVATION_STATUS="
                        + idConservation);
            }
            if ((idGroup.intValue() == -1) && (idConservation.intValue() != -1)) {
                sql.append("F.ID_COUNTRY = " + idCountry + " AND H.ID_CONSERVATION_STATUS=" + idConservation);
            }
            if ((idGroup.intValue() != -1) && (idConservation.intValue() == -1)) {
                sql.append(" F.ID_COUNTRY = " + idCountry + " AND C.ID_GROUP_SPECIES=" + idGroup);
            }
            if ((idGroup.intValue() == -1) && (idConservation.intValue() == -1)) {
                sql.append(" F.ID_COUNTRY = " + idCountry);
            }
        }

        if (null != criteriaSearch && null != criteriaType && null != oper) {
            String _criteria = criteriaSearch;

            // Do the mapping / transform from group name to group ID
            if (0 == criteriaType.compareTo(CRITERIA_GROUP)) {
                _criteria = SpeciesSearchUtility.findGroupID(criteriaSearch).toString();
            }
            sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), _criteria, oper));
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
        StringBuffer url = new StringBuffer();

        if (null != idGroup && null != idCountry && null != idConservation) {
            url.append(Utilities.writeFormParameter("idGroup", idGroup.toString()));
            url.append(Utilities.writeFormParameter("idCountry", idCountry.toString()));
            url.append(Utilities.writeFormParameter("idConservation", idConservation.toString()));
        }

        if (null != criteriaSearch && null != criteriaType && null != oper) {
            url.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
            url.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
            url.append(Utilities.writeFormParameter("oper", oper.toString()));
        }
        return url.toString();
    }

    /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
     * so an representation of this object could be displayed on the page.
     * @return A human readable representation of an object.
     */
    public String toHumanString() {
        StringBuffer sql = new StringBuffer();

        if (null != criteriaSearch && null != criteriaType && null != oper) {
            String _criteria = criteriaSearch;

            // Do the mapping / transform from group name to group ID
            if (0 == criteriaType.compareTo(CRITERIA_GROUP)) {
                _criteria = criteriaSearch;
            }
            sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), _criteria, oper));
        }
        return sql.toString();
    }
}

