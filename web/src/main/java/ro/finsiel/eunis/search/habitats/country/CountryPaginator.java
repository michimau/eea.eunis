package ro.finsiel.eunis.search.habitats.country;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class used for habitats->country.
 * @author finsiel
 */
public class CountryPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public CountryPaginator(Paginable finder) {
        init(finder);
    }
}
