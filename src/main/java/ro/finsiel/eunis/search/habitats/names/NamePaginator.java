package ro.finsiel.eunis.search.habitats.names;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class for habitats->names.
 * @author finsiel
 */
public class NamePaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder Data factory.
   */
  public NamePaginator(Paginable finder) {
    init(finder);
  }
}
