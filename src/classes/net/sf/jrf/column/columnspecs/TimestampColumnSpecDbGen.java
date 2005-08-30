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
 * Contributor: James Evans (jevans@vmguys.com)
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
package net.sf.jrf.column.columnspecs;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.Date;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;

import net.sf.jrf.column.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.TimestampJoinColumn;
import net.sf.jrf.sql.*;
import org.apache.log4j.Category;

/**
 *  This subclass of  <code>TimestampColumnSpec</code> is for
 *  columns that <strong>MUST</strong> have their values generated
 *  from the database time stamp function.
 * <p>
 *  Timestamps can be used for an optimistic lock (i.e. first save wins).
 *  Optimistic locks do not lock users out of an item while someone goes to
 *  lunch (i.e. leaves an item open for a long time).
 *
 * @see   net.sf.jrf.column.columnspecs.SQLDateColumnSpec
 */
public class TimestampColumnSpecDbGen
        extends TimestampColumnSpec {

  final static Category LOG = Category.getInstance(TimestampColumnSpecDbGen.class.getName());
  /* ===============  Static Variables  =============== */
  private boolean insertOnly = false;

  /** Default constructor * */
  public TimestampColumnSpecDbGen() {
    super();
  }

  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with column options assuming
   * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
   *
   * @param columnName    column name.
   * @param columnOption  <code>ColumnOption</code> instance to use.
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  value to use for default if column value is null.
   */
  public TimestampColumnSpecDbGen(String columnName, ColumnOption columnOption, String getter, String setter,
                                  Object defaultValue) {
    super(columnName, columnOption, getter, setter, defaultValue);
  }

  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with column options and a <code>GetterSetter</code> instance.
   *
   * @param columnName        column name.
   * @param columnOption      <code>ColumnOption</code> instance to use.
   * @param defaultValue      value to use for default if column value is null.
   * @param getterSetter      Description of the Parameter
   */
  public TimestampColumnSpecDbGen(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
    super(columnName, columnOption, getterSetter, defaultValue);
  }


  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with three option values.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TimestampColumnSpecDbGen(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    super(columnName, getter, setter, defaultValue, option1, option2, option3);
  }

  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with no option values supplied.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TimestampColumnSpecDbGen(
          String columnName,
          String getter,
          String setter,
          Object defaultValue) {
    super(columnName,
            getter,
            setter,
            defaultValue,
            0,
            0,
            0);
  }

  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with one option value.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TimestampColumnSpecDbGen(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1) {
    super(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            0,
            0);
  }

  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with two option values.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2       Description of the Parameter
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TimestampColumnSpecDbGen(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1,
          int option2) {
    this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            option2,
            0);
  }

  /**
   * Constructs a <code>TimestampColumnSpecDbGen</code> with three option values and a <code>GetterSetter</code> implementation.
   *
   * @param columnName        name of the column
   * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
   * @param defaultValue      default value when the return value from the "getter" is null.
   * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TimestampColumnSpecDbGen(
          String columnName,
          GetterSetter getterSetterImpl,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

  }

  /**
   * Sets whether this time stamp is for insert only operations.
   * <code>AbstractDomain</code> will use the setting of this
   * attribute to correctly build prepared insert and update statements.
   * Given table TimestampColumnSpecDbGen with an column called OPEN_TIME with a value set to
   * <code>true</code>, under Oracle, for example, the prepared statements would be:
   * <pre>
   *     Insert into X (OPEN_TIME,. . .)  values (sysdate,. . .)
   *     Update X set . . . 	// OPEN_TIME never part of SQL.
   * </pre>
   * Conversely, given table Y with an column called LAST_ACCESS with a value set to
   * <code>false</code>, under Oracle, for example, the prepared statements would be:
   * <pre>
   *     Insert into Y (LAST_ACCESS,. . .)  values (sysdate,. . .)
   *     Update X set LAST_ACCESS = sysdate, . . . // LAST_ACCESS is part of SQL.
   * </pre>
   * <p>
   * The default value, if this method is never called, is <code>false</code>.
   *
   * @param insertOnly  if <code>true</code>, time stamps are for inserts only.
   * and the column is also an optimistic lock column.
   */
  public void setInsertOnly(boolean insertOnly) {
    if (i_optimisticLock && insertOnly) {
      throw new IllegalArgumentException("Timestamp cannot be both an optimistic lock column and an insert only type.");
    }
    this.insertOnly = insertOnly;
  }

  /**
   * Description of the Method
   *
   * @return   Description of the Return Value
   */
  public Object optimisticLockDefaultValue() {
    return ColumnSpec.DEFAULT_TO_NOW;
  }

  /**
   * Returns whether this time stamp column is for insert only.
   *
   * @return   <code>true</code> if  time stamps are for inserts only.
   * @see      #setInsertOnly(boolean)
   */
  public boolean isInsertOnly() {
    return this.insertOnly;
  }

  /**
   * @param isInsert      Description of the Parameter
   * @param dbPolicy      Description of the Parameter
   * @param sequenceName  Description of the Parameter
   * @param tableName     Description of the Parameter
   * @return              The preparedSqlValueString value
   * @see                 net.sf.jrf.column.ColumnSpec#getPreparedSqlValueString(boolean,DatabasePolicy,String,String)  *
   */
  public String getPreparedSqlValueString(boolean isInsert, DatabasePolicy dbPolicy,
                                          String sequenceName, String tableName) {
    return dbPolicy.timestampFunction();
  }

  /**
   * @param stmt              The new preparedColumnValueTo value
   * @param value             The new preparedColumnValueTo value
   * @param position          The new preparedColumnValueTo value
   * @exception SQLException  Description of the Exception
   * @see                     net.sf.jrf.column.ColumnSpec#setPreparedColumnValueTo(JRFPreparedStatement,Object,int)
   */
  public void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
          throws SQLException {
    if (!i_optimisticLock) {
      throw new RuntimeException("Set prepared values for timestamps only apply to optimistic locks");
    }
    super.setPreparedColumnValueTo(stmt, value, position);
  }
}// TimestampColumnSpec
