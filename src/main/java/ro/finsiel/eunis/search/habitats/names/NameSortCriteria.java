package ro.finsiel.eunis.search.habitats.names;

import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.jrfTables.habitats.names.NamesDomain;

/**
 * Sort criteria for habitats->names.
 * @author finsiel
 */
public class NameSortCriteria extends AbstractSortCriteria {
  /**
   * Do not sort.
   */
  public static final Integer SORT_NONE = new Integer(1);
  /**
   * Sort by level.
   */
  public static final Integer SORT_LEVEL = new Integer(2);
  /**
   * Sort by eunis code.
   */
  public static final Integer SORT_EUNIS_CODE = new Integer(3);
  /**
   * Sort by annex code.
   */
  public static final Integer SORT_ANNEX_CODE = new Integer(4);
  /**
   * Sort by name.
   */
  public static final Integer SORT_SCIENTIFIC_NAME = new Integer(5);
  /**
   * Sort by english name.
   */
  public static final Integer SORT_VERNACULAR_NAME = new Integer(6);

  /**
   * Ctor.
   * @param sortCriteria Sort criteria.
   * @param ascendency Ascendency.
   * @param database Not used.
   */
  public NameSortCriteria(Integer sortCriteria, Integer ascendency, Integer database) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_LEVEL, "A.LEVEL");
    possibleSorts.put(SORT_EUNIS_CODE, "A.EUNIS_HABITAT_CODE ");
    possibleSorts.put(SORT_ANNEX_CODE, "A.CODE_2000 ");
    possibleSorts.put(SORT_SCIENTIFIC_NAME, "A.SCIENTIFIC_NAME");
    possibleSorts.put(SORT_VERNACULAR_NAME, "A.DESCRIPTION");
  }
}
