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
 * Contributor: Alix Jermyn (Icon MediaLab Belgium -
 *                              alix.jermyn@iconmedialab.com)
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

// note that all references to Date refer to a java.sql.Date, not a
// java.util.Date

import java.sql.Date;
import java.sql.PreparedStatement;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;

import net.sf.jrf.column.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.SQLDateJoinColumn;
import net.sf.jrf.sql.*;

import org.apache.log4j.Category;

/**
 * This subclass of AbstractColumnSpec does java.sql.Date specific things.
 * Note that this is not java.util.Date, but since java.sql.Date is a
 * subclass of java.util.Date, there will be some compatibility.  Users
 * may use or ignore the time component of the value.
 */
public class SQLDateColumnSpec
        extends AbstractColumnSpec {

  final static Category LOG = Category.getInstance(SQLDateColumnSpec.class.getName());

  /* ===============  Static Variables  =============== */
  protected final static Class s_class = java.sql.Date.class;
  /** Description of the Field */
  public final static String SINGLE_QUOTE = "'";


  /**Constructor for the SQLDateColumnSpec object */
  public SQLDateColumnSpec() {
    super();
  }

  /**
   * Constructs a <code>SQLDateColumnSpec</code> with column options assuming
   * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
   *
   * @param columnName    column name.
   * @param columnOption  <code>ColumnOption</code> instance to use.
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  value to use for default if column value is null.
   */
  public SQLDateColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
                           Object defaultValue) {
    super(columnName, columnOption, getter, setter, defaultValue);
  }

  /**
   * Constructs a <code>SQLDateColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
   *
   * @param columnName        column name.
   * @param columnOption      <code>ColumnOption</code> instance to use.
   * @param defaultValue      value to use for default if column value is null.
   * @param getterSetter      Description of the Parameter
   */
  public SQLDateColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
    super(columnName, columnOption, getterSetter, defaultValue);
  }


  /**
   * Constructs a <code>SQLDateColumnSpec</code> with three option values.
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
  public SQLDateColumnSpec(
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
   * Constructs a <code>SQLDateColumnSpec</code> with no option values supplied.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public SQLDateColumnSpec(
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
   * Constructs a <code>SQLDateColumnSpec</code> with one option value.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public SQLDateColumnSpec(
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
   * Constructs a <code>SQLDateColumnSpec</code> with two option values.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2       Description of the Parameter
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public SQLDateColumnSpec(
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
   * Constructs a <code>SQLDateColumnSpec</code> with three option values and a <code>GetterSetter</code> implementation.
   *
   * @param columnName        name of the column
   * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
   * @param defaultValue      default value when the return value from the "getter" is null.
   * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
   */
  public SQLDateColumnSpec(
          String columnName,
          GetterSetter getterSetterImpl,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

  }

  /**
   * This method overrides the superclass implementation.
   *
   * @param obj       a value of type 'Object'
   * @param dbPolicy  a value of type 'DatabasePolicy'
   * @return          a value of type 'String'
   */
  public String formatForSql(Object obj, DatabasePolicy dbPolicy) {
    // force a runtime error if not a Date
    java.sql.Date sqlDate = (java.sql.Date) obj;
    String returnValue = "null";
    if (sqlDate != null) {
      if (sqlDate.equals(AbstractDomain.CURRENT_DATE)) {
        // Set the return value to today (SYSDATE, GETDATE(), etc...)
        returnValue = dbPolicy.timestampFunction();
      } else {
        returnValue = dbPolicy.formatDate(sqlDate);
      }
    }
    return returnValue;
  }// formatForSql(...)


  /**
   * This method goes with encode().  The String parameter must have been
   * created by the encode() method, which uses the toString() method unless
   * overidden.  By Default the toString() and valueOf() methods both use
   * the ANSI format, yyyy-mm-dd.
   *
   * @param aString  a value of type 'String'
   * @return         a value of type 'Object' (This actually will be a
   *                                   java.sql.Date or null)
   */
  public Object decode(String aString) {
    if (aString.trim().equals("null")) {
      return null;
    }
    return java.sql.Date.valueOf(aString);
  }


  /**
   * Gets the columnClass attribute of the SQLDateColumnSpec object
   *
   * @return   The columnClass value
   */
  public Class getColumnClass() {
    return s_class;
  }

  /**
   * Gets the date value from the result set.
   * <code>java.sql.PreparedStatement.getTimestamp(String)</code> will be used to get the actual value since
   * <code>java.sql.PreparedStatement.getDate(String)</code> will lop off the time component.
   *
   * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
   * @return                  a value of type 'Object'
   * @exception SQLException  if an error occurs
   * @see                     #setPreparedColumnValueTo(JRFPreparedStatement,Object,int)
   */
  public Object getColumnValueFrom(JRFResultSet jrfResultSet)
          throws SQLException {
    return jrfResultSet.getDate(this.getColumnIdx());
  }

  /**
   * Return the ANSI standard SQL column type.
   *
   * @param dbPolicy  a value of type 'DatabasePolicy'
   * @return          a value of type 'String'
   */
  public String getSQLColumnType(DatabasePolicy dbPolicy) {
    return dbPolicy.getDateColumnType();
  }

  /**
   * Description of the Method
   *
   * @return   Description of the Return Value
   */
  public JoinColumn buildJoinColumn() {
    return new SQLDateJoinColumn(this.getColumnName(),
            this.getSetter());
  }

  /**
   * @param stmt              The new preparedColumnValueTo value
   * @param value             The new preparedColumnValueTo value
   * @param position          The new preparedColumnValueTo value
   * @exception SQLException  Description of the Exception
   * @see                     net.sf.jrf.column.ColumnSpec#setPreparedColumnValueTo(JRFPreparedStatement,Object,int)
   * Some (all?) JDBC drivers ignore any time values in an <code>java.sql.PreparedStatement.setDate(int,java.sql.Date)</code>
   * call.  Thus, this method converts any value to a <code>java.sql.Timestamp</code> and
   * calls <code>java.sql.PreparedStatement.setTimestamp(int,java.sql.Timestamp)</code> to set the value.
   */
  public void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
          throws SQLException {
    if (value != null) {
      //LOG.info("setPreparedColumnValueTo(stmt,"+value+","+position+")");
      java.sql.Date d = (java.sql.Date) value;
      if (d.equals(JRFConstants.CURRENT_DATE)) {
        value = new java.sql.Date(new java.util.Date().getTime());
      }
    }
    stmt.setDate(value, position);
  }

}// SQLDateColumnSpec
