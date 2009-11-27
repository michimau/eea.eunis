package ro.finsiel.eunis.search.sites.year;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class for sites->year.
 * @author finsiel
 */
public class YearPaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public YearPaginator(Paginable finder) {
    init(finder);
  }
}
