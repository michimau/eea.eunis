/*
*
* The contents of this file are subject to the Mozilla Public License
* Version 1.1 (the "License"); you may not use this file except in
 compliance with the License. You may obtain a copy of the License at
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
* Contributor: 		James Evans (jevans@vmguys.com)
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
package net.sf.jrf.domain;

import java.util.*;

import net.sf.jrf.*;
import net.sf.jrf.sql.*;

/**
 * <code>AbstractDomain</code> will use implementations
 * of this interface to handle <code>PersistentObject</code>s that
 * are embedded in other <code>PersistentObject</code>s.  The general constract
 * is that a handler may use one and only one <code>AbstractDomain</code> instance.
 *
 * @see   net.sf.jrf.domain.AbstractDomain#update(PersistentObject)
 */
public interface EmbeddedPersistentObjectHandler {

  /**
   * Constant to denote that <code>constructObjects</code> should be
   * never be called.  This context will be most appropriate for
   * nesting levels greater than two (2) where the actual object
   * construction will be done at a higher level above for efficiency purposes.
   * Consider the following scenario:
   * <pre>
   * Table A (
   *		id integer not null
   *		.
   *		.
   *		primary key(id)
   * )
   * Table A_dates (
   *		id integer not null,
   *		workdate date not null,
   *		.
   *		.
   *		primary key(id,workdate)
   * )
   * Table A_date_detail (
   *		id integer not null
   *		workdate date not null,
   *		detailtype integer not null,
   *		.
   *		.
   *		primary key(id,workdate,detailtype)
   * </pre>
   * An application may need to build a composite object that
   * includes A as a base and all Table A_dates for
   * a given date range and all associated A_date_detail
   * records.  The objects would look like:
   * <pre>
   * public A extends PersistentObject {
   * .
   * .
   * public ADateDetail extends PersistentObject {
   * .
   * .
   * public AComposite extends A {
   *		private ArrayList dateInfo;
   *		.
   *		public ArrayList getDateInfo() {
   *			return dateInfo;
   *		}
   *		.
   *	     .
   *
   * public ADateDetailComposite extends ADateDetail {
   *		private ArrayList detailInfo;
   *		.
   *		.
   *		public ArrayList getDetaiInfo() {
   *			return detailInfo;
   *		}
   *
   * </pre>
   *  The embedded handler for <code>AComposite</code> at level 1
   *  would be responsible for constructing the objects
   *  as opposed to <code>ADateDetailCompite</code>.  In other words,
   *  the return value <code>getConstructObjectContext()</code>
   *  <code>ADateDetailComposite</code>'s handler would be
   *  <code>CONSTRUCT_CONTEXT_NONE</code>.
   *  The most efficient way of constructing the composite object is
   *  make three SQL statements for the tables based on the date
   *  range and build the relationships in Java space.  The build
   *  process is best left to the base object.
   *
   * @see   #getConstructObjectContext()
   */
  public static int CONSTRUCT_CONTEXT_NONE = 0;

  /**
   * Constant to denote that <code>constructObjects</code> should be
   * called after <em>each</em> row fetched by the parent object.
   *
   * @see   #constructObjects(PersistentObject,JRFResultSet)
   * @see   #getConstructObjectContext()
   */
  public static int CONSTRUCT_CONTEXT_AFTER_EACH_ROW = 1;

  /**
   * Constant to denote that <code>constructObjects</code> should be
   * called after <em>all</em> rows have been fetched by the parent. Ordinarily this
   * context applies to single row fetches but could apply to multiple row fetches
   *
   * @see   #constructObjects(PersistentObject,JRFResultSet)
   * @see   #getConstructObjectContext()
   */
  public static int CONSTRUCT_CONTEXT_AFTER_ALL_ROWS = 2;

  /**
   * Returns the context in which <code>AbstractDomain</code> will call
   * <code>constructObjects()</code>.
   *
   * @return   context in which <code>AbstractDomain</code> will call <code>constructObjects()</code>.
   * @see      #constructObjects(PersistentObject,JRFResultSet)
   * @see      #CONSTRUCT_CONTEXT_AFTER_EACH_ROW
   * @see      #CONSTRUCT_CONTEXT_AFTER_ALL_ROWS
   */
  public int getConstructObjectContext();


  /**
   * Constructs the embedded object or objects based on the
   * information from the parent <code>PersistentObject</code>
   * and any other fields from the <code>JRFResultSet</code>
   * generated from a <code>find(PersistentObject)</code> of
   * the parent object's <code>AbstractDomain</code>. This method is called by <code>AbstractDomain</code>
   * when the construct context is <code>CONSTRUCT_CONTEXT_AFTER_ALL_ROWS</code>.
   *
   * @param parentPO  the <em>last</em> <code>PersistentObject</code> instance.
   *					fetched a call to the parent's <code>AbstractDomain.find(PersistentObject)</code> method.
   * @see             net.sf.jrf.domain.AbstractDomain#find(Object)
   * @see             #CONSTRUCT_CONTEXT_AFTER_ALL_ROWS
   * @see             #getConstructObjectContext()
   */
  public void constructObjects(PersistentObject parentPO);

  /**
   * Constructs the embedded object or objects based on the
   * information from the parent <code>PersistentObject</code>
   * and any other fields from the <code>JRFResultSet</code>
   * generated from a <code>find(PersistentObject)</code> of
   * the parent object's <code>AbstractDomain</code>. This method is called by <code>AbstractDomain</code>
   * when the construct context is <code>CONSTRUCT_CONTEXT_EACH_ROW</code>.
   *
   * @param parentPO         <code>PersistentObject</code> instance just
   *					fetched a call to the parent's
   *		     		<code>AbstractDomain.find(PersistentObject)</code> method.
   * @param parentResultset  Description of the Parameter
   * @see                    net.sf.jrf.domain.AbstractDomain#find(Object)
   * @see                    #CONSTRUCT_CONTEXT_AFTER_EACH_ROW
   * @see                    #getConstructObjectContext()
   */
  public void constructObjects(PersistentObject parentPO, JRFResultSet parentResultset);


  /**
   * Updates child key values from parent key values. This method is required for
   * inserts only.  An example implementation could be:
   * <pre>
   *   public void populateEmbeddedObjectKeyValues(PersistentObject parentPO, PersistentObject embeddedPO)
   *   {
   *		// Populate sequence id value from master to detail record.
   *	 	Customer c = (Customer) parentPO;
   *		CustomerPhone cp = (CustomerPhone) embeddedPO;
   *		cp.setId(c.getId());
   *
   *   }
   * </pre>
   *
   * @param parentPO    <code>PersistentObject</code> instance just
   *					fetched a call to the parent's
   * @param embeddedPO  <code>PersistentObject</code> instance of the embedded object.
   */
  public void populateEmbeddedObjectKeyValues(PersistentObject parentPO, PersistentObject embeddedPO);

  /**
   * Returns the <code>AbstractDomain</code> instance, if required, that manages this
   * object.
   *
   * @return   <code>AbstractDomain</code> instance that manages the object or <code>null</code>
   * not required by the parent.
   */
  public AbstractDomain getDomain();

  /**
   * Returns an <code>Iterator</code> implementation to use by the parent <code>AbstractDomain</code>
   * to validate, save and delete child records.  If there are no current records, implementations should
   * return <code>null</code>.
   *
   * @param parentPO  <code>PersistentObject</code> instance of the parent.
   * @return          <code>Iterator</code> instance for parent <code>AbstractDomain</code> to use to
   * fetch returned objects or <code>null</code> if no records exist.
   * @see             net.sf.jrf.domain.AbstractDomain#update(PersistentObject)
   */
  public Iterator getObjectIterator(PersistentObject parentPO);

  /**
   * Deletes all detail records under the parent.
   *
   * @param parentPO  <code>PersistentObject</code> instance of the parent.
   */
  public void deleteDetailRecords(PersistentObject parentPO);

  /**
   * Returns <code>true</code> if the embedded object or objects are dependent detail records
   * of the parent.  In other words, when the parent record no longer exists, these records also
   * should also no longer exist.  For example, a customer record and his order records.
   * A <code>true</code> return determines if <code>delete()</code> will
   * be called on the objects when <code>delete()</code> is called by the parent
   * <code>AbstractDomain</code>.
   *
   * @return   <code>true</code> if the embedded object or objects s are dependent detail records.
   */
  public boolean isDependentDetailRecord();

  /**
   * Returns <code>true</code> if object is read-only.
   *
   * @return   <code>true</code> if object is read only.
   */
  public boolean isReadOnly();


  /** Returns the bean attribute name of the getter/setter for the embedded object,
   * @return bean attribute name (e.g getNames(): "names").
   */
  public String getBeanAttribute();
}
