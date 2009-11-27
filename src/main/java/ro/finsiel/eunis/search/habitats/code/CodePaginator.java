package ro.finsiel.eunis.search.habitats.code;

import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Paginable;

/**
 * Paginator class used for habitats->code.
 * @author finsiel
 */
public class CodePaginator extends AbstractPaginator {

  /**
   * Normal constructor.
   * @param finder Data factory.
   */
  public CodePaginator(Paginable finder) {
    init(finder);
  }
}
