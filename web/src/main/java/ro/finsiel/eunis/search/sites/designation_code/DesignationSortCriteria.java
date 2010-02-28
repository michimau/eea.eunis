package ro.finsiel.eunis.search.sites.designation_code;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort cirteria for sites->designated codes.
 * @author finsiel
 */
public class DesignationSortCriteria extends AbstractSortCriteria {
  /**
   * Do not sort.
   */
  public static final Integer SORT_NONE = new Integer(0);
  /**
   * Sort by source db.
   */
  public static final Integer SORT_SOURCE_DB = new Integer(1);
  /**
   * Sort by name.
   */
  public static final Integer SORT_NAME = new Integer(2);
  /**
   * Sort by country.
   */
  public static final Integer SORT_COUNTRY = new Integer(3);
  /**
   * Sort by latitude.
   */
  public static final Integer SORT_LAT = new Integer(4);
  /**
   * Sort by longitude.
   */
  public static final Integer SORT_LONG = new Integer(5);
  /**
   * Sort by year.
   */
  public static final Integer SORT_YEAR = new Integer(6);
  /**
   * Sort by size.
   */
  public static final Integer SORT_SIZE = new Integer(7);


  /**
   * Ctor.
   * @param sortCriteria Criteria used for sorting.
   * @param ascendency Ascendency.
   */
  public DesignationSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_SOURCE_DB, "C.SOURCE_DB");
    possibleSorts.put(SORT_NAME, "C.NAME");
    possibleSorts.put(SORT_COUNTRY, "G.AREA_NAME_EN");
    possibleSorts.put(SORT_SIZE, "C.AREA");
    possibleSorts.put(SORT_LAT, "IF(C.LAT_NS='N',IF(C.LAT_DEG IS NULL,0,C.LAT_DEG)*3600 + IF(C.LAT_MIN IS NULL,0,C.LAT_MIN)*60 + IF(C.LAT_SEC IS NULL,0,C.LAT_SEC),(-1)*(IF(C.LAT_DEG IS NULL,0,C.LAT_DEG)*3600 + IF(C.LAT_MIN IS NULL,0,C.LAT_MIN)*60 + IF(C.LAT_SEC IS NULL,0,C.LAT_SEC)))"); // Order
    possibleSorts.put(SORT_LONG, "IF(C.LONG_EW='E',IF(C.LONG_DEG IS NULL,0,C.LONG_DEG)*3600 +IF(C.LONG_MIN IS NULL,0,C.LONG_MIN)*60 + IF(C.LONG_SEC IS NULL,0,C.LONG_SEC),(-1)*(IF(C.LONG_DEG IS NULL,0,C.LONG_DEG) *3600 + IF(C.LONG_MIN IS NULL,0,C.LONG_MIN)*60 + IF(C.LONG_SEC IS NULL,0,C.LONG_SEC)))"); // Order
    possibleSorts.put(SORT_YEAR, "CAST(CONCAT(" +
            "IF(C.source_db='CDDA_INTERNATIONAL',right(designation_date,4),'')," +
            "IF(C.source_db='CDDA_NATIONAL',right(designation_date,4),'')," +
            "IF(C.source_db='EMERALD',right(designation_date,4),'')," +
            "IF(C.source_db='BIOGENETIC',left(designation_date,4),'')," +
            "IF(C.source_db='DIPLOMA',right(designation_date,4),'')," +
            "IF(C.source_db='NATURA2000',right(designation_date,4),'')," +
            "IF(C.source_db='CORINE',right(designation_date,4),'')," +
            "IF(C.source_db='NATURENET',right(designation_date,4),'')" +
            ") AS SIGNED)");

  }
}