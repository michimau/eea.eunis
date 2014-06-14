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
 *  This subclass of AbstractColumnSpec does Timestamp-specific things.
 *  This class should only be used for applications that generate
 *  the value to be inserted into the database. If an application
 *  wants to use the database vendor's system timestamp values,
 *  use the sub-class <code>TimestampColumnSpecDbGen</code>. <strong>
 *  DO NOT use this class for optimistic locks, use <code>TimestampColumnSpecDbGen</code>.
 *  </strong>.
 *  <p>
 *
 * @see   net.sf.jrf.column.columnspecs.SQLDateColumnSpec
 * @see   net.sf.jrf.column.columnspecs.SQLTimeColumnSpec
 */
public class TimestampColumnSpec
     extends AbstractColumnSpec
{

    final static Category LOG = Category.getInstance(TimestampColumnSpec.class.getName());
    /* ===============  Static Variables  =============== */

    protected static Class s_class = Timestamp.class;

    /** Default constructor * */
    public TimestampColumnSpec()
    {
        super();
    }

    /**
     * Constructs a <code>TimestampColumnSpec</code> with column options assuming
     * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
     *
     * @param columnName    column name.
     * @param columnOption  <code>ColumnOption</code> instance to use.
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  value to use for default if column value is null.
     */
    public TimestampColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
        Object defaultValue)
    {
        super(columnName, columnOption, getter, setter, defaultValue);
    }

    /**
     * Constructs a <code>TimestampColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
     *
     * @param columnName        column name.
     * @param columnOption      <code>ColumnOption</code> instance to use.
     * @param defaultValue      value to use for default if column value is null.
     * @param getterSetter      Description of the Parameter
     */
    public TimestampColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue)
    {
        super(columnName, columnOption, getterSetter, defaultValue);
    }


    /**
     * Constructs a <code>TimestampColumnSpec</code> with three option values.
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
    public TimestampColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1,
        int option2,
        int option3)
    {
        super(columnName, getter, setter, defaultValue, option1, option2, option3);
    }

    /**
     * Constructs a <code>TimestampColumnSpec</code> with no option values supplied.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public TimestampColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue)
    {
        super(columnName,
            getter,
            setter,
            defaultValue,
            0,
            0,
            0);
    }

    /**
     * Constructs a <code>TimestampColumnSpec</code> with one option value.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public TimestampColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1)
    {
        super(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            0,
            0);
    }

    /**
     * Constructs a <code>TimestampColumnSpec</code> with two option values.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2       Description of the Parameter
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public TimestampColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1,
        int option2)
    {
        this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            option2,
            0);
    }

    /**
     * Constructs a <code>TimestampColumnSpec</code> with three option values and a <code>GetterSetter</code> implementation.
     *
     * @param columnName        name of the column
     * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
     * @param defaultValue      default value when the return value from the "getter" is null.
     * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
     */
    public TimestampColumnSpec(
        String columnName,
        GetterSetter getterSetterImpl,
        Object defaultValue,
        int option1,
        int option2,
        int option3)
    {
        super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

    }

    /* ===============  Instance Methods  =============== */
    /**
     * Override of the superclass implementation.
     *
     * @param obj       a value of type 'Object'
     * @param dbPolicy  a value of type 'DatabasePolicy'
     * @return          a value of type 'String'
     */
    public String formatForSql(Object obj, DatabasePolicy dbPolicy)
    {
        String returnValue = "null";
        Timestamp ts = (Timestamp) obj;
        if (ts != null)
        {
            if (ts.equals(AbstractDomain.CURRENT_TIMESTAMP))
            {
                // Set the return value to now (SYSDATE, GETDATE(), etc...)
                returnValue = dbPolicy.timestampFunction();
            }
            else
            {
                returnValue = dbPolicy.formatTimestamp(ts);
                LOG.debug("formatForSql(): returnValue = dbPolicy.formatTimestamp(" + ts + ") = " + returnValue);
            }
        }
        return returnValue;
    }// formatForSql(...)


    /**
     * This method goes with encode().  The String parameter must have been
     * created by the encode() method.
     *
     * @param aString  a value of type 'String'
     * @return         a value of type 'Object' (This actually will be a Timestamp or
     *         null)
     */
    public Object decode(String aString)
    {
        if (aString.trim().equals("null"))
        {
            return null;
        }
        return Timestamp.valueOf(aString);
    }


    /**
     * Gets the columnClass attribute of the TimestampColumnSpec object
     *
     * @return   The columnClass value
     */
    public Class getColumnClass()
    {
        return s_class;
    }

    /**
     * Override of the superclass implementation.
     * This ensures we get a Timestamp (instead of a Date or something else)
     * from the JDBC driver.
     *
     * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
     * @return                  a value of type 'Object'
     * @exception SQLException  if an error occurs
     */
    public Object getColumnValueFrom(JRFResultSet jrfResultSet)
        throws SQLException
    {
        return jrfResultSet.getTimestamp(this.getColumnIdx());
    }


    /**
     * Return the ANSI standard SQL column type.  This is intended for
     * testing.
     *
     * @param dbPolicy  Description of the Parameter
     * @return          a value of type 'String'
     */
    public String getSQLColumnType(DatabasePolicy dbPolicy)
    {
        return dbPolicy.timestampColumnType();
    }

    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public Object optimisticLockDefaultValue()
    {
        throw new RuntimeException("Base timestampColumnSpec class does NOT support optimistic locks");
    }

    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public JoinColumn buildJoinColumn()
    {
        return new TimestampJoinColumn(this.getColumnName(), this.getSetter());
    }

    /**
     * @param stmt              The new preparedColumnValueTo value
     * @param value             The new preparedColumnValueTo value
     * @param position          The new preparedColumnValueTo value
     * @exception SQLException  Description of the Exception
     * @see                     net.sf.jrf.column.ColumnSpec#setPreparedColumnValueTo(JRFPreparedStatement,Object,int)
     */
    public void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
        throws SQLException
    {
        if (value != null)
        {
            Timestamp ts = (Timestamp) value;
            if (ts.equals(JRFConstants.CURRENT_TIMESTAMP))
            {
                value = new java.sql.Timestamp(new java.util.Date().getTime());
            }
        }
        stmt.setTimestamp(value, position);
    }

}// TimestampColumnSpec
