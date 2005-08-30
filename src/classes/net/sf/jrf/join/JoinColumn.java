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
package net.sf.jrf.join;

import java.sql.SQLException;
import java.util.StringTokenizer;

import net.sf.jrf.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.gettersetters.*;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.ConfigurationException;
import net.sf.jrf.sql.*;

// VM Change 1
// Added GetterSetterImpl set get methods.
// VM Change 2
// Modified constructors to use default implementation.
// VM Change 3
// Modified  copyColumnValueToPersistentObject() to call implementation.
// VM Change 4
// Commented out unnecessary  setValueTo()
// VM Change 5
/// Throw exception in setSetter() if GetterSetterImpl is already set.

/**
 * Subclasses of this class represent columns from another table that we
 * want included in our PersistentObject.  These are not columns that are
 * used in the actual join (ie. "Table1.Col1 = Table2.Col1") between tables.
 * <p>
 * The column alias is important since the real column name may match one in
 * the main table.
 */
public abstract class JoinColumn {

  protected String i_columnName = null;
  protected int i_columnIdx;
  protected String i_columnAlias = null;
  protected String i_setter = null;

  // VM Change 1
  protected GetterSetter i_getterSetterImpl = null;

  /* ===============  Static Variables  =============== */
  protected static Class s_class = String.class;


  /* ===============  Constructors  =============== */
  /**Constructor for the JoinColumn object */
  public JoinColumn() {
    super();
  }


  /**
   * Construct a JoinColumnInstance that is ready to be used.
   *
   * @param columnName  a value of type 'String' - can include alias like
   *                   this: "Name PersonName"
   * @param setter      a value of type 'String'
   */
  public JoinColumn(
          String columnName,
          String setter) {
    this.setColumnName(columnName);
    i_setter = setter;
    i_getterSetterImpl = new GetterSetterDefaultImpl(this.getColumnClass(), null, setter);// VM Change 2 -- Set default getter
  }

  /**
   * Constructs instance using column name and getter setter impl.
   *
   * @param columnName        name of the column.
   * @param getterSetterImpl  implementation of <code>GetterSetter</code> for the column.
   */
  public JoinColumn(String columnName, GetterSetter getterSetterImpl) {
    this.setColumnName(columnName);
    i_getterSetterImpl = getterSetterImpl;
  }

  /**
   * Construct a JoinColumn instance that is ready to be used.
   *
   * @param columnName   a value of type 'String'
   * @param columnAlias  a value of type 'String' - This can be important if
   *                    the main table has a matching column name.
   * @param setter       a value of type 'String'
   */
  public JoinColumn(
          String columnName,
          String columnAlias,
          String setter) {
    i_columnName = columnName;
    i_columnAlias = columnAlias;
    i_setter = setter;
    i_getterSetterImpl = new GetterSetterDefaultImpl(this.getColumnClass(), null, setter);// VM Change 2 -- Set default getter
  }

  /**
   * Sets the columnIdx attribute of the JoinColumn object
   *
   * @param columnIdx  The new columnIdx value
   */
  public void setColumnIdx(int columnIdx) {
    this.i_columnIdx = columnIdx;
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
    return jrfResultSet.getObject(i_columnIdx);
  }

  /**
   * Gets the columnClass attribute of the JoinColumn object
   *
   * @return   The columnClass value
   */
  public abstract Class getColumnClass();


  /**
   * Gets the columnName attribute of the JoinColumn object
   *
   * @return   The columnName value
   */
  public String getColumnName() {
    return i_columnName;
  }

  /**
   * Sets the columnName attribute of the JoinColumn object
   *
   * @param name  The new columnName value
   */
  public void setColumnName(String name) {
    String result[] = net.sf.jrf.domain.AbstractDomain.parseEntityArgument(name, "Join Column");
    i_columnName = result[0];
    i_columnAlias = result[1];
  }// setColumnName(aString)


  /**
   * Gets the columnAlias attribute of the JoinColumn object
   *
   * @return   The columnAlias value
   */
  public String getColumnAlias() {
    return i_columnAlias;
  }

  /**
   * Sets the columnAlias attribute of the JoinColumn object
   *
   * @param alias  The new columnAlias value
   */
  public void setColumnAlias(String alias) {
    //i_columnAlias = alias;
  }


  /**
   * Gets the setter attribute of the JoinColumn object
   *
   * @return   The setter value
   */
  public String getSetter() {
    return i_setter;
  }

  /**
   * Sets the setter attribute of the JoinColumn object
   *
   * @param setter  The new setter value
   */
  public void setSetter(String setter) {
    // VM Change 5
    if (i_getterSetterImpl != null) {
      throw new RuntimeException("Unable to setSetter() for " + this.getColumnName() +
              " A getterSetter  implementation already exists.");
    }
    i_setter = setter;
  }


  /**
   * Copy the value of my column to the appropriate attribute for this
   * persistent object.
   *
   * @param jrfResultSet      a value of type 'JRFResultSet'
   * @param aPO               a value of type 'PersistentObject'
   * @exception SQLException  if an error occurs
   */
  public void copyColumnValueToPersistentObject(JRFResultSet jrfResultSet,
                                                PersistentObject aPO)
          throws SQLException {

    // VM Change 3
    if (i_getterSetterImpl != null) {
      Object value = this.getColumnValueFrom(jrfResultSet);
      i_getterSetterImpl.set(aPO, value);
    }
  }


  // VM Change 4 -- this method is no longer needed. (see above)
  /*
private void setValueTo(Object aValue,
                        PersistentObject aPO)
  {
  AbstractColumnSpec.setValueTo(aValue,
                                aPO,
                                this.getSetter(),
                                this.getColumnClass());
  }
 */
  /**
   * Description of the Method
   *
   * @param sqlBuffer   Description of the Parameter
   * @param tableAlias  Description of the Parameter
   */
  protected void buildSelectColumnString(StringBuffer sqlBuffer,
                                         String tableAlias) {
    sqlBuffer.append(tableAlias);
    sqlBuffer.append(".");
    sqlBuffer.append(i_columnName);
    if (!i_columnName.equals(i_columnAlias)) {
      sqlBuffer.append(" AS ");
      sqlBuffer.append(i_columnAlias);
    }
  }

  // VM Change 1
  /**
   * Gets the getterSetterImpl attribute of the JoinColumn object
   *
   * @return   The getterSetterImpl value
   */
  public GetterSetter getGetterSetterImpl() {
    return i_getterSetterImpl;
  }

  /**
   * Sets the getterSetterImpl attribute of the JoinColumn object
   *
   * @param getterSetterImpl  The new getterSetterImpl value
   */
  public void setGetterSetterImpl(GetterSetter getterSetterImpl) {
    i_getterSetterImpl = getterSetterImpl;
  }

}// JoinColumn


