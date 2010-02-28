package ro.finsiel.eunis.search.habitats.legal;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort criteria for habitats->legal instruments.
 * @author finsiel
 */
public class LegalSortCriteria extends AbstractSortCriteria {
  /**
   * Do not sort.
   */
  public static final Integer SORT_NONE = new Integer(0);
  /**
   * Sort by name.
   */
  public static final Integer SORT_SCIENTIFIC_NAME = new Integer(1);
  /**
   * Sort by eunis code.
   */
  public static final Integer SORT_EUNIS_CODE = new Integer(2);
  /**
   * Sort by Legal instrument name.
   */
  public static final Integer SORT_LEGAL_INSTRUMENTS = new Integer(3);
  /**
   * Sort by level.
   */
  public static final Integer SORT_LEVEL = new Integer(4);

  /**
   * Ctor.
   * @param sortCriteria Sort criteria.
   * @param ascendency Ascendency.
   */
  public LegalSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_SCIENTIFIC_NAME, "SCIENTIFIC_NAME"); // SCIENTIFIC NAME
    possibleSorts.put(SORT_EUNIS_CODE, "EUNIS_HABITAT_CODE"); // EUNIS CODE
    possibleSorts.put(SORT_LEGAL_INSTRUMENTS, "C.NAME"); // LEGAL TEXT
    possibleSorts.put(SORT_LEVEL, "LEVEL"); // EUNIS CODE
  }
}