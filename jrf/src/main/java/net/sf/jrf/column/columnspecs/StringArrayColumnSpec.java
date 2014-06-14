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
 * Contributor: Alix Jermyn (alix.jermyn@usa.net)
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

import java.util.ArrayList;
import java.util.StringTokenizer;
import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.column.*;
import net.sf.jrf.domain.PersistentObject;

import net.sf.jrf.exceptions.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.StringArrayJoinColumn;
import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;

// JE Change 1
// Change in getSQLColumnType(DatabasePolicy dbPolicy)
// JE Change 2
// Initialize max length to 255

/**
 * Subclass of AbstractColumnSpec that handles arrays of strings.<p/>
 *
 * This Column Spec will take an array of Strings from a Persistent
 * Object and convert it to a comma delimited string back in the database.
 * Similarly, a commma delimited String in a database column will be
 * reconstituted back into an array of Strings.<p/>
 *
 * The default delimiter is a comma, but this can be dynamically reset.<p/>
 *
 * The underlying field in the PersistentObject will be an Array of Strings.
 * If this array is null, the corresponding column in the database will be
 * set to null.  Similarly, a null column in the database will reconstitute
 * itself as a null String[] object.<p/>
 *
 * However, a String[] of zero length will be saved as an empty String,
 * and an empty String will reconstitute itself as an zero length array.
 * Null objects in the String Array, or strings which are empty or contain
 * only spaces, will be ignored when being converted.
 */
public class StringArrayColumnSpec
     extends TextColumnSpec
{

    /* ===============  Static Variables  =============== */
    /** Description of the Field */
    public final static String EMPTY_STRING = "";
    /** Description of the Field */
    public final static String[] EMPTY_ARRAY = new String[0];
    /** Description of the Field */
    public final static String COMMA = ",";
    protected static Class s_class = String[].class;

    /* ===============  Instance Variables  =============== */
    protected String i_delimiter = COMMA;


    /* ===============  Constructors  =============== */
    /** Default constructor * */
    public StringArrayColumnSpec()
    {
        super();
    }

    /**
     * Constructs a <code>StringArrayColumnSpec</code> with column options assuming
     * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
     *
     * @param columnName    column name.
     * @param columnOption  <code>ColumnOption</code> instance to use.
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  value to use for default if column value is null.
     */
    public StringArrayColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
        Object defaultValue)
    {
        super(columnName, columnOption, getter, setter, defaultValue);
    }

    /**
     * Constructs a <code>StringArrayColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
     *
     * @param columnName        column name.
     * @param columnOption      <code>ColumnOption</code> instance to use.
     * @param defaultValue      value to use for default if column value is null.
     * @param getterSetter      Description of the Parameter
     */
    public StringArrayColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue)
    {
        super(columnName, columnOption, getterSetter, defaultValue);
    }


    /**
     * Constructs a <code>StringArrayColumnSpec</code> with three option values.
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
    public StringArrayColumnSpec(
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
     * Constructs a <code>StringArrayColumnSpec</code> with no option values supplied.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public StringArrayColumnSpec(
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
     * Constructs a <code>StringArrayColumnSpec</code> with one option value.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public StringArrayColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1)
    {
        this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            0,
            0);
    }

    /**
     * Constructs a <code>StringArrayColumnSpec</code> with two option values.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2       Description of the Parameter
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public StringArrayColumnSpec(
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
     * Constructs a <code>StringArrayColumnSpec</code> with three option values and a <code>GetterSetter</code> implementation.
     *
     * @param columnName        name of the column
     * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
     * @param defaultValue      default value when the return value from the "getter" is null.
     * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
     */
    public StringArrayColumnSpec(
        String columnName,
        GetterSetter getterSetterImpl,
        Object defaultValue,
        int option1,
        int option2,
        int option3)
    {
        super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

    }

    /**
     * Sets the delimiter used to delimit the String stored
     * in the database.<p/>
     *
     * The default delimiter is the comma, ",".
     *
     * @param delimiter  The new delimiter value
     */
    public void setDelimiter(String delimiter)
    {
        i_delimiter = delimiter;
    }

// ---------------------------------------------------- ArrayToDelimitedString


    /**
     * Takes an array of Strings and converts them into a single
     * delimited String.  If the array is empty, or contains only
     * null or empty objects an empty string is returned "".
     * If the Array is null, then a null String is returned.
     * External spaces are removed from each array item.
     * If an array object is null, empty or  constains only
     * white space, it is ignored.
     *
     * @param values     list of values to convert
     * @param delimiter  delimiter to user for parsing.
     * @return           a comma delimited (default) string, or null
     */
    protected static String arrayToDelimitedString(String[] values,
        String delimiter)
    {

        if (values == null)
        {
            return (String) null;
        }

        int length = values.length;
        if (length == 0)
        {
            return EMPTY_STRING;
        }

        // a typical lookup value is a 3 char string, so allowing for the
        // delimiters, the output string length should be about:
        StringBuffer sb = new StringBuffer(length * 4);
        String token = null;

        for (int i = 0; i < length; i++)
        {

            if (values[i] == null)
            {
                continue;
            }

            token = values[i].trim();

            if (EMPTY_STRING.equals(token))
            {
                continue;
            }

            if (sb.length() > 0)
            {
                sb.append(delimiter);
            }
            sb.append(token);
        }

        if (sb.length() > 0)
        {
            return sb.toString();
        }
        else
        {
            return EMPTY_STRING;
        }
    }// arrayToDelimitedString


//  ------------------------------------------------- ArrayFromDelimitedString
    /**
     * Takes a delimited string of values and
     * converts it into an array of string values.
     * If the original String is empty or null, a zero length Array is returned
     *
     * @param values     the String to convert to an Array of Strings
     * @param delimiter  delimiter to user for parsing.
     * @return           an Array of Strings (never null)
     * @see              #arrayToDelimitedString(String[],String)
     */
    public static String[] arrayFromDelimitedString(String values,
        String delimiter)
    {

        if (values == null)
        {
            return (String[]) null;
        }

        if (EMPTY_STRING.equals(values.trim()))
        {
            return EMPTY_ARRAY;
        }

        ArrayList list = new ArrayList();
        String token = null;
        StringTokenizer st = new StringTokenizer(values, String.valueOf(delimiter));

        while (st.hasMoreTokens())
        {
            token = st.nextToken().trim();
            if (EMPTY_STRING.equals(token))
            {
                continue;
            }
            list.add(token);
        }
        return (String[]) list.toArray(new String[list.size()]);
    }


    /**
     * This method overrides the superclass implementation.  A string of
     * "null" is returned if object is null, otherwise it returns a String
     * with quotes around it.  Internal single quotes are converted to two
     * single quotes and the string is wrapped in single quotes.
     *
     * @param obj           Description of the Parameter
     * @param dbPolicy      Description of the Parameter
     * @return              a value of type 'String'
     */
    public String formatForSql(Object obj, DatabasePolicy dbPolicy)
    {

        String returnValue = "null";
        if (obj != null)
        {
            returnValue =
                StringUtil.delimitString(
                StringArrayColumnSpec.arrayToDelimitedString((String[]) obj,
                i_delimiter),
                "'");
        }
        return returnValue;
    }// formatForSql(...)


    /**
     * Decodes an Array of Strings from an encoded String.<p/>
     *
     * Note that null String[] objects are encoded as the string "'null",
     * so this method does not work correctly for an Array of Strings
     * consisting of a single String with a value of "null"
     *
     * @param aString  a value of type 'String'
     * @return         a value of type 'Object' (This actually will be a String or null)
     */
    public Object decode(String aString)
    {
        if (aString.trim().equals("null"))
        {
            return null;
        }
        return StringArrayColumnSpec.arrayFromDelimitedString(aString, i_delimiter);
    }

    /**
     * Overidden method that matches with decode().<p/>
     *
     * Note that null String[] objects are encoded as the string "'null",
     * so this method does not work correctly for an Array of Strings
     * consisting of a single String with a value of "null".<p/>
     *
     * @param obj  the object (String[]) to encode to a String'
     * @return     an encoded string)
     */
    public String encode(Object obj)
    {
        return (obj == null ?
            "null" :
            StringArrayColumnSpec.arrayToDelimitedString((String[]) obj,
            i_delimiter));
    }


    /**
     * Gets the columnClass attribute of the StringArrayColumnSpec object
     *
     * @return   The columnClass value
     */
    public Class getColumnClass()
    {
        return s_class;
    }


    /**
     * Return a String[] from JDBCHelper.  Reconstitute an Array of Strings
     * from a delimited String.  The strange behaviour with SQLServer (and
     * maybe Sybase) that keeps returning empty or whitespace strings as one
     * blank character can be ignored, as any white spaced is trimmed out
     * before creating the array.
     *
     * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
     * @return                  a value of type 'Object'
     * @exception SQLException  if an error occurs in JDBCHelper
     */
    public Object getColumnValueFrom(JRFResultSet jrfResultSet)
        throws SQLException
    {
        String[] returnValue =
            StringArrayColumnSpec.arrayFromDelimitedString(
            jrfResultSet.getString(this.getColumnIdx()),
            i_delimiter);
        return returnValue;
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
        throws MissingAttributeException
    {
        String value = (String) super.validateRequired(aPO);
        // a null value tells us it had to be non-required or an error would
        // have been thrown.
        if (value != null &&
            value.trim().length() == 0)
        {
            throw new MissingAttributeException(
                "Required attribute - "
                + this.getColumnName()
                + "- is an empty string value.");
        }
        return value;
    }// validateRequired(aPersistentObject)


    // JE Change 1
    /**
     * Return the ANSI standard SQL column type.  This was written to support
     * the test suites.  If there is no standard that will work across
     * platforms, then we'll add a method to dbPolicy and return its value.
     *
     * @param dbPolicy  a value of type 'DatabasePolicy'
     * @return          a value of type 'String'
     */
    public String getSQLColumnType(DatabasePolicy dbPolicy)
    {
        return dbPolicy.getTextColumnTypeDefinition(i_maxLength, i_multibyte, i_variable, i_blockSize);
    }


    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public JoinColumn buildJoinColumn()
    {
        StringArrayJoinColumn joinColumn =
            new StringArrayJoinColumn(this.getColumnName(),
            this.getSetter());
        joinColumn.setDelimiter(i_delimiter);
        return joinColumn;
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
        stmt.setString(encode(value), position, super.i_sqlType);
    }

}// StringArrayColumnSpec
