package ro.finsiel.eunis.search.habitats.species;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class used for habitats->species.
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