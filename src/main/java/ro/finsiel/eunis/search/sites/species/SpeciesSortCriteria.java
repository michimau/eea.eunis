package ro.finsiel.eunis.search.sites.species;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort cirteria for sites->species.
 * @author finsiel
 */
public class SpeciesSortCriteria extends AbstractSortCriteria {
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
  public static final Integer SORT_NAME = new Integer(4);
  /**
   * Sort by designation type.
   */
  public static final Integer SORT_DESIGNATION = new Integer(2);
  /**
   * Sort by species from this site.
   */
  public static final Integer SORT_SPECIES = new Integer(5);
  /**
   * Sort by latitude.
   */
  public static final Integer SORT_LAT = new Integer(6);
  /**
   * Sort by longitude.
   */
  public static final Integer SORT_LONG = new Integer(7);

  /**
   * Ctor.
   * @param sortCriteria Criteria used for sorting.
   * @param ascendency Ascendency.
   */
  public SpeciesSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_SOURCE_DB, "H.SOURCE_DB");
    possibleSorts.put(SORT_NAME, "H.NAME");
    possibleSorts.put(SORT_DESIGNATION, "J.DESCRIPTION");
    possibleSorts.put(SORT_SPECIES, "C.SCIENTIFIC_NAME");
    possibleSorts.put(SORT_LAT, "IF(H.LAT_NS='N',IF(H.LAT_DEG IS NULL,0,H.LAT_DEG)*3600 + IF(H.LAT_MIN IS NULL,0,H.LAT_MIN)*60 + IF(H.LAT_SEC IS NULL,0,H.LAT_SEC),(-1)*(IF(H.LAT_DEG IS NULL,0,H.LAT_DEG)*3600 + IF(H.LAT_MIN IS NULL,0,H.LAT_MIN)*60 + IF(H.LAT_SEC IS NULL,0,H.LAT_SEC)))"); // Order
    possibleSorts.put(SORT_LONG, "IF(H.LONG_EW='E',IF(H.LONG_DEG IS NULL,0,H.LONG_DEG)*3600 +IF(H.LONG_MIN IS NULL,0,H.LONG_MIN)*60 + IF(H.LONG_SEC IS NULL,0,H.LONG_SEC),(-1)*(IF(H.LONG_DEG IS NULL,0,H.LONG_DEG) *3600 + IF(H.LONG_MIN IS NULL,0,H.LONG_MIN)*60 + IF(H.LONG_SEC IS NULL,0,H.LONG_SEC)))"); // Order
  }
}