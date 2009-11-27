package ro.finsiel.eunis.search.species.sites;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort criteria used for species->sites.
 * @author finsiel
 */
public class SitesSortCriteria extends AbstractSortCriteria {
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
   * @param sortCriteria Type of criteria used for sorting.
   * @param ascendency Ascendency.
   */
  public SitesSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_GROUP, "I.COMMON_NAME"); // Group
    possibleSorts.put(SORT_ORDER, "L.NAME"); // Order
    possibleSorts.put(SORT_FAMILY, "J.NAME"); // Family
    possibleSorts.put(SORT_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME"); // Scientific name
  }
}

