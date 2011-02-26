package ro.finsiel.eunis.search.species.legal;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort criteria for species->legal instruments.
 * @author finsiel
 */
public class LegalSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /** Define the sort to be done after scientific name. */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(1);

    /**
     * Normal constructor.
     * @param sortCriteria Criteria used for sorting (one of the static Integers above)
     * @param ascendency Sort ascendant / descendant (one of the super.static Integers above)
     */
    public LegalSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "E.SCIENTIFIC_NAME"); // SCIENTIFIC NAME
    }
}
