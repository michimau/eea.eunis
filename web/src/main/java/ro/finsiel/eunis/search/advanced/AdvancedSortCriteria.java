package ro.finsiel.eunis.search.advanced;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort criteria used for advanced search.
 * @author finsiel
 */
public class AdvancedSortCriteria extends AbstractSortCriteria {
    // Sort criteria for species
    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by group.
     */
    public static final Integer SORT_GROUP = new Integer(1);

    /**
     * Sort by family.
     */
    public static final Integer SORT_FAMILY = new Integer(2);

    /**
     * Sort by order.
     */
    public static final Integer SORT_ORDER = new Integer(3);

    /**
     * Sort by scientific name.
     */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(4);
    // Extra sort criteria for habitats
    /**
     * Sort by level.
     */
    public static final Integer SORT_LEVEL = new Integer(5);

    /**
     * Sort by eunis code.
     */
    public static final Integer SORT_EUNIS_CODE = new Integer(6);

    /**
     * Sort by annex code.
     */
    public static final Integer SORT_ANNEX_CODE = new Integer(7);

    /**
     * Sort by english name.
     */
    public static final Integer SORT_ENGLISH_NAME = new Integer(8);
    // Extra sort criteria for sites
    /**
     * Sort by source db.
     */
    public static final Integer SORT_SOURCE_DB = new Integer(8);

    /**
     * Sort by site name.
     */
    public static final Integer SORT_SITE_NAME = new Integer(9);

    /**
     * Sort by designation type.
     */
    public static final Integer SORT_DESIGNATION_TYPE = new Integer(10);

    /**
     * Sort by size.
     */
    public static final Integer SORT_SIZE = new Integer(11);

    /**
     * Sort by designation year.
     */
    public static final Integer SORT_DESIGNATION_YEAR = new Integer(12);

    /**
     * Sort by country.
     */
    public static final Integer SORT_COUNTRY = new Integer(13);

    /**
     * Sort by length.
     */
    public static final Integer SORT_LENGTH = new Integer(14);

    /**
     * Sort by min altitude.
     */
    public static final Integer SORT_MIN_ALTITUDE = new Integer(15);

    /**
     * Sort by max altitude.
     */
    public static final Integer SORT_MAX_ALTITUDE = new Integer(16);

    /**
     * Sort by mean altitude.
     */
    public static final Integer SORT_MEAN_ALTITUDE = new Integer(17);

    /**
     * Sort by manager.
     */
    public static final Integer SORT_MANAGER = new Integer(18);

    /**
     * Sort by ownership.
     */
    public static final Integer SORT_OWNERSHIP = new Integer(19);

    /**
     * Sort by character.
     */
    public static final Integer SORT_CHARACTER = new Integer(20);

    /**
     * Sort by compilation date.
     */
    public static final Integer SORT_COMPILATION_DATE = new Integer(21);

    /**
     * Sort by proposed date.
     */
    public static final Integer SORT_PROPOSED_DATE = new Integer(22);

    /**
     * Sort by respondent.
     */
    public static final Integer SORT_RESPONDENT = new Integer(23);

    /**
     * Sort by source.
     */
    public static final Integer SORT_SOURCE = new Integer(24);

    /**
     * Sort by editor.
     */
    public static final Integer SORT_EDITOR = new Integer(25);

    /**
     * Sort by book title.
     */
    public static final Integer SORT_BOOK_TITLE = new Integer(26);

    /**
     * Sort by habitat priority.
     */
    public static final Integer SORT_PRIORITY = new Integer(27);

    /**
     * Sort by habitat description.
     */
    public static final Integer SORT_DESCRIPTION = new Integer(28);

    /**
     * Ctor.
     * @param sortCriteria Sort criteria.
     * @param ascendency Ascendency.
     */
    public AdvancedSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings for species
        possibleSorts.put(SORT_NONE, "none");
        possibleSorts.put(SORT_GROUP, "B.COMMON_NAME");
        possibleSorts.put(SORT_ORDER, "D.NAME");
        possibleSorts.put(SORT_FAMILY, "C.NAME");
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "A.SCIENTIFIC_NAME");
        // Initialize the mappings for habitats
        possibleSorts.put(SORT_LEVEL, "A.LEVEL");
        possibleSorts.put(SORT_EUNIS_CODE, "A.EUNIS_HABITAT_CODE ");
        possibleSorts.put(SORT_ANNEX_CODE, "A.CODE_ANNEX1 ");
        possibleSorts.put(SORT_ANNEX_CODE, "A.CODE_ANNEX1 ");
        possibleSorts.put(SORT_ENGLISH_NAME, "A.DESCRIPTION");
        possibleSorts.put(SORT_DESCRIPTION, "A.DESCRIPTION");
        possibleSorts.put(SORT_PRIORITY, "A.PRIORITY");
        // Initialize the mappings for sites
        possibleSorts.put(SORT_MANAGER, "A.MANAGER");
        possibleSorts.put(SORT_OWNERSHIP, "A.OWNERSHIP");
        possibleSorts.put(SORT_CHARACTER, "A.CHARACTER");
        possibleSorts.put(SORT_COMPILATION_DATE, "A.COMPILATION_DATE");
        possibleSorts.put(SORT_PROPOSED_DATE, "A.PROPOSED_DATE");
        possibleSorts.put(SORT_RESPONDENT, "A.RESPONDENT");
        possibleSorts.put(SORT_SOURCE_DB, "A.SOURCE_DB");
        possibleSorts.put(SORT_SITE_NAME, "A.NAME");
        possibleSorts.put(SORT_DESIGNATION_TYPE, "E.DESCRIPTION");
        possibleSorts.put(SORT_SIZE, "A.AREA");
        possibleSorts.put(SORT_LENGTH, "A.LENGTH");
        possibleSorts.put(SORT_COUNTRY, "C.AREA_NAME_EN");
        possibleSorts.put(SORT_MIN_ALTITUDE, "A.ALT_MIN");
        possibleSorts.put(SORT_MAX_ALTITUDE, "A.ALT_MAX");
        possibleSorts.put(SORT_MEAN_ALTITUDE, "A.ALT_MEAN");
        possibleSorts.put(SORT_BOOK_TITLE, "N.BOOK_TITLE");
        possibleSorts.put(SORT_SOURCE, "N.SOURCE");
        possibleSorts.put(SORT_EDITOR, "N.EDITOR");
        possibleSorts.put(SORT_DESIGNATION_YEAR,
                "CONCAT(" + "IF(A.source_db='BIOGENETIC',left(designation_date,4),''),"
                + "IF(A.source_db='CDDA_INTERNATIONAL',right(designation_date,4),''),"
                + "IF(A.source_db='CDDA_NATIONAL',right(designation_date,4),''),"
                + "IF(A.source_db='EMERALD',right(designation_date,4),''),"
                + "IF(A.source_db='DIPLOMA',right(designation_date,4),''),"
                + "IF(A.source_db='NATURA2000',right(designation_date,4),''),"
                + "IF(A.source_db='CORINE',right(designation_date,4),''),"
                + "IF(A.source_db='NATURENET',right(designation_date,4),'')" + ")");
    }
}
