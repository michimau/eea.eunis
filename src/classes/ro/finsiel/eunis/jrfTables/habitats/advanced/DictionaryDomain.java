package ro.finsiel.eunis.jrfTables.habitats.advanced;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.advanced.AdvancedSortCriteria;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.ShortColumnSpec;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.JoinTable;

import java.util.List;

public class DictionaryDomain extends AbstractDomain implements Paginable {
  public static final Integer SEARCH_EUNIS = new Integer(0);
  public static final Integer SEARCH_ANNEX_I = new Integer(1);

  /** Criterias applied for sorting */
  private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted
  /** Cache the results of a count to avoid overhead queries for counting */
  private Long _resultCount = new Long(-1);

  private String IdSession = "";

  /**
   * @param IdSession
   */
  public DictionaryDomain(String IdSession) {
    this.sortCriteria = null;
    this.IdSession = IdSession;
  }

  /****/
  public PersistentObject newPersistentObject() {
    return new DictionaryPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("CHM62EDT_HABITAT");
    this.setTableAlias("A");
    this.setReadOnly(true);

    this.addColumnSpec(new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_ZERO, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName", "setScientificName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_ANNEX1", "getCodeAnnex1", "setCodeAnnex1", DEFAULT_TO_NULL));
    this.addColumnSpec(new ShortColumnSpec("PRIORITY", "getPriority", "setPriority", null, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode", "setEunisHabitatCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CLASS_REF", "getClassRef", "setClassRef", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_PART_2", "getCodePart2", "setCodePart2", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("LEVEL", "getHabLevel", "setHabLevel", DEFAULT_TO_NULL));

    // Add the join only if the search is also done in descriptions
    OuterJoinTable habitatDescr = new OuterJoinTable("CHM62EDT_HABITAT_DESCRIPTION B", "ID_HABITAT", "ID_HABITAT");
    this.addJoinTable(habitatDescr);

    JoinTable advSearchResults = new JoinTable("EUNIS_ADVANCED_SEARCH_RESULTS", "ID_NATURE_OBJECT", "ID_NATURE_OBJECT");
    this.addJoinTable(advSearchResults);
  }

  /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
   * index offset.
   * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
   * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
   * @param sortCriteria The criteria used for sorting
   * @return A list of objects which match query criteria
   */
  public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {
    this.sortCriteria = sortCriteria;
    String filterSQL = " 1=1 AND EUNIS_ADVANCED_SEARCH_RESULTS.ID_SESSION = '" + IdSession + "'";
    // Add the LIMIT clause to return only the wanted results
    filterSQL += " GROUP BY A.ID_HABITAT ";
    // Add the ORDER BY clause to do the sorting
    if (sortCriteria.length > 0) {
      filterSQL += _prepareWhereSort();
    }
    if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
      filterSQL += " LIMIT " + offsetStart + ", " + pageSize;
    }
//    System.out.println("filterSQL: " +filterSQL);
    List tempList = this.findWhere(filterSQL.toString());
    _resultCount = new Long(-1);// After each query, reset the _resultCount, so countResults do correct numbering.
    return tempList;

  }

  /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
   * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
   * @return The total number of results
   */
  public Long countResults() throws CriteriaMissingException {
    if (-1 == _resultCount.longValue()) {
      _resultCount = _rawCount();
    }
    return _resultCount;
  }

  /** This method does the raw counting (meaning that will do a DB query for retrieving results count). You should check
   * in your code that this method is called (in ideal way) only once and results are cached. This is what
   * countResults() method does in this class
   * @see ro.finsiel.eunis.jrfTables.species.country.RegionDomain#countResults
   */
  private Long _rawCount() {
    StringBuffer sql = new StringBuffer();
    sql.append("SELECT COUNT(DISTINCT A.ID_HABITAT) FROM CHM62EDT_HABITAT AS A " +
            " LEFT OUTER JOIN CHM62EDT_HABITAT_DESCRIPTION B ON B.ID_HABITAT=A.ID_HABITAT " +
            " INNER JOIN EUNIS_ADVANCED_SEARCH_RESULTS C ON A.ID_NATURE_OBJECT=C.ID_NATURE_OBJECT" +
            " WHERE 1=1 AND C.ID_SESSION='" + IdSession + "'");
    Long ret = findLong(sql.toString());
    if (null == ret) return new Long(0);
    return ret;
  }

  /** Prepare the ORDER BY clause used to do the sorting. Basically it adds the ORDER clause with the criterias set in
   * the sortCriteria[] array.
   * @return SQL representation of the sorting.
   */
  private StringBuffer _prepareWhereSort() {
    StringBuffer filterSQL = new StringBuffer();
    try {
      boolean useSort = false;
      if (sortCriteria.length > 0) {
        int i = 0;
        do {
          if (i > 0) filterSQL.append(", ");
          AdvancedSortCriteria criteria = (AdvancedSortCriteria) sortCriteria[i]; // Notice the upcast here
          if (!criteria.getCriteriaAsString().equals("none")) {// Do not add if criteria is sort to NOT SORT
            if (!criteria.getAscendencyAsString().equals("none")) { // Don't add if ascendency is set to none, nasty hacks
              filterSQL.append(criteria.toSQL());
              useSort = true;
            }
          }
          i++;
        } while (i < sortCriteria.length);
      }
      if (useSort) {// If a sort criteria was indeed used, then insert ORDER BY clause at the start of the string
        filterSQL.insert(0, " ORDER BY ");
      }
    } catch (InitializationException e) {
      e.printStackTrace();  //To change body of catch statement use Options | File Templates.
    } finally {
      return filterSQL;
    }
  }
}
