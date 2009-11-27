package ro.finsiel.eunis.search.habitats.sites;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class used for habitats->sites.
 * @author finsiel
 */
public class SitesPaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder Data factory.
   */
  public SitesPaginator(Paginable finder) {
    init(finder);
  }
}