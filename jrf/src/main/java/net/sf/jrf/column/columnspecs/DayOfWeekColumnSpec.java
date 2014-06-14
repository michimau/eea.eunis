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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;

import net.sf.jrf.column.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.*;
import net.sf.jrf.sql.*;
import org.apache.log4j.Category;
/**
 * A column specification for storing the day of week as a Locale-specific string in the database and
 * presenting the representation in Java space as an integer mapping to one of the <code>Calendar</code>
 * constants for day of week.  The storage mechanism in the database allows for simple usage in third-party
 * report writers.
 */
public class DayOfWeekColumnSpec extends TextColumnSpec
{

    final static Category LOG = Category.getInstance(DayOfWeekColumnSpec.class.getName());
    /* ===============  Static Variables  =============== */
    /** Simple data formatter using 'EEE' * */
    protected SimpleDateFormat formatter = createFormatter();

    /** Definition of a null Day of week value. * */
    public final static int NULLDAYOFWEEK = -99;

    protected final static Class s_class = java.lang.Integer.class;

    /** Date search default constructor. */
    public DayOfWeekColumnSpec() { }

    /**
     * Constructs a <code>DayOfWeekColumnSpec</code> with column options assuming
     * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
     *
     * @param columnName    column name.
     * @param columnOption  <code>ColumnOption</code> instance to use.
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  value to use for default if column value is null.
     */
    public DayOfWeekColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
        Object defaultValue)
    {
        super(columnName, columnOption, getter, setter, defaultValue);
    }

    /**
     * Constructs a <code>DayOfWeekColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
     *
     * @param columnName        column name.
     * @param columnOption      <code>ColumnOption</code> instance to use.
     * @param defaultValue      value to use for default if column value is null.
     * @param getterSetter      Description of the Parameter
     */
    public DayOfWeekColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue)
    {
        super(columnName, columnOption, getterSetter, defaultValue);
    }

    /**
     * Create formatter for day of week.
     *
     * @return   <code>SimpleDateFormat</code> instance to format DOW.
     */
    public static SimpleDateFormat createFormatter()
    {
        return new SimpleDateFormat("EEEEEEEEE");
    }

    private void setLength()
    {
        super.i_maxLength = 15;// Allow for localeSpecific sizes
    }

    /**
     * Returns the string representation of <code>Calendar.SUNDAY,Calendar.MONDAY</code> etc.
     *
     * @param obj       <code>Integer</code> object mapping to one of the seven <code>Calendar</code> constants for day of week.
     * @param dbPolicy  <code>DatabasePolicy</code> instance.
     * @return          string representation of <code>java.util.Date.getTime()</code>.
     */
    public String formatForSql(Object obj, DatabasePolicy dbPolicy)
    {
        String returnValue;
        if (obj == null)
        {
            returnValue = "null";
        }
        else
        {
            Integer i = (Integer) obj;
            if (i.intValue() == NULLDAYOFWEEK)
            {
                returnValue = "null";
            }
            else
            {
                try
                {
                    GregorianCalendar c = new GregorianCalendar();
                    c.set(Calendar.DAY_OF_WEEK, i.intValue());
                    returnValue = formatter.format(c.getTime());
                }
                catch (Exception p)
                {
                    throw new IllegalArgumentException(
                        "Illegal argument for formatForSql(DOW): " + p.getMessage());
                }
            }
        }
        return returnValue;
    }// formatForSql(...)


    /**
     * This method goes with encode().  The String parameter must have been
     * created by the encode() method.
     *
     * @param aString  a value of type 'String'
     * @return         <code>Date</code> object
     */
    public Object decode(String aString)
    {
        return (aString == null ? "null" : aString.toString());
    }


    /**
     * Gets the columnClass attribute of the DayOfWeekColumnSpec object
     *
     * @return   The columnClass value
     */
    public Class getColumnClass()
    {
        return s_class;
    }

    /**
     * Returns a <code>Date</code> object enclosed as a integer value in the result set.
     *
     * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
     * @return                  <code>Date</code> object enclosed as an integer
     * @exception SQLException  if an error occurs
     */
    public Object getColumnValueFrom(JRFResultSet jrfResultSet)
        throws SQLException
    {
        return getColumnValueFrom(formatter, jrfResultSet, this.getColumnIdx());
    }

    /**
     * Returns a <code>Date</code> object enclosed as a integer value in the result set.
     *
     * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
     * @param colIdx            column index.
     * @param formatter         Description of the Parameter
     * @return                  <code>Date</code> object enclosed as an integer. If underlying database value is <code>null</code>,
     * 	  <code>NULLDAYOFWEEK</code> will be returned.
     * @exception SQLException  if an error occurs
     * @see                     #NULLDAYOFWEEK
     */
    public static Object getColumnValueFrom(SimpleDateFormat formatter, JRFResultSet jrfResultSet, int colIdx)
        throws SQLException
    {
        String s = jrfResultSet.getString(colIdx);
        if (s == null)
        {
            return new Integer(NULLDAYOFWEEK);
        }
        try
        {
            GregorianCalendar c = new GregorianCalendar();
            c.setTime(formatter.parse(s));
            return new Integer(c.get(Calendar.DAY_OF_WEEK));
        }
        catch (Exception ex)
        {
            throw new SQLException("Unable to parse value in DOW value in database: " +
                ex.getMessage());
        }
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
        String s = formatForSql(value, null);
        if (s.equals("null"))
        {
            stmt.setString(null, position, super.i_sqlType, super.i_maxLength);
        }
        else
        {
            stmt.setString(s, position, super.i_sqlType, super.i_maxLength);
        }
    }


    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public JoinColumn buildJoinColumn()
    {
        return new DayOfWeekJoinColumn(this.getColumnName(), this.getSetter());
    }

}// DayOfWeekColumnSpec




