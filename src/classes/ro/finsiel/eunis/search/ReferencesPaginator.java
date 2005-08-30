package ro.finsiel.eunis.search;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class used for main references search (header).
 * @author finsiel
 */
public class ReferencesPaginator extends AbstractPaginator {

  /**
   * Creates a new ReferencesPaginator object.
   * @param finder Data factory.
   */
  public ReferencesPaginator(Paginable finder) {
    init(finder);
  }
}