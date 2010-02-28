package ro.finsiel.eunis.search.species.internationalthreatstatus;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort criteria used for species->international threat status.
 * @author finsiel
 */
public class InternationalthreatstatusSortCriteria extends AbstractSortCriteria {
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
  public static final Integer SORT_FAMILY = new Integer(2);
  /**
   * Sort by order.
   */
  public static final Integer SORT_ORDER = new Integer(3);
  /**
   * Sort by scientific name.
   */
  public static final Integer SORT_SCIENTIFIC_NAME = new Integer(4);

  /**
   * Ctor.
   * @param sortCriteria Sort criteria.
   * @param ascendency Ascendency.
   */
  public InternationalthreatstatusSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_GROUP, "D.COMMON_NAME"); // Group
    possibleSorts.put(SORT_ORDER, "J.NAME"); // Order
    possibleSorts.put(SORT_FAMILY, "I.NAME"); // Family
    possibleSorts.put(SORT_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME"); // SCIENTIFIC NAME
  }
}