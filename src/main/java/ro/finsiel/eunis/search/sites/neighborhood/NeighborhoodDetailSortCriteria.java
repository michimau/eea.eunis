package ro.finsiel.eunis.search.sites.neighborhood;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort criterion used when sorting sites displayed within a range of a specified site.
 * @author finsiel
 */
public class NeighborhoodDetailSortCriteria extends AbstractSortCriteria {
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
   * Sort by size.
   */
  public static final Integer SORT_SIZE = new Integer(2);
  /**
   * Sort by country.
   */
  public static final Integer SORT_COUNTRY = new Integer(3);
  /**
   * Sort by designation.
   */
  public static final Integer SORT_DESIGN = new Integer(5);
  /**
   * Sort by latitude.
   */
  public static final Integer SORT_LAT = new Integer(6);
  /**
   * Sort by longitude.
   */
  public static final Integer SORT_LONG = new Integer(7);
  /**
   * Sort by designation year.
   */
  public static final Integer SORT_YEAR = new Integer(8);

  /**
   * Ctor.
   * @param sortCriteria Sort criteria.
   * @param ascendency Ascendency.
   */
  public NeighborhoodDetailSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_SOURCE_DB, "SOURCE_DB");
    possibleSorts.put(SORT_NAME, "NAME");
    possibleSorts.put(SORT_SIZE, "AREA");
    possibleSorts.put(SORT_COUNTRY, "AREA_NAME_EN");
    possibleSorts.put(SORT_DESIGN, "DESCRIPTION");
    possibleSorts.put(SORT_LAT, "IF(LAT_NS='N',IF(LAT_DEG IS NULL, 0, LAT_DEG) * 3600 + " +
            " IF(LAT_MIN IS NULL, 0, LAT_MIN) * 60 + " +
            " IF(LAT_SEC IS NULL, 0, LAT_SEC),(-1)*(IF(LAT_DEG IS NULL, 0, LAT_DEG)*3600 + " +
            " IF(LAT_MIN IS NULL,0, LAT_MIN)*60 + IF(LAT_SEC IS NULL,0,LAT_SEC)))");
    possibleSorts.put(SORT_LONG, "IF(LONG_EW='E',IF(LONG_DEG IS NULL,0,LONG_DEG)*3600 + " +
            " IF(LONG_MIN IS NULL,0,LONG_MIN)*60 + " +
            " IF(LONG_SEC IS NULL,0,LONG_SEC),(-1)*(IF(LONG_DEG IS NULL,0,LONG_DEG) *3600 + " +
            " IF(LONG_MIN IS NULL,0,LONG_MIN)*60 + IF(LONG_SEC IS NULL,0,LONG_SEC)))");
    possibleSorts.put(SORT_YEAR, "CONCAT(" + "IF(SOURCE_DB='BIOGENETIC',left(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='CDDA_INTERNATIONAL',RIGHT(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='CDDA_NATIONAL',RIGHT(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='EMERALD',RIGHT(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='DIPLOMA',RIGHT(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='NATURA2000',RIGHT(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='CORINE',RIGHT(DESIGNATION_DATE,4),'')," +
            "IF(SOURCE_DB='NATURENET',RIGHT(DESIGNATION_DATE,4),'')" +
            ")");
  }
}