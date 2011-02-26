package ro.finsiel.eunis.search.species.country;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * This is the paginator class used by SpeciesCountry (Species->Country/Region) type of search.
 * @author finsiel
 */
public class CountryPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder The finder object used to do the search. Searches are done trough this AbstractPaginator class, not
     * directly, because it handles also other issues like sorting for example.
     */
    public CountryPaginator(Paginable finder) {
        init(finder);
    }
}
