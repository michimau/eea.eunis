package ro.finsiel.eunis.search.habitats.dictionaries;

import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Sort criteria for habitats->advanced search.
 * @author finsiel
 */
public class DictionarySortCriteria extends AbstractSortCriteria
{
  /**
   * Sort by level.
   */
  public static final Integer SORT_LEVEL = new Integer(0);
  /**
   * Sort by code.
   */
  public static final Integer SORT_CODE = new Integer(1);
  /**
   * Sort by scientific name.
   */
  public static final Integer SORT_SCIENTIFIC_NAME = new Integer(2);

  /**
   * Sort by english name.
   */
  public static final Integer SORT_ENGLISH_NAME = new Integer(3);
}
