package ro.finsiel.eunis.search.sites.coordinates;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort cirteria for sites->coordinates.
 * @author finsiel
 */
public class CoordinatesSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by source db.
     */
    public static final Integer SORT_SOURCE_DB = new Integer(1);

    /**
     * Sort by country.
     */
    public static final Integer SORT_COUNTRY = new Integer(2);

    /**
     * Sort by name.
     */
    public static final Integer SORT_NAME = new Integer(3);

    /**
     * Sort by size.
     */
    public static final Integer SORT_SIZE = new Integer(4);

    /**
     * Sort by latitude.
     */
    public static final Integer SORT_LAT = new Integer(5);

    /**
     * Sort by longitude.
     */
    public static final Integer SORT_LONG = new Integer(6);

    /**
     * Sort by year.
     */
    public static final Integer SORT_YEAR = new Integer(7);

    /**
     * Ctor.
     * @param sortCriteria Criteria used for sorting.
     * @param ascendency Ascendency.
     */
    public CoordinatesSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_SOURCE_DB, "A.SOURCE_DB");
        possibleSorts.put(SORT_NAME, "A.NAME");
        possibleSorts.put(SORT_SIZE, "A.AREA");
        possibleSorts.put(SORT_COUNTRY, "C.AREA_NAME_EN");
        possibleSorts.put(SORT_LAT, "A.LATITUDE");
        possibleSorts.put(SORT_LONG, "A.LONGITUDE");
        possibleSorts.put(SORT_YEAR,
                "CAST(CONCAT(" + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''),"
                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''),"
                + "IF(A.source_db='EMERALD',right(designation_date,4),''),"
                + "IF(A.source_db='BIOGENETIC',left(designation_date,4),''),"
                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''),"
                + "IF(A.source_db='NATURA2000',right(designation_date,4),''),"
                + "IF(A.source_db='CORINE',right(designation_date,4),''),"
                + "IF(A.source_db='NATURENET',right(designation_date,4),'')" + ") AS SIGNED)");
    }
}
