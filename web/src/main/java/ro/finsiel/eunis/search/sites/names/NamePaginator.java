package ro.finsiel.eunis.search.sites.names;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class for sites->names.
 * @author finsiel
 */
public class NamePaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public NamePaginator(Paginable finder) {
        init(finder);
    }
}
