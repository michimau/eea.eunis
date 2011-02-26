package ro.finsiel.eunis.search.species.internationalthreatstatus;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator object for species->International threat status.
 * @author finsiel
 */
public class InternationalthreatstatusPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public InternationalthreatstatusPaginator(Paginable finder) {
        init(finder);
    }
}
