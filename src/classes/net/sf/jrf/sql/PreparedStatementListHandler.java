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
 * The Initial Developer of the Original Code is is.com (bought by wamnet.com).
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: James Evans (jevans@vmguys.com)
 * Contributor: _____________________________________
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
package net.sf.jrf.sql;

import java.sql.*;
import java.util.*;

import net.sf.jrf.column.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.sqlbuilder.*;

import org.apache.log4j.Category;

/**
 * A prepared statement list handling class that is managed by a
 * particular <code>JRFConnection</code> instance.
 *
 * @see   net.sf.jrf.sql.JRFConnection#getPreparedStatementList()
 */
public class PreparedStatementListHandler {

  final static Category LOG = Category.getInstance(PreparedStatementListHandler.class.getName());
  private Hashtable list = new Hashtable();
  private JRFConnection jrfConnection = null;

  /**
   * Constructs a prepared statement handler.  User cannot
   * directly create this entity -- Use JRFConnection.
   *
   * @param jrfConnection  Description of the Parameter
   */
  PreparedStatementListHandler(JRFConnection jrfConnection) {
    this.setConnection(jrfConnection);
  }

  // Only callable from JRFConnection.
  void setConnection(JRFConnection jrfConnection) {
    if (this.jrfConnection != null && this.jrfConnection.equals(jrfConnection)) {
      return;
    }
    closeAll();
    this.jrfConnection = jrfConnection;
  }

  /**
   * Fetches a prepared statement based on supplied key used
   * in any of the add methods.  This method will properly handle
   * re-preparing the statement should the connection have
   * closed since the last execute.
   *
   * @param key  key to use to search for the statement.
   * @return     A <code>JRFPreparedStatement</code> instance ready to be
   * set up with parameters.
   * @see        #addNoParameterStatement(String,String)
   * @see        #addInsertStatement(String,InsertSQLBuilder,List,String)
   * @see        #addUpdateStatement(String,UpdateSQLBuilder,List,String)
   * @see        #addSelectByPrimaryKeyStatement(String,SelectSQLBuilder,ColumnSpec,String)
   * @see        #addDeleteByPrimaryKeyStatement(String,ColumnSpec,String)
   * @see        #addSelectWhereOrderbyStatement(String,SelectSQLBuilder,String,String,String,List)
   */
  public JRFPreparedStatement get(String key) {
    JRFPreparedStatement i = (JRFPreparedStatement) list.get(key);
    if (i == null) {
      throw new IllegalArgumentException(key + " does not exist. " + getKeys());
    }
    i.open(jrfConnection);
    return i;
  }

  /**
   * Returns all SQL statements and statuses of this handler.
   *
   * @return   all SQL statements and statuses of this handler.
   */
  public String toString() {
    StringBuffer buf = new StringBuffer();
    Iterator iter = list.values().iterator();
    int i = 0;
    int size = list.size();
    while (iter.hasNext()) {
      i++;
      buf.append("\n" + i + " of " + size + ": ");
      buf.append(iter.next());
    }
    return buf.toString();
  }

  /**
   * Sets parameters based on supplied key and returns <code>JRFPreparedStatement</code> that is
   * ready to be executed.
   *
   * @param key     key to use to search for the statement.
   * @param params  Object containing the parameter or parameters.
   * @return        A <code>JRFPreparedStatement</code> instance set up with parameters and
   * ready to be executed.
   * @see           #addNoParameterStatement(String,String)
   * @see           #addInsertStatement(String,InsertSQLBuilder,List,String)
   * @see           #addUpdateStatement(String,UpdateSQLBuilder,List,String)
   * @see           #addSelectByPrimaryKeyStatement(String,SelectSQLBuilder,ColumnSpec,String)
   * @see           #addDeleteByPrimaryKeyStatement(String,ColumnSpec,String)
   * @see           #addSelectWhereOrderbyStatement(String,SelectSQLBuilder,String,String,String,List)
   */
  public JRFPreparedStatement getAndPrepare(String key, Object params) {
    JRFPreparedStatement i = this.get(key);
    if (LOG.isDebugEnabled()) {
      LOG.debug("getAndPrepare(" + key + "," + params + "): " + i.sql);
    }
    try {
      i.prepare(params);
      return i;
    } catch (SQLException ex) {
      throw new DatabaseException(ex, "Error setting up prepared statement [" + i.sql + "]");
    }
  }

  /**
   * Adds a no-parameter SQL prepared statement of any kind.  This method should be used
   * for applications that wish to prepare group by or other summary statements.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param sql                        An SQL statement of any kind, without parameters.
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addNoParameterStatement(String key, String sql)
          throws IllegalArgumentException {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFPreparedStatement(sql,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  /**
   * Adds an adhoc SQL prepared statement of any kind.  This method should be used
   * for applications that wish to prepare group by or other summary statements.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param sql                        An SQL statement of any kind, with or withou parameters.
   * @param colSpecs                   list of <code>ColumnSpec</code>s.
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addAdHocStatement(String key, String sql, List colSpecs)
          throws IllegalArgumentException {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFAdHocPreparedStatement(sql, colSpecs,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  /**
   * Adds an SQL insert prepared statement.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param sqlBuilder                 appropriate <code>InsertSQLBuilder</code> instance that maps to the
   * <code>AbstractDomain</code> sub-class
   * @param colSpecs                   list of <code>ColumnSpec</code>s.
   * @param tableName                  name of table or table alias.
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addInsertStatement(String key,
                                 InsertSQLBuilder sqlBuilder,
                                 List colSpecs,
                                 String tableName)
          throws IllegalArgumentException {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFInsertPreparedStatement(
              sqlBuilder, colSpecs, tableName,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  /**
   * Adds an SQL update prepared statement.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param sqlBuilder                 appropriate <code>UpdateSQLBuilder</code> instance that maps to the
   * <code>AbstractDomain</code> sub-class with the primary key.
   * @param colSpecs                   list of <code>ColumnSpec</code>s.
   * @param tableName                  name of table or table alias.
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addUpdateStatement(String key,
                                 UpdateSQLBuilder sqlBuilder,
                                 List colSpecs,
                                 String tableName)
          throws IllegalArgumentException {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFUpdatePreparedStatement(
              sqlBuilder, colSpecs, tableName,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  /**
   * Add an SQL select by primary key prepared statement.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param sqlBuilder                 appropriate <code>SelectSQLBuilder</code> instance that maps to the
   * <code>AbstractDomain</code> sub-class with the primary key.
   * @param primaryKeyColumnSpec       <code>ColumnSpec</code>s of the primary key of the <code>AbstractDomain</code>
   *  sub-class in <code>sqlBuilder</code>.
   * @param tableAlias                 name of table or table alias.
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addSelectByPrimaryKeyStatement(String key,
                                             SelectSQLBuilder sqlBuilder,
                                             ColumnSpec primaryKeyColumnSpec,
                                             String tableAlias)
          throws IllegalArgumentException {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFSelectPKPreparedStatement(
              sqlBuilder, primaryKeyColumnSpec, tableAlias,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  /**
   * Add an SQL delete by primary key prepared statement.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param primaryKeyColumnSpec       <code>ColumnSpec</code>s of the primary key of the <code>AbstractDomain</code>
   *  sub-class in <code>sqlBuilder</code>.
   * @param tableName                  name of table or table alias.
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addDeleteByPrimaryKeyStatement(String key,
                                             ColumnSpec primaryKeyColumnSpec,
                                             String tableName)
          throws IllegalArgumentException {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFDeletePKPreparedStatement(
              primaryKeyColumnSpec, tableName,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  /**
   * Add an SQL select by adhoc where statement and optional
   * order by clause.
   *
   * @param key                        key to use for fetching statement for processing through
   * a call to <code>get()</code>.
   * @param sqlBuilder                 appropriate <code>SelectSQLBuilder</code>.
   * @param whereClause                syntactically correct prepared where clause.
   * @param orderBy                    optional order by clause. May be <code>null</code>.
   * @param tableName                  name of table or table alias.
   * @param columnSpecs                The feature to be added to the SelectWhereOrderbyStatement attribute
   * @throws IllegalArgumentException  if a statment already exists under this key.
   * @see                              #get(String)
   */
  public void addSelectWhereOrderbyStatement(String key, SelectSQLBuilder sqlBuilder,
                                             String whereClause, String orderBy, String tableName, List columnSpecs) {
    if (!isKeyPresent(key)) {
      JRFPreparedStatement i = new JRFSelectWhereOrderByPreparedStatement(sqlBuilder,
              whereClause, orderBy, tableName, columnSpecs,
              jrfConnection.getDataSourceProperties());
      list.put(key, i);
    }
  }

  private boolean isKeyPresent(String key) {
    return list.get(key) != null ? true : false;
    /*
JRFPreparedStatement i = (JRFPreparedStatement) list.get(key);
if (i != null)
  throw new IllegalArgumentException("Already have a statement under key ["+key+"]: "+i+"\n"+getKeys());
*/
  }

  /**
   * Removes a statement added in any of the add methods.
   *
   * @param key  key to locate statement.
   * @return     <code>true</code> if statement was found.
   * @see        #addNoParameterStatement(String,String)
   * @see        #addInsertStatement(String,InsertSQLBuilder,List,String)
   * @see        #addUpdateStatement(String,UpdateSQLBuilder,List,String)
   * @see        #addSelectByPrimaryKeyStatement(String,SelectSQLBuilder,ColumnSpec,String)
   * @see        #addDeleteByPrimaryKeyStatement(String,ColumnSpec,String)
   * @see        #addSelectWhereOrderbyStatement(String,SelectSQLBuilder,String,String,String,List)
   */
  public boolean remove(String key) {
    JRFPreparedStatement i = (JRFPreparedStatement) list.get(key);
    if (i == null) {
      return false;
    }
    i.close();
    list.remove(key);
    return true;
  }

  /**
   * Closes an individual prepared statement on the list.
   *
   * @param key  key to locate statement.
   */
  public void close(String key) {
    JRFPreparedStatement i = (JRFPreparedStatement) list.get(key);
    if (i != null) {
      i.close();
    }
  }

  /**
   * Returns a list of all keys on the handler
   *
   * @return   list of keys
   */
  public String getKeys() {
    StringBuffer buf = new StringBuffer();
    Iterator iter = list.keySet().iterator();
    int i = 0;
    buf.append("List keys: [");
    while (iter.hasNext()) {
      if (++i > 1) {
        buf.append(",");
      }
      buf.append((String) iter.next());
    }
    buf.append("]");
    return buf.toString();
  }

  /** Clears the list */
  public void clear() {
    closeAll();
    list.clear();
  }

  /** Closes all prepared statements. */
  public void closeAll() {
    Iterator iter = list.values().iterator();
    int c = 0;
    while (iter.hasNext()) {
      JRFPreparedStatement i = (JRFPreparedStatement) iter.next();
      c += i.close();
    }
    if (LOG.isDebugEnabled()) {
      LOG.debug("closeAll(): closed " + c + " of " + list.size() + " statement(s).");
    }
  }

  /**
   * Assures statements are closed.
   *
   * @exception Throwable  Description of the Exception
   */
  protected void finalize()
          throws Throwable {
    try {
      closeAll();
    } finally {
      super.finalize();
    }
  }
}
