package ro.finsiel.eunis.search.species.speciesByReferences;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator class used for species->references.
 * @author finsiel
 */
public class ReferencesPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public ReferencesPaginator(Paginable finder) {
        init(finder);
    }
}
