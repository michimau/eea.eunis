/**
 * User: root
 * Date: May 21, 2003
 * Time: 9:44:24 AM
 */
package ro.finsiel.eunis.search.habitats.advanced;


import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;


/**
 * Paginator class used for habitats advanced search.
 * @author finsiel
 */
public class DictionaryPaginator extends AbstractPaginator {

    /**
     * Normal constructor.
     * @param finder data factory.
     */
    public DictionaryPaginator(Paginable finder) {
        init(finder);
    }
}
