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
package net.sf.jrf.column;

import java.sql.Types;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.*;
import org.apache.log4j.Category;

/**  Sub-class of <code>SizedColumnSpec</code> for all text fields. */
public abstract class TextColumnSpec extends SizedColumnSpec {

  protected boolean i_multibyte = false;
  protected int i_sqlType = java.sql.Types.VARCHAR;
  private static Category LOG = Category.getInstance(TextColumnSpec.class.getName());

  /** Default constructor * */
  public TextColumnSpec() {
  }

  /**
   * Constructs a <code>TextColumnSpec</code> with column options assuming
   * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
   *
   * @param columnName    column name.
   * @param columnOption  <code>ColumnOption</code> instance to use.
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  value to use for default if column value is null.
   */
  public TextColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
                        Object defaultValue) {
    super(columnName, columnOption, getter, setter, defaultValue);
  }

  /**
   * Constructs a <code>TextColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
   *
   * @param columnName        column name.
   * @param columnOption      <code>ColumnOption</code> instance to use.
   * @param defaultValue      value to use for default if column value is null.
   * @param getterSetter      Description of the Parameter
   */
  public TextColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
    super(columnName, columnOption, getterSetter, defaultValue);
  }


  /**
   * Constructs a <code>TextColumnSpec</code> with three option values.
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
  public TextColumnSpec(
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
   * Constructs a <code>TextColumnSpec</code> with no option values supplied.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TextColumnSpec(
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
   * Constructs a <code>TextColumnSpec</code> with one option value.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TextColumnSpec(
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
   * Constructs a <code>TextColumnSpec</code> with two option values.
   *
   * @param columnName    name of the column
   * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue  default value when the return value from the "getter" is null.
   * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2       Description of the Parameter
   * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TextColumnSpec(
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
   * Constructs a <code>TextColumnSpec</code> with three option values and a <code>GetterSetter</code> implementation.
   *
   * @param columnName        name of the column
   * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
   * @param defaultValue      default value when the return value from the "getter" is null.
   * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
   */
  public TextColumnSpec(
          String columnName,
          GetterSetter getterSetterImpl,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

  }

  /**
   * Sets whether the column value, if applicable, supports multibyte characters.
   *
   * @param multibyte  if <code>true</code> multibyte is supported for the column.
   */
  public void setMultibyte(boolean multibyte) {
    i_multibyte = multibyte;
  }

  /**
   * Return whether the column value, if applicable, supports multibyte characters.
   *
   * @return   <code>true</code> if multibyte is supported for the column.
   */
  public boolean getMultibyte() {
    return i_multibyte;
  }

  /**
   * Return the ANSI standard SQL column type.
   *
   * @param dbPolicy  a value of type 'DatabasePolicy'
   * @return          a value of type 'String'
   */
  public String getSQLColumnType(DatabasePolicy dbPolicy) {
    return dbPolicy.getTextColumnTypeDefinition(i_maxLength, i_multibyte, i_variable, i_blockSize);
  }


  /**
   * Sets the associated <code>java.sql.Types</code> value
   * based on the database vendor and parameter values.
   *
   * @param policy  database policy instance.
   */
  public void setSqlType(DatabasePolicy policy) {
    i_sqlType = policy.getTextColumnSqlType(super.i_maxLength, i_multibyte,
            super.i_variable, super.i_blockSize);
  }

  /**
   * Encodes a text object for a compound key.  This code exists as static method
   * so that both <code>CompoundPrimaryKeyColumnSpec</code>.encodeFromPersistentObject()</code>
   * and <code>PersistentObject.getEncodedKey()</code> may use the same logic.
   *
   * @param s  <code>String</code> value to encode.
   * @return   an encoded <code>String value that may include quotes and bar (|) characters.
   */
  public static String encodeCompoundKeyTextObject(String s) {
    StringBuffer buffer = new StringBuffer();
    int j = 0;
    buffer.append('"');
    // Escape '|'s and '"' characters. StreamTokenizer will handle
    // everything else. See decodeFromPersistentObject.
    while (j < s.length()) {
      if (s.charAt(j) == '|' || s.charAt(j) == '"') {
        buffer.append('\\');
      }
      buffer.append(s.charAt(j));
      j++;
    }
    buffer.append('"');
    return buffer.toString();
  }
}
