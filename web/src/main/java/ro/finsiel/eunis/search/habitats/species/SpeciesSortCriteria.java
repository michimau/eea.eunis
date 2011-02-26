package ro.finsiel.eunis.search.habitats.species;


import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.jrfTables.habitats.species.ScientificNameDomain;


/**
 * Sort criteria for habitats->species.
 * @author finsiel
 */
public class SpeciesSortCriteria extends AbstractSortCriteria {

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
     */
    public SpeciesSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_LEVEL, "H.LEVEL");
        possibleSorts.put(SORT_EUNIS_CODE, "H.EUNIS_HABITAT_CODE ");
        possibleSorts.put(SORT_ANNEX_CODE, "H.CODE_2000 ");
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "H.SCIENTIFIC_NAME");
        possibleSorts.put(SORT_VERNACULAR_NAME, "H.DESCRIPTION");
    }
}
