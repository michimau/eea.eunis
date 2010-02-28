package ro.finsiel.eunis.search.combined;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class used for combined search.
 * @author finsiel
 */
public class CombinedSearchPaginator extends AbstractPaginator {
  /**
   * Normal constructor.
   * @param finder Data factory.
   */
  public CombinedSearchPaginator(Paginable finder) {
    init(finder);
  }
}
