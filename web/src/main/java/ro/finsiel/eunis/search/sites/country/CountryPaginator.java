package ro.finsiel.eunis.search.sites.country;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator used for sites->country.
 * @author finsiel.
 */
public class CountryPaginator extends AbstractPaginator {

    /**
     * Normal constructor.
     * @param finder The 'data factory' used to do the search
     */
    public CountryPaginator(Paginable finder) {
        init(finder);
    }
}
