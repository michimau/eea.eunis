package ro.finsiel.eunis.search.species.national;
import ro.finsiel.eunis.search.Paginable;
import ro.finsiel.eunis.search.AbstractPaginator;

/**
 * Paginator class for species->national threat status.
 * @author finsiel
 */
public class NationalPaginator extends AbstractPaginator {

  /**
   * Ctor.
   * @param finder Data factory.
   */
  public NationalPaginator(Paginable finder) {
    init(finder);
  }
}
