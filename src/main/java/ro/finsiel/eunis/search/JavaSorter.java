package ro.finsiel.eunis.search;

import java.util.Vector;
import java.util.Collections;
import java.util.Comparator;

/**
 * Class to support the sorting of an given array of Objects<br />
 * In order to do a sorting, your class will  provide a getSortCriteria
 * method in order to extract the criteria after which sorting is done.
 * @author finsiel
 */
public class JavaSorter {
  /** Elements in the list are sorted in <i> natural sorting order</i>. */
  public static final boolean SORT_ASCENDING = false;
  /** Elements in the list that are sorted in <i> reverse natural sorting order</i>.*/
  public static final boolean SORT_DESCENDING = true;
  /** Alias for SORT_ASCENDING. */
  public static final boolean SORT_ALPHABETICAL = false;
  /** Alias for SORT_DESCENDING. */
  public static final boolean SORT_REVERSE_ALPHABETICAL = true;


  /** Creates a new instance of JavaSorter. */
  public JavaSorter() {
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
   * @throws ClassCastException - if the list contains elements that are not
   * mutually comparable (i.e. compare a String with an Int)
   * @throws UnsupportedOperationException - if the specified list's list-iterator
   * does not support the set operation.
   */
  public Vector sort(Vector data, boolean order) throws ClassCastException, UnsupportedOperationException {
    CaseInsensitiveComparator comp = new CaseInsensitiveComparator();
    if (SORT_DESCENDING == order) comp.reverseOrder();
    if (null != data && data.size() > 0) {
      Collections.sort(data, comp);
    }
    return data;
  }

  /**
   * Comparator objects which does the comparison between objects at the lowest level.
   */
  public static class CaseInsensitiveComparator implements Comparator {
    boolean ascending = true;

    /**
     * Set the sorting to be 'descending'.
     */
    public void reverseOrder() {
      ascending = false;
    }

    public int compare(Object element1, Object element2) {
      try {
        String lower1 = ((JavaSortable) element1).getSortCriteria().toLowerCase();
        String lower2 = ((JavaSortable) element2).getSortCriteria().toLowerCase();
        int res = lower1.compareTo(lower2);
        res = (ascending) ? res : (-1) * res;
        return res;
      } catch (ClassCastException ex) {
        System.out.println("You can only sort/compare objects which implements JavaSortable");
        ex.printStackTrace();
        return 0;
      }
    }
  }
}