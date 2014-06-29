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
 * Portions created by VM Systems are Copyright (C) 2000 VM Systems, Inc.
 * All Rights Reserved.
 *
 * Contributor: James Evans (jevans@vmguys.com - VM Systems, Inc.)
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
package net.sf.jrf.dbpolicies;

import java.lang.reflect.Method;

import java.sql.*;
import java.util.List;

import net.sf.jrf.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;

import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;

import org.apache.log4j.Category;

/**
 *  DB2 supports both internal and external sequences.  Therefore, a this base class supports the common
 * methods and sub-classes exist for each sequence type.
 */
public abstract class DB2DatabasePolicyBase implements DatabasePolicy
{
    private final static Category LOG = Category.getInstance(DB2DatabasePolicyBase.class.getName());

    /**
     * @param sqlType    SQL numerical type.
     * @param precision  precision
     * @param scale      scale
     * @return           The numericColumnTypeDefinition value
     * @see              net.sf.jrf.DatabasePolicy#getNumericColumnTypeDefinition(int,int,int)
     */
    public String getNumericColumnTypeDefinition(int sqlType, int precision, int scale)
    {
        return DefaultImpls.getNumericColumnTypeDefinition(sqlType, precision, scale);
    }


    /**
     * @return   The primaryKeyQualifiers value
     * @see      net.sf.jrf.DatabasePolicy#getPrimaryKeyQualifiers() *
     */
    public String getPrimaryKeyQualifiers()
    {
        return "NOT NULL";
    }

    /**
     * This is the string value (function name) to put into the SQL to tell
     * the database to insert the current timestamp.
     *
     * @return   a value of type 'String'
     */
    public String timestampFunction()
    {
        return "CURRENT TIMESTAMP";
    }


    /**
     * The return value should be in the format that the database recognizes
     * for a timestamp.
     *
     * @param ts  a value of type 'Timestamp'
     * @return    a value of type 'String'
     */
    public String formatTimestamp(Timestamp ts)
    {
        return (ts == null ?
            "null" :
            "'" + ts.toString() + "'");
    }


    /**
     * The result of this is used in SQL.  This will return only the date
     *  (not the time portion)
     *
     * @param sqlDate  a value of type 'java.sql.Date'
     * @return         a value of type 'String'
     */
    public String formatDate(java.sql.Date sqlDate)
    {
        return (sqlDate == null ?
            "null" :
            "'" + sqlDate.toString() + "'");
    }


    /**
     * This should return the the SQL to use to have the database
     * return the current timestamp.
     *
     * @return   a value of type 'String'
     */
    public String currentTimestampSQL()
    {
        return "select CURRENT TIMESTAMP";
    }


    /**
     * Return a string with a name-value pair that represents an SQL outer
     * join in a WHERE clause for SQLServer and Sybase.  Given this operator
     * (*=), it looks like SQLServer always gives preference to the rows in
     * the table on the left whether it is a foreign key in the left table or
     * a foreign key in the right table.  This is what we want since we always
     * put the main table on the left.
     *
     * @param mainTableColumn  a value of type 'String'
     * @param joinTableColumn  a value of type 'String'
     * @return                 a value of type 'String'
     */
    public String outerWhereJoin(String mainTableColumn,
        String joinTableColumn)
    {
        return mainTableColumn + " left outer join " + joinTableColumn + " ";
    }


    /**
     * This method is used when building SQL to create tables.
     *
     * @return   a value of type 'String'
     */
    public String timestampColumnType()
    {
        return "TIMESTAMP";
    }

    /**
     * @see                        net.sf.jrf.DatabasePolicy#getTextColumnTypeDefinition(int,boolean,boolean,int)
     */
    public String getTextColumnTypeDefinition(int maxLength, boolean multiByteCharacters,
        boolean variable, int minBlockSize)
    {
        if (maxLength == 0)
        return "CLOB(50K)"; // Default to 50 K
    int type = getTextColumnSqlType(maxLength,multiByteCharacters,variable,minBlockSize);
    String sType = "VARCHAR";
    switch (type) {
        case java.sql.Types.CLOB:
                sType = "CLOB";
            break;
        case java.sql.Types.CHAR:
                sType = "CHAR";
            break;
        case java.sql.Types.LONGVARCHAR:
                sType = "LONG VARCHAR";
            break;
    }
        return sType+"(" + maxLength + ")";
    }

    /**
     * @see                        net.sf.jrf.DatabasePolicy#getTextColumnSqlType(int,boolean,boolean,int)
     */
    public int getTextColumnSqlType(int maxLength, boolean multiByteCharacters,
        boolean variable, int minBlockSize)
    {
        if (maxLength == 0 || maxLength > 32700)
        {
            return java.sql.Types.CLOB;
        }
        if (variable)
        {
            if (maxLength == 1)
            {
                return java.sql.Types.CHAR;
            }
            return java.sql.Types.LONGVARCHAR;
        }
    // Doesn't matter about non-variable if length is too big.
        return maxLength > 254 ? java.sql.Types.VARCHAR:java.sql.Types.CHAR;
    }

    /**
     * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnTypeDefinition(int,boolean,int) *
     */
    public String getBinaryColumnTypeDefinition(int maxLength,
        boolean variable, int minBlockSize)
    {
        return "BLOB(" + maxLength + ")";
    }

    /**
     * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnSqlType(int,boolean,int) *
     */
    public int getBinaryColumnSqlType(int maxLength, boolean variable, int minBlockSize)
    {
        return java.sql.Types.BLOB;
    }

    /**
     * @return   The duplicateKeyErrorCode value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorCode() *
     */
    public int getDuplicateKeyErrorCode()
    {
        return 1;   // FIXME
    }

    /**
     * @return   The duplicateKeyErrorText value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorText() *
     */
    public String getDuplicateKeyErrorText()
    {
        return "FFSDF";//FIXME
    }

    /**
     * @return   The duplicateKeyCheckType value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyCheckType() *
     */
    public int getDuplicateKeyCheckType()
    {
        return DatabasePolicy.DUPKEYCHECK_CODE;//???
    }

    /**
     * Returns "INTEGER"
     *
     * @return   The autoIncrementNumericColumnType value
     */
    public String getAutoIncrementNumericColumnType()
    {
        return "INTEGER";
    }

    /**
     * Gets the dateColumnType attribute of the DB2DatabasePolicy object
     *
     * @return   The dateColumnType value
     */
    public String getDateColumnType()
    {
        return "DATE";
    }

    /**
     * Gets the timeColumnType attribute of the DB2DatabasePolicy object
     *
     * @return   The timeColumnType value
     */
    public String getTimeColumnType()
    {
        return "TIME";
    }

    /**
     * @see                     net.sf.jrf.DatabasePolicy#initialize(StatementExecuter) *
     */
    public synchronized void initialize(StatementExecuter se)
        throws SQLException
    {
    }

    /**
     * @see             net.sf.jrf.DatabasePolicy#formatToUpper(String) *
     */
    public String formatToUpper(String argument)
    {
        return DefaultImpls.formatToUpper(argument);
    }

    /**
     * @see             net.sf.jrf.DatabasePolicy#formatToLower(String) *
     */
    public String formatToLower(String argument)
    {
        return DefaultImpls.formatToLower(argument);
    }

    /**
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLExpression(ForeignKey) *
     */
    public String getForeignKeySQLExpression(ForeignKey foreignKey)
    {
        return DefaultImpls.getForeignKeySQLExpression(foreignKey);
    }

    /**
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLStatement(ForeignKey) *
     */
    public String getForeignKeySQLStatement(ForeignKey foreignKey)
    {
        return DefaultImpls.getForeignKeySQLStatement(foreignKey);
    }

    /**
     * @return   Description of the Return Value
     * @see      net.sf.jrf.DatabasePolicy#foreignKeyExpressionsAllowedInCreateTable() *
     */
    public boolean foreignKeyExpressionsAllowedInCreateTable()
    {
        return true;
    }

    /**
     * @see                         net.sf.jrf.DatabasePolicy#getCreateIndexSQL(String,String,List,String) *
     */
    public String getCreateIndexSQL(String tableName, String indexType, List columns, String storageSpecification)
    {
        return "";
    }

    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public boolean padCHARStrings()
    {
        return false;
    }

    /**
     * Returns "NULL"
     *
     * @return   "NULL"
     */
    public String getNullableColumnQualifier()
    {
        return " NULL";
    }
}
