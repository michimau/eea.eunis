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
 * Contributor: Jonathan Carlson (joncrlsn@users.sf.net)
 * Contributor: Craig Laurent (clauren@wamnet.com, craigLaurent@yahoo.com)
 * Contributor: Tim Dawson (tdawson@wamnet.com)
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
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

import net.sf.jrf.JRFProperties;

import net.sf.jrf.exceptions.*;

import org.apache.log4j.Category;

/**
 * <code>JRFResult</code> encapsulates a JDBC <code>ResultSet</code>
 * and provides wrapper methods on the <code>get.</code> methods
 * to handle data source-specific pecularities.  Mirroring JDBC, and
 * instance of this class may only be obtained through an execute call
 * on <code>JRFStatementExecuter</code>.
 *
 * @see   net.sf.jrf.sql.StatementExecuter#executeQuery(String)
 * @see   net.sf.jrf.sql.StatementExecuter#executeQuery(PreparedStatement)
 * @see   net.sf.jrf.sql.StatementExecuter#executeQuery(JRFPreparedStatement)
 */
public class JRFResultSet {
  /** log4j category for debugging and errors */
  private final static Category LOG = Category.getInstance(JRFResultSet.class.getName());

  private int i_recCount = -1;
  private ResultSet i_resultSet = null;
  private DataSourceProperties dataSourceProperties = null;

  JRFResultSet(ResultSet resultSet, DataSourceProperties dataSourceProperties) {
    this.i_resultSet = resultSet;
    this.dataSourceProperties = dataSourceProperties;
  }

  public void setCount(int i_recCount) {
    this.i_recCount = i_recCount;
  }

  public int getCount() {
    return this.i_recCount;
  }

  public boolean last() throws SQLException {
    return i_resultSet.last();
  }

  public void beforeFirst() throws SQLException {
    i_resultSet.beforeFirst();
  }

  public int getRow() throws SQLException {
    return i_resultSet.getRow();
  }

  /**
   * Returns result set information.
   *
   * @return                  <code>ResultSetMetaData</code> instance.
   * @exception SQLException  Description of the Exception
   */
  public ResultSetMetaData getMetaData()
          throws SQLException {
    return i_resultSet.getMetaData();
  }

  /**
   * Moves the cursor to the next row in the result set.
   *
   * @return                  true if the new current row is valid; false if there are no
   *              more rows.
   * @exception SQLException  if a database access error occurs
   */
  public boolean next()
          throws SQLException {
    return i_resultSet.next();
  }

  /**
   * Get whatever type of object is in the given column.
   * If the column has a null, this will return false.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Object'
   * @exception SQLException  Description of the Exception
   */
  public Object getObject(String column)
          throws SQLException {
    return i_resultSet.getObject(column);
  }


  /**
   * Get whatever type of object is in the given column.
   * If the column has a null, this will return false.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Object'
   * @exception SQLException  Description of the Exception
   */
  public Object getObject(int column)
          throws SQLException {
    return i_resultSet.getObject(column);
  }

  ////////////////////////////////////////////////////////////////
  // Some underlying drivers or DataSource (Poolman) have wrap
  // the ResultSet get methods and cause problems for getBoolean()
  // depending on how the column is defined.  These methods are
  // fallbacks to avoid direct calls to geBoolean().
  ////////////////////////////////////////////////////////////////////
  private boolean getUnsupportedGetBoolean(int column)
          throws SQLException {
    int i = i_resultSet.getInt(column);
    return (i == 0 ? false : true);
  }

  private boolean getUnsupportedGetBoolean(String column)
          throws SQLException {
    int i = i_resultSet.getInt(column);
    return (i == 0 ? false : true);
  }


  /**
   * Calls the getBoolean() method on the ResultSet.
   * If the column has a null, this will return false.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'boolean'
   * @exception SQLException  if column is not found
   */
  public boolean getboolean(String column)
          throws SQLException {
    if (dataSourceProperties.isResultSetGetBooleanSupported()) {
      return i_resultSet.getBoolean(column);
    }
    return getUnsupportedGetBoolean(column);
  }


  /**
   * Calls the getboolean() method on the ResultSet.
   * If the column has a null, this will return false.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'boolean'
   * @exception SQLException  if column is not found
   */
  public boolean getboolean(int column)
          throws SQLException {
    if (dataSourceProperties.isResultSetGetBooleanSupported()) {
      return i_resultSet.getBoolean(column);
    }
    return getUnsupportedGetBoolean(column);
  }


  /**
   * Calls the getBoolean() method on the ResultSet and wraps the boolean in
   * a Boolean.  If the column has a null, this will return false.
   * (This used to return null if the JDBC driver did, but each JDBC driver
   *  behaves a little differently, so this equalizes that)
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Boolean'
   * @exception SQLException  if column is not found
   */
  public Boolean getBoolean(String column)
          throws SQLException {
    return (Boolean) handleNullReturn(new Boolean(getboolean(column)));
  }

  /**
   * Calls the getBoolean() method on the ResultSet and wraps the boolean in
   * a Boolean.  If the column has a null, this will return false.
   * (This used to return null if the JDBC driver did, but each JDBC driver
   *  behaves a little differently, so this equalizes that)
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Boolean'
   * @exception SQLException  if column is not found
   */
  public Boolean getBoolean(int column)
          throws SQLException {
    Boolean b = (Boolean) handleNullReturn(new Boolean(getboolean(column)));
    return b == null ? b.FALSE : b;
  }

  /**
   * Calls the getBoolean() method on the ResultSet and wraps the boolean in
   * a Boolean.  If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Boolean', or null.
   * @exception SQLException  if column is not found
   */
  public Boolean getNullableBoolean(String column)
          throws SQLException {
    Boolean b = (Boolean) handleNullReturn(new Boolean(getboolean(column)));
    return b == null ? b.FALSE : b;
  }


  /**
   * Calls the getBoolean() method on the ResultSet and wraps the boolean in
   * a Boolean.  If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Boolean', or null.
   * @exception SQLException  if column is not found
   */
  public Boolean getNullableBoolean(int column)
          throws SQLException {
    return (Boolean) handleNullReturn(new Boolean(getboolean(column)));
  }


  private String handleStringReturn(String result) {
    if (result == null) {
      return null;
    }
    return result.trim();
  }

  /**
   * Calls the getString() method on the ResultSet and trims the result.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'String'
   * @exception SQLException  if column is not found
   * @see                     #getRawString
   */
  public String getString(String column)
          throws SQLException {
    return handleStringReturn(this.getRawString(column));
  }


  /**
   * Calls the getString() method on the ResultSet and trims the result.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'String'
   * @exception SQLException  if column is not found
   * @see                     #getRawString
   */
  public String getString(int column)
          throws SQLException {
    return handleStringReturn(this.getRawString(column));
  }


  /**
   * Calls the getString() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'String'
   * @exception SQLException  if column is not found
   */
  public String getRawString(String column)
          throws SQLException {
    return i_resultSet.getString(column);
  }


  /**
   * Calls the getString() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'String'
   * @exception SQLException  if column is not found
   */
  public String getRawString(int column)
          throws SQLException {
    return i_resultSet.getString(column);
  }


  /**
   * Calls the getTimestamp() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Date'
   * @exception SQLException  if column is not found
   */
  public Timestamp getTimestamp(String column)
          throws SQLException {
    return i_resultSet.getTimestamp(column);
  }


  /**
   * Calls the getTimestamp() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'java.sql.Date'
   * @exception SQLException  if column is not found
   */
  public Timestamp getTimestamp(int column)
          throws SQLException {
    return i_resultSet.getTimestamp(column);
  }

  /**
   * Calls the getDate() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'java.sql.Date'
   * @exception SQLException  if column is not found
   */
  public Date getDate(String column)
          throws SQLException {
    return i_resultSet.getDate(column);
  }

  /**
   * Calls the getDate() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'java.sql.Date'
   * @exception SQLException  if column is not found
   */
  public Date getDate(int column)
          throws SQLException {
    return i_resultSet.getDate(column);
  }

  /**
   * Calls the getTime() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'java.sql.Time'
   * @exception SQLException  if column is not found
   */
  public Time getTime(String column)
          throws SQLException {
    return i_resultSet.getTime(column);
  }


  /**
   * Calls the getTime() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'java.sql.Time'
   * @exception SQLException  if column is not found
   */
  public Time getTime(int column)
          throws SQLException {
    return i_resultSet.getTime(column);
  }


  private Object handleNullReturn(Object obj)
          throws SQLException {
    return i_resultSet.wasNull() ? null : obj;
  }

  /**
   * Calls the getInt() method on the ResultSet and wraps the resulting int
   * in an Integer.  If database has a null, null is returned.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Integer'
   * @exception SQLException  if column is not found
   */
  public Integer getInteger(String column)
          throws SQLException {
    return (Integer) handleNullReturn(new Integer(i_resultSet.getInt(column)));
  }


  /**
   * Calls the getInt() method on the ResultSet and wraps the resulting int
   * in an Integer.  If database has a null, null is returned.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Integer'
   * @exception SQLException  if column is not found
   */
  public Integer getInteger(int column)
          throws SQLException {
    return (Integer) handleNullReturn(new Integer(i_resultSet.getInt(column)));
  }


  /**
   * Calls the getLong() method on the ResultSet and wraps the resulting
   * long in a Long.  If database has a null, null is returned.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Long'
   * @exception SQLException  if column is not found
   */
  public Long getLong(String column)
          throws SQLException {
    return (Long) handleNullReturn(new Long(i_resultSet.getInt(column)));
  }


  /**
   * Calls the getLong() method on the ResultSet and wraps the resulting
   * long in a Long.  If database has a null, null is returned.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Long'
   * @exception SQLException  if column is not found
   */
  public Long getLong(int column)
          throws SQLException {
    return (Long) handleNullReturn(new Long(i_resultSet.getLong(column)));
  }

  /**
   * Calls the getInt() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'int'
   * @exception SQLException  if column is not found
   */
  public int getint(String column)
          throws SQLException {
    return i_resultSet.getInt(column);
  }

  /**
   * Calls the getInt() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'int'
   * @exception SQLException  if column is not found
   */
  public int getint(int column)
          throws SQLException {
    return i_resultSet.getInt(column);
  }

  /**
   * Calls the getLong() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'long'
   * @exception SQLException  if column is not found
   */
  public long getlong(String column)
          throws SQLException {
    return i_resultSet.getLong(column);
  }

  /**
   * Calls the getLong() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'long'
   * @exception SQLException  if column is not found
   */
  public long getlong(int column)
          throws SQLException {
    return i_resultSet.getLong(column);
  }

  /**
   * Calls the getShort() method on the ResultSet and wraps the result
   * in a Short.  If database has a null, null is returned.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Short'
   * @exception SQLException  if column is not found
   */
  public Short getShort(String column)
          throws SQLException {
    return (Short) handleNullReturn(new Short(i_resultSet.getShort(column)));
  }


  /**
   * Calls the getShort() method on the ResultSet and wraps the resulting
   * in a Short.  If database has a null, null is returned.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Short'
   * @exception SQLException  if column is not found
   */
  public Short getShort(int column)
          throws SQLException {
    return (Short) handleNullReturn(new Short(i_resultSet.getShort(column)));
  }

  /**
   * Calls the getFloat() method on the ResultSet and wraps the resulting
   * float in a Float.  If database has a null, null is returned.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Float'
   * @exception SQLException  if column is not found
   */
  public Float getFloat(String column)
          throws SQLException {
    return (Float) handleNullReturn(new Float(i_resultSet.getFloat(column)));
  }


  /**
   * Calls the getFloat() method on the ResultSet and wraps the resulting
   * float in a Float.  If database has a null, null is returned.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Float'
   * @exception SQLException  if column is not found
   */
  public Float getFloat(int column)
          throws SQLException {
    return (Float) handleNullReturn(new Float(i_resultSet.getFloat(column)));
  }

  /**
   * Calls the getFloat() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'float'
   * @exception SQLException  if column is not found
   */
  public float getfloat(String column)
          throws SQLException {
    return i_resultSet.getFloat(column);
  }


  /**
   * Calls the getFloat() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'float'
   * @exception SQLException  if column is not found
   */
  public float getfloat(int column)
          throws SQLException {
    return i_resultSet.getFloat(column);
  }


  /**
   * Calls the getDouble() method on the ResultSet and wraps the resulting
   * double in a Double.  If database has a null, null is returned.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Double'
   * @exception SQLException  if column is not found
   */
  public Double getDouble(String column)
          throws SQLException {
    return (Double) handleNullReturn(new Double(i_resultSet.getDouble(column)));
  }


  /**
   * Calls the getDouble() method on the ResultSet and wraps the resulting
   * double in a Double.  If database has a null, null is returned.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Double'
   * @exception SQLException  if column is not found
   */
  public Double getDouble(int column)
          throws SQLException {
    return (Double) handleNullReturn(new Double(i_resultSet.getDouble(column)));
  }

  /**
   * Calls the getDouble() method on the ResultSet.
   * If the column has a null, this will return a zero.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'double'
   * @exception SQLException  if column is not found
   */
  public double getdouble(String column)
          throws SQLException {
    return i_resultSet.getDouble(column);
  }

  /**
   * Calls the getBigDecimal() method on the ResultSet.
   * If the column has a null, this will return null.
   *
   * @param column            a value of type String
   * @return                  a value of type BigDecimal
   * @exception SQLException  if column is not found
   */
  public BigDecimal getBigDecimal(String column)
          throws SQLException {
    return handleBigDecimalReturn(column, -1);
  }

  private BigDecimal handleBigDecimalReturn(String columnName, int columnOffset) throws SQLException {
    if (!dataSourceProperties.isBigDecimalSupported()) {
      String result;
      if (columnName == null) {
        result = i_resultSet.getString(columnOffset);
      } else {
        result = i_resultSet.getString(columnName);
      }
      return result == null ? null : new BigDecimal(result);
    }
    if (columnName == null) {
      return i_resultSet.getBigDecimal(columnOffset);
    }
    return i_resultSet.getBigDecimal(columnName);
  }

  /**
   * Calls the getBigDecimal() method on the ResultSet.
   * If the column has a null, this will return null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'BigDecimal'
   * @exception SQLException  if column is not found
   */
  public BigDecimal getBigDecimal(int column)
          throws SQLException {
    return handleBigDecimalReturn(null, column);
  }


  /**
   * Calls the getBytes() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'byte[]'
   * @exception SQLException  if column is not found
   */
  public byte[] getBytes(int column)
          throws SQLException {
    return i_resultSet.getBytes(column);
  }


  /**
   * Calls the getBytes() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'byte[]'
   * @exception SQLException  if column is not found
   */
  public byte[] getBytes(String column)
          throws SQLException {
    return i_resultSet.getBytes(column);
  }

  /**
   * Calls the getClob() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Clob'
   * @exception SQLException  if column is not found
   */
  public Clob getClob(String column)
          throws SQLException {
    return i_resultSet.getClob(column);
  }

  /**
   * Calls the getClob() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'int'
   * @return                  a value of type 'Clob'
   * @exception SQLException  if column is not found
   */
  public Clob getClob(int column)
          throws SQLException {
    return i_resultSet.getClob(column);
  }

  /**
   * Calls the getBlob() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'Blob'
   * @exception SQLException  if column is not found
   */
  public Blob getBlob(String column)
          throws SQLException {
    return i_resultSet.getBlob(column);
  }

  /**
   * Calls the getBlob() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            column index.
   * @return                  a value of type 'Blob'
   * @exception SQLException  if column is not found
   */
  public Blob getBlob(int column)
          throws SQLException {
    return i_resultSet.getBlob(column);
  }

  /**
   * Calls the getBinaryStream() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type 'String'
   * @return                  a value of type 'InputStream'
   * @exception SQLException  if column is not found
   */
  public InputStream getBinaryStream(String column)
          throws SQLException {
    return i_resultSet.getBinaryStream(column);
  }


  /**
   * Calls the getBinaryStream() method on the ResultSet.
   * If the column has a null, this will return a null.
   *
   * @param column            a value of type int
   * @return                  a value of type 'InputStream'
   * @exception SQLException  if column is not found
   */
  public InputStream getBinaryStream(int column)
          throws SQLException {
    return i_resultSet.getBinaryStream(column);
  }

  /** Close the result set. */
  public void close() {
    if (i_resultSet != null) {
      try {
        i_resultSet.close();
      } catch (SQLException ex) {
      }// Don't care.
    }
  }

}
