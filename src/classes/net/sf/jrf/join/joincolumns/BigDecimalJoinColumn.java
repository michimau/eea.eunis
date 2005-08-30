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
package net.sf.jrf.join.joincolumns;

import java.math.BigDecimal;

import java.sql.SQLException;

import net.sf.jrf.column.GetterSetter;
import net.sf.jrf.join.*;

import net.sf.jrf.sql.*;

/**
 *  This subclass of JoinColumn represents an BigDecimal column we want joined
 *  from another table.
 */
public class BigDecimalJoinColumn
        extends JoinColumn {

  /* ===============  Static Variables  =============== */
  protected static Class s_class = BigDecimal.class;


  /* ===============  Constructors  =============== */
  /**
   * Construct an instance that is ready to be used.
   *
   * @param columnName  a value of type 'String' - can include the alias
   *                   like this: "Name PersonName"
   * @param setterName  a value of type 'String'
   */
  public BigDecimalJoinColumn(
          String columnName,
          String setterName) {
    super(columnName,
            setterName);
  }

  /**
   * Construct an instance that is ready to be used.
   *
   * @param columnName   a value of type 'String'
   * @param columnAlias  a value of type 'String'
   * @param setterName   a value of type 'String'
   */
  public BigDecimalJoinColumn(
          String columnName,
          String columnAlias,
          String setterName) {
    super(columnName,
            columnAlias,
            setterName);
  }

  /**
   * Constructs instance using column name and getter setter impl.
   *
   * @param columnName        name of the column.
   * @param getterSetterImpl  implementation of <code>GetterSetter</code> for the column.
   */
  public BigDecimalJoinColumn(String columnName, GetterSetter getterSetterImpl) {
    super(columnName, getterSetterImpl);
  }

  /**
   * This is usually overridden by subclasses to explicitly specify the type
   * of object to be retrieved from the result set in JRFResultSet.
   *
   * @param jrfResultSet      a value of type 'JRFResultSet'
   * @return                  a value of type 'Object'
   * @exception SQLException  if an error occurs
   */
  public Object getColumnValueFrom(JRFResultSet jrfResultSet)
          throws SQLException {
    return jrfResultSet.getBigDecimal(i_columnIdx);
  }


  /**
   * Gets the columnClass attribute of the BigDecimalJoinColumn object
   *
   * @return   The columnClass value
   */
  public Class getColumnClass() {
    return s_class;
  }

}// BigDecimalJoinColumn
