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
package net.sf.jrf.sqlbuilder;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import java.util.StringTokenizer;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.column.ColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.sql.*;
import org.apache.log4j.Category;

/**  Subclasses of this class generate SQL. */
public abstract class SQLBuilder {

  final static Category LOG = Category.getInstance(SQLBuilder.class.getName());

  /** This is a copy of the ColumnSpec list */
  protected AbstractDomain i_domain = null;
  protected List i_columnSpecs = null;
  protected String i_tableName = null;
  protected String i_tableAlias = null;
  protected DatabasePolicy i_dbPolicy = null;


  /* ===============  Constructors  =============== */
  /**Constructor for the SQLBuilder object */
  public SQLBuilder() {
    throw new ConfigurationException(
            "The empty constructor is not to be used: SQLBuilder() ");
  }

  /**
   *Constructor for the SQLBuilder object
   *
   * @param domain  Description of the Parameter
   */
  public SQLBuilder(AbstractDomain domain) {
    i_domain = domain;
    // This list is a clone
    i_columnSpecs = domain.getColumnSpecs();
    i_tableName = domain.getTableName();
    i_tableAlias = domain.getTableAlias();
    i_dbPolicy = domain.getDatabasePolicy();
  }

  /**
   * Gets the columnSpecs attribute of the SQLBuilder object
   *
   * @return   The columnSpecs value
   */
  public List getColumnSpecs() {
    return i_columnSpecs;
  }

  /**
   * Gets the tableName attribute of the SQLBuilder object
   *
   * @return   The tableName value
   */
  public String getTableName() {
    return i_tableName;
  }

  /**
   * Gets the tableAlias attribute of the SQLBuilder object
   *
   * @return   The tableAlias value
   */
  public String getTableAlias() {
    return i_tableAlias;
  }

  /**
   * Gets the databasePolicy attribute of the SQLBuilder object
   *
   * @return   The databasePolicy value
   */
  public DatabasePolicy getDatabasePolicy() {
    return i_dbPolicy;
  }

  /**
   * Throws a database exception if data policy
   *
   * @throws DatabaseException  if database policy is not set.
   */
  protected void checkPolicy() {
    if (i_dbPolicy == null) {
      throw new DatabaseException("The DatabasePolicy has not been set for " + this);
    }
  }

}// SQLBuilder


