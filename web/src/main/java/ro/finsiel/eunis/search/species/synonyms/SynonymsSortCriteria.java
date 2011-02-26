package ro.finsiel.eunis.search.species.synonyms;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort criteria used for species->synonyms results.
 * @author finsiel
 */
public class SynonymsSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by group.
     */
    public static final Integer SORT_GROUP = new Integer(1);
    // /**
    // * Sort by order.
    // */
    // public static final Integer SORT_ORDER = new Integer(2);
    // /**
    // * Sort by family.
    // */
    // public static final Integer SORT_FAMILY = new Integer(3);
    /**
     * Sort by scientific name.
     */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(4);

    /**
     * Which sort criteria to represent.
     * @param sortCriteria Sort criteria used.
     * @param ascendency Ascendency.
     */
    public SynonymsSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_GROUP, "E.COMMON_NAME");
        // possibleSorts.put(SORT_ORDER, "G.NAME");
        // possibleSorts.put(SORT_FAMILY, "F.NAME");
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "D.SCIENTIFIC_NAME");
    }
}
