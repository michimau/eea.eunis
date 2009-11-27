package ro.finsiel.eunis.search.sites.neighborhood;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class for sites->neighborhood.
 * @author finsiel
 */
public class NeighborhoodPaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public NeighborhoodPaginator(Paginable finder) {
    init(finder);
  }
}