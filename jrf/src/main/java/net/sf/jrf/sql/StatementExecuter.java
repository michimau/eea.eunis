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
 *  The Initial Developer of the Original Code is is.com (bought by wamnet.com).
 *  Portions created by is.com are Copyright (C) 2000 is.com.
 *  All Rights Reserved.
 *
 *  Contributor: James Evans (jevans@vmguys.com)
 *  Contributor: _____________________________________
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
package net.sf.jrf.sql;

import net.sf.jrf.exceptions.*;
import java.math.BigDecimal;
import java.sql.*;
import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.*;
import java.util.List;
import java.util.Properties;
import java.util.Vector;
import java.util.Hashtable;
import java.util.Enumeration;

import net.sf.jrf.JRFProperties;

import org.apache.log4j.Category;

/**
 *  A statement-executor utility. Users of this class may execute SQL statements
 *  and process result sets. Also provided are a suite of single row, single
 *  column wrapping methods over <code>executeQuery</code> that will obtain a
 *  single <code>Object</code> result. <p>
 *
 *  No access to underlying connection is provided. An instance of this class
 *  may only be obtained from a <code>JRFConnection</code> instance.
 *
 *@author     jevans
 *@created    June 13, 2002
 *@see        net.sf.jrf.sql.JRFConnection
 *@see        net.sf.jrf.sql.JRFResultSet
 */
public class StatementExecuter {
    /**
     *  log4j category for debugging and errors
     */
    private final static Category LOG = Category.getInstance(StatementExecuter.class.getName());
    private final static Category SQLLOG = Category.getInstance(StatementExecuter.class.getName() + ".sql");

    private Statement i_staticSQLstatement = null;
    // For re-use under some platforms ? -- not currently used.
    private JRFConnection i_jrfConnection = null;
    // Connection handle.
    private DataSourceProperties dataSourceProperties = null;
    // Property handle.
    private SQLWarning staticSqlMostRecentWarnings = null;


    ///////////////////////////////////////////////////////////
    // Constructor and close() called ONLY by JRFConnection.
    ///////////////////////////////////////////////////////////
    /**
     *  Constructor for the StatementExecuter object
     *
     *@param  connection            Description of the Parameter
     *@param  dataSourceProperties  Description of the Parameter
     */
    StatementExecuter(JRFConnection connection, DataSourceProperties dataSourceProperties) {
        i_jrfConnection = connection;
        this.dataSourceProperties = dataSourceProperties;
    }


    /** Fetches the underlying <code>JRFConnection</code> handle.
     * @return <code>JRFConnection</code> handle. 
     */
    public JRFConnection getConnection()  {
	return i_jrfConnection; 
    }

    /**
     *  Sets the upForStaticStatementExecute attribute of the StatementExecuter
     *  object
     *
     *@param  forQuery          The new upForStaticStatementExecute value
     *@return                   Description of the Return Value
     *@exception  SQLException  Description of the Exception
     */
    private Statement setUpForStaticStatementExecute(boolean forQuery) throws SQLException {
        i_jrfConnection.assureDatabaseConnection();
        return i_jrfConnection.createStatement(forQuery);
    }


    /**
     *  Execute the SQL string. The native sql of the query is logged. It is up
     *  to the user to make sure this gets closed appropriately.
     *
     *@param  sqlString      a value of type 'String'
     *@return                a <code>JRFResultSet</code> instance with the data.
     *@throws  SQLException  if a database access error occurs.
     */
    public JRFResultSet executeQuery(String sqlString) throws SQLException {
        Statement stmt = setUpForStaticStatementExecute(true);
        if (SQLLOG.isDebugEnabled()) {
            // log the SQL
            SQLLOG.debug("executeQuery([" + sqlString + "])" + this);
        }
        i_jrfConnection.statementExecutionCount++;
        JRFResultSet result = new JRFResultSet(stmt.executeQuery(sqlString), dataSourceProperties);
        staticSqlMostRecentWarnings = stmt.getWarnings();
        return result;
    }


    /**
     *  Executes a prepared statement.
     *
     *@param  stmt           prepared statement to execute. All IN parameter
     *      values must have been set.
     *@return                a <code>JRFResultSet</code> instance with the data.
     *@throws  SQLException  if an error occurs
     */
    public JRFResultSet executeQuery(PreparedStatement stmt) throws SQLException {
        return executeQuery(stmt, null);
    }


    /**
     *  Returns <code>SQLWarnings</code> from the most recently executed static
     *  SQL statement.
     *
     *@return    last <code>SQLWarnings</code> issued from calls to either
     *      <code>executeQuery(String)</code> or <code>executeUpdate(String</code>
     *      .
     */
    public SQLWarning getStaticSqlWarnings() {
        return staticSqlMostRecentWarnings;
    }


    /**
     *  Executes a prepared statement.
     *
     *@param  stmt           a <code>JRFPreparedStatement</code> instance. must
     *      have been set.
     *@return                a <code>JRFResultSet</code> instance with the data.
     *@throws  SQLException  if an error occurs
     */
    public JRFResultSet executeQuery(JRFPreparedStatement stmt) throws SQLException {
        return executeQuery(stmt.preparedStatement, stmt.sql);
    }


    /**
     *  Description of the Method
     *
     *@param  stmt              Description of the Parameter
     *@param  sql               Description of the Parameter
     *@return                   Description of the Return Value
     *@exception  SQLException  Description of the Exception
     */
    private JRFResultSet executeQuery(PreparedStatement stmt, String sql) throws SQLException {
        i_jrfConnection.assureDatabaseConnection();
        stmt.setMaxRows(i_jrfConnection.maxRows);
        if (SQLLOG.isDebugEnabled()) {
           SQLLOG.debug("executeQuery( Prepared[" + stmt + "] ("+sql+")" + this);
        }
        i_jrfConnection.statementExecutionCount++;
        return new JRFResultSet(stmt.executeQuery(), dataSourceProperties);
    }


    /**
     *  Execute an update/insert/delete.
     *
     *@param  sqlString         SQL statement to execute. <b>DO NOT use this
     *      method to issue create and drop table statements!</b> .
     *@return                   number of rows updated.
     *@exception  SQLException  if an error occurs
     */
    public int executeUpdate(String sqlString) throws SQLException {
        Statement stmt = setUpForStaticStatementExecute(false);
	/*
        if (SQLLOG.isDebugEnabled()) {
            // log the SQL
            SQLLOG.debug("executeUpdate([" + sqlString + "])" + this);
        }
	*/
        i_jrfConnection.statementExecutionCount++;
        int result = stmt.executeUpdate(sqlString);
        if (SQLLOG.isDebugEnabled()) {
            SQLLOG.debug("executeUpdate([" + sqlString + "]) returned " + result);
	}
        staticSqlMostRecentWarnings = stmt.getWarnings();
        return result;
    }


    /**
     *  Execute an update/insert/delete on a PreparedStatement
     *
     *@param  stmt           a <code>PreparedStatement</code> instance.
     *@return                either the row count for INSERT, UPDATE or DELETE
     *      statements; or 0 for SQL statements that return nothing <b>DO NOT
     *      use this method to issue create and drop table statements.</b> .
     *@throws  SQLException  if an error occurs.
     *@see                   #executeCreateOrDropTableSQL(String)
     */
    public int executeUpdate(PreparedStatement stmt) throws SQLException {
        return executeUpdate(stmt, null);
    }


    /**
     *  Execute an update/insert/delete on a PreparedStatement
     *
     *@param  stmt           a <code>JRFPreparedStatement</code> instance.
     *@return                either the row count for INSERT, UPDATE or DELETE
     *      statements; or 0 for SQL statements that return nothing <b>DO NOT
     *      use this method to issue create and drop table statements.</b> .
     *@throws  SQLException  if an error occurs.
     *@see                   #executeCreateOrDropTableSQL(String)
     */
    public int executeUpdate(JRFPreparedStatement stmt) throws SQLException {
        return executeUpdate(stmt.preparedStatement, stmt.sql);
    }


    /**
     *  Description of the Method
     *
     *@param  stmt              Description of the Parameter
     *@param  sql               Description of the Parameter
     *@return                   Description of the Return Value
     *@exception  SQLException  Description of the Exception
     */
    private int executeUpdate(PreparedStatement stmt, String sql) throws SQLException {
        i_jrfConnection.assureDatabaseConnection();
        if (SQLLOG.isDebugEnabled()) {
            SQLLOG.debug("executeUpdate(PreparedStatement[\n" + stmt + "\n[("+sql+")])" + this);
        }
        i_jrfConnection.statementExecutionCount++;
        return stmt.executeUpdate();
    }


    /**
     *  Executes a create or drop table statement, Creates a table, correctly
     *  handling auto-commit feature on JDBC. For databases or vendors that do
     *  not support auto-commit for drop and create, an attempt to issue a SQL
     *  drop or create statement with auto-commit set to true may result in a
     *  hang.
     *
     *@param  sqlStatement   syntactically correct SQL create or drop table
     *      statement.
     *@throws  SQLException  if an execution error occurs.
     *@see                   net.sf.jrf.sql.DataSourceProperties#isTransactionsForDropAndCreateSupported()
     */
    public void executeCreateOrDropTableSQL(String sqlStatement) throws SQLException {
	///////////////////////////////////////////////////////////////////
        // Determine whether transactions are supported. If they are not,
        // turn on auto-commit mode before you execute the statements and
        // restore state when complete.
	///////////////////////////////////////////////////////////////////
        if (SQLLOG.isDebugEnabled()) {
            SQLLOG.debug("executeCreateOrDropTableSQL(" + sqlStatement + ")");
        }

        i_jrfConnection.assureDatabaseConnection();
        boolean closeConnectionUponCompletion = false;
        Statement stmt = null;
        if (!i_jrfConnection.getDataSourceProperties().isTransactionsForDropAndCreateSupported()) {
            LOG.debug("Opening an auto-commit connection to do the job for " + sqlStatement + "");
            i_jrfConnection.close();
            i_jrfConnection.assureAutoCommitConnection();
            closeConnectionUponCompletion = true;
        }
        stmt = setUpForStaticStatementExecute(false);
        try {
            stmt.executeUpdate(sqlStatement);
            i_jrfConnection.statementExecutionCount++;
        } catch (SQLException e) {
            throw e;
        } finally {
            if (closeConnectionUponCompletion) {
                i_jrfConnection.close();
            }
        }
    }


    /**
     *  Description of the Method
     *
     *@param  sql               Description of the Parameter
     *@return                   Description of the Return Value
     *@throws  SQLException  if an execution error occurs.
     */
    private JRFResultSet initSingleRowColumnFetchStatic(String sql) throws SQLException {
        if (SQLLOG.isDebugEnabled()) {
            SQLLOG.debug("Executing static SQL for single row/column fetch: [" + sql + "]");
        }
        JRFResultSet r = this.executeQuery(sql);
        r.next();
        return r;
    }


    /**
     *  Description of the Method
     *
     *@param  stmt              Description of the Parameter
     *@return                   Description of the Return Value
     *@throws  SQLException  if an execution error occurs.
     */
    private JRFResultSet initSingleRowColumnFetchPrepared(JRFPreparedStatement stmt) throws SQLException {
        JRFResultSet r = this.executeQuery(stmt.preparedStatement, stmt.sql);
        r.next();
        return r;
    }


    ////////////////// STRING ////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  r                 Description of the Parameter
     *@return                   Description of the Return Value
     *@exception  SQLException  Description of the Exception
     */
    private String procSingleStringResult(JRFResultSet r) throws SQLException {
        String result = r.getString(1);
        r.close();
        return result;
    }


    /**
     *  Fetches a single column, single row query as a <code>String</code>.
     *
     *@param  sql               SQL select statement.
     *@return                   String single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public String getSingleRowColAsString(String sql) throws SQLException {
        return procSingleStringResult(initSingleRowColumnFetchStatic(sql));
    }


    /**
     *  Fetches a single column, single row query as a <code>String</code>.
     *
     *@param  stmt              <code>JRFPreparedStatement</code> instance.
     *@return                   String single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public String getSingleRowColAsString(JRFPreparedStatement stmt) throws SQLException {
        return procSingleStringResult(initSingleRowColumnFetchPrepared(stmt));
    }


    ////////////////// Long ////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  r                 Description of the Parameter
     *@return                   Description of the Return Value
     *@throws  SQLException  if an execution error occurs.
     */
    private Long procSingleLongResult(JRFResultSet r) throws SQLException {
        Long result = r.getLong(1);
        r.close();
        return result;
    }


    /**
     *  Fetches a single column, single row query as a <code>Long</code>.
     *
     *@param  sql               SQL select statement.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public Long getSingleRowColAsLong(String sql) throws SQLException {
        return procSingleLongResult(initSingleRowColumnFetchStatic(sql));
    }


    /**
     *  Fetches a single column, single row query as a <code>Long</code>.
     *
     *@param  stmt              <code>JRFPreparedStatement</code> instance.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public Long getSingleRowColAsLong(JRFPreparedStatement stmt) throws SQLException {
        return procSingleLongResult(initSingleRowColumnFetchPrepared(stmt));
    }


    ////////////////// Long ////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  r                 Description of the Parameter
     *@return                   Description of the Return Value
     *@throws  SQLException  if an execution error occurs.
     */
    private long procSinglelongResult(JRFResultSet r) throws SQLException {
        long result = r.getlong(1);
        r.close();
        return result;
    }


    /**
     *  Fetches a single column, single row query as a primitive long.
     *
     *@param  sql               SQL select statement.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public long getSingleRowColAsLongValue(String sql) throws SQLException {
        return procSinglelongResult(initSingleRowColumnFetchStatic(sql));
    }


    /**
     *  Fetches a single column, single row query as a <code>long</code>.
     *
     *@param  stmt              <code>JRFPreparedStatement</code> instance.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public long getSingleRowColAsLongValue(JRFPreparedStatement stmt) throws SQLException {
        return procSinglelongResult(initSingleRowColumnFetchPrepared(stmt));
    }


    ////////////////// Integer  ////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  r                 Description of the Parameter
     *@return                   Description of the Return Value
     *@throws  SQLException  if an execution error occurs.
     */
    private Integer procSingleIntegerResult(JRFResultSet r) throws SQLException {
        Integer result = r.getInteger(1);
        r.close();
        return result;
    }


    /**
     *  Fetches a single column, single row query as a <code>Integer</code>.
     *
     *@param  sql               SQL select statement.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public Integer getSingleRowColAsInteger(String sql) throws SQLException {
        return procSingleIntegerResult(initSingleRowColumnFetchStatic(sql));
    }


    /**
     *  Fetches a single column, single row query as a <code>Integer</code>.
     *
     *@param  stmt              <code>JRFPreparedStatement</code> instance.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public Integer getSingleRowColAsInteger(JRFPreparedStatement stmt) throws SQLException {
        return procSingleIntegerResult(initSingleRowColumnFetchPrepared(stmt));
    }


    ////////////////// int  ////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  r                 Description of the Parameter
     *@return                   Description of the Return Value
     *@exception  SQLException  Description of the Exception
     */
    private int procSingleintResult(JRFResultSet r) throws SQLException {
        int result = r.getint(1);
        r.close();
        return result;
    }


    /**
     *  Fetches a single column, single row query as a primitive int.
     *
     *@param  sql               SQL select statement.
     *@return                   numeric single column value.
     *@throws  SQLException  if an execution error occurs.
     */
    public int getSingleRowColAsIntValue(String sql) throws SQLException {
        return procSingleintResult(initSingleRowColumnFetchStatic(sql));
    }


    /**
     *  Fetches a single column, single row query as a <code>int</code>.
     *
     *@param  stmt              <code>JRFPreparedStatement</code> instance.
     *@return                   numeric single column,
     *@throws  SQLException  if an execution error occurs.
     */
    public int getSingleRowColAsIntValue(JRFPreparedStatement stmt) throws SQLException {
        return procSingleintResult(initSingleRowColumnFetchPrepared(stmt));
    }


    ////////////////// timestamp ////////////////////////////////////////////
    /**
     *  Description of the Method
     *
     *@param  r                 Description of the Parameter
     *@return                   Description of the Return Value
     *@throws  SQLException  if an execution error occurs.
     */
    private Timestamp procSingleTimestampResult(JRFResultSet r) throws SQLException {
        Timestamp result = r.getTimestamp(1);
        r.close();
        return result;
    }


    /**
     *  Fetches a single column, single row query as a <code>Timestamp</code>.
     *
     *@param  sql               SQL select statement.
     *@return                   numeric single column value.
     *@throws  SQLException  if an execution error occurs.
     */
    public Timestamp getSingleRowColAsTimestamp(String sql) throws SQLException {
        return procSingleTimestampResult(initSingleRowColumnFetchStatic(sql));
    }


    /**
     *  Fetches a single column, single row query as a <code>Timestamp</code>.
     *
     *@param  stmt              <code>JRFPreparedStatement</code> instance.
     *@return                   numeric single column value.
     *@throws  SQLException  if an execution error occurs.
     */
    public Timestamp getSingleRowColAsTimestamp(JRFPreparedStatement stmt) throws SQLException {
        return procSingleTimestampResult(initSingleRowColumnFetchPrepared(stmt));
    }

}
