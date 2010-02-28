package ro.finsiel.eunis.search.species.groups;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator object for species->groups.
 * @author finsiel
 */
public class GroupsPaginator extends AbstractPaginator {
  /**
   * Ctor.
   * @param finder Data factory.
   */
  public GroupsPaginator(Paginable finder) {
    init(finder);
  }
}
