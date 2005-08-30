package ro.finsiel.eunis.search.species.names;

import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator used for species->names.
 * @author finsiel
 */
public class NamePaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder The 'data factory' used to do the search
   */
  public NamePaginator(Paginable finder) {
    init(finder);
  }
}