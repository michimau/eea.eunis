package ro.finsiel.eunis.search.sites.designations;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class for sites->designations.
 * @author finsiel
 */
public class DesignationsPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public DesignationsPaginator(Paginable finder) {
        init(finder);
    }

}
