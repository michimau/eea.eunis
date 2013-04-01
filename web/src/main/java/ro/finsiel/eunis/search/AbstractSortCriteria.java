package ro.finsiel.eunis.search;


import java.util.Hashtable;

import ro.finsiel.eunis.exceptions.InitializationException;


/**
 * This class implements sort criteria which is used to sort the results of a query after a column for example.
 * It contains the basic support for this: the sortCriteria and the ascendency.
 * Basically a sorting criteria could have three (3) statuses: NONE, ASCENDING, DESCENDING. This class resembles that
 * behaviour.
 * @author finsiel
 */
public abstract class AbstractSortCriteria {

    /** Do not SORT. Note: If an AbstractSortCriteria object is set to ASCENDENCY_NONE, the sort will not be performed. */
    public static final Integer ASCENDENCY_NONE = new Integer(0);

    /** Sorting is done *Alphabetically*. */
    public static final Integer ASCENDENCY_ASC = new Integer(1);

    /** Sorting is done *Inverse alphabetically*. */
    public static final Integer ASCENDENCY_DESC = new Integer(2);

    /** Criteria used for sorting. */
    private Integer sortCriteria;

    /** Ascendency used for sorting (3-way: NONE/ASCENDING/DESCENDING). */
    private Integer ascendency;

    /** Maps integer values of ascendency to MySQL ascendecy specifier. */
    private static Hashtable ascendencyMapper = new Hashtable();

    /** Maps the sorts to SQL table names... */
    protected static Hashtable possibleSorts = new Hashtable();

    /**
     * Creates a new AbstractSortCriteria object.
     */
    public AbstractSortCriteria() {
        ascendencyMapper.put(ASCENDENCY_ASC, "ASC");
        ascendencyMapper.put(ASCENDENCY_DESC, "DESC");
        ascendencyMapper.put(ASCENDENCY_NONE, "none");
    }

    /**
     * Return a string representation of this sort criteria i.e. none, ASC, DESC.
     * @return String representation of this object (Human readable string).
     * @throws InitializationException If possibleSorts was null (object not correctly initialized).
     */
    public String getCriteriaAsString() throws InitializationException {
        if (null == possibleSorts) {
            throw new InitializationException(
                    "possibleSorts not intialized, please review the code!");
        }
        return possibleSorts.get(getSortCriteria()).toString();
    }

    /**
     * Getter for sortCriteria field.
     * @return The value of sortCriteria field/
     */
    public Integer getSortCriteria() {
        return sortCriteria;
    }

    /**
     * Setter for sortCriteria field.
     * @param sortCriteria New value for sortCriteria.
     */
    public final void setSortCriteria(Integer sortCriteria) {
        this.sortCriteria = sortCriteria;
    }

    /**
     * This method constructs an SQL representation of this object, for example:
     * "TABLENAME.COLUMN ASC" means sorting after that column, ascending.
     * @return An SQL representation of this object.
     */
    public String toSQL() {
        StringBuffer sql = new StringBuffer();

        try {
            sql.append(getCriteriaAsString()); // Added criteria
            sql.append(" ");
            sql.append(getAscendencyAsString()); // Added ascencency...
        } catch (InitializationException iex) {
            iex.printStackTrace(System.err);
        } finally {
            return sql.toString();
        }
    }

    /**
     * This method constructs and URL representation of this object, for example:
     * &sort=1&ascendency=1 ...
     * @return The URL type of representation for this object
     */
    public String toURLParam() {
        StringBuffer url = new StringBuffer();

        if (null != sortCriteria && null != ascendency) {
            // &sort=1&ascendency=1
            url.append("&sort=" + sortCriteria);
            url.append("&ascendency=" + ascendency);
        }
        return url.toString();
    }

    /**
     * This method constucts an FORM (aka web page form) representation of this object, for example:
     * &ltINPUT type=hidden name=paramName value=paramValue&gt.
     * @return An WEB-PAGE FORM compatible type of representation for this object.
     */
    public String toFORMParam() {
        StringBuffer form = new StringBuffer();

        if (null != sortCriteria && null != ascendency) {
            // <input type="hidden" name="sort" value="1">
            form.append(
                    Utilities.writeFormParameter("sort", sortCriteria.toString()));
            form.append(
                    Utilities.writeFormParameter("ascendency",
                    ascendency.toString()));
        }
        return form.toString();
    }

    /**
     * Getter for ascendency field.
     * @return The value of ascendency field.
     */
    public final Integer getAscendency() {
        return ascendency;
    }

    /** Return the value of ascendency, represented as SQL statement, in other words ASC, DESC.
     * @return  The following values are returned :<br />
     * if criteria is ASCENDENCY_ASC return "ASC"<br />
     * if criteria is ASCENDENCY_DESC return "DESC"<br />
     * if criteria is ASCENDENCY_NONE return "none"<br />
     */
    public final String getAscendencyAsString() {
        return (String) ascendencyMapper.get(ascendency);
    }

    /**
     * Setter for ascendency field.
     * @param ascendency New value of ascendency field.
     */
    public void setAscendency(Integer ascendency) {
        this.ascendency = ascendency;
    }
}
