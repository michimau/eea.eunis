package ro.finsiel.eunis.search.species.sites;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator class used for species->references.
 * @author finsiel
 */
public class SitesPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public SitesPaginator(Paginable finder) {
        init(finder);
    }
}
