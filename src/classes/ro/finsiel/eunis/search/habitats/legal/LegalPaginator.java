package ro.finsiel.eunis.search.habitats.legal;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class used for habitats->legal instruments.
 * @author finsiel
 */
public class LegalPaginator extends AbstractPaginator {

  /**
   * Normal constructor.
   * @param finder Data factory used to query the database.
   */
  public LegalPaginator(Paginable finder) {
    init(finder);
  }
}
