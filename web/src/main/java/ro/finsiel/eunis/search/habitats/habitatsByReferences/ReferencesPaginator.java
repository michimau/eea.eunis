package ro.finsiel.eunis.search.habitats.habitatsByReferences;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator used for habitats->references.
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
