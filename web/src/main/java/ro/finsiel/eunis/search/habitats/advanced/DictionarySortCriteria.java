package ro.finsiel.eunis.search.habitats.advanced;


import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.jrfTables.habitats.advanced.DictionaryDomain;


/**
 * Sort criteria for habitats->advanced search.
 * @author finsiel
 */
public class DictionarySortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by level.
     */
    public static final Integer SORT_LEVEL = new Integer(1);

    /**
     * Sort by code (eunis or annex).
     */
    public static final Integer SORT_CODE = new Integer(2);

    /**
     * Sort by name.
     */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(3);

    /**
     * Sort by english name.
     */
    public static final Integer SORT_ENGLISH_NAME = new Integer(4);

    /**
     * Ctor.
     * @param sortCriteria Sort criteria.
     * @param ascendency Ascendency.
     * @param database Possible values: DictionaryDomain.SEARCH_EUNIS / DictionaryDomain.SEARCH_ANNEX_I
     */
    public DictionarySortCriteria(Integer sortCriteria, Integer ascendency, Integer database) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_LEVEL, "LEVEL");
        if (null != database && 0 == database.compareTo(DictionaryDomain.SEARCH_EUNIS)) {
            possibleSorts.put(SORT_CODE, "EUNIS_HABITAT_CODE ");
        }
        if (null != database && 0 == database.compareTo(DictionaryDomain.SEARCH_ANNEX_I)) {
            possibleSorts.put(SORT_CODE, "CODE_ANNEX1 ");
        }
        if (null != database) {
            possibleSorts.put(SORT_CODE, "EUNIS_HABITAT_CODE ");
        }
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "SCIENTIFIC_NAME");
        possibleSorts.put(SORT_ENGLISH_NAME, "DESCRIPTION");
    }
}
