/**
 * Date: Apr 7, 2003
 * Time: 2:24:34 PM
 */
package ro.finsiel.eunis.search.habitats.dictionaries;


import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;


/**
 * Paginator class.
 */
public class DictionaryPaginator extends AbstractPaginator {

    /**
     * Constructor.
     * @param finder Data source
     */
    public DictionaryPaginator(Paginable finder) {
        init(finder);
    }
}
