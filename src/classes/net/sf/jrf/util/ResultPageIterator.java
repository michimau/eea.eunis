/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations under
 * the License.
 *
 * The Original Code is jRelationalFramework.
 *
 * The Initial Developer of the Original Code is is.com.
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: Jonathan Carlson (joncrlsn@users.sf.net)
 * Contributor: ____________________________________
 *
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License (the "GPL") or the GNU Lesser General
 * Public license (the "LGPL"), in which case the provisions of the GPL or
 * LGPL are applicable instead of those above.  If you wish to allow use of
 * your version of this file only under the terms of either the GPL or LGPL
 * and not to allow others to use your version of this file under the MPL,
 * indicate your decision by deleting the provisions above and replace them
 * with the notice and other provisions required by either the GPL or LGPL
 * License.  If you do not delete the provisions above, a recipient may use
 * your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.util;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import net.sf.jrf.domain.AbstractDomain;

/**
 * This class is a ListIterator for the "pages" of a result set.
 *
 * ListIterators can iterate forward or backwards.  The page size can only
 * be set as part of constructor of this class.
 *
 * Actually, for each page the whole query is executed again, but only the
 * appropriate subset of rows are converted to objects and returned.  This
 * means that if rows are added to or removed from the table between
 * #nextPage() calls, a row may show up in two pages, or a row may not show
 * up at all.  For web display purposes, this probably won't be a problem,
 * but the developer should be aware of this potential.  The philosophy here
 * was to implement something as simply as possible until the need for a
 * more complex solution is at hand.
 *
 * To use this class, create an anonymous subclass with the doFind() method
 * overridden.  Then use it as you would any iterator.  Here is an example
 * of how it would be used:
 * <code>
 * CustomerDomain domain = new CustomerDomain();<br />
 * final SalesPerson fred = new SalesPerson("Fred");<br />
 *
 *ResultPageIterator iterator =<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;new ResultPageIterator(domain, 10)<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;{<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;List doFind(AbstractDomain domain)<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CustomerDomain custDomain = (CustomerDomain) domain;<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return custDomain.findAllFor(fred);<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br />
 *&nbsp;&nbsp;&nbsp;&nbsp;};<br />
 *<br />
 *while (iterator.hasNext())<br />
 *{<br />
 *&nbsp;&nbsp;List results = iterator.nextPage();<br />
 *&nbsp;&nbsp;// do something with the page of objects...<br />
 *}<br />
 * </code>
 */
public abstract class ResultPageIterator
        implements ListIterator {

  /** required field */
  protected AbstractDomain i_domain;
  /** required field */
  protected int i_pageSize;

  protected boolean i_hasNext = false;

  protected int i_pageNumber = 0;

  /**
   * This constructor should not be used since it will return an invalid
   * iterator.
   */
  private ResultPageIterator() {
  }

  /**
   *Constructor for the ResultPageIterator object
   *
   * @param domain    Description of the Parameter
   * @param pageSize  Description of the Parameter
   */
  public ResultPageIterator(AbstractDomain domain,
                            int pageSize) {
    i_domain = domain;
    i_pageSize = pageSize;
  }


  /* ========== Getters and Setters ========== */
  /**
   * Gets the domain attribute of the ResultPageIterator object
   *
   * @return   The domain value
   */
  public AbstractDomain getDomain() {
    return i_domain;
  }


  /**
   * Gets the pageSize attribute of the ResultPageIterator object
   *
   * @return   The pageSize value
   */
  public int getPageSize() {
    return i_pageSize;
  }


  /* ========== Command Methods  ========== */

  /** This method is unsupported. */
  public void remove() {
    throw new java.lang.UnsupportedOperationException();
  }

  /**
   * This method is unsupported.
   *
   * @param anObject  Description of the Parameter
   */
  public void add(Object anObject) {
    throw new java.lang.UnsupportedOperationException();
  }

  /**
   * This method is unsupported.
   *
   * @param anObject  Description of the Parameter
   */
  public void set(Object anObject) {
    throw new java.lang.UnsupportedOperationException();
  }

  /**
   * Returns the next higher page number (page numbers start at 1, not 0)
   *
   * @return   a value of type 'int'
   */
  public int nextIndex() {
    if (this.hasNext()) {
      return i_pageNumber + 1;
    } else {
      return i_pageNumber;
    }
  }

  /**
   * Returns the previous page number (page numbers start at 1, not 0)
   *
   * @return   a value of type 'int'
   */
  public int previousIndex() {
    if (this.hasPrevious()) {
      return i_pageNumber - 1;
    } else {
      return -1;
    }
  }

  /**
   * Return true if there is another page of objects available.
   *
   * @return   a value of type 'boolean'
   */
  public boolean hasNext() {
    if (i_pageNumber == 0) {
      i_domain.setStartingIndex(1);
      i_domain.setEndingIndex(1);
      List result = this.doFind(i_domain);
      i_hasNext = (result.size() > 0);
    }
    return i_hasNext;
  }// hasNext()


  /**
   * Return true if it is possible to go back to the previous page of objects.
   *
   * @return   a value of type 'boolean'
   */
  public boolean hasPrevious() {
    return (i_pageNumber > 1);
  }// hasPrevious()


  /**
   * This method is here to match the ListIterator interface.  Note that the
   * return type is Object instead of the List return type on nextPage().
   *
   * @return   a value of type 'Object'  (This will always be a List, however)
   */
  public Object next() {
    return this.nextPage();
  }// next()


  /**
   * This method returns the next page of objects.  If none exist,
   * NoSuchElementException is thrown.
   *
   * @return   a value of type 'List'
   */
  public List nextPage() {
    if (!this.hasNext()) {
      throw new java.util.NoSuchElementException();
    }
    return this.findNext();
  }// nextPage()


  /**
   * This method is here to match the ListIterator interface.  Note that the
   * return type is Object instead of the List return type on previousPage().
   *
   * @return   a value of type 'Object'  (This will always be a List, however)
   */
  public Object previous() {
    return this.previousPage();
  }// previous()


  /**
   * This method returns the previous page of objects.  If none exist,
   * NoSuchElementException is thrown.
   *
   * @return   a value of type 'List'
   */
  public List previousPage() {
    if (!this.hasPrevious()) {
      throw new java.util.NoSuchElementException();
    }
    return this.findPrevious();
  }// nextPage()


  /** Restart iterating from the beginning. */
  public void reset() {
    i_pageNumber = 0;
  }


  /**
   * Return the current page number.
   *
   * @return   a value of type 'int'
   */
  public int getPageNumber() {
    return i_pageNumber;
  }


  /**
   * This method must be overridden with a call to a find method on the
   * domain.
   *
   * @param domain  Description of the Parameter
   * @return        a value of type 'List'
   */
  protected abstract List doFind(AbstractDomain domain);


  /* ========== Private Method(s)  ========== */
  private List findNext() {
    i_pageNumber++;
    return this.find();
  }

  private List findPrevious() {
    i_pageNumber--;
    return this.find();
  }

  private List find() {
    List result = null;
    int startingIndex = ((i_pageNumber - 1) * i_pageSize) + 1;
    int endingIndex = (i_pageNumber) * i_pageSize;
    i_domain.setStartingIndex(startingIndex);
    // Try to find one more than the page size
    i_domain.setEndingIndex(endingIndex + 1);
    result = this.doFind(i_domain);
    if (result == null) {
      result = new ArrayList();
    }

    // If we found an extra one, we know there is more.
    if (result.size() > i_pageSize) {
      i_hasNext = true;
      // remove the last, extra element.
      result.remove(i_pageSize);
    } else {
      i_hasNext = false;
    }
    return result;
  }// find()

}// ResultPageIterator




