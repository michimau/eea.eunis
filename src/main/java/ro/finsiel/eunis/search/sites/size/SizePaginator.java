package ro.finsiel.eunis.search.sites.size;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class for sites->size.
 * @author finsiel
 */
public class SizePaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public SizePaginator(Paginable finder) {
    init(finder);
  }
}
