package ro.finsiel.eunis.search.sites.habitats;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class for sites->habitats.
 * @author finsiel
 */
public class HabitatPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public HabitatPaginator(Paginable finder) {
        init(finder);
    }

}
