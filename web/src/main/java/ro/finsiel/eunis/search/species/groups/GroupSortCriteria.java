package ro.finsiel.eunis.search.species.groups;


import ro.finsiel.eunis.search.AbstractSortCriteria;


/**
 * Sort criteria used for species->groups.
 * @author finsiel
 */
public class GroupSortCriteria extends AbstractSortCriteria {

    /**
     * Do not sort.
     */
    public static final Integer SORT_NONE = new Integer(0);

    /**
     * Sort by order.
     */
    public static final Integer SORT_ORDER = new Integer(1);

    /**
     * Sort by family.
     */
    public static final Integer SORT_FAMILY = new Integer(2);

    /**
     * Sort by scientific name.
     */
    public static final Integer SORT_SCIENTIFIC_NAME = new Integer(3);

    /**
     * Sort by scientific name.
     */
    public static final Integer SORT_GROUP = new Integer(4);

    /**
     * Normal constructor.
     * @param sortCriteria Criteria used for sorting (one of this.SORT_NONE/ORDER/FAMILY/SCIENTIFIC_NAME)
     * @param ascendency Ascendency type such as none/ascending/descending (one of super.ASCENDENCY_NONE/ASC/DESC)
     */
    public GroupSortCriteria(Integer sortCriteria, Integer ascendency) {
        setSortCriteria(sortCriteria);
        setAscendency(ascendency);
        // Initialize the mappings
        possibleSorts.put(SORT_NONE, "none"); // If none, then DO NOT SORT
        possibleSorts.put(SORT_ORDER, "C.NAME"); // ORDER
        possibleSorts.put(SORT_FAMILY, "B.NAME"); // FAMILY
        possibleSorts.put(SORT_SCIENTIFIC_NAME, "A.SCIENTIFIC_NAME"); // SCIENTIFIC NAME
        possibleSorts.put(SORT_GROUP, "D.COMMON_NAME"); // GROUP
    }

    /**
     * Test method.
     * @param args Command line args.
     * @throws Exception Exception.
     */
    public static void main(String[] args) throws Exception {
        GroupSortCriteria aSort = new GroupSortCriteria(GroupSortCriteria.SORT_FAMILY, GroupSortCriteria.ASCENDENCY_DESC);
        // System.out.println("1.aSort.getCriteriaAsString():" + aSort.getCriteriaAsString());
        // System.out.println("2.aSort.toSQL():" + aSort.toSQL());
        // System.out.println("3.aSort.toURLParam():" + aSort.toURLParam());
        // System.out.println("3.aSort.toFORMParam():" + aSort.toFORMParam());
    }
}
