package ro.finsiel.eunis.jrfTables;

/**
 * All JRF tables which columns must be sorted by Java must implement this
 * interface. Each class job is to return a valid string in order to be sorted (the string which is used for sorting).
 * @author  finsiel
 */
public interface JRFSortable {

  /**
   * This method will return a string after which the comparison between same type
   * of objects can be done.
   */
  String getSortCriteria();
}