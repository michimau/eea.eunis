package ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefPersist;

import java.util.List;


import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.OuterJoinTable;
import net.sf.jrf.join.joincolumns.DateJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.join.joincolumns.ShortJoinColumn;
import net.sf.jrf.join.joincolumns.IntegerJoinColumn;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesSearchCriteria;
import ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesSortCriteria;

import java.util.List;

public class RefDomain extends AbstractDomain implements Paginable {
  public static final Integer SEARCH_EUNIS = new Integer(0);
  public static final Integer SEARCH_ANNEX_I = new Integer(1);
  public static final Integer SEARCH_BOTH = new Integer(2);
  public static final Integer SOURCE = new Integer(3);
  public static final Integer OTHER_INFO = new Integer(4);

  /** Criterias applied for searching */
  private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set
  /** Criterias applied for sorting */
  private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted
  /** Cache the results of a count to avoid overhead queries for counting */
  private Long _resultCount = new Long(-1);
  /** Specifies where to search: SEARCH_EUNIS or SEARCH_ANNEX_I */
  private Integer searchPlace = SEARCH_EUNIS;

  private Integer source = SOURCE;


  public RefDomain(AbstractSearchCriteria[] searchCriteria, AbstractSortCriteria[] sortCriteria, Integer searchPlace, Integer source) {
    this.searchCriteria = searchCriteria;
    this.searchPlace = searchPlace;
    this.sortCriteria = sortCriteria;
    this.source = source;
  }

  /**
   **/
  public PersistentObject newPersistentObject() {
    return new RefPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());
    this.setTableName("DC_INDEX");
    this.setReadOnly(true);
    this.setTableAlias("A");

    this.addColumnSpec(
            new IntegerColumnSpec("ID_DC", "getIdDc", "setIdDc", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("COMMENT", "getComment", "setComment", DEFAULT_TO_NULL));

    // Joined tables
    OuterJoinTable Source = null;
    Source = new OuterJoinTable("DC_SOURCE D", "ID_DC", "ID_DC");
    Source.addJoinColumn(new StringJoinColumn("SOURCE", "setSource"));
    Source.addJoinColumn(new StringJoinColumn("EDITOR", "setEditor"));
    Source.addJoinColumn(new StringJoinColumn("URL", "setUrl"));
    this.addJoinTable(Source);


    OuterJoinTable Date = null;
    Date = new OuterJoinTable("DC_DATE E", "ID_DC", "ID_DC");
    Date.addJoinColumn(new DateJoinColumn("CREATED", "created", "setcreated"));
    this.addJoinTable(Date);

    OuterJoinTable Title = null;
    Title = new OuterJoinTable("DC_TITLE F", "ID_DC", "ID_DC");
    Title.addJoinColumn(new StringJoinColumn("TITLE", "title", "settitle"));
    Title.addJoinColumn(new StringJoinColumn("ALTERNATIVE", "alternative", "setalternative"));
    this.addJoinTable(Title);

    OuterJoinTable Publisher = null;
    Publisher = new OuterJoinTable("DC_PUBLISHER G", "ID_DC", "ID_DC");
    Publisher.addJoinColumn(new StringJoinColumn("PUBLISHER", "publisher", "setpublisher"));
    this.addJoinTable(Publisher);

    JoinTable habitatReferences = null;
    habitatReferences = new JoinTable("CHM62EDT_HABITAT_REFERENCES B", "ID_DC", "ID_DC");
    habitatReferences.addJoinColumn(new StringJoinColumn("ID_HABITAT", "idHabitat", "setIdHabitat"));
    habitatReferences.addJoinColumn(new ShortJoinColumn("HAVE_SOURCE", "haveSource", "setHaveSource"));
    habitatReferences.addJoinColumn(new ShortJoinColumn("HAVE_OTHER_REFERENCES", "haveOtherReferences", "setHaveOtherReferences"));
    this.addJoinTable(habitatReferences);

    JoinTable habitat = null;
    habitat = new JoinTable("CHM62EDT_HABITAT H", "ID_HABITAT", "ID_HABITAT");
    habitat.addJoinColumn(new StringJoinColumn("SCIENTIFIC_NAME", "scName", "setScName"));
    habitat.addJoinColumn(new StringJoinColumn("EUNIS_HABITAT_CODE", "eunisCode", "setEunisCode"));
    habitat.addJoinColumn(new StringJoinColumn("CODE_ANNEX1", "annex1Code", "setAnnex1Code"));
    habitat.addJoinColumn(new StringJoinColumn("CODE_2000", "code2000", "setCode2000"));
    habitat.addJoinColumn(new IntegerJoinColumn("LEVEL", "level", "setLevel"));
    habitat.addJoinColumn(new StringJoinColumn("DESCRIPTION", "description", "setDescription"));
    habitatReferences.addJoinTable(habitat);
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
    filterSQL.append(" GROUP BY H.ID_HABITAT ");

    // Add the ORDER BY clause to do the sorting
    if (sortCriteria.length > 0) {
      filterSQL.append(_prepareWhereSort());
    }
    // Add the LIMIT clause to return only the wanted results
    if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
      filterSQL.append(" LIMIT " + offsetStart + ", " + pageSize);
    }
    List tempList = this.findWhere(filterSQL.toString());
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
    filterSQL.append(" GROUP BY H.ID_HABITAT ");

    List tempList = this.findWhere(filterSQL.toString());
    if (null != tempList)
      return new Long(tempList.size());
    else
      return new Long(0);

  }


  /** This helper method is used to construct the string after WHERE...based on search criterias set. In another words
   * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
   * @return SQL string
   * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
   */
  private StringBuffer _prepareWhereSearch() throws CriteriaMissingException {
    StringBuffer filterSQL = new StringBuffer();
    if (searchCriteria.length <= 0) throw new CriteriaMissingException("No criteria set for searching. Search interrupted.");
    filterSQL.append(" (1 = 1) ");
    filterSQL.append(" AND IF(TRIM(H.CODE_2000) <> '',RIGHT(H.CODE_2000,2),1) <> IF(TRIM(H.CODE_2000) <> '','00',2) AND IF(TRIM(H.CODE_2000) <> '',LENGTH(H.CODE_2000),1) = IF(TRIM(H.CODE_2000) <> '',4,1) ");
    if (0 != RefDomain.SEARCH_BOTH.compareTo(searchPlace)) {
      if (0 == searchPlace.compareTo(RefDomain.SEARCH_EUNIS)) {
        filterSQL.append(" AND H.ID_HABITAT>=1 and H.ID_HABITAT<10000 ");
      }
      if (0 == searchPlace.compareTo(RefDomain.SEARCH_ANNEX_I)) {
        filterSQL.append(" AND H.ID_HABITAT>10000 ");
      }
    } else
      filterSQL.append(" AND H.ID_HABITAT<>'-1' and H.ID_HABITAT<>'10000' ");

    if (0 == source.compareTo(RefDomain.SOURCE)) {
      filterSQL.append(" AND B.HAVE_SOURCE = '1' ");
    }
    if (0 == source.compareTo(RefDomain.OTHER_INFO)) {
      filterSQL.append(" AND B.HAVE_OTHER_REFERENCES = '1' ");
    }
    for (int i = 0; i < searchCriteria.length; i++) {
      ReferencesSearchCriteria aCriteria = (ReferencesSearchCriteria) searchCriteria[i]; // upcast
      if (aCriteria == null) {
      } else {
        if (aCriteria.toSQL().length() > 0) filterSQL.append(" AND ");
        filterSQL.append(aCriteria.toSQL());
      }
    }
    return filterSQL;
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
          ReferencesSortCriteria criteria = (ReferencesSortCriteria) sortCriteria[i]; // Notice the upcast here
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

  /** This method returns all the criterias used to do the search in database
   * @return An array of criteria objects used to do the search. Please note that in order to do at least one (1) search
   * you should pass an array of at least of length of 1 or the search wouldn't (or at least shouldn't) be done.
   * Also as a trick, by passing more than one (1) object the search should do 'search in results' type of search, so
   * basically an array of length with more than (>) 1 will do addiotional filtering.
   */
  public AbstractSearchCriteria[] getSearchCriteria() {
    return searchCriteria;
  }

  /** Sets the search criteria used to do the filters...
   * @param criteria Search criteria used to do the filtering of results.
   * You could use this method to implement an navigation type of search in results. Take for example:
   * Search for habitats whom scientific name is Marine, then filter after 'marine'. you could to an navigation bar
   * which 'remembers' searched results as follows: "Marine" > .... implemented as links, so user
   * pressing on back links, goes back to the search criteria...
   */
  public void setSearchCriteria(AbstractSearchCriteria[] criteria) {
    this.searchCriteria = criteria;
  }


  /** This method must be implementing by inheriting classes and should return the representation of all
   * AbstractSearchCriteria objects as an single URL, for example if implementing class has 2 params: county/region
   * then this method should return:
   * country=XXX&region=YYY&country=ZZZ&region=WWW ...., in order to put all objects on the request to forward params to
   * next page and provide the ability to reconstruct there the objects.
   * @return An URL compatible representation of this object.
   */
  public String getSearchCriteriaAsURL() {
    return null;
  }

  /** Retrieve the currently criteria used for sorting
   * @return Sort criteria used
   */
  public AbstractSortCriteria[] getSortCriteria() {
    return new AbstractSortCriteria[0];
  }

  /** Set the new sort criteria
   * @param criterias The new criterias (columns) after which the results will be sorted.
   */
  public void setSortCriteria(AbstractSortCriteria[] criterias) {
  }
}

