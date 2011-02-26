package ro.finsiel.eunis.search.species.country;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Defines an new sort criteria for the Species->Country/Region type of search.
 * @author finsiel
 */
public class CountrySortCriteria extends AbstractSortCriteria {

    /** Define the sort to be *unsorted*. */
    public static final Integer SORT_NONE = new Integer(0);

    /** Define the sort to be done after country. */
    public static final Integer SORT_COUNTRY = new Integer(1);

    /** Define the sort to be done after group. */
    public static final Integer SORT_GROUP = new Integer(2);

    /** Define the sort to be done after order. */
    public static final Integer SORT_ORDER = new Integer(3);

    /** Define the sort to be done after family. */
    public static final Integer SORT_FAMILY = new Integer(4);

    /** Define the sort to be done after scientific name. */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(5);

    /** Define the sort to be done after biogeoregion name.*/
    public static final Integer SORT_BIOGEOREGION = new Integer(6);

    /**
     * Ctor.
     * @param sortCriteria Sort criteria
     * @param ascendency Ascendency
     */
    public CountrySortCriteria(int sortCriteria, int ascendency) {
        setSortCriteria(new Integer(sortCriteria));
        setAscendency(new Integer(ascendency));
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_COUNTRY, "AREA_NAME_EN"); // COUNTRY
        possibleSorts.put(SORT_GROUP, "D.COMMON_NAME"); // GROUP
        possibleSorts.put(SORT_ORDER, "E.NAME"); // ORDER
        possibleSorts.put(SORT_FAMILY, "E.NAME"); // FAMILY
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "C.SCIENTIFIC_NAME"); // SCIENTIFIC NAME
        possibleSorts.put(SORT_BIOGEOREGION, "NAME"); // BIOGEOREGION
    }
}
