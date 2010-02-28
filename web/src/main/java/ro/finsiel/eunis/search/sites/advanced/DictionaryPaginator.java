package ro.finsiel.eunis.search.sites.advanced;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class for sites->advanced search.
 * @author finsiel
 */
public class DictionaryPaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public DictionaryPaginator(Paginable finder) {
    init(finder);
  }
}