package ro.finsiel.eunis.search.sites.species;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort cirteria for sites->species.
 * @author finsiel
 */
public class SpeciesSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by source db.
     */
    public static final Integer SORT_SOURCE_DB = new Integer(1);

    /**
     * Sort by name.
     */
    public static final Integer SORT_NAME = new Integer(4);

    /**
     * Sort by designation type.
     */
    public static final Integer SORT_DESIGNATION = new Integer(2);

    /**
     * Sort by species from this site.
     */
    public static final Integer SORT_SPECIES = new Integer(5);

    /**
     * Sort by latitude.
     */
    public static final Integer SORT_LAT = new Integer(6);

    /**
     * Sort by longitude.
     */
    public static final Integer SORT_LONG = new Integer(7);

    /**
     * Ctor.
     * @param sortCriteria Criteria used for sorting.
     * @param ascendency Ascendency.
     */
    public SpeciesSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_SOURCE_DB, "H.SOURCE_DB");
        possibleSorts.put(SORT_NAME, "H.NAME");
        possibleSorts.put(SORT_DESIGNATION, "J.DESCRIPTION");
        possibleSorts.put(SORT_SPECIES, "C.SCIENTIFIC_NAME");
        possibleSorts.put(SORT_LAT, "H.LATITUDE"); // Order
        possibleSorts.put(SORT_LONG, "H.LONGITUDE"); // Order
    }
}
