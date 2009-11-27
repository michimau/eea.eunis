package ro.finsiel.eunis.search.sites.species;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class for sites->species.
 * @author finsiel
 */
public class SpeciesPaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public SpeciesPaginator(Paginable finder) {
    init(finder);
  }

}