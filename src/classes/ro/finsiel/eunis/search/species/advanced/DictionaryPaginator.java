package ro.finsiel.eunis.search.species.advanced;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class for advanced search and combined search.
 */
public class DictionaryPaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder Data source provider
   */
  public DictionaryPaginator(Paginable finder) {
    init(finder);
  }
}
