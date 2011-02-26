package ro.finsiel.eunis.search.species.legal;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class for species->legal instruments.
 * @author finsiel
 */
public class LegalPaginator extends AbstractPaginator {

    /**
     * Normal constructor.
     * @param finder Data factory used to query database
     */
    public LegalPaginator(Paginable finder) {
        init(finder);
    }
}
