package ro.finsiel.eunis.search.species.advanced;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort criteria used for advanced/combined search.
 * @author finsiel
 */
public class DictionarySortCriteria extends AbstractSortCriteria {
  /**
   * Do not sort.
   */
  public static final Integer SORT_NONE = new Integer(0);
  /**
   * Sort by group.
   */
  public static final Integer SORT_GROUP = new Integer(1);
  /**
   * Sort by family.
   */
  public static final Integer SORT_FAMILY = new Integer(4);
  /**
   * Sort by order.
   */
  public static final Integer SORT_ORDER = new Integer(2);
  /**
   * Sort by scientific name.
   */
  public static final Integer SORT_SCIENTIFIC_NAME = new Integer(3);

  /**
   * Ctor.
   * @param sortCriteria Criteria used for sorting.
   * @param ascendency Ascendency.
   */
  public DictionarySortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none");
    possibleSorts.put(SORT_GROUP, "COMMON_NAME");
    possibleSorts.put(SORT_ORDER, "SCIENTIFIC_NAME");
    possibleSorts.put(SORT_FAMILY, "SCIENTIFIC_NAME");
    possibleSorts.put(SORT_SCIENTIFIC_NAME, "SCIENTIFIC_NAME");
  }
}
