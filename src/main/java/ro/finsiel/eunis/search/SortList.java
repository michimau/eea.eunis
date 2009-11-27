package ro.finsiel.eunis.search;

import ro.finsiel.eunis.jrfTables.JRFSortable;

import java.util.Collections;
import java.util.Comparator;
import java.util.Vector;

/**
 * Class to support the sorting of an given array of Objects<br />
 * In order to do a sorting, you class will  provide a valid
 * <code>toString()</code>
 * method in order to extract the criteria after which sorting is done.
 * @author  finsiel
 */
public class SortList {
  /** Elements in the list are sorted in <i>reverse natural sorting order</i>. */
  public static final boolean SORT_ASCENDING = false;
  /** Elements in the list that are sorted in <i>natural sorting order</i>.*/
  public static final boolean SORT_DESCENDING = true;

  /** Creates a new instance of SortList. */
  public SortList() {
  }

  /** Method used to sort a given Vector.
   * @param data Vector of objects to be sorted. Remember that
   * their toString method must return a valid comparison
   * @param order Must be either <code>SortList.SORT_ASCENDIG</code>
   * or <code>SortList.SORT_DESCENDING</code>If other specified,
   * no sorting is done
   * @return The sorted Vector. Warning, this functions alters the
   * content of the input <code>data</code> parameter, so if you
   * want to preserve the original order, then do a copy before calling
   * this method.
   * @throws java.lang.ClassCastException - if the list contains elements that are not
   * mutually comparable (i.e. compare a String with an Int)
   * @throws java.lang.UnsupportedOperationException - if the specified list's list-iterator
   * does not support the set operation.
   */
  public Vector sort(Vector data, boolean order) throws ClassCastException, UnsupportedOperationException {
    CaseInsensitiveComparator comp = new CaseInsensitiveComparator();
    if (SORT_DESCENDING == order) comp.reverseOrder();
    Collections.sort(data, comp);
    return data;
  }

  /**
   * Implementation of Comparator interface used for comparing objects sorted by SortList.
   * @author finsiel
   */
  public static class CaseInsensitiveComparator implements Comparator {
    boolean ascending = true;

    /**
     * Set the sorting to be 'descending'.
     */
    public void reverseOrder() {
      ascending = false;
    }

    /**
     * Comparation method.
     * @param element1 Compared element 1.
     * @param element2 Compared element 2.
     * @return 1 if element1 is greater than element2, 0 if both elements are equal or -1 if element2 is greater than element1.
     */
    public int compare(Object element1, Object element2) {
      try
      {
        String lower1 = ((JRFSortable) element1).getSortCriteria().toLowerCase();
        String lower2 = ((JRFSortable) element2).getSortCriteria().toLowerCase();

        int res = lower1.compareTo(lower2);
        res = (ascending) ? res : (-1) * res;
        return res;
      } catch (ClassCastException ex) {
        System.out.println("You can only sort/compare objects which implements JRFSortable : " + ex.getMessage());
        ex.printStackTrace();
        return 0;
      }
    }
  }
}