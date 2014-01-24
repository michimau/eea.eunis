package ro.finsiel.eunis.search;

import java.util.List;

import ro.finsiel.eunis.exceptions.CriteriaMissingException;
import ro.finsiel.eunis.exceptions.InitializationException;

/**
 * This is the paginator class used for all the results from search page. Keep the track of currently displayed page on browser,
 * page size. It has its data retrieved from Data factory classes represented by JRF Domain classes. All data factories must
 * implement the Paginable interface. In pages with results declare an object derived from this class depending on the type of
 * search.<br />
 * For further information consult also the Paginable interface.
 * 
 * @see ro.finsiel.eunis.search.Paginable
 * @author finsiel
 */
public abstract class AbstractPaginator {

    /**
     * Keep the currently sort criteria used for sorting the page.
     */
    private AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

    /**
     * The default number of results per page displayed.
     */
    public static final int DEFAULT_PAGE_SIZE = 10;

    /**
     * Current page size.
     */
    private int pageSize = DEFAULT_PAGE_SIZE;

    /**
     * Paginable object which is used to do the search.
     */
    protected Paginable finder = null;

    /**
     * Page currently displayed on the client.
     */
    private int currentPage = 0;

    /**
     * You will init() your object by calling the init(finder). This way all initializations were made correctly.
     * 
     * @param finder
     *            Provide an finder object in order to do all the initializations. Usually this is derived from JRF...
     */
    protected final void init(Paginable finder) {
        this.finder = finder;
    }

    /**
     * Setter for the pageSize field.
     * 
     * @param newSize
     *            New number of results displayed per page
     */
    public final void setPageSize(final int newSize) {
        if (newSize <= 0) {
            pageSize = DEFAULT_PAGE_SIZE;
        }
        this.pageSize = newSize;
    }

    /**
     * Getter for the pageSize field.
     * 
     * @return Number of results per page displayed.
     */
    public final int getPageSize() {
        return pageSize;
    }

    /**
     * This method should be implemented in derived classes to retrieve the required page.
     * 
     * @param pageNumber
     *            Page number.
     * @return The result list displayed on the page.
     * @throws InitializationException
     *             If the finder object was null.
     * @throws CriteriaMissingException
     *             If you didn't initialize correcly (with setSearchCriteria...) the finder.
     */
    public List getPage(int pageNumber) throws InitializationException, CriteriaMissingException {
        if (null == finder) {
            throw new InitializationException("'finder' object was null, so call 'init(finder)' from the finder object failed.");
        }
        // Compute offsetStart and offsetEnd for the Paginator.getResults(offsetStart, offsetEnd).
        // Check an overflow and adjust the computed offsets. I'm not sure if it's even needed since MySQL won't mind if
        // gets an 'end' out of range, returns only the results until real end index and not one overflowing...
        int lastPage = countPages();

        if (pageNumber > lastPage) {
            pageNumber = lastPage;
        }
        int start = pageNumber * pageSize;
        int end = pageSize;

        // Fire up the search and return the results
        return finder.getResults(start, end, sortCriteria);
    }

    /**
     * Count the total number of pages.
     * 
     * @return The number of pages computed as finder.countResults() / pageSize + 1. Check this hack if it's correct!
     * @throws CriteriaMissingException
     *             When search is not initialized correctly.
     */
    public final int countPages() throws CriteriaMissingException, InitializationException {
        if (null == finder) {
            throw new InitializationException("'finder' object was null, so call 'init(finder)' from the finder object failed.");
        }
        if (pageSize <= 0) {
            pageSize = DEFAULT_PAGE_SIZE;
        }
        int i = (finder.countResults().intValue() / pageSize) + 1;

        if ((finder.countResults().intValue() % pageSize) == 0) {
            i--;
        }
        return i;
    }

    /**
     * Count the total number of results.
     * 
     * @return All the results of the query.
     * @throws CriteriaMissingException
     *             When search is not initialized correcly.
     */
    public final int countResults() throws CriteriaMissingException, InitializationException {
        if (null == finder) {
            throw new InitializationException("'finder' object was null, so call 'init(finder)' from the finder object failed.");
        }
        return finder.countResults().intValue();
    }

    /**
     * Provides access to the currently criteria used for sort.
     * 
     * @return Criteria used to sort current page.
     */
    public final AbstractSortCriteria[] getSortCriteria() {
        return sortCriteria;
    }

    /**
     * Set the criteria to sort the page.
     * 
     * @param sortCriteria
     *            sort criteria.
     */
    public final void setSortCriteria(AbstractSortCriteria[] sortCriteria) {
        this.sortCriteria = sortCriteria;
    }

    /**
     * Getter for currentPage property.
     * 
     * @return Value of currentPage.
     */
    public final int getCurrentPage() {
        return currentPage;
    }

    /**
     * Setter for currentPage property. Also performs bounds checking (you can't specify a page index > countPages(). If do
     * currentPage = countPages() - 1. You can't also specify a page index < 0. If do, currentPage = 0.
     * 
     * @param currentPage
     *            New value for currentPage.
     * @return The real current page (normally should be currentPage, but if invalid page index specified, this value is adjusted as
     *         specified above.
     */
    public final int setCurrentPage(int currentPage) {
        try {
            this.currentPage = (currentPage >= countPages()) ? currentPage = countPages() - 1 : currentPage;
            this.currentPage = (currentPage <= 0) ? 0 : currentPage;
            return this.currentPage;
        } catch (CriteriaMissingException ex) {
            System.err
                    .println("Exception while setting currentPage, could not perform the search to count results. No criteria set.");
            ex.printStackTrace(System.err);
            return 0;
        } catch (InitializationException iex) {
            System.err.println("finder object not initialized, please call init()");
            iex.printStackTrace(System.err);
            return 0;
        }
    }
}
