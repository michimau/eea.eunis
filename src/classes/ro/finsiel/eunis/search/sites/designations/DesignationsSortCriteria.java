package ro.finsiel.eunis.search.sites.designations;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort cirteria for sites->designations.
 * @author finsiel
 */
public class DesignationsSortCriteria extends AbstractSortCriteria {
  /**
   * Do not sort.
   */
  public static final Integer SORT_NONE = new Integer(0);
  /**
   * Sort by source db.
   */
  public static final Integer SORT_SOURCE_DB = new Integer(1);
  /**
   * Sort by designation abbreviation.
   */
  public static final Integer SORT_ABREVIATION = new Integer(2);
  /**
   * Sort by designation type.
   */
  public static final Integer SORT_DESIGNATION = new Integer(3);
  /**
   * Sort by designation type in english.
   */
  public static final Integer SORT_DESIGNATION_EN = new Integer(4);
  /**
   * Sort by designation type in french.
   */
  public static final Integer SORT_DESIGNATION_FR = new Integer(5);
  /**
   * Sort by country iso.
   */
  public static final Integer SORT_ISO = new Integer(6);
  /**
   * Sort by reference source.
   */
  public static final Integer SORT_SOURCE = new Integer(7);
  /**
   * Sort by country.
   */
  public static final Integer SORT_COUNTRY = new Integer(8);

  /**
   * Ctor.
   * @param sortCriteria Criteria used for sorting.
   * @param ascendency Ascendency.
   */
  public DesignationsSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_SOURCE_DB, "S.SOURCE_DB");
    possibleSorts.put(SORT_ABREVIATION, "J.ID_DESIGNATION");
    possibleSorts.put(SORT_DESIGNATION, "J.DESCRIPTION");
    possibleSorts.put(SORT_DESIGNATION_EN, "J.DESCRIPTION_EN");
    possibleSorts.put(SORT_DESIGNATION_FR, "J.DESCRIPTION_FR");
    possibleSorts.put(SORT_ISO, "I.AREA_NAME_EN");
    possibleSorts.put(SORT_SOURCE, "J.DATA_SOURCE");
    possibleSorts.put(SORT_COUNTRY, "I.AREA_NAME_EN");

  }
}

