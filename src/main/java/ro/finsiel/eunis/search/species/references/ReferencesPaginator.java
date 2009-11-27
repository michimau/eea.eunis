package ro.finsiel.eunis.search.species.references;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class for species->books.
 * @author finsiel
 */
public class ReferencesPaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder Data factory
   */
  public ReferencesPaginator(Paginable finder) {
    init(finder);
  }
}