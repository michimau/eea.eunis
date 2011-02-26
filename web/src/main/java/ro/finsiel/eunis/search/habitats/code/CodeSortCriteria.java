package ro.finsiel.eunis.search.habitats.code;


import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.jrfTables.habitats.code.CodeDomain;


/**
 * Sort criteria for habitats->codes.
 * @author finsiel
 */
public class CodeSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by level.
     */
    public static final Integer SORT_LEVEL = new Integer(1);

    /**
     * Sort by eunis code.
     */
    public static final Integer SORT_EUNIS_CODE = new Integer(2);

    /**
     * Sort by annex code.
     */
    public static final Integer SORT_ANNEX_CODE = new Integer(3);

    /**
     * Sort by name.
     */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(4);

    /**
     * Sort by english name.
     */
    public static final Integer SORT_ENGLISH_NAME = new Integer(5);

    /**
     * Ctor.
     * @param sortCriteria Sort criteria.
     * @param ascendency Ascendency.
     * @param database Not used.
     */
    public CodeSortCriteria(Integer sortCriteria, Integer ascendency, Integer database) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_LEVEL, "LEVEL");
        possibleSorts.put(SORT_EUNIS_CODE, "EUNIS_HABITAT_CODE ");
        possibleSorts.put(SORT_ANNEX_CODE, "CODE_2000 ");
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "SCIENTIFIC_NAME");
        possibleSorts.put(SORT_ENGLISH_NAME, "DESCRIPTION");
    }

}
