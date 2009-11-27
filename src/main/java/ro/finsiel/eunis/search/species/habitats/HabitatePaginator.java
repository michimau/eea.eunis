package ro.finsiel.eunis.search.species.habitats;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator object for species->habitats.
 * @author finsiel
 */
public class HabitatePaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder Data factory.
   */
  public HabitatePaginator(Paginable finder) {
    init(finder);
  }
}