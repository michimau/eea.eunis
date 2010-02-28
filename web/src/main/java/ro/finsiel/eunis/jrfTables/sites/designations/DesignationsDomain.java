package ro.finsiel.eunis.jrfTables.sites.designations;

/**
 * Date: Jun 2, 2003
 * Time: 11:07:25 AM
 */

import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.designations.DesignationsSearchCriteria;
import ro.finsiel.eunis.search.sites.designations.DesignationsSortCriteria;

import java.util.List;


public class DesignationsDomain extends AbstractDomain implements Paginable {
  /** Criterias applied for searching */
  private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set
  /** Criterias applied for sorting */
  private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

  /** Cache the results of a count to avoid overhead queries for counting */
  private Long _resultCount = new Long(-1);


  private boolean[] source_db = {false, false, false, false, false, false, false, false};
  private String[] db = {"Natura2000", "Corine", "Diploma", "CDDA_National", "CDDA_International", "Biogenetic", "NatureNet", "Emerald"};


  /**
   * Normal constructor
   * @param searchCriteria The search criteria used to query the database
   * @param sortCriteria Sort criterias used for sorting the results
   */
  public DesignationsDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria, boolean[] source) {
    this.searchCriteria = searchCriteria;
    this.sortCriteria = sortCriteria;
    this.source_db = source;
  }

  public DesignationsDomain(AbstractSearchCriteria[] searchCriteria, boolean[] source) {
    this.searchCriteria = searchCriteria;
    this.source_db = source;
  }

  public DesignationsDomain() {
  }

  /****/
  public PersistentObject newPersistentObject() {
    return new DesignationsPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_DESIGNATIONS");
    this.setTableAlias("J");
    this.setReadOnly(true);

    this.addColumnSpec(
            new CompoundPrimaryKeyColumnSpec(
                    new StringColumnSpec("ID_DESIGNATION", "getIdDesignation", "setIdDesignation", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY),
                    new StringColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_NULL, NATURAL_PRIMARY_KEY)
            )
    );

    this.addColumnSpec(new StringColumnSpec("DESCRIPTION", "getDescription", "setDescription", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION_EN", "getDescriptionEn", "setDescriptionEn", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("DESCRIPTION_FR", "getDescriptionFr", "setDescriptionFr", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ID_DESIGNATION", "getAbbreviation", "setAbbreviation", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ORIGINAL_DATASOURCE", "getSourceDb", "setSourceDb", null));

    JoinTable J4 = new OuterJoinTable("CHM62EDT_SITES S", "ID_DESIGNATION", "ID_DESIGNATION");
    J4.addJoinColumn(new StringJoinColumn("SOURCE_DB", "setDataSet"));
    this.addJoinTable(J4);

    OuterJoinTable J3 = new OuterJoinTable("CHM62EDT_COUNTRY I", "ID_GEOSCOPE", "ID_GEOSCOPE");
    J3.addJoinColumn(new StringJoinColumn("AREA_NAME_EN", "setCountry"));
    this.addJoinTable(J3);

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
    if (searchCriteria.length < 1) throw new CriteriaMissingException("Unable to search because no search criteria was specified...");

    StringBuffer filterSQL = _prepareWhereSearch();

    filterSQL.append("GROUP BY J.ID_DESIGNATION,J.ID_GEOSCOPE");
    // Add the ORDER BY clause to do the sorting
    if (sortCriteria.length > 0) {
      filterSQL.append(_prepareWhereSort());
    }
    // Add the LIMIT clause to return only the wanted results
    if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
      filterSQL.append(" LIMIT " + offsetStart + ", " + pageSize);
    }

    //List tempList = this.findWhere(filterSQL.toString());
    List tempList = this.findCustom("SELECT J.ID_DESIGNATION, J.ID_GEOSCOPE,J.DESCRIPTION,J.DESCRIPTION_EN,J.DESCRIPTION_FR,J.ID_DESIGNATION,J.ORIGINAL_DATASOURCE,S.SOURCE_DB,I.AREA_NAME_EN " +
            "FROM CHM62EDT_DESIGNATIONS J "
            + "INNER JOIN CHM62EDT_SITES S ON (J.ID_DESIGNATION=S.ID_DESIGNATION AND J.ID_GEOSCOPE=S.ID_GEOSCOPE) "
            + "LEFT OUTER JOIN CHM62EDT_COUNTRY I ON J.ID_GEOSCOPE=IF(I.ID_GEOSCOPE='',NULL,I.ID_GEOSCOPE) "
            + "WHERE  " + filterSQL.toString());
    _resultCount = new Long(-1);// After each query, reset the _resultCount, so countResults do correct numbering.
    return tempList;
  }


  /** This method is used to count the total list of results from a query. It is used to find all for use in pagination.
   * Having the total number of results and the results displayed per page, the you could find the number of pages i.e.
   * @return Number of results found
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

   * @return
   * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException
   */
  private Long _rawCount() throws CriteriaMissingException {

    if (searchCriteria.length < 1) throw new CriteriaMissingException("Unable to search because no search criteria was specified...");
    // Prepare the WHERE clause   put search Criteria
    StringBuffer filterSQL = _prepareWhereSearch();

    filterSQL.append("GROUP BY J.ID_DESIGNATION,J.ID_DESIGNATION");

    //List tempList = this.findWhere(filterSQL.toString());
    List tempList = this.findCustom("SELECT J.ID_DESIGNATION, J.ID_GEOSCOPE,J.DESCRIPTION,J.DESCRIPTION_EN,J.DESCRIPTION_FR,J.ID_DESIGNATION,J.ORIGINAL_DATASOURCE,S.SOURCE_DB,I.AREA_NAME_EN " +
            "FROM CHM62EDT_DESIGNATIONS J "
            + "INNER JOIN CHM62EDT_SITES S ON (J.ID_DESIGNATION=S.ID_DESIGNATION AND J.ID_GEOSCOPE=S.ID_GEOSCOPE) "
            + "LEFT OUTER JOIN CHM62EDT_COUNTRY I ON J.ID_GEOSCOPE=IF(I.ID_GEOSCOPE='',NULL,I.ID_GEOSCOPE) "
            + "WHERE  " + filterSQL.toString());
    if (null != tempList)
      return new Long(tempList.size());
    else
      return new Long(0);
  }

  /**
   * This helper method is used to construct the string after WHERE...based on search criterias set. In another words
   * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
   * @return SQL string
   * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
   */
  private StringBuffer _prepareWhereSearch() throws CriteriaMissingException {
    StringBuffer filterSQL = new StringBuffer();
    if (searchCriteria.length <= 0) throw new CriteriaMissingException("No criteria set for searching. Search interrupted.");

    for (int i = 0; i < searchCriteria.length; i++) {
      if (i > 0 && filterSQL.length() > 0) filterSQL.append(" AND ");
      DesignationsSearchCriteria aCriteria = (DesignationsSearchCriteria) searchCriteria[i]; // upcast
      filterSQL.append(aCriteria.toSQL());
    }

    filterSQL.append(" AND S.ID_GEOSCOPE = J.ID_GEOSCOPE ");
    filterSQL = Utilities.getConditionForSourceDB(filterSQL, source_db, db, "S");
    return filterSQL;
  }


  /**
   * Prepare the ORDER BY clause used to do the sorting. Basically it adds the ORDER clause with the criterias set in
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
          DesignationsSortCriteria criteria = (DesignationsSortCriteria) sortCriteria[i]; // Notice the upcast here
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
    }
    return filterSQL;
  }
}

