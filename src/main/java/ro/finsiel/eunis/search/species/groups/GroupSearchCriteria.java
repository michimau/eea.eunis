package ro.finsiel.eunis.search.species.groups;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

import java.util.Hashtable;

/**
 * Search criteria for species->groups.
 * @author finsiel
 */
public final class GroupSearchCriteria extends AbstractSearchCriteria {
  /** Defines a search after Group.  */
  public static final Integer CRITERIA_GROUP = new Integer(0);
  /** Defines a search after Order.  */
  public static final Integer CRITERIA_ORDER = new Integer(1);
  /** Defines a search after Family. */
  public static final Integer CRITERIA_FAMILY = new Integer(2);
  /** Defines a search after Scientific name. */
  public static final Integer CRITERIA_SCIENTIFIC_NAME = new Integer(3);

  /* Defines the group after which the search is done. */
  private Integer groupID = null;

  /** Map the search criterias to SQL queries. */
  private static Hashtable sqlMappings = null;
  /** Map the search criterias to human readable strings. */
  private static Hashtable humanMappings = null;


  /**
   * Constructs an new object resembling search criteria, which is given by its groupID, so I basically search
   * all the species from a group.
   * @param groupID The ID of the group I'm searching for.
   */
  public GroupSearchCriteria(Integer groupID) {
    _initSQLMappings();
    _initHumanMappings();
    this.groupID = groupID;
    this.criteriaSearch = null;
    this.criteriaType = null;
    this.oper = null;
  }

  /** Constructs an object should be used for search in results. It gives the three basic elements for constructing
   * the object.
   * @param criteriaSearch Search criteria: String to be searched (the filter)
   * @param criteriaType Criteria type: this.ORDER/FAMILY/SCIENTIFIC NAME (what first param refers to)
   * @param oper Type of link between first two parameters: super.OPERATOR_IS/STARTS/CONTAINS
   */
  public GroupSearchCriteria(String criteriaSearch, Integer criteriaType, Integer oper) {
    _initSQLMappings();
    _initHumanMappings();
    this.criteriaSearch = criteriaSearch;
    this.criteriaType = criteriaType;
    this.oper = oper;
    this.groupID = null;
  }

  /** This method must be implementing by inheriting classes and should return the representation of an object as
   * an URL, for example if implementing class has 2 params: county/region then this method should return:
   * country=XXX&region=YYY, in order to put the object on the request to forward params to next page.
   * @return An URL compatible representation of this object.
   */
  public String toURLParam() {
    StringBuffer url = new StringBuffer();
    if (null != groupID) {
      url.append(Utilities.writeURLParameter("groupID", groupID.toString()));
    }
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      url.append(Utilities.writeURLParameter("criteriaSearch", criteriaSearch));
      url.append(Utilities.writeURLParameter("criteriaType", criteriaType.toString()));
      url.append(Utilities.writeURLParameter("oper", oper.toString()));
    }
    return url.toString();
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
    if (null != groupID) {
      form.append(Utilities.writeFormParameter("groupID", groupID.toString()));
    }
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      form.append(Utilities.writeFormParameter("criteriaSearch", criteriaSearch));
      form.append(Utilities.writeFormParameter("criteriaType", criteriaType.toString()));
      form.append(Utilities.writeFormParameter("oper", oper.toString()));
    }
    return form.toString();
  }

  /**
   * Transform this object into an SQL representation.
   * @return SQL representation of this object
   */
  public String toSQL() {
    StringBuffer sql = new StringBuffer();
    if (null != groupID) {
      sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(CRITERIA_GROUP), groupID.toString(), Utilities.OPERATOR_IS));
    }
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      sql.append(Utilities.prepareSQLOperator((String) sqlMappings.get(criteriaType), criteriaSearch, oper));
    }
    return sql.toString();
  }


  /** This method supplies a human readable string representation of this object. for example "Country is Romania"...
   * so an representation of this object could be displayed on the page.
   * @return A human readable representation of an object.
   */
  public String toHumanString() {
    StringBuffer human = new StringBuffer();
    if (null != groupID) {
      human.append(Utilities.prepareHumanString((String) humanMappings.get(CRITERIA_GROUP), groupID.toString(), Utilities.OPERATOR_IS));
    }
    if (null != criteriaSearch && null != criteriaType && null != oper) {
      human.append(Utilities.prepareHumanString((String) humanMappings.get(criteriaType), criteriaSearch, oper));
    }
    return human.toString();
  }

  /** Init the mappings used to compose the SQL query. */
  private void _initSQLMappings() {
    if (null != sqlMappings) return;
    sqlMappings = new Hashtable();
    sqlMappings.put(CRITERIA_GROUP, "A.ID_GROUP_SPECIES");
    sqlMappings.put(CRITERIA_ORDER, "C.NAME");
    sqlMappings.put(CRITERIA_FAMILY, "B.NAME");
    sqlMappings.put(CRITERIA_SCIENTIFIC_NAME, "A.SCIENTIFIC_NAME");
  }

  /** Init the human mappings so you can represent this object in human language. */
  private void _initHumanMappings() {
    if (null != humanMappings) return;
    humanMappings = new Hashtable();
    humanMappings.put(CRITERIA_GROUP, "Group");
    humanMappings.put(CRITERIA_ORDER, "Order");
    humanMappings.put(CRITERIA_FAMILY, "Family ");
    humanMappings.put(CRITERIA_SCIENTIFIC_NAME, "Scientific name");
  }

  /**
   * Testing method.
   * @param args command line
   */
  public static void main(String[] args) {
    GroupSearchCriteria aCriteria = new GroupSearchCriteria(new Integer(234));
//    System.out.println("1.aCriteria.toHumanString():" + aCriteria.toHumanString());
//    System.out.println("1.aCriteria.toSQL():" + aCriteria.toSQL());
//    System.out.println("1.aCriteria.toURLParam():" + aCriteria.toURLParam());
//    System.out.println("1.aCriteria.toFORMParam():" + aCriteria.toFORMParam());
    GroupSearchCriteria anotherCriteria = new GroupSearchCriteria("my custom search",
            GroupSearchCriteria.CRITERIA_SCIENTIFIC_NAME, Utilities.OPERATOR_CONTAINS);
//    System.out.println("2.anotherCriteria.toHumanString():" + anotherCriteria.toHumanString());
//    System.out.println("2.anotherCriteria.toSQL():" + anotherCriteria.toSQL());
//    System.out.println("2.anotherCriteria.toURLParam():" + anotherCriteria.toURLParam());
//    System.out.println("2.anotherCriteria.toFORMParam():" + anotherCriteria.toFORMParam());
  }
}