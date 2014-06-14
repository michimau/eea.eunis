/*
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *
 *  http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations under
 *  the License.
 *
 *  The Original Code is jRelationalFramework.
 *
 *  The Initial Developer of the Original Code is is.com.
 *  Portions created by is.com are Copyright (C) 2000 is.com.
 *  All Rights Reserved.
 *
 *  Contributor(s): James Evans (jevans@vmguys.com)
 *  Contributor(s): ____________________________________
 *
 *  Alternatively, the contents of this file may be used under the terms of
 *  the GNU General Public License (the "GPL") or the GNU Lesser General
 *  Public license (the "LGPL"), in which case the provisions of the GPL or
 *  LGPL are applicable instead of those above.  If you wish to allow use of
 *  your version of this file only under the terms of either the GPL or LGPL
 *  and not to allow others to use your version of this file under the MPL,
 *  indicate your decision by deleting the provisions above and replace them
 *  with the notice and other provisions required by either the GPL or LGPL
 *  License.  If you do not delete the provisions above, a recipient may use
 *  your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.column.columnspecs;

import net.sf.jrf.column.*;
import net.sf.jrf.*;
import net.sf.jrf.join.joincolumns.*;
import net.sf.jrf.join.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.sql.*;
import net.sf.jrf.DatabasePolicy;

import java.sql.SQLException;
import java.sql.Types;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import org.apache.log4j.Category;
import java.util.Date;
import java.text.*;

/**
 *  A colums specification for <code>java.util.Date</code>. A date type value
 *  will be stored in the database but this class will handle conversions
 *  between <code>java.sql.TimeStamp<code> and
 * <code>java.util.Date</code> for result sets and prepared statement
 *  processing. This class was designed for applications that wish to dispense
 *  with handling <code>java.sql.Date</code>, <code>java.sql.Time</code> or
 *  <code>java.sql.Timestamp</code> directly in application scope.
 *
 *@author     jevans
 *@created    June 13, 2002
 */
public class DateColumnSpec extends AbstractColumnSpec {

    final static Category LOG = Category.getInstance(DateColumnSpec.class.getName());
    /*
     *  ===============  Static Variables  ===============
     */
    /**
     *  Description of the Field
     */
    protected final static Class s_class = java.util.Date.class;


    /**
     *  Date search default constructor.
     */
    public DateColumnSpec() { }


    /**
     *  Constructs a <code>DateColumnSpec</code> with column options assuming
     *  reflection will be used for getting and setting values in the <code>PersistentObject</code>
     *  .
     *
     *@param  columnName    column name.
     *@param  columnOption  <code>ColumnOption</code> instance to use.
     *@param  getter        name of the method to get the column data from the
     *      <code>PersistentObject</code>
     *@param  setter        name of the method to set column data in the <code>PersistentObject</code>
     *      .
     *@param  defaultValue  value to use for default if column value is null.
     */
    public DateColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
            Object defaultValue) {
        super(columnName, columnOption, getter, setter, defaultValue);
    }


    /**
     *  Constructs a <code>DateColumnSpec</code> with column options and a
     *  <code>GetterSetter</code> instance.
     *
     *@param  columnName    column name.
     *@param  columnOption  <code>ColumnOption</code> instance to use.
     *@param  defaultValue  value to use for default if column value is null.
     *@param  getterSetter  Description of the Parameter
     */
    public DateColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
        super(columnName, columnOption, getterSetter, defaultValue);
    }


    /**
     *  Returns the string representation of <code>java.util.Date.getTime()</code>
     *  .
     *
     *@param  obj       <code>Date</code> object.
     *@param  dbPolicy  <code>DatabasePolicy</code> instance.
     *@return           string representation of <code>java.util.Date.getTime()</code>
     *      .
     */
    public String formatForSql(Object obj, DatabasePolicy dbPolicy) {
        String returnValue;
        if (obj == null) {
            returnValue = "null";
        } else {
            java.util.Date d = (java.util.Date) obj;
            returnValue = dbPolicy.formatTimestamp(new Timestamp(d.getTime()));
        }
        return returnValue;
    }

    // formatForSql(...)


    /**
     *  Encodess date column spec.
     *
     *@param  obj  <code>Date</code> object.
     *@return      encoded date.
     */
    public String encode(Object obj) {
        if (obj == null) {
            return "null";
        }
        Date d = (Date) obj;
        return new Timestamp(d.getTime()).toString();
    }


    /**
     *  This method goes with encode(). The String parameter must have been
     *  created by the encode() method.
     *
     *@param  aString  a value of type 'String'
     *@return          <code>Date</code> object
     */
    public Object decode(String aString) {
        if (aString.trim().equals("null")) {
            return null;
        }
        return new Date(Timestamp.valueOf(aString).getTime());
    }


    /**
     *  Gets the columnClass attribute of the DateColumnSpec object
     *
     *@return    The columnClass value
     */
    public Class getColumnClass() {
        return s_class;
    }


    /**
     *  Return the ANSI standard SQL column type.
     *
     *@param  dbPolicy  a value of type 'DatabasePolicy'
     *@return           a value of type 'String'
     */
    public String getSQLColumnType(DatabasePolicy dbPolicy) {
        return dbPolicy.timestampColumnType();
    }


    /**
     *  Returns a <code>Date</code> object enclosed as a integer value in the
     *  result set.
     *
     *@param  jrfResultSet      <code>JRFResultSet</code> encapsulating an
     *      active <code>java.sql.ResultSet</code>.
     *@return                   <code>Date</code> object enclosed as an integer
     *@exception  SQLException  if an error occurs
     */
    public Object getColumnValueFrom(JRFResultSet jrfResultSet)
             throws SQLException {
        Timestamp result = jrfResultSet.getTimestamp(this.getColumnIdx());
        return result == null ? null : new Date(result.getTime());
    }


    /**
     *@param  stmt              The new preparedColumnValueTo value
     *@param  value             The new preparedColumnValueTo value
     *@param  position          The new preparedColumnValueTo value
     *@exception  SQLException  Description of the Exception
     *@see                      net.sf.jrf.column.ColumnSpec#setPreparedColumnValueTo(JRFPreparedStatement,Object,int)
     */
    public void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
             throws SQLException {
        if (value != null) {
            java.util.Date d = (java.util.Date) value;
            if (d.equals(JRFConstants.CURRENT_DATE)) {
                value = new java.sql.Timestamp(new java.util.Date().getTime());
            } else {
                value = new java.sql.Timestamp(d.getTime());
            }
        }
        stmt.setTimestamp(value, position);
    }


    /**
     *  Description of the Method
     *
     *@return    Description of the Return Value
     */
    public JoinColumn buildJoinColumn() {
        return new DateJoinColumn(this.getColumnName(), this.getSetter());
    }

}
// DateColumnSpec



