package ro.finsiel.eunis.jrfTables.sites.habitats;

/**
 * Date: May 19, 2003
 * Time: 10:51:29 AM
 */

import net.sf.jrf.column.columnspecs.IntegerColumnSpec;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.habitats.HabitatSearchCriteria;
import ro.finsiel.eunis.search.sites.habitats.HabitatSortCriteria;
import ro.finsiel.eunis.jrfTables.GenericDomain;
import ro.finsiel.eunis.jrfTables.GenericPersist;
import ro.finsiel.eunis.admin.FileUtils;

import java.util.List;
import java.util.Vector;

public class HabitatDomain extends AbstractDomain implements Paginable {
  public static final Integer SEARCH_EUNIS = new Integer(0);
  public static final Integer SEARCH_ANNEX_I = new Integer(1);
  public static final Integer SEARCH_BOTH = new Integer(2);
  /** Criterias applied for searching */
  private AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0]; // 0 length means not criteria set
  /** Criterias applied for sorting */
  private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0]; // 0 length means unsorted

  /** Cache the results of a count to avoid overhead queries for counting */
  private Long _resultCount = new Long(-1);
  /** Specifies where to search: SEARCH_EUNIS or SEARCH_ANNEX_I */
  private Integer searchPlace = SEARCH_EUNIS;

  private boolean[] source_db = {true, true, true, true, true, true, false, true };
  private String[] db = {"Natura2000", "Corine", "Diploma", "CDDA_National", "CDDA_International", "Biogenetic", "NatureNet", "Emerald"};
  private Integer searchAttribute = null;

  /**
   * Normal constructor
   * @param searchCriteria The search criteria used to query the database
   * @param sortCriteria Sort criterias used for sorting the results
   */
  public HabitatDomain(AbstractSearchCriteria[] searchCriteria,
                       AbstractSortCriteria[] sortCriteria,
                       Integer searchPlace,
                       boolean[] source,
                       Integer searchAttribute) {
    this.searchAttribute = searchAttribute;
    this.searchCriteria = searchCriteria;
    this.sortCriteria = sortCriteria;
    this.searchPlace = searchPlace;
    this.source_db = source;
  }

  public HabitatDomain(AbstractSearchCriteria[] searchCriteria, Integer searchPlace, boolean[] source) {
    this.searchCriteria = searchCriteria;
    this.searchPlace = searchPlace;
    this.source_db = source;
  }

  public HabitatDomain() {
  }

  /****/
  public PersistentObject newPersistentObject() {
    return new HabitatPersist();
  }

  /****/
  public void setup() {
    // These setters could be used to override the default.
    // this.setDatabasePolicy(new null());
    // this.setJDBCHelper(JDBCHelperFactory.create());

    this.setTableName("CHM62EDT_SITES");
    this.setReadOnly(true);
    this.setTableAlias("A");
    this.addColumnSpec(new StringColumnSpec("ID_SITE", "getIdSite", "setIdSite", DEFAULT_TO_EMPTY_STRING, NATURAL_PRIMARY_KEY));
    this.addColumnSpec(new StringColumnSpec("SOURCE_DB", "getSourceDB", "setSourceDB", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_NATURE_OBJECT", "getIdNatureObject", "setIdNatureObject", DEFAULT_TO_NULL));
    this.addColumnSpec(new IntegerColumnSpec("ID_GEOSCOPE", "getIdGeoscope", "setIdGeoscope", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("ID_DESIGNATION", "getIdDesignation", "setIdDesignation", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("NAME", "getName", "setName", DEFAULT_TO_EMPTY_STRING, REQUIRED));
    this.addColumnSpec(new StringColumnSpec("LONG_EW", "getLongEW", "setLongEW", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_DEG", "getLongDeg", "setLongDeg", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_MIN", "getLongMin", "setLongMin", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LONG_SEC", "getLongSec", "setLongSec", DEFAULT_TO_NULL));

    this.addColumnSpec(new StringColumnSpec("LAT_NS", "getLatNS", "setLatNS", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_DEG", "getLatDeg", "setLatDeg", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_MIN", "getLatMin", "setLatMin", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LAT_SEC", "getLatSec", "setLatSec", DEFAULT_TO_NULL));

    this.addColumnSpec(new StringColumnSpec("LONGITUDE", "getLongitude", "setLongitude", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("LATITUDE", "getLatitude", "setLatitude", DEFAULT_TO_NULL));

    // FROM CHM62EDT_HABITAT
    this.addColumnSpec(new StringColumnSpec("SCIENTIFIC_NAME", "getHabitatName", "setHabitatName", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("EUNIS_HABITAT_CODE", "getEunisHabitatCode", "setEunisHabitatCode", DEFAULT_TO_NULL));
    this.addColumnSpec(new StringColumnSpec("CODE_2000", "getCode2000", "setCode2000", DEFAULT_TO_NULL));
    // FROM CHM62EDT_HABITAT_CLASS_CODE
    this.addColumnSpec(new StringColumnSpec("CODE", "getHabitatClassCodeCode", "setHabitatClassCodeCode", DEFAULT_TO_NULL));
  }

  /** This method is used to retrieve a sub-set of the main results of a query given its start index offset and end
   * index offset.
   * @param offsetStart The start offset (i.e. 0). If offsetStart = offSetEnd then return the whole list
   * @param pageSize The end offset (i.e. 1). If offsetStart = offSetEnd then return the whole list
   * @param sortCriteria The criteria used for sorting
   * @return A list of objects which match query criteria
   */
  public List getResults(int offsetStart, int pageSize, AbstractSortCriteria[] sortCriteria) throws CriteriaMissingException {
    StringBuffer filterSQL = new StringBuffer();
    this.sortCriteria = sortCriteria;
    filterSQL = _prepareWhereSearch();
    String sql = prepareSQL("H.ID_SITE, H.SOURCE_DB, H.ID_NATURE_OBJECT, H.ID_GEOSCOPE, H.ID_DESIGNATION, H.NAME, H.LONG_EW, H.LONG_DEG, H.LONG_MIN, " +
            "H.LONG_SEC, H.LAT_NS, H.LAT_DEG, H.LAT_MIN, H.LAT_SEC, H.LONGITUDE, H.LATITUDE," +
            "C.SCIENTIFIC_NAME, " +
            "C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME", // Because of extended columns from the table.
            filterSQL + " GROUP BY H.ID_NATURE_OBJECT");
    // Add the ORDER BY clause to do the sorting
    if (sortCriteria.length > 0) {
      sql += _prepareWhereSort();
    }
    // Add the LIMIT clause to return only the wanted results
    if (pageSize != 0) { // Doesn't make sense for pageSize = 0.
      sql += " LIMIT " + offsetStart + ", " + pageSize;
    }
    List results = new Vector();
    try {
      results = findCustom(sql);
    } catch (Exception _ex) {
      _ex.printStackTrace();
      results = new Vector();
    } finally {
      _resultCount = new Long(-1);// After each query, reset the _resultCount, so countResults do correct numbering.
      return results;
    }
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
    Long results = new Long(-1);
    StringBuffer filterSQL = _prepareWhereSearch();
    String sql = prepareSQL("COUNT(DISTINCT H.ID_NATURE_OBJECT)", filterSQL.toString());
    try
    {
      results = findLong(sql);
    }
    catch (Exception _ex)
    {
      _ex.printStackTrace();
      results = new Long(-1);
    }
    return results;
  }

  /**
   * This helper method is used to construct the string after WHERE...based on search criterias set. In another words
   * constructs .....WHERE...>>B.ID_GEOSCOPE_LINK=XXX OR B.ID_GEOSCOPE_LINK=YYY OR B.ID_GEOSCOPE_LINK=ZZZ .....
   * @return SQL string
   * @throws ro.finsiel.eunis.exceptions.CriteriaMissingException If no search criteria search or wrong criteria is set.
   */
  private StringBuffer _prepareWhereSearch() throws CriteriaMissingException {
    StringBuffer filterSQL = new StringBuffer();
    if (0 != searchPlace.compareTo(SEARCH_BOTH)) {
      if (0 == searchPlace.compareTo(SEARCH_EUNIS)) {
        filterSQL.append(" AND C.ID_HABITAT >=1 AND C.ID_HABITAT<10000 ");
      }
      if (0 == searchPlace.compareTo(SEARCH_ANNEX_I)) {
        filterSQL.append(" AND C.ID_HABITAT>10000 ");
      }
    } else {
      filterSQL.append(" AND C.ID_HABITAT <>'-1' AND C.ID_HABITAT<>'10000' ");
    }
    filterSQL = Utilities.getConditionForSourceDB(filterSQL, source_db, db, "H");
    if (searchCriteria.length <= 0) throw new CriteriaMissingException("No criteria set for searching. Search interrupted.");
    for (int i = 0; i < searchCriteria.length; i++) {
      filterSQL.append(" AND ");
      HabitatSearchCriteria aCriteria = (HabitatSearchCriteria) searchCriteria[i]; // upcast
      filterSQL.append(aCriteria.toSQL());
    }
    filterSQL.append(" AND IF(TRIM(C.CODE_2000) <> '',RIGHT(C.CODE_2000,2),1) <> IF(TRIM(C.CODE_2000) <> '','00',2) AND IF(TRIM(C.CODE_2000) <> '',LENGTH(C.CODE_2000),1) = IF(TRIM(C.CODE_2000) <> '',4,1) ");
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
          HabitatSortCriteria criteria = (HabitatSortCriteria) sortCriteria[i]; // Notice the upcast here
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

  /**
   * Finds habitats from the specified site
   * @param criteria New search criteria
   * @return A non-null list with habitats names
   */
  public List findHabitatsFromSite(HabitatSearchCriteria criteria,
                                   Integer searchAttribute,
                                   boolean[] source) {
    if (null == criteria) {
      System.out.println("Warning:" + HabitatDomain.class.getName() + "::findHabitatsFromSite(" + criteria + ", " + "...). One of criterias was null.");
      return new Vector();
    }
    this.searchCriteria = new AbstractSearchCriteria[1];
    this.searchCriteria[0] = criteria;
    this.searchAttribute = searchAttribute;
    this.source_db = source;
    StringBuffer filterSQL = new StringBuffer("");
    List results = new Vector();
    List habitats = new Vector();
    try {
      filterSQL = _prepareWhereSearch();
    } catch (CriteriaMissingException _ex) {
      _ex.printStackTrace();
    }
    String sql = prepareSQL("H.ID_SITE, H.SOURCE_DB, H.ID_NATURE_OBJECT, H.ID_GEOSCOPE, H.ID_DESIGNATION, H.NAME, H.LONG_EW, H.LONG_DEG, H.LONG_MIN, " +
            "H.LONG_SEC, H.LAT_NS, H.LAT_DEG, H.LAT_MIN, H.LAT_SEC, H.LONGITUDE, H.LATITUDE, " +
            "C.SCIENTIFIC_NAME, " +
            "C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME", // Because of extended columns from the table.
            filterSQL + " GROUP BY C.ID_NATURE_OBJECT");
    try {
      results = new HabitatDomain().findCustom(sql);
    } catch (Exception _ex) {
      _ex.printStackTrace();
    }
    for (int i = 0; i < results.size(); i++) {
      HabitatPersist habitat = (HabitatPersist) results.get(i);
      habitats.add(habitat.getHabitatName());
    }
    return habitats;
  }

  /**
   * Finds habitats from the specified site
   * @param criteria New search criteria
   * @return A non-null list with habitats names
   */
  public List findHabitatsFromSpecifiedSite(HabitatSearchCriteria criteria,
                                   Integer searchAttribute,
                                   boolean[] source,
                                   String siteName) {
    if (null == criteria) {
      System.out.println("Warning:" + HabitatDomain.class.getName() + "::findHabitatsFromSite(" + criteria + ", " + "...). One of criterias was null.");
      return new Vector();
    }
    this.searchCriteria = new AbstractSearchCriteria[1];
    this.searchCriteria[0] = criteria;
    this.searchAttribute = searchAttribute;
    this.source_db = source;
    StringBuffer filterSQL = new StringBuffer("");
    List results = new Vector();
    List habitats = new Vector();
    try {
      filterSQL = _prepareWhereSearch();
      filterSQL.append(" AND H.NAME = '"+siteName.replaceAll("'","''")+"' ");
    } catch (CriteriaMissingException _ex) {
      _ex.printStackTrace();
    }
    String sql = prepareSQL("H.ID_SITE, H.SOURCE_DB, H.ID_NATURE_OBJECT, H.ID_GEOSCOPE, H.ID_DESIGNATION, H.NAME, H.LONG_EW, H.LONG_DEG, H.LONG_MIN, " +
            "H.LONG_SEC, H.LAT_NS, H.LAT_DEG, H.LAT_MIN, H.LAT_SEC, H.LONGITUDE, H.LATITUDE, " +
            "C.SCIENTIFIC_NAME, " +
            "C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME", // Because of extended columns from the table.
            filterSQL + " GROUP BY C.ID_NATURE_OBJECT");
    try {
      results = new HabitatDomain().findCustom(sql);
    } catch (Exception _ex) {
      _ex.printStackTrace();
    }
    for (int i = 0; i < results.size(); i++) {
      HabitatPersist habitat = (HabitatPersist) results.get(i);
      habitats.add(habitat.getHabitatName());
    }
    return habitats;
  }

  /**
   * Finds habitats from the specified site.
   * @param criteria New search criteria
   * @return A non-null list with species scientific names
   */
  public List findPopupLOV(HabitatSearchCriteria criteria,
                           Integer database,
                           Integer searchAttribute,
                           boolean[] source) {
    if (null == criteria) {
      System.out.println("Warning: " + HabitatDomain.class.getName() + "::findPopupLOV(" + criteria + ", " + "...). One of criterias was null.");
      return new Vector();
    }
    this.searchCriteria = new AbstractSearchCriteria[1];
    this.searchCriteria[0] = criteria;
    this.searchAttribute = searchAttribute;
    this.source_db = source;
    StringBuffer filterSQL = new StringBuffer("");
    List results = new Vector();
    List habitats = new Vector();
    try {
      filterSQL = _prepareWhereSearch();
    } catch (CriteriaMissingException _ex) {
      _ex.printStackTrace();
    }
    String sql = "";
    // SCIENTIFIC NAME
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_NAME.intValue()) {
      sql = prepareSQL("H.ID_SITE, H.SOURCE_DB, H.ID_NATURE_OBJECT, H.ID_GEOSCOPE, H.ID_DESIGNATION, H.NAME, H.LONG_EW, H.LONG_DEG, H.LONG_MIN, " +
              "H.LONG_SEC, H.LAT_NS, H.LAT_DEG, H.LAT_MIN, H.LAT_SEC, H.LONGITUDE, H.LATITUDE, " +
              "C.SCIENTIFIC_NAME, " +
              "C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME, C.SCIENTIFIC_NAME", // Because of extended columns from the table.
              filterSQL + " GROUP BY C.ID_NATURE_OBJECT");
      try {
        results = new HabitatDomain().findCustom(sql);
      } catch (Exception _ex) {
        _ex.printStackTrace();
      }
      for (int i = 0; i < results.size(); i++) {
        HabitatPersist habitat = (HabitatPersist) results.get(i);
        habitats.add(habitat.getHabitatName());
      }
    }
    // CODE
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_CODE.intValue()) {
      filterSQL = new StringBuffer();
      if (0 != searchPlace.compareTo(SEARCH_BOTH)) {
        if (0 == searchPlace.compareTo(SEARCH_EUNIS)) {
          filterSQL.append(" C.ID_HABITAT >= 1 AND C.ID_HABITAT < 10000 ");
        }
        if (0 == searchPlace.compareTo(SEARCH_ANNEX_I)) {
          filterSQL.append(" C.ID_HABITAT>10000 ");
        }
      } else {
        filterSQL.append(" C.ID_HABITAT <> '-1' AND C.ID_HABITAT <> '10000' ");
      }
      filterSQL = Utilities.getConditionForSourceDB(filterSQL, source_db, db, "H");

      String where = criteria.getSearchString();
      Integer relOp = criteria.getRelationOp();
      if ( where == null || where.trim().equalsIgnoreCase(""))
      {
        where = "%";
        relOp = Utilities.OPERATOR_CONTAINS;
      }
      sql = "(" +
              " SELECT DISTINCT C.EUNIS_HABITAT_CODE AS COLUMN1 " +
              " FROM CHM62EDT_HABITAT AS C " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) AND " + Utilities.prepareSQLOperator("C.EUNIS_HABITAT_CODE", where, relOp ) +
              " AND " + filterSQL +
              " )" +
              " UNION " +
              " (" +
              " SELECT DISTINCT C.CODE_2000 AS COLUMN1 " +
              " FROM CHM62EDT_HABITAT AS C " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) AND " + Utilities.prepareSQLOperator("C.CODE_2000", where, relOp ) +
              " AND " + filterSQL +
              " ) " +
              " UNION " +
              " ( " +
              " SELECT DISTINCT D.CODE AS COLUMN1 " +
              " FROM CHM62EDT_HABITAT AS C " +
              " INNER JOIN CHM62EDT_HABITAT_CLASS_CODE AS D ON C.ID_HABITAT = D.ID_HABITAT " +
              " INNER JOIN CHM62EDT_CLASS_CODE AS E ON (D.ID_CLASS_CODE = E.ID_CLASS_CODE AND E.LEGAL = '0') " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) AND " + Utilities.prepareSQLOperator("D.CODE", where, relOp ) +
              " AND " + filterSQL +
              ") ORDER BY COLUMN1 LIMIT 0," + Utilities.MAX_POPUP_RESULTS;
      try {
        results = new GenericDomain().findCustom(sql);
      } catch (Exception _ex) {
        _ex.printStackTrace();
      }
      for (int i = 0; i < results.size(); i++) {
        GenericPersist code = (GenericPersist) results.get(i);
        habitats.add(code.getColumn1());
      }
    }
    // LEGAL INSTRUMENTS
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_LEGAL_INSTRUMENTS.intValue()) {
      sql = prepareSQL("E.NAME AS COLUMN1", filterSQL.toString() + " GROUP BY E.NAME");
      try {
        results = new GenericDomain().findCustom(sql);
      } catch (Exception _ex) {
        _ex.printStackTrace();
      }
      for (int i = 0; i < results.size(); i++) {
        GenericPersist habitat = (GenericPersist) results.get(i);
        habitats.add(habitat.getColumn1());
      }
    }
    // COUNTRY
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_COUNTRY.intValue()) {
      sql = prepareSQL("E.AREA_NAME_EN AS COLUMN1", filterSQL.toString() + " GROUP BY E.AREA_NAME_EN");
      try {
        results = new GenericDomain().findCustom(sql);
      } catch (Exception _ex) {
        _ex.printStackTrace();
      }
      for (int i = 0; i < results.size(); i++) {
        GenericPersist habitat = (GenericPersist) results.get(i);
        habitats.add(habitat.getColumn1());
      }
    }
    // REGION
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_REGION.intValue()) {
      sql = prepareSQL("E.NAME AS COLUMN1", filterSQL.toString() + " GROUP BY E.NAME");
      try {
        results = new GenericDomain().findCustom(sql);
      } catch (Exception _ex) {
        _ex.printStackTrace();
      }
      for (int i = 0; i < results.size(); i++) {
        GenericPersist habitat = (GenericPersist) results.get(i);
        habitats.add(habitat.getColumn1());
      }
    }
    return habitats;
  }

  /**
   * Prepare the SQL for the search.
   * @param what The SELECT condition (ex. SELECT C.SCIENTIFIC_NAME,E.VALUE...)
   * @param whereCondition the WHERE condition for SQL.
   * @return The full SQL for the search.
   */
  private String prepareSQL(String what, String whereCondition) {
    String sql = "";
    // If we search on habitat scientific name as main criteria
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_NAME.intValue()) {
      sql = "SELECT " + what +
              " FROM CHM62EDT_HABITAT AS C " +
              " LEFT JOIN CHM62EDT_HABITAT_DESCRIPTION AS K ON K.ID_HABITAT = C.ID_HABITAT " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS G ON C.ID_NATURE_OBJECT = G.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON G.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) " + whereCondition;
    }
    // If we search on habitat legal instruments as main criteria
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_CODE.intValue()) {
      sql = "SELECT " + what +
              " FROM CHM62EDT_HABITAT AS C " +
              " LEFT JOIN CHM62EDT_HABITAT_CLASS_CODE AS D ON C.ID_HABITAT = D.ID_HABITAT " +
              " LEFT JOIN CHM62EDT_CLASS_CODE AS E ON (D.ID_CLASS_CODE = E.ID_CLASS_CODE AND E.LEGAL = '0') " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) " + whereCondition;
    }
    // If we search on habitat legal instruments as main criteria
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_LEGAL_INSTRUMENTS.intValue()) {
      sql = "SELECT " + what +
              " FROM CHM62EDT_HABITAT AS C " +
              " INNER JOIN CHM62EDT_HABITAT_CLASS_CODE AS D ON C.ID_HABITAT = D.ID_HABITAT " +
              " INNER JOIN CHM62EDT_CLASS_CODE AS E ON (D.ID_CLASS_CODE = E.ID_CLASS_CODE AND E.LEGAL = '1') " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) " + whereCondition;
    }
    // If we search on habitats country as main criteria
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_COUNTRY.intValue()) {
      sql = "SELECT " + what +
              " FROM CHM62EDT_HABITAT AS C " +
              " INNER JOIN CHM62EDT_REPORTS AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
              " INNER JOIN CHM62EDT_COUNTRY AS E ON D.ID_GEOSCOPE = E.ID_GEOSCOPE " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) " + whereCondition;
    }
    // If we search on habitats country as main criteria
    if (searchAttribute.intValue() == HabitatSearchCriteria.SEARCH_REGION.intValue()) {
      sql = "SELECT " + what +
              " FROM CHM62EDT_HABITAT AS C " +
              " INNER JOIN CHM62EDT_REPORTS AS D ON C.ID_NATURE_OBJECT = D.ID_NATURE_OBJECT " +
              " INNER JOIN CHM62EDT_BIOGEOREGION AS E ON D.ID_GEOSCOPE_LINK = E.ID_GEOSCOPE " +
              " INNER JOIN CHM62EDT_NATURE_OBJECT_REPORT_TYPE AS K ON C.ID_NATURE_OBJECT = K.ID_NATURE_OBJECT_LINK " +
              " INNER JOIN CHM62EDT_SITES AS H ON K.ID_NATURE_OBJECT = H.ID_NATURE_OBJECT " +
              " WHERE (1 = 1) " + whereCondition;
    }
    return sql;
  }
}