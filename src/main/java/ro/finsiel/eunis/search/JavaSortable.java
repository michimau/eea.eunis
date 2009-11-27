package ro.finsiel.eunis.search;

/**
 * This interface should be implemented by objects which can be sorted in Java,
 * using Java's internal sorting algorithm.
 * @author finsiel
 */
public interface JavaSortable {
  /**
   * This method will return a string after which the comparison between same type
   * of objects can be done.
   * @return Criteria string used by system to sort the object.
   */
  String getSortCriteria();
}
