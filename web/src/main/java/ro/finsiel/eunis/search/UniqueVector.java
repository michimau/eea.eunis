package ro.finsiel.eunis.search;

import java.util.Vector;

/**
 * Vector for storing strings which are unique (duplicates are discarded silently).
 * Order of addition is preserved like in normal vector.
 * @author finsiel
 */
public class UniqueVector {
  private Vector elements = new Vector();

  /**
   * Creates a new UniqueVector object.
   */
  public UniqueVector() {}

  /**
   * Add an element in the vector.
   * @param element String to add.
   */
  public void addElement(String element) {
    if (null == element) return;
    if (null != element && element.equalsIgnoreCase("")) return;
    if (!exists(element)) {
      elements.add(element);
    }
  }

  /**
   * Retrieve the set of elements stored, as a normal Vector.
   * @return Elements stored by this vector.
   */
  public Vector elements() {
    return elements;
  }

  /**
   * Check if an element can be added to the vector.
   * @param newElement Element to add.
   * @return true if element does not already exists.
   */
  public boolean canBeAdded(String newElement) {
    if (null == newElement) return false;
    if (exists(newElement)) return false;
    return true;
  }

  /**
   * Retrieve an list of elements in a String, separated by comma (ex: element1,element2,element3 etc.).
   * @return Elements in a string.
   */
  public String getElementsSeparatedByComma() {
    StringBuffer ret = new StringBuffer();
    for (int i = elements.size() - 1; i >= 0; i--) {
      String element = (String) elements.get(i);
      ret.append(element);
      if (i != 0) ret.append(",");
    }
    return ret.toString();
  }

  private boolean exists(String newElement) {
    for (int i = elements.size() - 1; i >= 0; i--) {
      String element = (String) elements.get(i);
      if (element.equalsIgnoreCase(newElement)) return true;
    }
    return false;
  }

  /**
   * Clear the elements of the vector.
   */
  public void clear() {
    elements.clear();
  }

  /**
   * Get the size of the vector.
   * @return size.
   */
  public int size() {
    return elements.size();
  }

  /**
   * Retrieve an element from vector from specified position.
   * If position is invalid, then null is returned.
   * @param i position.
   * @return String with element
   */
  public String get(int i) {
    String element = null;
    try
    {
      element = (String)elements.get(i);
    } catch (ArrayIndexOutOfBoundsException e) {
      e.printStackTrace();
    } catch (ClassCastException e) {
      e.printStackTrace();
    }
    return element;
  }

  /**
   * Test method.
   * @param args Command line arguments.
   */
  public static void main(String[] args) {
    UniqueVector v = new UniqueVector();
    v.addElement("EE");
    v.addElement("EE");
    v.addElement("DD");
    v.addElement("XX");
    v.addElement("ZZ");
    v.addElement("ZZ");
    System.out.println(v.getElementsSeparatedByComma());
  }
}