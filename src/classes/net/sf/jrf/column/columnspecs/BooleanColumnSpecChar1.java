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
import java.sql.Types;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;

import net.sf.jrf.column.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.BooleanJoinColumnChar1;
import net.sf.jrf.sql.*;
import org.apache.log4j.Category;

/**
 * A boolean column specification for database columns storing
 * boolean values as single character field (CHAR(1)).  The default values of the
 * character are "Y" and "N"; however, these can be changed. This specification
 * is particularly useful when outside generic reporting tools
 * are used in the application (often easier to manage character fields with specific meanings
 * as opposed to numerical fields 0 and 1).
 */
public class BooleanColumnSpecChar1 extends TextColumnSpec {

  protected final static Class s_class = java.lang.Boolean.class;

  /** Value to denote <code>true</code>, which defaults to "Y". * */
  protected String trueValue = "Y";

  /** Value to denote <code>false</code>, which defaults to "N". * */
  protected String falseValue = "N";


  /** Default constructor. */
  public BooleanColumnSpecChar1() {
    initParams();
  }

  /**
   * Constructs a <code>BooleanColumnSpecChar1</code> with column options assuming
   * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
   *
   * @param columnName    column name.
   * @param columnOption  <code>ColumnOption</code> instance to use.
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  value to use for default if column value is null.
   */
  public BooleanColumnSpecChar1(String columnName, ColumnOption columnOption, String getter, String setter,
                                Object defaultValue) {
    super(columnName, columnOption, getter, setter, defaultValue);
    initParams();
  }

  /**
   * Constructs a <code>BooleanColumnSpecChar1</code> with column options and a <code>GetterSetter</code> instance.
   *
   * @param columnName        column name.
   * @param columnOption      <code>ColumnOption</code> instance to use.
   * @param defaultValue      value to use for default if column value is null.
   * @param getterSetter      Description of the Parameter
   */
  public BooleanColumnSpecChar1(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
    super(columnName, columnOption, getterSetter, defaultValue);
    initParams();
  }

  /**
   * Constructs a <code>BooleanColumnSpecChar1</code> with column options and a <code>GetterSetter</code> instance.
   *
   * @param columnName        column name.
   * @param columnOption      <code>ColumnOption</code> instance to use.
   * @param defaultValue      value to use for default if column value is null.
   * @param trueValue         single character value to use to denote <code>true</code>.  This value will
   * be written to the database for all <code>true</code> column values.
   * @param falseValue        single character value to use to denote <code>false</code>.  This value will
   * be written to the database for all <code>false</code> column values.
   * @param getterSetter      Description of the Parameter
   */
  public BooleanColumnSpecChar1(String columnName, ColumnOption columnOption, GetterSetter getterSetter,
                                Object defaultValue, char trueValue, char falseValue) {
    super(columnName, columnOption, getterSetter, defaultValue);
    setTrueValue(trueValue);
    setFalseValue(falseValue);
    initParams();
  }

  /**
   * Initialize <code>SizedColumnSpec</code> and <code>TextColumnSpec</code> parameters.
   * Sub-classes may override this if desired.
   */
  protected void initParams() {
    super.i_maxLength = 1;
    super.i_variable = false;
    super.i_multibyte = false;
    super.i_sqlType = java.sql.Types.CHAR;
  }

  /**
   * Sets the value to use to denote <code>false</code>.  Default is "N" (No).
   *
   * @param falseValue  single character value to use to denote <code>false</code>.  This value will
   * be written to the database for all <code>false</code> column values.
   * @see               #falseValue
   */
  public void setFalseValue(char falseValue) {
    this.falseValue = new String(new char[]{falseValue});
  }

  /**
   * Sets the value to use to denote <code>true</code>.  Default is "Y" (Yes).
   *
   * @param trueValue  single character value to use to denote <code>true</code>.  This value will
   * be written to the database for all <code>true</code> column values.
   * @see              #trueValue
   */
  public void setTrueValue(char trueValue) {
    this.trueValue = new String(new char[]{trueValue});
  }

  /**
   * Returns <code>trueValue</code> if value is <code>true</code> and <code>falseValue</code> if value is <code>false</code>.
   *
   * @param obj       <code>Boolean<code> object.
   * @param dbPolicy  <code>DatabasePolicy</code> instance, not used for this context.
   * @return          <code>trueValue</code> if value is <code>true</code> and <code>falseValue</code> if value is <code>false</code>.
   * @see             #trueValue
   * @see             #falseValue
   */
  public String formatForSql(Object obj, DatabasePolicy dbPolicy) {
    if (obj != null && obj.equals(Boolean.TRUE)) {
      return "'" + trueValue + "'";
    }
    return "'" + falseValue + "'";
  }

  /**
   * Returns <code>true</code> if <code>String</code> parameter is <code>trueValue</code> and
   * <code>false</code> if it is anything else.
   *
   * @param aString  parameter that should either be <code>trueValue</code> or <code>falseValue</code>
   * @return         <code>true</code> if <code>String</code> parameter is <code>trueValue</code> and
   * <code>false</code> if it is anything else.
   * @see            #trueValue
   * @see            #falseValue
   */
  public Object decode(String aString) {
    if (aString.trim().equals("null")) {
      return null;
    }
    return new Boolean(aString.charAt(0) == trueValue.charAt(0) ? true : false);
  }

  /**
   * Returns <code>Boolean</code> class.
   *
   * @return   <code>Boolean</code> class.
   */
  public Class getColumnClass() {
    return s_class;
  }

  /**
   * Extracts and returns the <code>Boolean</code> value from
   * the result set.
   *
   * @param resultSet      <code>JRFResultSet</code> to use.
   * @return               the <code>Boolean</code> value from
   * the result set.
   * @throws SQLException  if an error occurs accessing the result set.
   */
  public Object getColumnValueFrom(JRFResultSet resultSet)
          throws SQLException {
    return getColumnValueFrom(resultSet, this.getColumnIdx(), trueValue);
  }

  /**
   * Extracts and returns the <code>Boolean</code> value from
   * the result set.
   *
   * @param resultSet      <code>JRFResultSet</code> to use.
   * @param columnIdx      column index in result set of boolean column.
   * @param trueValue      String value that denote <code>true</code> in the database.
   * @return               the <code>Boolean</code> value from
   * the result set.
   * @throws SQLException  if an error occurs accessing the result set.
   */
  public static Object getColumnValueFrom(JRFResultSet resultSet, int columnIdx, String trueValue)
          throws SQLException {
    String returnValue = resultSet.getString(columnIdx);
    if (returnValue != null && returnValue.equals(trueValue)) {
      return new Boolean(true);
    }
    return new Boolean(false);
  }

  /**
   * Returns "CHAR(1)".
   *
   * @param dbPolicy  <code>DatabasePolicy</code> instance, not used for this context.
   * @return          "CHAR(1)".
   */
  public String getSQLColumnType(DatabasePolicy dbPolicy) {
    return "CHAR(1)";
  }

  /**
   * Returns a newly-instantiated <code>BooleanJoinColumn</code>.
   *
   * @return   newly-instantiated <code>BooleanJoinColumn</code>.
   */
  public JoinColumn buildJoinColumn() {
    BooleanJoinColumnChar1 b = new BooleanJoinColumnChar1(this.getColumnName(), this.getSetter());
    b.setTrueValue(this.trueValue.charAt(0));
    return b;
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
    Boolean b = (Boolean) value;
    String s = b.booleanValue() ? trueValue : falseValue;
    stmt.setString(s, position, java.sql.Types.CHAR);
  }

}
