package ro.finsiel.eunis.search.species.advanced;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class for advanced search and combined search.
 * @author finsiel
 */
public class DictionaryPaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder
   */
  public DictionaryPaginator(Paginable finder) {
    init(finder);
  }
}
