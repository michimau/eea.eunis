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

// VM Change 1
// Added new implicit key column method.
// VM Change 2
// Added SQL text column definition method.

/**
 *  Instances of this class perform InstantDB-specific logic and return
 *  InstantDB-specific information.
 */
public class InstantDBDatabasePolicy
     implements DatabasePolicy
{

    private final static Category LOG = Category.getInstance(InstantDBDatabasePolicy.class.getName());
    private Method getLastValueInsertedMethod;
    private String methodParams[] = new String[2];

    /**
     * Returns <code>SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT</code>.
     *
     * @return   <code>SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT</code>.
     * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT
     */
    public int getSequenceSupportType()
    {
        return DatabasePolicy.SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT;
    }

    /**
     * Returns <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE</code>.
     *
     * @return   <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE</code>.
     * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE
     */
    public int getSequenceFetchAfterInsertSupportType()
    {
        return net.sf.jrf.DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE;
    }

    //////////////////////////////////////////////////////////////////
    // SEQUENCE_SUPPORT_EXTERNAL - required methods -- not supported here.
    //////////////////////////////////////////////////////////////////
    /**
     * @param sequenceName  Description of the Parameter
     * @param tableName     Description of the Parameter
     * @return              Description of the Return Value
     * @see                 net.sf.jrf.DatabasePolicy#sequenceSQL(String,String)
     */
    public String sequenceSQL(String sequenceName, String tableName)
    {
        return null;
    }

    /**
     * @param sequenceName  Description of the Parameter
     * @param tableName     Description of the Parameter
     * @return              Description of the Return Value
     * @see                 net.sf.jrf.DatabasePolicy#sequenceNextValSQL(String,String) *
     */
    public String sequenceNextValSQL(String sequenceName, String tableName)
    {
        return "";
    }

    /**
     * @param domain            Description of the Parameter
     * @param stmtExecuter      Description of the Parameter
     * @exception SQLException  Description of the Exception
     * @see                     net.sf.jrf.DatabasePolicy#createSequence(AbstractDomain,StatementExecuter)
     * Not supported for InstantDB
     */
    public void createSequence(AbstractDomain domain, StatementExecuter stmtExecuter)
        throws SQLException
    {
    }

    /**
     * @param domain             Description of the Parameter
     * @param storageParameters  Description of the Parameter
     * @param stmtExecuter       Description of the Parameter
     * @exception SQLException   Description of the Exception
     * @see                      #createSequence(AbstractDomain,String,StatementExecuter)
     * Not supported for InstantDB
     */
    public void createSequence(AbstractDomain domain, String storageParameters, StatementExecuter stmtExecuter)
        throws SQLException
    {
    }

    /**
     * @param sequenceName        Description of the Parameter
     * @param sequenceParameters  Description of the Parameter
     * @return                    The createSequenceSQL value
     * @see                       net.sf.jrf.DatabasePolicy#getCreateSequenceSQL(String,String)
     * Not supported under Instant DB.
     */
    public String getCreateSequenceSQL(String sequenceName, String sequenceParameters)
    {
        return null;
    }

    //////////////////////////////////////////////////////////////////
    // SEQUENCE_SUPPORT_AUTOINCREMENT_.. - supported here.
    //////////////////////////////////////////////////////////////////

    /**
     *  Hypersonic uses auto-increment for assigning arbitrary primary key ids.
     *
     * @return   a value of type 'String'
     */
    public String autoIncrementIdentifier()
    {
        return "AUTO INCREMENT";
    }

    /**
     * @param sequenceName  Description of the Parameter
     * @param tableName     Description of the Parameter
     * @return              The findLastInsertedSequenceSql value
     * @see                 net.sf.jrf.DatabasePolicy#getFindLastInsertedSequenceSql(String,String) *
     */
    public String getFindLastInsertedSequenceSql(String sequenceName, String tableName)
    {
        return "";
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
        Long id = null;
        try
        {
            Connection c = getInstantDbPhysicalConnection(stmt);
            if (getLastValueInsertedMethod == null)
            {
                Class[] parmClasses = {String.class, String.class};
                getLastValueInsertedMethod = c.getClass().getMethod("getLastValueInserted", parmClasses);
            }
            methodParams[0] = tableName;
            methodParams[1] = columnName;
            Object obj = getLastValueInsertedMethod.invoke(c, methodParams);
            if (obj instanceof Integer)
            {
                Integer intID = (Integer) obj;
                id = new Long(intID.intValue());
            }
            else
            {// assume it's a Long

                id = (Long) obj;
            }
        }
        catch (Exception e)
        {
            LOG.error(
                "Reflection error in "
                + "InstantDBDatabasePolicy#findAutoIncrementId(...)",
                e);
            throw new ConfigurationException(e.fillInStackTrace().toString());
        }
        return id;
    }

    /**
     * Fetches the physical InstantDB connection.  <code>DataSource</code> implementations
     * wrap the <code>Connection</code> class so sub-classe will need to override this
     * method to get <code>findAutoIncrementByMethodInvoke</code> to work.  Putatively,
     * the method <code>java.sql.PooledConnection.getConnection()</code> should return the physical
     * connection so this base version attempts to get the physical connection by
     * casting the <code>Connection</code> handle to <code>javax.sql.PooledConnection</code>.
     *
     * @param stmt           Description of the Parameter
     * @return               the actual InstantDB physical connection, not a <code>DataSource</code>
     * wrapper.
     * @see                  #findAutoIncrementIdByMethodInvoke(String,String,Statement)
     * @throws SQLException  if a database access error occurs.
     */
    protected Connection getInstantDbPhysicalConnection(Statement stmt)
        throws SQLException
    {
        Connection conn = stmt.getConnection();
        if (conn instanceof javax.sql.PooledConnection)
        {
            javax.sql.PooledConnection pc = (javax.sql.PooledConnection) conn;
            return pc.getConnection();
        }
        LOG.info("getInstantDbPhysicalConnection(): unable to cast connection handle to PooledConnection: " + conn);
        return conn;
    }
    // END SEQUENCE METHODS

    /**
     * @param sqlType    Description of the Parameter
     * @param precision  Description of the Parameter
     * @param scale      Description of the Parameter
     * @return           The numericColumnTypeDefinition value
     * @see              net.sf.jrf.DatabasePolicy#getNumericColumnTypeDefinition(int,int,int) *
     */
    public String getNumericColumnTypeDefinition(int sqlType, int precision, int scale)
    {
        return DefaultImpls.getNumericColumnTypeDefinition(sqlType, precision, scale);//TODO implement here.
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
        return "NOW";
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
        return "'" + ts.toString() + "'";
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
        return "SELECT sysdate = NOW";
    }


    /**
     * Outer WHERE joins are not supported in InstantDB, so this just returns
     * a normal join.
     *
     * @param mainTableColumn  a value of type 'String'
     * @param joinTableColumn  a value of type 'String'
     * @return                 a value of type 'String'
     */
    public String outerWhereJoin(String mainTableColumn,
        String joinTableColumn)
    {
        return mainTableColumn + "=" + joinTableColumn + " ";
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

    // VM Change 1
    /**
     * Returns <code>false</code>
     *
     * @return   <code>false</code>
     */
    public boolean hasImplicitAutoIncrementColumns()
    {
        return false;
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
        return "VARCHAR(" + maxLength + ")";// TODO Fix me.
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
        if (maxLength == 0 || maxLength > 255)
        {// TODO: Fix me.
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
        return "BINARY(" + maxLength + ")";// TODO: Fix me.
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
        return -1;// ???
    }


    /**
     * @return   The duplicateKeyErrorText value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorText() *
     */
    public String getDuplicateKeyErrorText()
    {
        return "FSDFSDF";// TODO
    }

    /**
     * @return   The duplicateKeyCheckType value
     * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyCheckType() *
     */
    public int getDuplicateKeyCheckType()
    {
        return DatabasePolicy.DUPKEYCHECK_TEXT;//???
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
     * Gets the dateColumnType attribute of the InstantDBDatabasePolicy object
     *
     * @return   The dateColumnType value
     */
    public String getDateColumnType()
    {
        return "DATE";
    }

    /**
     * Gets the timeColumnType attribute of the InstantDBDatabasePolicy object
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
        return "";// TODO
    }

    /**
     * @param foreignKey  Description of the Parameter
     * @return            The foreignKeySQLStatement value
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLStatement(ForeignKey) *
     */
    public String getForeignKeySQLStatement(ForeignKey foreignKey)
    {
        return "";// TODO
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

}// InstantDBDatabasePolicy


