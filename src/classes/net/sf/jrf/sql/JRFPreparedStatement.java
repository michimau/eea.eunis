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

import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.*;
import java.math.BigDecimal;
import java.sql.*;
import java.sql.Types;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

import net.sf.jrf.JRFProperties;
import net.sf.jrf.column.ColumnSpec;

import net.sf.jrf.exceptions.*;

import org.apache.log4j.Category;

/**
 * The framework's encapsulation of a JDBC <code>PreparedStatement</code>.  This
 * base class is only used for no-parameter prepared statements.
 * Subclasses will always override <code>setPreparedValues</code>
 * with the requisite code to set prepared values in a statement.
 * An instance or sub-class instance of this class can only be obtained through
 * a <code>PreparedStatementListHandler</code> instance.
 *
 * @see   net.sf.jrf.sql.PreparedStatementListHandler
 * @see   #setPreparedValues(Object)
 */
public class JRFPreparedStatement {
  /** log4j category for debugging and errors */
  private final static Category LOG = Category.getInstance(JRFPreparedStatement.class.getName());

  String sql = null;
  PreparedStatement preparedStatement = null;
  protected DataSourceProperties dataSourceProperties = null;
  private boolean closed = true;

  /**
   * Constructs an instance.
   *
   * @param dataSourceProperties  Description of the Parameter
   */
  JRFPreparedStatement(DataSourceProperties dataSourceProperties) {
    this.dataSourceProperties = dataSourceProperties;
  }

  /**
   * Constructs an instance with given SQL.
   *
   * @param sql                   SQL statement.
   * @param dataSourceProperties  Driver-specific properties.
   */
  JRFPreparedStatement(String sql, DataSourceProperties dataSourceProperties) {
    this.sql = sql;
    this.dataSourceProperties = dataSourceProperties;
  }

  /**
   * Prepares statement with value supplied in object.
   * to set parameters in the prepared statement.
   *
   * @param obj            Object that contains parameters to set.
   * @throws SQLException  if a JDBC set parameter method fails.
   */
  public void prepare(Object obj)
          throws SQLException {
    setPreparedValues(obj);
    if (LOG.isDebugEnabled()) {
      LOG.debug("Setting prepared values complete for [" + sql + "]");
    }
  }

  /**
   * Returns the SQL string and status.
   *
   * @return   SQL statement and status.
   */
  public String toString() {

    return "\n[SQL:" + sql + "]\n[PREP STMT: " + preparedStatement + "]\nclosed? " + closed;
  }

  /**
   * Set prepared statement with values from some object.  This base version
   * does nothing.
   *
   * @param obj            generally a <code>List</code> of </code>ColumnSpec</code> objects.
   * @throws SQLException  if a JDBC set parameter method fails.
   */
  protected void setPreparedValues(Object obj)
          throws SQLException {
  }

  ////////////////////////////////////////////////////
  // Called by PreparedStatementList only.
  ////////////////////////////////////////////////////
  int close() {
    try {
      if (!closed) {
        if (LOG.isDebugEnabled()) {
          LOG.debug("Closing statement: " + sql + " stmt = " + preparedStatement);
        }
        preparedStatement.close();
        closed = true;
        return 1;
      }
    } catch (SQLException ex) {
    }// Don't care
    return 0;
  }

  void open(JRFConnection jrfConnection) {
    if (!closed) {
      return;
    }
    try {
      jrfConnection.assureDatabaseConnection();
      preparedStatement = jrfConnection.connection.prepareStatement(sql);
      if (LOG.isDebugEnabled()) {
        LOG.debug("Successfully prepared [" + sql + "] stmt = " + preparedStatement);
      }
    } catch (Exception ex) {
      throw new DatabaseException(ex, "Unable to prepare statement: " + sql);
    }
    closed = false;
  }

  /**
   * Returns the SQL statement.
   *
   * @return   SQL statement.
   */
  public String getSql() {
    return this.sql;
  }

  /**
   * Returns the actual <code>PreparedStatement</code>.
   *
   * @return     The statement value
   */
  public PreparedStatement getStatement() {
    return this.preparedStatement;
  }

  /**
   * Wraps the operation of testing for null object values and calling
   * <code>PreparedStatement.setNull()</code> for the type.
   *
   * @param position          position in prepared statement.
   * @param type              a <code>java.sql.Types</code> value.
   * @param value             The new null value
   * @return                  true if object is null; <code>setNull</code> will have been called.
   * @exception SQLException  Description of the Exception
   */
  public boolean setNull(int position,
                         Object value, int type)
          throws SQLException {
    if (value == null) {
      preparedStatement.setNull(position, type);
      return true;
    }
    return false;
  }

  // JE Change 3
  // Match all the get result set "get" methods with static prepared statement set methods.

  /**
   * Sets a prepared statement short value.
   *
   * @param value             value to set (<code>java.lang.Short</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setShort(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.SMALLINT)) {
      preparedStatement.setShort(position, ((java.lang.Short) value).shortValue());
    }
  }

  /**
   * Sets a prepared statement long value.
   *
   * @param value             value to set (<code>java.lang.Long</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setLong(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.BIGINT)) {
      preparedStatement.setLong(position, ((java.lang.Long) value).longValue());
    }
  }

  /**
   * Sets a prepared statement integer value.
   *
   * @param value             value to set (<code>java.lang.Integer</code>)
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setInteger(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.INTEGER)) {
      preparedStatement.setInt(position, ((java.lang.Integer) value).intValue());
    }
  }

  /**
   * Sets a prepared statement double value.
   *
   * @param value             value to set (<code>java.lang.Double</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setDouble(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.DOUBLE)) {
      preparedStatement.setDouble(position, ((java.lang.Double) value).doubleValue());
    }
  }

  /**
   * Sets a prepared statement float value.
   *
   * @param value             value to set (<code>java.lang.Float</code>)
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setFloat(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.FLOAT)) {
      preparedStatement.setFloat(position, ((java.lang.Float) value).floatValue());
    }
  }

  /**
   * Sets a prepared statement date value.
   *
   * @param value             value to set (<code>java.sql.Date</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setDate(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.DATE)) {
      preparedStatement.setDate(position, (java.sql.Date) value);
    }
  }

  /**
   * Sets a prepared statement time value.
   *
   * @param value             value to set (<code>java.sql.Time</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setTime(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.TIME)) {
      preparedStatement.setTime(position, (java.sql.Time) value);
    }
  }


  /**
   * Sets a prepared statement time stamp value.
   *
   * @param value             value to set (<code>java.sql.TimeStamp</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setTimestamp(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.TIMESTAMP)) {
      preparedStatement.setTimestamp(position, (java.sql.Timestamp) value);
    }
  }

  /**
   * Sets a prepared statement decimal value.
   *
   * @param value             value to set (<code>java.math.BigDecimal</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setBigDecimal(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.DECIMAL)) {
      preparedStatement.setBigDecimal(position, (BigDecimal) value);
    }
  }

  /**
   * Sets a prepared statement boolean.
   *
   * @param value             value to set (<code>java.lang.Boolean</code>).
   * @param position          position in the statement.
   * @param type              The new boolean value
   * @exception SQLException  Description of the Exception
   */
  public void setBoolean(Object value, int position, int type)
          throws SQLException {
    if (!setNull(position, value, type)) {
      if (dataSourceProperties.isPreparedSetBooleanSupported()) {
        preparedStatement.setBoolean(position, ((java.lang.Boolean) value).booleanValue());
      } else {
        Boolean b = (java.lang.Boolean) value;
        preparedStatement.setInt(position, b.booleanValue() ? 1 : 0);
      }
    }
  }

  /**
   * Sets a prepared statement character value.
   *
   * @param value             value to set (<code>java.lang.Character</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setCharacter(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.CHAR)) {
      preparedStatement.setString(position, "" + value + "");
    }
  }

  /**
   * Sets a prepared statement <code>String</code> value.
   *
   * @param value             value to set (<code>java.lang.String</code>).
   * @param position          position in the statement.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setString(Object value, int position, int type)
          throws SQLException {
    setString(value, position, type, -1);
  }

  /**
   * Sets a prepared statement <code>String</code> value.
   *
   * @param value             value to set (<code>java.lang.String</code>).
   * @param position          position in the statement.
   * @param maxLength         maximum length of the string.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setString(Object value, int position, int type, int maxLength)
          throws SQLException {
    if (!setNull(position, value, type)) {
      String s = (String) value;
      if (maxLength > 0 && type == java.sql.Types.CHAR && dataSourceProperties.getDatabasePolicy().padCHARStrings()) {
        StringBuffer buf = new StringBuffer();
        int i = 0;
        while (i < maxLength) {
          if (i < s.length()) {
            buf.append(s.charAt(i));
          } else {
            buf.append(' ');
          }
          i++;
        }
        s = buf.toString();
      }
      preparedStatement.setString(position, s);
    }
  }

  /**
   * Sets a prepared statement <code>StringBuffer</code> value.
   *
   * @param value             value to set (<code>java.lang.StringBuffer</code>).
   * @param position          position in the statement.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setStringBuffer(Object value, int position, int type)
          throws SQLException {
    if (!setNull(position, value, type)) {
      preparedStatement.setString(position, ((StringBuffer) value).toString());
    }
  }

  /**
   * Sets a prepared statement <code>byte[]</code> value.
   *
   * @param value             value to set (<code>byte[]</code>).
   * @param position          position in the statement.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setBytes(Object value, int position, int type)
          throws SQLException {
    if (!setNull(position, value, type)) {
      preparedStatement.setBytes(position, ((byte[]) value));
    }
  }

  /**
   * Sets a prepared statement binary <code>InputStream</code> value.
   *
   * @param value             value to set (<code>InputStream</code>).
   * @param position          position in the statement.
   * @param length            length of the data.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setBinaryStream(Object value, int position,
                              int length, int type)
          throws SQLException {
    if (!setNull(position, value, type)) {
      preparedStatement.setBinaryStream(position, (InputStream) value, length);
    }
  }

  /**
   * Sets a prepared statement ascii <code>InputStream</code> value.
   *
   * @param value             value to set (<code>InputStream</code>).
   * @param position          position in the statement.
   * @param length            length of the data.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setAsciiStream(Object value, int position,
                             int length, int type)
          throws SQLException {
    if (!setNull(position, value, type)) {
      preparedStatement.setAsciiStream(position, (InputStream) value, length);
    }
  }

  /**
   * Sets a prepared statement <code>Reader</code> value.
   *
   * @param value             value to set (<code>Reader</code>).
   * @param position          position in the statement.
   * @param length            length of the data.
   * @param type              <code>java.sql.Types</code> value.
   * @exception SQLException  Description of the Exception
   */
  public void setCharacterStream(Object value, int position,
                                 int length, int type)
          throws SQLException {
    if (!setNull(position, value, type)) {
      preparedStatement.setCharacterStream(position, (Reader) value, length);
    }
  }

  /**
   * Sets a prepared statement <code>Clob</code> value.
   *
   * @param value             value to set (<code>Clob</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setClob(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.CLOB)) {
      preparedStatement.setClob(position, (Clob) value);
    }
  }

  /**
   * Sets a prepared statement <code>Blob</code> value.
   *
   * @param value             value to set (<code>Blob</code>).
   * @param position          position in the statement.
   * @exception SQLException  Description of the Exception
   */
  public void setBlob(Object value, int position)
          throws SQLException {
    if (!setNull(position, value, java.sql.Types.BLOB)) {
      preparedStatement.setBlob(position, (Blob) value);
    }
  }

  /**
   * Sets an actual column specification value. This function exists
   * solely for the purpose of logging debug and error messages.
   *
   * @param aColumnSpec    <code>ColumnSpec</code> instance.
   * @param value          value to set.
   * @param idx            index to use for prepared call.
   * @throws SQLException  if error occurs setting prepared value.
   */
  protected void setPreparedColumnValue(ColumnSpec aColumnSpec, Object value, int idx)
          throws SQLException {
    setPreparedColumnValue(this, aColumnSpec, value, idx);
  }


  /**
   * Sets an actual column specification value. This function exists
   * solely for the purpose of logging debug and error messages.
   *
   * @param stmt           <code>PreparedStatement</code> instance.
   * @param aColumnSpec    <code>ColumnSpec</code> instance.
   * @param value          value to set.
   * @param idx            index to use for prepared call.
   * @throws SQLException  if error occurs setting prepared value.
   */
  public static void setPreparedColumnValue(JRFPreparedStatement stmt, ColumnSpec aColumnSpec, Object value, int idx)
          throws SQLException {
    try {

      if (LOG.isDebugEnabled()) {
        LOG.debug("Setting prepared value for parameter "
                + idx + " to '" + value + "' for column " + aColumnSpec.getColumnName());
      }
      aColumnSpec.setPreparedColumnValueTo(stmt, value, idx);
    } catch (SQLException ex) {// Trap exception so logging for the error can be done locally
      LOG.error("Setting prepared value for parameter " + idx + " to '" + value + "' for column "
              + aColumnSpec.getColumnName() +
              "has failed in [" + stmt.getSql() + "]: " + ex.getMessage(), ex);
      throw ex;
    }
  }

}

