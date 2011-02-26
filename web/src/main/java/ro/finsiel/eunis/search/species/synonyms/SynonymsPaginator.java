package ro.finsiel.eunis.search.species.synonyms;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator class used for species->synonyms.
 * @author finsiel
 */
public class SynonymsPaginator extends AbstractPaginator {

    /**
     * Ctor.
     * @param finder Data factory.
     */
    public SynonymsPaginator(Paginable finder) {
        init(finder);
    }
}
