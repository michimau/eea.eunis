package ro.finsiel.eunis.search.species.national;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.SpeciesSearchUtility;

import java.util.Hashtable;

/**
 * Search criteria for species->national threat status.
 * @author finsiel
 */
public class NationalSearchCriteria extends AbstractSearchCriteria {
  /** Used in filters, filtering by Group. */
  public static final Integer CRITERIA_GROUP = new Integer(0);
  /** Used in filters, filtering by Order. */
  public static final Integer CRITERIA_ORDER = new Integer(1);
  /** Used in filters, filtering by Family. */
  public static final Integer CRITERIA_FAMILY = new Integer(2);
  /** Used in filters, filtering by Scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);
  private String groupName = null;
  private String statusName = null;
  private String countryName = null;

  private Hashtable sqlMappings = null;
  private Hashtable humanMappings = null;

  /**
   * New main search criteria object.
   * @param groupName group name
   * @param statusName status name
   * @param countryName country name
   */
  public NationalSearchCriteria(String groupName, String statusName, String countryName) {
    _initHumanMappings();
    _initSQLMappings();
    this.groupName = groupName;
    this.statusName = statusName;
    this.countryName = countryName;
  }

  /**
   * New search in results search criteria.
   * @param criteriaSearch Search string
   * @param criteriaType Type of search.
   * @param oper Relation operator.
   */
  public NationalSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
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
    sqlMappings.put(CRITERIA_GROUP, "C.ID_GROUP_SPECIES");
    sqlMappings.put(CRITERIA_ORDER, "J.NAME");
    sqlMappings.put(CRITERIA_FAMILY, "I.NAME");
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME ");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
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
    if (null != groupName && null != statusName && null != countryName) {
      url.append(Utilities.writeURLParameter("groupName", groupName.toString()));
      url.append(Utilities.writeURLParameter("statusName", statusName.toString()));
      url.append(Utilities.writeURLParameter("countryName", countryName.toString()));
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
  public String toSQL()
  {
    StringBuffer sql = new StringBuffer();

    if (null != groupName && null != statusName && null != countryName) {
      if (!groupName.equalsIgnoreCase("any")) sql.append(" AND D.common_name='" + groupName + "'");
      if (!countryName.equalsIgnoreCase("any")) {
        sql.append(" AND F.area_name_en='" + countryName + "'");
      }
      if (!statusName.equalsIgnoreCase("any")) {
        sql.append(" AND H.NAME='" + statusName + "'");
      }
    }


    if (null != criteriaSearch && null != criteriaType && null != oper) {
      String _criteria = criteriaSearch;
      // Do the mapping / transform from group name to group ID
      if (0 == criteriaType.compareTo(CRITERIA_GROUP)) _criteria = SpeciesSearchUtility.findGroupID(criteriaSearch).toString();
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
    if (null != groupName && null != statusName && null != countryName) {
      url.append(Utilities.writeFormParameter("groupName", groupName.toString()));
      url.append(Utilities.writeFormParameter("statusName", statusName.toString()));
      url.append(Utilities.writeFormParameter("countryName", countryName.toString()));
    }

    if (null != criteriaSearch && null != criteriaType && null != oper) {
      url.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
      url.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
      url.append(Utilities.writeFormParameter("oper", oper.toString()));
    }
    return url.toString();
  }

  /**
   * This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer sql = new StringBuffer();
    if (null != criteriaSearch && null != criteriaType && null != oper)
    {
      String _criteria = criteriaSearch;
      // Do the mapping / transform from group name to group ID
      if (0 == criteriaType.compareTo(CRITERIA_GROUP)) _criteria = criteriaSearch;
      sql.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), _criteria, oper));
    }
    return sql.toString();
  }
}