package ro.finsiel.eunis.search.sites.designation_code;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class for sites->designated codes.
 * @author finsiel
 */
public class DesignationPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public DesignationPaginator(Paginable finder) {
        init(finder);
    }
}
