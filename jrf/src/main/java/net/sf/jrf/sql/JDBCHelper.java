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


import java.math.BigDecimal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;

import java.util.List;
import java.util.Properties;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;

import org.apache.log4j.Category;

/**
 *  Instances of this class execute JDBC queries and give access to data
 *  columns.
 *
 *  <p>Note: **AutoCommit has been turned off**.  You must explicitly call
 *  commit() or rollback(). (If you do not, the close method will commit any
 *  uncommitted transactions).
 *
 *  <h2>How to Use</h2>
 *
 *  In your class that needs to execute a query put something like this:
 *
 *  <CODE><PRE>
 *  Vector result = new Vector(20);
 *  JDBCHelper helper = null;
 *  try
 *      {
 *      helper = new JDBCHelper("weblogic.jdbc.pool.Driver",
 *                              "jdbc:weblogic:pool",
 *                              "myPool");
 *      helper.executeQuery("SELECT * FROM Status");
 *      while (helper.next())
 *          {
 *          StatusValue aStatusValue =
 *                 new StatusValue(helper.getInteger("StatusId"));
 *          aStatusValue.setCode(helper.getString("Code"));
 *          aStatusValue.setActive(helper.getboolean("Active"));
 *          aStatusValue.setSortOrder(helper.getint("SortOrder"));
 *          result.addElement(aStatusValue);
 *          } // while
 *      helper.close();
 *      }
 *  catch (SQLException e)
 *      {
 *      LOG.error(
 *            "***SQLException - Column name: " + helper.getColumnName());
 *      e.printStackTrace();
 *      throw e;
 *      }
 *  catch (Exception e)
 *      {
 *      LOG.error("Exception caught in Xyx.abc()", e);
 *      e.printStackTrace();
 *      throw e;
 *      }
 *  </PRE></CODE>
 *
 *  <P>Quick summary of the column value getter methods:<BR>
 *  (This is here to show the naming convention)
 *
 *  <TABLE>
 *  <TR><TH>method name</TH>  <TH>return type</TH></TR>
 *  <TR><TD>getint</TD>       <TD>int</TD></TR>
 *  <TR><TD>getInteger</TD>   <TD>Integer or null</TD></TR>
 *  <TR><TD>getlong</TD>      <TD>long</TD></TR>
 *  <TR><TD>getLong</TD>      <TD>Long</TD></TR>
 *  <TR><TD>getShort</TD>     <TD>Short</TD></TR>
 *  <TR><TD>getboolean</TD>   <TD>boolean</TD></TR>
 *  <TR><TD>getBoolean</TD>   <TD>Boolean</TD></TR>
 *  <TR><TD>getNullableBoolean</TD><TD>Boolean or null</TD></TR>
 *  <TR><TD>getfloat</TD>     <TD>float</TD></TR>
 *  <TR><TD>getFloat</TD>     <TD>Float or null</TD></TR>
 *  <TR><TD>getdouble</TD>    <TD>double</TD></TR>
 *  <TR><TD>getDouble</TD>    <TD>Double</TD></TR>
 *  <TR><TD>getString</TD>    <TD>trimmed String or null</TD></TR>
 *  <TR><TD>getRawString</TD> <TD>String or null</TD></TR>
 *  <TR><TD>getDate</TD>      <TD>java.sql.Date or null</TD></TR>
 *  <TR><TD>getTime</TD>      <TD>java.sql.Time or null</TD></TR>
 *  <TR><TD>getTimestamp</TD> <TD>java.sql.Timestamp or null</TD></TR>
 *  <TR><TD>getBigDecimal</TD><TD>BigDecimal</TD></TR>
 *  </TABLE>
 *
 * Note: the i_reuseStatement field was added to account for a JDBCDriver
 * (The FreeTDS SQLServer driver) that rolls back the connection whenever a
 * statement is closed.  (From my knowledge no other drivers work this way,
 * but this driver does allow reuse of statements).  Note that using the
 * executeQuery(aPreparedStatement) or executeUpdated(aPreparedStatement)
 * methods will close the statement regardless of whether i_reuseStatement
 * is true or not.
 */
public class JDBCHelper
     implements Cloneable
{

    /** log4j category for debugging and errors */
    private final static Category LOG =
        Category.getInstance(JDBCHelper.class.getName());
    /** log4j category for logging the SQL */
    private final static Category SQLLOG =
        Category.getInstance(JDBCHelper.class.getName() + ".sql");

    /** The delimiter characters - single quote. */
    public final static String SINGLE_QUOTE = "'";
    /** The delimiter characters - double quote. */
    public final static String DOUBLE_QUOTE = "\"";

    /** These ivars support the two methods of creating connections */
    private String i_driverClass = null;
    private String i_url = null;
    private Properties i_properties = new Properties();
    private String i_dataSourceName = null;
    private DataSource i_dataSource = null;
    /** These ivars maintain the connection and SQL processing */
    private Connection i_connection = null;
    private Statement i_statement = null;
    private ResultSet i_resultSet = null;
    private String i_sqlString = "";
    /** These ivars aid with error messages for SQL debugging */
    private String i_columnName = "";
    private int i_columnIndex = 0;

    /** The following ivars provide support for how SQL processing is done. */
    /** this variable has been replaced by i_commitButDontClose */
    // private boolean    i_shouldClose = true;
    /** this is false when I am in a JDBCHelperPool */
    private boolean i_commitButDontClose = false;
    private boolean i_closeButDontCommit = false;
    /** This should be true if shouldAutoCommit is false */
    private boolean i_shouldCommitOnClose = true;
    /** This value is passed to connection.setAutoCommit(boolean) */
    private boolean i_shouldAutoCommit = false;
    /** This is true for drivers (like freetds) that ties TX to the statement */
    private boolean i_reuseStatement = false;

    /** This variable provides support for a JDBCHelper pool. */
    private boolean i_inPool = false;
    private JDBCHelperPool i_jdbcHelperPool = null;

    /** This set by the beginTransaction() and endTransaction() methods */
    private boolean i_isInsideTransaction = false;

    /** Description of the Field */
    public static int s_instanceCount = 0;
    private int i_serialNum = ++s_instanceCount;


    /**
     *  Constructors  **************
     *
     * @param driverClass  Description of the Parameter
     * @param url          Description of the Parameter
     * @param poolName     Description of the Parameter
     */

    /**
     * Create a JDBCHelper that will use the supplied information to get a
     * connection from a JDBC connection pool.  (This may be specific to
     * Weblogic).
     *
     * @param poolName     a value of type 'String'
     * @param driverClass  Description of the Parameter
     * @param url          Description of the Parameter
     * @deprecated         Use J2EE DataSource instead
     */
    public JDBCHelper(String driverClass, String url, String poolName)
    {
        i_driverClass = driverClass;
        i_url = url;
        i_properties.put("connectionPoolID", poolName);
    }


    /**
     * Create a JDBC helper that will use the supplied information to get
     * a connection from a JDBC connection pool.
     *
     * @param dataSource  Description of the Parameter
     */
    public JDBCHelper(DataSource dataSource)
    {
        if (dataSource == null)
        {
            throw new IllegalArgumentException("dataSource cannot be null");
        }
        i_dataSource = dataSource;
    }


    /**
     * Create a JDBC helper that will use the supplied information to get
     * a connection from a JDBC connection pool.
     *
     * @param dataSourceName  Description of the Parameter
     */
    public JDBCHelper(String dataSourceName)
    {
        if (dataSourceName == null)
        {
            throw new IllegalArgumentException("dataSourceName cannot be null");
        }
        i_dataSourceName = dataSourceName;
    }


    /**
     * Create a JDBC helper that will use the supplied information to
     * create a JDBC connection.
     *
     * @param driverClass  Description of the Parameter
     * @param url          Description of the Parameter
     * @param user         Description of the Parameter
     * @param password     Description of the Parameter
     * @deprecated         Use J2EE DataSource instead
     */
    public JDBCHelper(String driverClass,
        String url,
        String user,
        String password)
    {
        i_driverClass = driverClass;
        i_url = url;
        i_properties.put("user", user);
        i_properties.put("password", password);
    }


    /**
     *   Instance Methods   ************
     *
     * @return   The commitButDontClose value
     */

    /**
     * Return whether the close() method should actually close the connection
     * or not.  This is used by the JDBCHelperPool to keep connections open.
     *
     * @return   Value of shouldClose.
     */
    public boolean getCommitButDontClose()
    {
        return i_commitButDontClose;
    }

    /**
     * Set the value of commitButDontClose.  This should be set to true when
     * you want the connection commit, but not actually close during the close()
     * method.
     * This is used by the JDBCHelperPool to keep it's connections open.
     *
     * @param v  Value to assign to shouldClose.
     */
    public void setCommitButDontClose(boolean v)
    {
        i_commitButDontClose = v;
    }

    /**
     * Return whether the commit() method should actually commit or not.
     * This is needed for EJB server options that don't allow commits.
     *
     * @return   Value of shouldClose.
     */
    public boolean getCloseButDontCommit()
    {
        return i_closeButDontCommit;
    }

    /**
     * Set the value of commitButDontClose.  This should be set to true when you
     * want the connection to be closed but not manually committed.
     * This is needed for EJB server options that don't allow commits.
     *
     * @param v  Value to assign to shouldClose.
     */
    public void setCloseButDontCommit(boolean v)
    {
        i_closeButDontCommit = v;
    }

    /**
     * Return the value of shouldCommitOnClose.    This should be true if
     * shouldAutoCommit is false.
     *
     * @return   Value of shouldCommitOnClose.
     */
    public boolean getShouldCommitOnClose()
    {
        return i_shouldCommitOnClose;
    }

    /**
     * Set the value of shouldCommitOnClose.  This should be true if
     * shouldAutoCommit is false.
     *
     * @param v  Value to assign to shouldCommitOnClose.
     */
    public void setShouldCommitOnClose(boolean v)
    {
        i_shouldCommitOnClose = v;
    }

    /**
     * Return the value of shouldAutoCommit.
     *
     * @return   Value of shouldAutoCommit.
     */
    public boolean getShouldAutoCommit()
    {
        return i_shouldAutoCommit;
    }

    /**
     * Set the value of shouldAutoCommit.  This value is passed to
     * Connection#setAutoCommit(boolean) when the connection is created.
     *
     * @param v  Value to assign to shouldAutoCommit.
     */
    public void setShouldAutoCommit(boolean v)
    {
        i_shouldAutoCommit = v;
    }

    /**
     * Return the value of reuseStatement.
     *
     * @return   Value of reuseStatement.
     */
    public boolean getReuseStatement()
    {
        return i_reuseStatement;
    }

    /**
     * Set the value of reuseStatement.  This is set to true for drivers
     * (like freeTDS) that tie transactions to the statement instead of
     * the connection.
     *
     * @param v  Value to assign to reuseStatement.
     */
    public void setReuseStatement(boolean v)
    {
        i_reuseStatement = v;
    }

    /**
     * Return the statement last used.
     *
     * @return   The statement value
     */
    public Statement getStatement()
    {
        return i_statement;
    }

    /**
     * Return boolean informing us whether we are inside a "transaction" or not.
     *
     * @return   Value of isInsideTransaction.
     */
    public boolean isInsideTransaction()
    {
        return i_isInsideTransaction;
    }

    /**
     * Gets the jDBCHelperPool attribute of the JDBCHelper object
     *
     * @return   The jDBCHelperPool value
     */
    public JDBCHelperPool getJDBCHelperPool()
    {
        return i_jdbcHelperPool;
    }

    /**
     * Sets the jDBCHelperPool attribute of the JDBCHelper object
     *
     * @param v  The new jDBCHelperPool value
     */
    public void setJDBCHelperPool(JDBCHelperPool v)
    {
        i_jdbcHelperPool = v;
    }

    /** Description of the Method */
    public void returnToPool()
    {
        if (i_jdbcHelperPool != null)
        {
            i_jdbcHelperPool.returnJDBCHelper(this);
        }
    }


    /**
     * Execute the SQL string. The native sql of the query is logged.
     * It is up to the user to make sure this gets closed appropriately.
     *
     * @param sqlString                   a value of type 'String'
     * @exception SQLException            if a database access error occurs
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     */
    public void executeQuery(String sqlString)
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        this.validateConnection();
        if (SQLLOG.isDebugEnabled())
        {// log the SQL
            SQLLOG.debug("[" + sqlString + "] " + this);
        }
        i_sqlString = sqlString;

        this.initStatement();

        i_resultSet = i_statement.executeQuery(i_sqlString);
    }

    /**
     * Gets a PreparedStatement for use with executeQuery(aPreparedStatement).
     *
     * @param sqlStatement                a SQL statement that may contain one or more '?' IN
     * parameter placeholders
     * @return                            Description of the Return Value
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     * @exception SQLException            Description of the Exception
     */
    public PreparedStatement prepareStatement(String sqlStatement)
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        this.validateConnection();
        i_sqlString = sqlStatement;
        if (SQLLOG.isDebugEnabled())
        {// log the SQL
            SQLLOG.debug(
                "[" + sqlStatement + "] " + this);
        }
        return i_connection.prepareStatement(sqlStatement);
    }

    /**
     * Executes a prepared statement created by prepareStatement().
     *
     * @param stmt                        prepared statement to execute. All IN parameter values
     * must have been set.
     * @exception SQLException            if an error occurs
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     */
    public void executeQuery(PreparedStatement stmt)
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        this.closeStatement();
        i_statement = stmt;
        i_resultSet = stmt.executeQuery();
    }


    /**
     * Execute an update/insert/delete.
     *
     * @param sqlString                   a value of type 'String'
     * @return                            a value of type 'int'
     * @exception SQLException            if an error occurs
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     */
    public int executeUpdate(String sqlString)
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        Statement statement;

        this.validateConnection();
        if (SQLLOG.isDebugEnabled())
        {// log the SQL
            SQLLOG.debug(
                "[" + sqlString + "] " + this);
        }

        this.initStatement();

        return i_statement.executeUpdate(sqlString);
    }


    /**
     * Execute an update/insert/delete on a PreparedStatement
     *
     * @param stmt                        Description of the Parameter
     * @return                            either the row count for INSERT, UPDATE or DELETE statements;
     * or 0 for SQL statements that return nothing
     * @exception SQLException            if an error occurs
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     */
    public int executeUpdate(PreparedStatement stmt)
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        Statement statement;

        this.validateConnection();
        if (SQLLOG.isDebugEnabled())
        {// log the SQL
            SQLLOG.debug(
                "[" + i_sqlString + "] " + this);
        }

        this.closeStatement();
        i_statement = stmt;
        return stmt.executeUpdate();
    }


    /**
     * Make sure the connection exists and is open.
     *
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     * @exception SQLException            Description of the Exception
     */
    private final void validateConnection()
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        if (i_inPool)
        {
            throw new SQLException(
                "This JDBCHelper instance (" + this + ") has been returned to "
                + "the pool. You must retrieve and use another one.");
        }

        if (LOG.isDebugEnabled())
        {
            LOG.debug(
                "Checking to see if connection is valid: " + i_connection);
        }
        if (i_connection == null || i_connection.isClosed())
        {
            // assumes standard close methods are used.
            i_statement = null;
            i_resultSet = null;

            if (i_dataSourceName != null && i_dataSource == null)
            {
                // look up DataSource via JNDI
                Context context = new InitialContext();
                i_dataSource = (DataSource) context.lookup(i_dataSourceName);
                context.close();
            }
            LOG.debug("About to get a new connection.");
            if (i_dataSource != null)
            {
                // get connection from datasource
                i_connection = i_dataSource.getConnection();
            }
            else
            {
                // no datasource, create new connection from driver info.
                if (LOG.isDebugEnabled())
                {
                    LOG.debug("Driver Class: " + i_driverClass);
                }
                Class.forName(i_driverClass).newInstance();
                i_connection = DriverManager.getConnection(i_url, i_properties);
            }
            // configure the connection properties.
            i_connection.setAutoCommit(this.getShouldAutoCommit());
            if (LOG.isDebugEnabled())
            {
                LOG.debug("Connection was created: " + i_connection);
            }
        }
    }


    /**
     * Answer true if the connection is closed.
     *
     * @return                  a value of type 'boolean'
     * @exception SQLException  Description of the Exception
     */
    public boolean isConnectionClosed()
        throws SQLException
    {
        if (i_connection != null)
        {
            return i_connection.isClosed();
        }
        else
        {
            return true;
        }
    }


    /**
     * Return the current Connection.  This was added to allow users to
     * bypass the executeQuery() method.  i.e. to use a PreparedStatement
     * instead of a Statement, etc.
     *
     * @return                            a value of type 'Connection'
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     * @exception SQLException            Description of the Exception
     */
    public Connection getConnection()
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        this.validateConnection();
        return i_connection;
    }


    /**
     * Return the current ResultSet
     *
     * @return   a value of type 'ResultSet'
     */
    public ResultSet getResultSet()
    {
        return i_resultSet;
    }


    /**
     * Move the cursor to the next row in the result set.
     *
     * @return                  true if the new current row is valid; false if there are no
     *              more rows.
     * @exception SQLException  if a database access error occurs
     */
    public boolean next()
        throws SQLException
    {
        return i_resultSet.next();
    }


    /**
     * Close the result set, statement, and connection.
     * If the connection is from a pool driver, it is returned to the pool.
     *
     * @exception SQLException  if a database access error occurs
     */
    public void close()
        throws SQLException
    {
        if (LOG.isDebugEnabled())
        {
            LOG.debug("at top of JDBCHelper.close(): " + this);
        }
        if (i_isInsideTransaction)
        {
            LOG.debug(
                "Connection closing postponed (still inside a transaction)");
            return;
        }
        if (i_connection != null &&
            !i_connection.isClosed())
        {
            try
            {
                // check if should commit before closing.
                if (i_shouldCommitOnClose || i_commitButDontClose)
                {
                    this.commit();
                }
            }
            finally
            {
                if (i_commitButDontClose)
                {
                    if (LOG.isDebugEnabled())
                    {
                        LOG.debug(
                            "Connection closing postponed (most likely because "
                            + "it is in a JDBCHelperPool).");
                    }
                }
                else
                {
                    // perform separately for the additional logging.
                    LOG.debug("close() is closing the ResultSet.");
                    this.closeResultSet();
                    LOG.debug("close() is closing the Statement.");
                    this.closeStatement();

                    LOG.debug("Connection closing.");
                    // If this connection came from a driver that is a pool,
                    // then this will return the connection to the pool.
                    // Else it will be freeing the connection (as it should).
                    i_connection.close();
                    i_connection = null;
                    LOG.debug("Connection closed.");
                }
            }
        }

        // If I came from a pool, I should return to it
        // so I can be reused.
        this.returnToPool();
    }// close()

    /**
     * Close the SQL Statement.
     * This is called when closing or changing the current SQL;
     * and enables the connection to be reused.
     *
     * @exception SQLException  Description of the Exception
     */
    private void closeStatement()
        throws SQLException
    {
        if (i_statement != null)
        {
            // if attempting to close the Statement,
            //    be sure to close any ResultSet first.
            //    assuming these methods used, and can't have RS without Stmt.
            this.closeResultSet();

            // The connection is being reused, but not the statement
            i_statement.close();
            i_statement = null;
        }
    }

    /**
     * Close the SQL ResultSet.
     * This is called when closing or changing the current SQL;
     * and enables the connection to be reused.
     *
     * @exception SQLException  Description of the Exception
     */
    private void closeResultSet()
        throws SQLException
    {
        if (i_resultSet != null)
        {
            i_resultSet.close();
            i_resultSet = null;
        }
    }

    /**
     * Initialize a Statement.  If none exists, a new one is created.
     * If reusing Statements, nothing is done;
     *   else the Statement is closed and a new one is created.
     *
     * @exception SQLException  Description of the Exception
     */
    private void initStatement()
        throws SQLException
    {
        // if not reusing the Statement, close it.  Then will get new one
        // always checking result set just in case a select was previously done.
        if (!i_reuseStatement)
        {
            this.closeStatement();
        }
        else
        {
            // just in case select was done on this Statement (which is being reused).
            this.closeResultSet();
        }
        // if statement exists, reuse it; else get a new one.
        if (i_statement == null)
        {
            i_statement = i_connection.createStatement();
        }
    }


    /**
     * Commit the transaction.
     *
     * @exception SQLException  if a database access error occurs
     */
    public void commit()
        throws SQLException
    {
        if (i_isInsideTransaction)
        {
            if (LOG.isDebugEnabled())
            {
                LOG.debug(
                    "Connection commit postponed (inside a transaction): " + this);
            }
        }
        else if (i_closeButDontCommit)
        {
            if (LOG.isDebugEnabled())
            {
                LOG.debug(
                    "Connection commit turned off: " + this);
            }
        }
        else
        {
            if (LOG.isDebugEnabled())
            {
                LOG.debug("Connection about to be committed: " + this);
            }
            i_connection.commit();
        }
    }


    /**
     * Rollback the transaction.
     *
     * @exception SQLException  if a database access error occurs
     */
    public void rollback()
        throws SQLException
    {
        i_isInsideTransaction = false;
        if (LOG.isDebugEnabled())
        {
            LOG.debug("Connection about to be rolled back: " + this);
        }
        i_connection.rollback();
    }


    /**
     * Calling this method tells JDBCHelper to ignore commit() messages and
     * close() messages until endTransaction() is called.  rollback() messages
     * are *not* ignored.
     *
     * @exception ClassNotFoundException  Description of the Exception
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     * @exception SQLException            Description of the Exception
     */
    public void beginTransaction()
        throws ClassNotFoundException,
        InstantiationException,
        IllegalAccessException,
        NamingException,
        SQLException
    {
        if (LOG.isDebugEnabled())
        {
            LOG.debug("Beginning a transaction: " + this);
        }
        this.validateConnection();
        i_isInsideTransaction = true;
    }


    /**
     * This method turns off the isInsideTransaction flag and commits the
     * database changes.  It is up to the user to close the JDBCHelper when
     * done with it.
     *
     * @exception SQLException  if an error occurs
     */
    public void endTransaction()
        throws SQLException
    {
        if (LOG.isDebugEnabled())
        {
            LOG.debug("Ending a transaction: " + this);
        }
        i_isInsideTransaction = false;
        this.commit();
    }


    /**
     * Return the name of the column that was unsuccessfully accessed.
     *
     * @return   a value of type 'String'
     */
    public String getColumnName()
    {
        return i_columnName;
    }


    /**
     * Return the SQL string that was last executed.
     *
     * @return   a value of type 'String'
     */
    public String getSQLString()
    {
        return i_sqlString;
    }

    /**
     * After this method is called, this JDBCHelper cannot be used until
     * markOutOfPool() is called.
     */
    public void markInPool()
    {
        i_inPool = true;
    }

    /** Description of the Method */
    public void markOutOfPool()
    {
        i_inPool = false;
    }

    /**
     * Gets the inPool attribute of the JDBCHelper object
     *
     * @return   The inPool value
     */
    public boolean isInPool()
    {
        return i_inPool;
    }


    /**
     * Print the column names returned in the result set out to System.out.
     * This is only done if the ResultSet is not null.
     * This is a debugging method; and has no practical application in production.
     */
    public void printColumnNames()
    {
        ResultSetMetaData metaData = null;
        if (i_resultSet == null)
        {
            return;
        }
        try
        {
            metaData = i_resultSet.getMetaData();
            System.out.print("Column Names: ");
            for (int i = 1; i <= metaData.getColumnCount(); i++)
            {
                System.out.print(metaData.getColumnName(i));
                if (i != metaData.getColumnCount())
                {
                    System.out.print(", ");
                }// if
            }// for
            System.out.println();// add a carriage return
        }
        catch (SQLException e)
        {
            LOG.error(
                "SQLException occurred in JDBCHelper#printColumnNames()", e);
        }
    }// printColumnNames()


    /**
     * Return a copy of myself without a database connection.
     * Because there will not be a database connection, it will be considered
     * to be outside of a transaction.
     *
     * @return                                a clone of this 'Object'
     * @exception CloneNotSupportedException  Description of the Exception
     */
    public Object clone()
        throws CloneNotSupportedException
    {
        JDBCHelper clone = (JDBCHelper) super.clone();

        // Clear out data specific to the source object.
        clone.i_statement = null;
        clone.i_resultSet = null;
        clone.i_connection = null;
        // These probably aren't necessary, but are for completeness
        clone.i_sqlString = "";
        clone.i_columnName = "";
        clone.i_columnIndex = 0;

        clone.i_serialNum = ++s_instanceCount;

        // clone will not be in pool, flag appropriately.
        clone.i_inPool = false;
        // clone will not even have a connection, so won't be inside a trans.
        clone.i_isInsideTransaction = false;

        return clone;
    }


    /* ==============  Column Value Accessors  ================= */

    /**
     * Get whatever type of object is in the given column.
     * If the column has a null, this will return false.
     *
     * @param column            a value of type 'String'
     * @return                  a value of type 'Object'
     * @exception SQLException  Description of the Exception
     */
    public Object getObject(String column)
        throws SQLException
    {
        i_columnName = column;
        Object returnValue = i_resultSet.getObject(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Object returnValue = i_resultSet.getObject(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        boolean returnValue = i_resultSet.getBoolean(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        boolean returnValue = i_resultSet.getBoolean(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Boolean returnValue = new Boolean(i_resultSet.getBoolean(column));
        if (returnValue == null)
        {
            returnValue = Boolean.FALSE;
        }
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Boolean returnValue = new Boolean(i_resultSet.getBoolean(column));
        if (returnValue == null)
        {
            returnValue = Boolean.FALSE;
        }
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Boolean returnValue = new Boolean(i_resultSet.getBoolean(column));
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Boolean returnValue = new Boolean(i_resultSet.getBoolean(column));
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        String result = this.getRawString(column);
        if (result != null)
        {
            result = result.trim();
        }
        return result;
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
        throws SQLException
    {
        String result = this.getRawString(column);
        if (result != null)
        {
            result = result.trim();
        }
        return result;
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
        throws SQLException
    {
        i_columnName = column;
        String returnValue = i_resultSet.getString(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        String returnValue = i_resultSet.getString(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Timestamp returnValue = i_resultSet.getTimestamp(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Timestamp returnValue = i_resultSet.getTimestamp(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Date returnValue = i_resultSet.getDate(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Date returnValue = i_resultSet.getDate(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Time returnValue = i_resultSet.getTime(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Time returnValue = i_resultSet.getTime(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Integer returnValue = new Integer(i_resultSet.getInt(column));
        i_columnName = "";
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Integer returnValue = new Integer(i_resultSet.getInt(column));
        i_columnIndex = 0;
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Long returnValue = new Long(i_resultSet.getLong(column));
        i_columnName = "";
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Long returnValue = new Long(i_resultSet.getLong(column));
        i_columnIndex = 0;
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        int returnValue = i_resultSet.getInt(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        int returnValue = i_resultSet.getInt(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        long returnValue = i_resultSet.getLong(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        long returnValue = i_resultSet.getLong(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Short returnValue = new Short(i_resultSet.getShort(column));
        i_columnName = "";
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Short returnValue = new Short(i_resultSet.getShort(column));
        i_columnIndex = 0;
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Float returnValue = new Float(i_resultSet.getFloat(column));
        i_columnName = "";
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Float returnValue = new Float(i_resultSet.getFloat(column));
        i_columnIndex = 0;
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        float returnValue = i_resultSet.getFloat(column);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        float returnValue = i_resultSet.getFloat(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        Double returnValue = new Double(i_resultSet.getDouble(column));
        i_columnName = "";
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        Double returnValue = new Double(i_resultSet.getDouble(column));
        i_columnIndex = 0;
        if (i_resultSet.wasNull())
        {
            returnValue = null;
        }
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        double returnValue = i_resultSet.getDouble(column);
        i_columnName = "";
        return returnValue;
    }


    /**
     * Calls the getDouble() method on the ResultSet.
     * If the column has a null, this will return a zero.
     *
     * @param column            a value of type 'int'
     * @return                  a value of type 'double'
     * @exception SQLException  if column is not found
     */
    public double getdouble(int column)
        throws SQLException
    {
        i_columnIndex = column;
        double returnValue = i_resultSet.getDouble(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;

        // WORKAROUND ****
        // Weblogic hasn't implemented ResultSet.getBigDecimal yet.
        // For now get it as a String and turn into a BigDecimal.
        String resultString = i_resultSet.getString(column);
        if (resultString == null)
        {
            return (BigDecimal) null;
        }
        BigDecimal returnValue = new BigDecimal(resultString);
        i_columnName = "";
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;

        // WORKAROUND ****
        // Weblogic hasn't implemented ResultSet.getBigDecimal yet.
        // For now get it as a String and turn into a BigDecimal.
        String resultString = i_resultSet.getString(column);
        if (resultString == null)
        {
            return (BigDecimal) null;
        }
        BigDecimal returnValue = new BigDecimal(resultString);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnIndex = column;
        byte[] returnValue = i_resultSet.getBytes(column);
        i_columnIndex = 0;
        return returnValue;
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
        throws SQLException
    {
        i_columnName = column;
        byte[] returnValue = i_resultSet.getBytes(column);
        i_columnName = "";
        return returnValue;
    }


    /* ==========  Convenience Helper Methods  ========== */

    /**
     * Formats a String for use as a String in a DB query
     *   where a single quote is the delimiter.
     *
     * @param p_val  the String to format
     * @return       String with quotes escaped, and enclosing.
     * @see          #delimitString
     */
    public static String delimitSingleQuote(String p_val)
    {
        return JDBCHelper.delimitString(p_val, SINGLE_QUOTE);
    }


    /**
     * Formats a String for use as a String in a DB query
     *   where a double quote is the delimiter.
     *
     * @param p_val  the String to format
     * @return       String with quotes escaped, and enclosing.
     * @see          #delimitString
     */
    public static String delimitDoubleQuote(String p_val)
    {
        return JDBCHelper.delimitString(p_val, DOUBLE_QUOTE);
    }


    /**
     * STATIC CLASS METHOD:
     * Formats a String for use as a String in a DB query
     *   where the delimiter is as provided.
     *
     * @param p_val        the String to format
     * @param p_delimiter  the delimiter for formatting
     * @return             String with quotes escaped, and enclosing.
     */
    public static String delimitString(String p_val, String p_delimiter)
    {
        String result = null;

        // replace occurrances of the delimiter with "double delimiters"
        // to "escape" the delimiter character within the string.
        result = JDBCHelper.replace(p_val,
            p_delimiter,
            (p_delimiter + p_delimiter));

        // pre-pend and post-pend the delimiter
        result = p_delimiter + result + p_delimiter;

        return result;
    }


    /**
     * This method should really be in a StringUtil class.
     * Replace occurrences of oldString with newString within the content text.
     *
     * @param content    The text String that will be acted upon (strings
     *                replaced).
     * @param oldString  The string that will be replaced.
     * @param newString  The string that will replace oldString.
     * @return           returns the content string with the replaced values, as a
     *         String, or original content if bad parms.
     */
    public static String replace(String content,
        String oldString,
        String newString)
    {
        // if any parms null or too small, no point in doing anything...return
        // content
        if ((content == null) ||
            (oldString == null) ||
            (oldString.length() < 1) ||
            (newString == null))
        {
            return content;
        }
        // if content too small to contain oldString, no point in doing
        // anything...return content
        if (content.length() < oldString.length())
        {
            return content;
        }

        // Perform String replacement
        String newContent = content;
        int foundIndex = content.indexOf(oldString);

        // Recurse through the string, replacing ALL occurrences recurse rather
        // than loop to allow a replace that includes itself (eg "'" with "''" -
        // SQL escaping)
        if (foundIndex != -1)
        {
            try
            {
                newContent = content.substring(0, foundIndex)
                    + newString
                    + replace(
                    content.substring(foundIndex + oldString.length(),
                    content.length()),
                    oldString,
                    newString);
            }
            catch (StringIndexOutOfBoundsException e)
            {
                Category.getInstance("JDBCHelper").error(
                    "Exception occured in JDBCHelper.replace()... Ignoring.", e);
            }
        }
        return newContent;
    }// replace(...)


    /**
     * This method should really be in a StringUtil class.
     * For a given List, this method creates a comma-separated string list and
     * surrounds it with parenthesis.  It is suitable for use in any SQL clauses
     * where that formatting is required.<br>
     * e.g. WHERE IN (foo,bar,blah)
     * e.g. VALUES (tom,dick,harry)<br>
     *
     * This calls the String.valueOf() method on each List element to produce the values.
     *
     * @param objects  a value of type 'List'
     * @return         a value of type 'String'
     */
    public static String toSQLList(List objects)
    {
        if (objects == null || objects.size() < 1)
        {
            return "()";
        }

        // Create a comma delimited, paren enclosed string of all the objects in
        // the List.  All concrete implementations of List will inherit from
        // AbstractCollection where the #toString() method does this formatting
        // but uses [] instead of (), so we have to replace it. Elements are
        // converted to strings as by String.valueOf(Object).  So if Your list
        // contains:
        //
        // 1234
        // 5678
        // 9012
        //
        // ... the resulting String will be:
        // (1234, 5678, 9012)

        return objects.toString().replace('[', '(').replace(']', ')');
    }

    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public String toString()
    {
        return "JDBCHelper #" + i_serialNum;
    }

}// JDBCHelper
