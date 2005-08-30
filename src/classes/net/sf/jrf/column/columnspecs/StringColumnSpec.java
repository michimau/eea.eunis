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
package net.sf.jrf.column.columnspecs;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;

import net.sf.jrf.column.*;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;
import org.apache.log4j.Category;

// VM Change 1
// Change in getSQLColumnType(DatabasePolicy dbPolicy)
// VM Change 2
// Initialize max length to 255

/** This subclass of AbstractColumnSpec does String-specific things. */
public class StringColumnSpec
        extends TextColumnSpec {

  /* ===============  Static Variables  =============== */
  protected static Class s_class = String.class;

  final static Category LOG = Category.getInstance(StringColumnSpec.class.getName());

  /* ===============  Constructors  =============== */
  /** Public constructor useful only for ad-hoc querie prepared statements. */
  public StringColumnSpec() {
  }

  /**
   * Constructs a <code>StringColumnSpec</code> with column options assuming
   * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
   *
   * @param columnName    column name.
   * @param columnOption  <code>ColumnOption</code> instance to use.
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  value to use for default if column value is null.
   */
  public StringColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
                          Object defaultValue) {
    super(columnName, columnOption, getter, setter, defaultValue);
  }

  /**
   * Constructs a <code>StringColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
   *
   * @param columnName        column name.
   * @param columnOption      <code>ColumnOption</code> instance to use.
   * @param defaultValue      value to use for default if column value is null.
   * @param getterSetter      Description of the Parameter
   */
  public StringColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
    super(columnName, columnOption, getterSetter, defaultValue);
  }


  /**
   * Constructs a <code>StringColumnSpec</code> with three option values.
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
  public StringColumnSpec(
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
   * Constructs a <code>StringColumnSpec</code> with no option values supplied.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public StringColumnSpec(
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
   * Constructs a <code>StringColumnSpec</code> with one option value.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public StringColumnSpec(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1) {
    this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            0,
            0);
  }

  /**
   * Constructs a <code>StringColumnSpec</code> with two option values.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2       Description of the Parameter
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public StringColumnSpec(
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
   * Constructs a <code>StringColumnSpec</code> with three option values and a <code>GetterSetter</code> implementation.
   *
   * @param columnName        name of the column
   * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
   * @param defaultValue      default value when the return value from the "getter" is null.
   * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
   */
  public StringColumnSpec(
          String columnName,
          GetterSetter getterSetterImpl,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

  }


  /**
   * This method overrides the superclass implementation.  A string of
   * "null" is returned if object is null, otherwise it returns a String
   * with quotes around it.  Internal single quotes are converted to
   * two single quotes and the string is wrapped in single quotes.
   *
   * @param obj           Description of the Parameter
   * @param dbPolicy      Description of the Parameter
   * @return              a value of type 'String'
   */
  public String formatForSql(Object obj, DatabasePolicy dbPolicy) {
    String returnValue = "null";
    if (obj != null) {
      returnValue = StringUtil.delimitString((String) obj, "'");
    }
    return returnValue;
  }// formatForSql(...)


  /**
   * This method goes with encode().  The String parameter must have been
   * created by the encode() method.
   *
   * @param aString  a value of type 'String'
   * @return         a value of type 'Object' (This actually will be a String or null)
   */
  public Object decode(String aString) {
    if (aString == null || aString.trim().equals("null")) {
      return null;
    }
    return aString;
  }

  /**
   * Convert the attribute for this object to a String that can be unconverted
   * later by the decodeToPersistentObject(...) method. The result of this
   * method is not for use in SQL.
   *
   * @param aPO  a value of type 'PersistentObject'
   * @return     Description of the Returned Value
   */
  public String encodeFromPersistentObject(PersistentObject aPO) {
    return encode(getValueFrom(aPO));
  }

  /**
   * Gets the columnClass attribute of the StringColumnSpec object
   *
   * @return   The columnClass value
   */
  public Class getColumnClass() {
    return s_class;
  }


  /**
   * Return a String from JDBCHelper.  If String is one blank, return an
   * empty string.  This resolves a strange issue with SQLServer (and maybe
   * Sybase) that keeps returning empty or whitespace strings as one blank
   * character.  If one blank is truly desired, then maybe this should go
   * into the DatabasePolicy, but then we'll have differing behavior when
   * switching databases.
   *
   * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
   * @return                  a value of type 'Object'
   * @exception SQLException  if an error occurs in JDBCHelper
   */
  public Object getColumnValueFrom(JRFResultSet jrfResultSet)
          throws SQLException {
    String returnValue = jrfResultSet.getString(this.getColumnIdx());
    // This if is here to solve a problem with SQLServer where an empty
    // string is returned as a one character blank string.
    if (returnValue != null &&
            returnValue.equals(" ")) {
      returnValue = "";
    }
    return returnValue;
  }

  /**
   * Validates the column value against the length.
   *
   * @param aPO                     <code>PersistentObject</code> instance to check.
   * @return                        Description of the Return Value
   * @throws InvalidValueException  if validation fails.
   * @see                           net.sf.jrf.exceptions.InvalidValueException
   */
  public Object validateValue(PersistentObject aPO)
          throws InvalidValueException {
    String s = (String) super.validateValue(aPO);
    if (s != null && s.length() > i_maxLength) {
      throw new InvalidValueException(i_maxLength, s);
    }
    return s;
  }

  /**
   * This is an override of the superclass implementation.  This method adds
   * a check to make sure the string is not empty or blank.
   *
   * @param aPO                            a value of type 'PersistentObject'
   * @return                               a value of type 'Object'
   * @exception MissingAttributeException  if an error occurs
   */
  public Object validateRequired(PersistentObject aPO)
          throws MissingAttributeException {
    String value = (String) super.validateRequired(aPO);
    // a null value tells us it had to be non-required or an error would
    // have been thrown.
    if (value != null &&
            value.trim().length() == 0) {
      throw new MissingAttributeException(
              "Required attribute - "
              + this.getColumnName()
              + "- is an empty string value.");
    }
    return value;
  }// validateRequired(aPersistentObject)


  // VM Change 1

  /**
   * Description of the Method
   *
   * @return   Description of the Return Value
   */
  public JoinColumn buildJoinColumn() {
    return new StringJoinColumn(this.getColumnName(),
            this.getSetter());
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
    stmt.setString(value, position, super.i_sqlType, super.i_maxLength);
  }

}// StringColumnSpec
