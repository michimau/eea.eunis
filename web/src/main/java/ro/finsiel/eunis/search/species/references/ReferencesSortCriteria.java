package ro.finsiel.eunis.search.species.references;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort criteria used for species->books.
 * @author finsiel
 */
public class ReferencesSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by author.
     */
    public static final Integer SORT_AUTHOR = new Integer(1);

    /**
     * Sort by date.
     */
    public static final Integer SORT_DATE = new Integer(2);

    /**
     * Sort by title.
     */
    public static final Integer SORT_TITLE = new Integer(3);

    /**
     * Sort by editor.
     */
    public static final Integer SORT_EDITOR = new Integer(4);

    /**
     * Sort by publisher.
     */
    public static final Integer SORT_PUBLISHER = new Integer(5);

    /**
     * Creates new sort criteria.
     * @param sortCriteria Criteria used for sorting
     * @param ascendency Ascendency
     */
    public ReferencesSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_AUTHOR, "A.SOURCE"); // Author
        possibleSorts.put(SORT_DATE, "A.CREATED"); // Date
        possibleSorts.put(SORT_TITLE, "A.TITLE"); // Title
        possibleSorts.put(SORT_EDITOR, "A.EDITOR"); // Editor
        possibleSorts.put(SORT_PUBLISHER, "A.PUBLISHER"); // Publisher
    }
}
