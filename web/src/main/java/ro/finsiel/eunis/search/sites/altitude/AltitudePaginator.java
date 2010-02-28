package ro.finsiel.eunis.search.sites.altitude;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class for sites->altitude.
 * @author finsiel
 */
public class AltitudePaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public AltitudePaginator(Paginable finder) {
    init(finder);
  }

}