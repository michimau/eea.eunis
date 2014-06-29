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
 * Contributor: Tal (tal@nbase.co.il)
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

import java.sql.*;
import java.util.List;

import net.sf.jrf.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;
// VM Change 1
// Added new implicit key column method.
// VM Change 2
// Added SQL text column definition method.
import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;
import org.apache.log4j.Category;

/**
 *  Instances of this class perform PostgreSQL-specific logic and return
 *  PostgreSQL-specific information.
 */
public class PostgreSQLDatabasePolicy
     implements DatabasePolicy
{
    private static Category LOG = Category.getInstance(PostgreSQLDatabasePolicy.class.getName());
    private final static String TEXT = "TEXT";
    private final static String CHAR = "CHAR";

    // BEGIN SEQUENCE METHODS

    /**
     * Returns <code>SEQUENCE_SUPPORT_EXTERNAL</code>.
     *
     * @return   <code>SEQUENCE_SUPPORT_EXTERNAL</code>.
     * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_SUPPORT_EXTERNAL
     */
    public int getSequenceSupportType()
    {
        return DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL;
    }

    /**
     * Returns <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
     *
     * @return   <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
     * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY
     */
    public int getSequenceFetchAfterInsertSupportType()
    {
        return net.sf.jrf.DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY;
    }

    //////////////////////////////////////////////////////////////////
    // SEQUENCE_SUPPORT_EXTERNAL - required methods -- supported here.
    //////////////////////////////////////////////////////////////////
    /**
     * @param sequenceName  Description of the Parameter
     * @param tableName     Description of the Parameter
     * @return              Description of the Return Value
     * @see                 net.sf.jrf.DatabasePolicy#sequenceSQL(String,String)
     */
    public String sequenceSQL(String sequenceName, String tableName)
    {
        return "SELECT " + sequenceNextValSQL(sequenceName, tableName);
    }

    /**
     * @param sequenceName  Description of the Parameter
     * @param tableName     Description of the Parameter
     * @return              Description of the Return Value
     * @see                 net.sf.jrf.DatabasePolicy#sequenceNextValSQL(String,String) *
     */
    public String sequenceNextValSQL(String sequenceName, String tableName)
    {
        return "NEXTVAL('" + sequenceName + "')";
    }

    /**
     * @param domain            Description of the Parameter
     * @param stmtExecuter      Description of the Parameter
     * @exception SQLException  Description of the Exception
     * @see                     net.sf.jrf.DatabasePolicy#createSequence(AbstractDomain,StatementExecuter)
     */
    public void createSequence(AbstractDomain domain, StatementExecuter stmtExecuter)
        throws SQLException
    {
        createSequence(domain, " INCREMENT 1 START 1", stmtExecuter);
    }

    /**
     * @param sequenceName        Description of the Parameter
     * @param sequenceParameters  Description of the Parameter
     * @return                    The createSequenceSQL value
     * @see                       net.sf.jrf.DatabasePolicy#getCreateSequenceSQL(String,String)
     */
    public String getCreateSequenceSQL(String sequenceName, String sequenceParameters)
    {
        if (sequenceParameters == null)
        {
            return "CREATE SEQUENCE " + sequenceName;
        }
        return "CREATE SEQUENCE " + sequenceName + " " + sequenceParameters;
    }

    /**
     * @param domain              Description of the Parameter
     * @param sequenceParameters  Description of the Parameter
     * @param stmtExecuter        Description of the Parameter
     * @exception SQLException    Description of the Exception
     * @see                       #createSequence(AbstractDomain,String,StatementExecuter) *
     */
    public void createSequence(AbstractDomain domain, String sequenceParameters, StatementExecuter stmtExecuter)
        throws SQLException
    {
        try
        {
            try {
                stmtExecuter.executeUpdate("DROP SEQUENCE " + domain.getSequenceName());
            }
            catch (SQLException ex) {
                LOG.debug("Sequence does not exist: [" +domain.getSequenceName()+"]. Rolling back connection.");
                stmtExecuter.getConnection().rollback();
            }
            if (sequenceParameters == null) {
                sequenceParameters = "";
            }
            stmtExecuter.executeUpdate(
                "CREATE SEQUENCE " + domain.getSequenceName() + " " + sequenceParameters);
        }
        catch (SQLException e) {
        LOG.error("Postgres SQL sequence create error.",e);
            throw e;
        }
        catch (Exception e)
        {
            throw new DatabaseException(e);
        }
    }

    /**
     * No support here.
     *
     * @return   blank string.
     */
    public String autoIncrementIdentifier()
    {
        return "";
    }

    /**
     * @param sequenceName  Description of the Parameter
     * @param tableName     Description of the Parameter
     * @return              The findLastInsertedSequenceSql value
     * @see                 net.sf.jrf.DatabasePolicy#getFindLastInsertedSequenceSql(String,String) *
     */
    public String getFindLastInsertedSequenceSql(String sequenceName, String tableName)
    {
        return "SELECT CURRVAL('" + sequenceName + "')";
    }

    /**
     * @param tableName   Description of the Parameter
     * @param columnName  Description of the Parameter
     * @param stmt        Description of the Parameter
     * @return            Description of the Return Value
     * @see               net.sf.jrf.DatabasePolicy#findAutoIncrementIdByMethodInvoke(String,String,Statement) *
     */
    public Long findAutoIncrementIdByMethodInvoke(String tableName, String columnName, Statement stmt)
    {
        return null;
    }

    /**
     * @param sqlType    Description of the Parameter
     * @param precision  Description of the Parameter
     * @param scale      Description of the Parameter
     * @return           The numericColumnTypeDefinition value
     * @see              net.sf.jrf.DatabasePolicy#getNumericColumnTypeDefinition(int,int,int) *
     */
    public String getNumericColumnTypeDefinition(int sqlType, int precision, int scale)
    {

        switch (sqlType)
        {
            case java.sql.Types.DOUBLE:
                return "FLOAT8";
            case java.sql.Types.FLOAT:
                return "FLOAT4";
            default:
            return DefaultImpls.getNumericColumnTypeDefinition(sqlType, precision, scale);
        }
    }

    /**
     * This should return the string value (function name) to put into the SQL
     * to tell the database to insert the current timestamp.
     *
     * @return   a value of type 'String'
     */
    public String timestampFunction()
    {
        return "timestamp(timestamp 'now')";
    }


    /**
     * The result of this is used in SQL.
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
     * @return   The primaryKeyQualifiers value
     * @see      net.sf.jrf.DatabasePolicy#getPrimaryKeyQualifiers() *
     */
    public String getPrimaryKeyQualifiers()
    {
        return "NOT NULL";
    }

    /**
     * The result of this is used in SQL.  This will return only the date
     * (not the time portion)
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
        return "select now()";
    }


    /**
     * Return a string with a name-value pair that represents an SQL outer
     * join in PostgreSQL.  Since we always put the main table on the left, we put
     * the (+) after the right side so that any extra null rows will be
     * generated for the right-hand table.
     *
     * @param mainTableColumn  a value of type 'String'
     * @param joinTableColumn  a value of type 'String'
     * @return                 a value of type 'String'
     */
    public String outerWhereJoin(String mainTableColumn,
        String joinTableColumn)
    {
        return mainTableColumn + " = " + joinTableColumn + " ";
    }

    /**
     * This method used when building SQL for creating a table.
     *
     * @return   a value of type 'String'
     */
    public String timestampColumnType()
    {
        return "TIMESTAMP";
    }


    /**
     * @param maxLength            Description of the Parameter
     * @param multiByteCharacters  Description of the Parameter
     * @param variable             Description of the Parameter
     * @param minBlockSize         Description of the Parameter
     * @return                     The textColumnTypeDefinition value
     * @see                        net.sf.jrf.DatabasePolicy#getTextColumnTypeDefinition(int,boolean,boolean,int)
     */
    public String getTextColumnTypeDefinition(int maxLength, boolean multiByteCharacters,
        boolean variable, int minBlockSize)
    {
        if (maxLength <= 0 || maxLength > 255)
        {
            return TEXT;
        }
        String n = (multiByteCharacters ? "N" : "");
        String v = (variable ? "VAR" : "");
        if (maxLength == 1)
        {
            return n + CHAR + "(1)";
        }
        return v + n + CHAR + "(" + maxLength + ")";
    }

    /**
     * @param maxLength            Description of the Parameter
     * @param multiByteCharacters  Description of the Parameter
     * @param variable             Description of the Parameter
     * @param minBlockSize         Description of the Parameter
     * @return                     The textColumnSqlType value
     * @see                        net.sf.jrf.DatabasePolicy#getTextColumnSqlType(int,boolean,boolean,int)
     */
    public int getTextColumnSqlType(int maxLength, boolean multiByteCharacters,
        boolean variable, int minBlockSize)
    {

        if (maxLength <= 0 || maxLength > 255)
        {
            return java.sql.Types.LONGVARCHAR;
        }
        if (variable)
        {
            if (maxLength == 1)
            {
                return java.sql.Types.CHAR;
            }
            return java.sql.Types.VARCHAR;
        }
        return java.sql.Types.CHAR;
    }

    /**
     * @param maxLength     Description of the Parameter
     * @param variable      Description of the Parameter
     * @param minBlockSize  Description of the Parameter
     * @return              The binaryColumnTypeDefinition value
     * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnTypeDefinition(int,boolean,int) *
     */
    public String getBinaryColumnTypeDefinition(int maxLength,
        boolean variable, int minBlockSize)
    {
        return TEXT;// TODO: Fix me.
    }

    /**
     * @param maxLength     Description of the Parameter
     * @param variable      Description of the Parameter
     * @param minBlockSize  Description of the Parameter
     * @return              The binaryColumnSqlType value
     * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnSqlType(int,boolean,int) *
     */
    public int getBinaryColumnSqlType(int maxLength, boolean variable, int minBlockSize)
    {
        return variable ? java.sql.Types.VARBINARY : java.sql.Types.BINARY;//TODO: Fix me
    }

    /**
     * @return   The duplicateKeyErrorCode value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorCode() *
     */
    public int getDuplicateKeyErrorCode()
    {
        return -22;
    }

    /**
     * @return   The duplicateKeyErrorText value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorText() *
     */
    public String getDuplicateKeyErrorText()
    {
        return "Cannot insert a duplicate key into unique index";
    }

    /**
     * @return   The duplicateKeyCheckType value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyCheckType() *
     */
    public int getDuplicateKeyCheckType()
    {
        return DatabasePolicy.DUPKEYCHECK_TEXT;//
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
     * Gets the dateColumnType attribute of the PostgreSQLDatabasePolicy object
     *
     * @return   The dateColumnType value
     */
    public String getDateColumnType()
    {
        return "DATE";
    }

    /**
     * Gets the timeColumnType attribute of the PostgreSQLDatabasePolicy object
     *
     * @return   The timeColumnType value
     */
    public String getTimeColumnType()
    {
        return "TIME";
    }

    /**
     * @param stmtExecuter      Description of the Parameter
     * @exception SQLException  Description of the Exception
     * @see                     net.sf.jrf.DatabasePolicy#initialize(StatementExecuter) *
     */
    public synchronized void initialize(StatementExecuter stmtExecuter)
        throws SQLException
    {
    }

    /**
     * @param argument  Description of the Parameter
     * @return          Description of the Return Value
     * @see             net.sf.jrf.DatabasePolicy#formatToUpper(String) *
     */
    public String formatToUpper(String argument)
    {
        return DefaultImpls.formatToUpper(argument);
    }

    /**
     * @param argument  Description of the Parameter
     * @return          Description of the Return Value
     * @see             net.sf.jrf.DatabasePolicy#formatToLower(String) *
     */
    public String formatToLower(String argument)
    {
        return DefaultImpls.formatToLower(argument);
    }

    /**
     * @param foreignKey  Description of the Parameter
     * @return            The foreignKeySQLExpression value
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLExpression(ForeignKey) *
     */
    public String getForeignKeySQLExpression(ForeignKey foreignKey)
    {
        if (foreignKey.getAdditionalInfo() == null)
        {
            return DefaultImpls.getForeignKeySQLExpression(foreignKey);
        }
        return DefaultImpls.getForeignKeySQLExpression(foreignKey) + " " + foreignKey.getAdditionalInfo();
    }

    /**
     * @param foreignKey  Description of the Parameter
     * @return            The foreignKeySQLStatement value
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLStatement(ForeignKey) *
     */
    public String getForeignKeySQLStatement(ForeignKey foreignKey)
    {
        if (foreignKey.getAdditionalInfo() == null)
        {
            return DefaultImpls.getForeignKeySQLStatement(foreignKey);
        }
        return DefaultImpls.getForeignKeySQLStatement(foreignKey) + " " + foreignKey.getAdditionalInfo();
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
     * @param tableName             Description of the Parameter
     * @param indexType             Description of the Parameter
     * @param columns               Description of the Parameter
     * @param storageSpecification  Description of the Parameter
     * @return                      The createIndexSQL value
     * @see                         net.sf.jrf.DatabasePolicy#getCreateIndexSQL(String,String,List,String) *
     */
    public String getCreateIndexSQL(String tableName, String indexType, List columns, String storageSpecification)
    {
        return "";// TODO
    }

    /**
     * @return   Description of the Return Value
     * @see      net.sf.jrf.DatabasePolicy#padCHARStrings() *
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

}// PostgreSQLDatabasePolicy

