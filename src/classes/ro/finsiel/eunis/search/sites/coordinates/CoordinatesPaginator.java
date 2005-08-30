package ro.finsiel.eunis.search.sites.coordinates;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class for sites->coordinates.
 * @author finsiel
 */
public class CoordinatesPaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public CoordinatesPaginator(Paginable finder) {
    init(finder);
  }
}