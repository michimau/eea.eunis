package ro.finsiel.eunis.formBeans;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Criteria used for sorting columns.
 * @author finsiel
 */
public class ReferencesSortCriteria extends AbstractSortCriteria {

  /**
   * Do not sort.
   */
  public static final Integer SORT_NONE = new Integer(0);

  /**
   * Sort by author.
   */
  public static final Integer SORT_AUTHOR = new Integer(1);

  /**
   * Sort by year.
   */
  public static final Integer SORT_YEAR = new Integer(2);

  /**
   * Sort by title.
   */
  public static final Integer SORT_TITLE = new Integer(3);

  /**
   * Sort by editor.
   */
  public static final Integer SORT_EDITOR = new Integer(4);

  /**
   * Sort by publisher.
   */
  public static final Integer SORT_PUBLISHER = new Integer(5);

  /**
   * Creates a new ReferencesSortCriteria object.
   * @param sortCriteria Sort critera.
   * @param ascendency Ascendency.
   */
  public ReferencesSortCriteria(Integer sortCriteria, Integer ascendency) {
    setSortCriteria(sortCriteria);
    setAscendency(ascendency);
    // Initialize the mappings
    possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
    possibleSorts.put(SORT_AUTHOR, "SOURCE");
    possibleSorts.put(SORT_YEAR, "CREATED");
    possibleSorts.put(SORT_TITLE, "TITLE ");
    possibleSorts.put(SORT_EDITOR, "EDITOR");
    possibleSorts.put(SORT_PUBLISHER, "PUBLISHER");
  }
}

