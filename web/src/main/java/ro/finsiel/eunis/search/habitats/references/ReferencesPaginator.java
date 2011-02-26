package ro.finsiel.eunis.search.habitats.references;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator class used for habitats->references.
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
