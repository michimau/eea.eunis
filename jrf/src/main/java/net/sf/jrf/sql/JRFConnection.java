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
 * Contributor: James Evans jevans@vmguys.com
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

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;
import javax.sql.XADataSource;
import net.sf.jrf.*;
import net.sf.jrf.exceptions.*;
import org.apache.log4j.Category;
/**
 * An encapsulation of a JDBC connection for the JRF framework.  This class
 * contains a <code>javax.sql.DataSource</code> entity, which will usually
 * be a connection pool.  In addition, this class contains:
 * <ul>
 * <li> An instance of <code>DataSourceProperties</code>.
 * <li> An single <code>StatementExecuter</code> instance.
 * <li> An instance of <code>PreparedStatementListHandler</code>.
 * </ul>
 * <p>
 * All JDBC connection management functionality is handled by this class.
 *
 * @see   net.sf.jrf.sql.StatementExecuter
 * @see   net.sf.jrf.sql.DataSourceProperties
 * @see   net.sf.jrf.sql.PreparedStatementListHandler
 */
public class JRFConnection
{

    private final static Category LOG = Category.getInstance(JRFConnection.class.getName());

    private PreparedStatementListHandler preparedStatementList = null;// List of prepared statements.
    Object dataSource = null;
    private StatementExecuter statementExecuter = null;// Statement executer
    private DataSourceProperties dataSourceProperties = null;// Data source properties.
    protected Connection connection = null;// Package scope - connection.
    private boolean closed = true;// Closed flag.
    private boolean dedicatedConnection = false;// Dedicated connection flag.
    /////////////////////////////////////////////////
    private int instanceId = 0;// Instance id for debugging only.
    int maxRows = 0;// Max rows to fetch statement executer reads
    boolean supportsTransactions = true;// Does DataSource support transactions.
    private ArrayList staticSQLStatements = new ArrayList();// For dedicated connections, list of statements
    private String name = "Unnamed Connection";// Name of connection useful for debugging.
    private int connectionRequests = 0;// Number of requests for a connection.
    int statementExecutionCount = 0;// Package scope - records number of statements
    // executeds - (see StatementExecuter).
    // Static values for debug tracking only.
    private static int instanceCounter = 0;// Records number of JRFConnection Instances
    private static int connectionCounter = 0;

    private final static String ASSUREFUNC = "assureDatabaseConnection()";

    private final static String CLOSE = "close()";// Records number of live connections.

    private interface ConnectionCreator  {
        public Connection getConnection() throws SQLException;
    }

    private class XAConnectionCreator implements ConnectionCreator {
        private XADataSource source;

        XAConnectionCreator(Object source) {
            this.source = (XADataSource) source;
        }
        public Connection getConnection()  throws SQLException{
            return source.getXAConnection().getConnection();
        }
    }
    private class RegularConnectionCreator implements ConnectionCreator {
        private DataSource source;

        RegularConnectionCreator(Object source) {
            this.source = (DataSource) source;
        }
        public Connection getConnection()  throws SQLException{
            return source.getConnection();
        }
    }
    private ConnectionCreator connectionCreator = null;

    /**
     * Constructs a JRF connection handle.
     *
     * @param dataSource            <code>XADataSource</code> or <code>DataSource</code> to use to get the connection.
     * @param dataSourceProperties  associated data source properties.
     */
    public JRFConnection(Object dataSource, DataSourceProperties dataSourceProperties)
    {
        this.dataSourceProperties = dataSourceProperties;
    this.dataSource = dataSource;
    if (dataSource instanceof XADataSource) {
        connectionCreator = new XAConnectionCreator(dataSource);
    }
    else if (dataSource instanceof DataSource) {
        connectionCreator = new RegularConnectionCreator(dataSource);
    }
    else {
        throw new IllegalArgumentException(dataSource.getClass()+" is not XADataSource or DataSource.");
    }
        this.statementExecuter = new StatementExecuter(this, dataSourceProperties);
        this.preparedStatementList = new PreparedStatementListHandler(this);
        this.instanceId = addInstance();
        try
        {
            dataSourceProperties.getDatabasePolicy().initialize(statementExecuter);
        }
        catch (SQLException ex)
        {
            throw new DatabaseException(ex, "Unable to init database policy.");
        }
        finally
        {
            close();
        }
    }

    /**
     * Sets the name of the connection. Useful for debuging only.
     *
     * @param name  name of JRFConnection.
     */
    public void setName(String name)
    {
        this.name = name;
    }

    /**
     * Returns user name of connection.
     *
     * @return   name of connection
     * @see      #setName(String)
     */
    public String getName()
    {
        return this.name;
    }

    /**
     * Returns the total connections and instances of <code>JRFConnection</code>
     * for the application.
     *
     * @return   connection and instance information.
     */
    public static synchronized String getInstanceAndConnectionInfo()
    {
        return "JRFConnection totals: Instances = " + instanceCounter + "; Connections = " + connectionCounter;
    }

    private static synchronized int addInstance()
    {
        return ++instanceCounter;
    }

    private static synchronized void removeInstance()
    {
        instanceCounter--;
    }

    private static synchronized void addConnection()
    {
        connectionCounter++;
    }

    private static synchronized void removeConnection()
    {
        connectionCounter--;
    }

    /**
     * Returns information on this connection.
     *
     * @return   connection information.
     */
    public String toString()
    {
        return "Name = " + name + "\n" +
            "Instance ID = " + instanceId + "\n" +
            "DataSource and properties = " + dataSource + dataSourceProperties + "\n" +
            "JDBC Connection closed? " + closed + "\n" +
            "Dedicated Connection? " + dedicatedConnection + "\n" +
            "Connection requests: " + connectionRequests;
    }

    /**
     * Returns the prepared statement list managed by this connection.
     * Applications, particularly <code>AbstractDomain</code>, may
     * add statements as needed.  However, the ultimate controller
     * of the instance is this class. <i>This method is the only way to obtain
     * a prepared statement list; no public constructors exist.</i>
     *
     * @return   the prepared statement list managed by this connection.
     */
    public PreparedStatementListHandler getPreparedStatementList()
    {
        return this.preparedStatementList;
    }

    /**
     * Sets a attribute on whether this connection is dedicated. A dedicated connection
     * is one that stays open for a significant period of time, often thoughout
     * the lifetime of an application.
     * The default behavior of <code>JRFConnection</code> is leave the connection
     * undedicated; it should be closed after an database operation, which
     * in most cases means that the data source will return the connection to
     * a pool.
     *
     * @param dedicatedConnection  if <code>true</code> connection is marked as dedicated.
     * @see                        #closeOrReleaseResources()
     */
    public void setDedicatedConnection(boolean dedicatedConnection)
    {
        if (!dedicatedConnection)
        {
            staticSQLStatements.clear();
        }
        this.dedicatedConnection = dedicatedConnection;
    }

    /**
     * Gets database meta data.
     *
     * @return               database meta data.
     * @throws SQLException  if database access error occurs.
     */
    public DatabaseMetaData getDatabaseMetaData()
        throws SQLException
    {
        assureDatabaseConnection();
        return connection.getMetaData();
    }

    /**
     * Gets the attribute on whether this connection is dedicated. A dedicated connection
     * is one that stays open for a significant period of time or often thoughout
     * the lifetime of an application.  A call to <code>closeOrReleaseResources</code> on
     * a dedicated connection will result only in the releasing of connection resources.
     * Setting a dedication allows for maximum performance, particularly
     * under databases such as Oracle and Sybase that support parse-once-execute-many-times technology.
     * <p>
     * The default behavior of <code>JRFConnection</code> is leave the connection
     * undedicated; it should be closed after an database operation, which
     * in most cases means that the data source will return the connection to
     * a <code>DataSource</code> pool.
     * <p>
     * <i>This method may become deprecated once JDBC 3.0 statement pools are in place.</i>.
     *
     * @return   <code>true</code> connection is marked as dedicated.
     * @see      #closeOrReleaseResources()
     */
    public boolean isDedicatedConnection()
    {
        return this.dedicatedConnection;
    }

    /**
     * Closes the connection if not dedicated (usually returning the connection
     * to a <code>DataSource</code> connection pool), and releases the <code>Statement</code>
     * resources if the connection is dedicated.
     *
     * @see   #isDedicatedConnection()
     */
    public void closeOrReleaseResources()
    {
        if (dedicatedConnection)
        {
            // Under a dedicated connection, free all statements created.
            Iterator si = staticSQLStatements.iterator();
            while (si.hasNext())
            {
                Statement s = (Statement) si.next();
                try
                {
                    s.close();
                }
                catch (SQLException ex)
                {}// It may already be closed.
            }
            staticSQLStatements.clear();
        }
        else
        {
            close();
        }
    }

    // Package scope method called from StatementExecuter to create a statement.
    // If connection is dedicated, store the statement so it may be released later
    // if closeOrReleaseResources().
    Statement createStatement(boolean forQuery)
        throws SQLException
    {
        Statement s = connection.createStatement();
        if (forQuery)
        {
            s.setMaxRows(maxRows);
        }
        if (dedicatedConnection)
        {
            staticSQLStatements.add(s);
        }
        return s;
    }

    /**
     * Sets a <code>DataSource</code> to use.  It is possible for some
     * applications to have multiple data sources for the same type of database.
     * Thus, the same <code>DataSourceProperties</code> can apply to all
     * <code>DataSources</code>.  This method is provided for such applications.
     *
     * @param dataSource  The new dataSource value
     */
    public void setDataSource(DataSource dataSource)
    {
        if (!this.dataSource.equals(dataSource))
        {
            close();
            this.dataSource = dataSource;
        connectionCreator = new RegularConnectionCreator(dataSource);
        }
    }

    /**
     * Sets a <code>XADataSource</code> to use.  It is possible for some
     * applications to have multiple data sources for the same type of database.
     * Thus, the same <code>DataSourceProperties</code> can apply to all
     * <code>DataSources</code>.  This method is provided for such applications.
     *
     * @param dataSource  The new XAdataSource value
     */
    public void setXADataSource(XADataSource dataSource)
    {
        if (!this.dataSource.equals(dataSource))
        {
            close();
            this.dataSource = dataSource;
        connectionCreator = new XAConnectionCreator(dataSource);
        }
    }

    /**
     * Returns the <code>StatementExecuter</code> instance in this class.  This method
     * is the <i>only</i> way to obtain a <code>StatementExecuter</code>; no
     * public constructors exist.
     *
     * @return   <code>StatementExecuter</code> instance in this class.
     */
    public StatementExecuter getStatementExecuter()
    {
        return statementExecuter;
    }

    /**
     * Returns true if connections are under the same data source.
     *
     * @param c  Description of the Parameter
     * @return   true if connection instances are using the same data source.
     */
    public boolean equals(JRFConnection c)
    {
        return this.dataSource.equals(c.dataSource);
    }

    /**
     * Checks to see if two <code>JRFConnection</code> instances
     * are currently using the same JDBC connection.
     *
     * @param c                 Description of the Parameter
     * @return                  <code>true</code> if both instances are using the
     * same <code>Connection</code> instances under the same
     * Data Source.
     * @exception SQLException  Description of the Exception
     */
    public boolean onSameConnection(JRFConnection c)
        throws SQLException
    {
        if (equals(c))
        {
            return onSameConnection(c.connection);
        }
        return false;
    }

    /**
     * Returns hash code for this connection, which is
     * the hash code of the underlying data source.
     *
     * @return   hash code of the underlying data source.
     */
    public int hashCode()
    {
        return this.dataSource.hashCode();
    }

    private boolean onSameConnection(Connection conn)
    {
        if (!closed && conn != null && conn.equals(connection))
        {
            return true;
        }// Already done
        return false;
    }

    /**
     * Synchronizes the connection between two <code>JRFConnection</code>
     * instances for use in transactions by setting the class
     * connection to be the same as the argument's connection provided
     * both instances are using the same data source.
     *
     * @param conn              Description of the Parameter
     * @return                  <code>true</code> if connections are already synchronized.
     * @exception SQLException  Description of the Exception
     */
    public boolean synchronizeConnection(JRFConnection conn)
        throws SQLException
    {
        // Not in use and needs work.
        if (this.equals(conn))
        {
            Connection c = conn.connection;// Should never be null.
            if (onSameConnection(c))
            {
                return true;
            }
            this.close();
            this.connection = c;
            this.closed = false;
            addConnection();
        }
        return false;
    }

    /**
     * Sets the maximum rows to fetch for SQL queries on this connection.
     *
     * @param maxRows  maximum rows to fetch for a query.  Zero denotes no limit.
     */
    public void setMaxRows(int maxRows)
    {
        if (maxRows < 0)
        {
            throw new IllegalArgumentException("maxRows must be greater than or equal to zero.");
        }
        this.maxRows = maxRows;
    }

    /**
     * Assures that a connection is ready to be used.
     *
     * @throws SQLException  if connection cannot be obtained or an error
     * occurs initializing <code>DatabasePolicy</code>
     */
    public void assureDatabaseConnection()
        throws SQLException
    {
        assureDatabaseConnection(false);
    }

    void assureAutoCommitConnection()
        throws SQLException
    {
        assureDatabaseConnection(true);
    }


    void assureDatabaseConnection(boolean forceAutoCommit)
        throws SQLException
    {
        if (closed)
        {
            connection = connectionCreator.getConnection();
            if (connection == null) {
                throw new SQLException(this + ": connection returned from data source was null.");
            }

            // Have we ever got a connection.
            if (connectionRequests == 0)
            {
                DatabaseMetaData d = connection.getMetaData();
                LOG.debug(instance(ASSUREFUNC) + "Got meta data. Support transactions? " + d.supportsTransactions());
                supportsTransactions = d.supportsTransactions();
            }
            // Do we have to set up auto commit??
            if (forceAutoCommit || !supportsTransactions)
            {
                connection.setAutoCommit(true);
            }
            else
            {
                connection.setAutoCommit(false);
            }
            connectionRequests++;
            addConnection();
            closed = false;
            if (LOG.isDebugEnabled())
            {
                LOG.debug(instance(ASSUREFUNC) + " new "
                    + ((forceAutoCommit || !supportsTransactions) ? "non-auto-commit" : "autocommit") + " connection " +
                    "pulled from data source. " + getInstanceAndConnectionInfo());
            }
        }
    }

    // Prefix for logging instance
    private String instance(String method)
    {
        return method + " name = [" + name + "] instance = [" + instanceId + "], connection handle [" + connection +
            "](" + statementExecutionCount + "): ";
    }

    /**
     * Returns <code>true</code> if connection is open.
     *
     * @return   <code>true</code> if connection is open.
     */
    public boolean isConnectionOpen()
    {
        return closed ? false : true;
    }

    /** Returns <code>XADataSource</code> or <code>DataSource</code>
    * @return <code>XADataSource</code> or <code>DataSource</code>
    */
    public Object getDataSource() {
    return this.dataSource;
    }

    /**
     * Returns <code>DataSourceProperties</code> instance that applies to this
     * connection.
     *
     * @return   <code>DataSourceProperties</code> instance.
     */
    public DataSourceProperties getDataSourceProperties()
    {
        return this.dataSourceProperties;
    }

    /**
     * Returns the database policy instance.
     *
     * @return   database policy instance.
     */
    public DatabasePolicy getDatabasePolicy()
    {
        return this.dataSourceProperties.getDatabasePolicy();
    }

    /** Closes the connection. */
    public void close()
    {
        if (!closed)
        {
            if (LOG.isDebugEnabled())
            {
                LOG.debug(instance(CLOSE) + " close request.");
            }
            try
            {
                preparedStatementList.closeAll();
                this.commit();
                connection.close();
                if (LOG.isDebugEnabled())
                {
                    LOG.debug(instance(CLOSE) + " connection closed (released back to data source pool) " +
                        getInstanceAndConnectionInfo());

                }
            }
            catch (SQLException ex)
            {
                LOG.error(instance(CLOSE) + "Failed Connection close on " + this, ex);
            }
            statementExecutionCount = 0;
            removeConnection();
            closed = true;
        }
    }

    /**
     * Rolls back connection.
     *
     * @throws DatabaseException  if database error occurs performing the rollback.
     */
    public void rollback()
    {
        if (this.dataSourceProperties.isCommitAndRollbackSupported())
        {
            checkConnection();
            try
            {
                connection.rollback();
                if (LOG.isDebugEnabled())
                {
                    LOG.debug(instance("rollback()") + "complete.");
                }
            }
            catch (SQLException ex)
            {
                throw new DatabaseException(ex, "Catastrophic rollback error!");
            }
            finally
            {
                statementExecutionCount = 0;
            }
        }
    }

    /**
     * Commits connection.
     *
     * @throws SQLException  if database error occurs performing the commit.
     */
    public void commit()
        throws SQLException
    {
        if (this.dataSourceProperties.isCommitAndRollbackSupported())
        {
            checkConnection();
            try
            {
                connection.commit();
                if (LOG.isDebugEnabled())
                {
                    LOG.debug(instance("commit()") + "complete.");
                }
            }
            finally
            {
                statementExecutionCount = 0;
            }
        }
    }

    private void checkConnection()
    {
        if (closed)
        {
            throw new IllegalStateException(this + ": connection is closed.");
        }
    }

    /**
     * Closes the connection resource if open.
     *
     * @exception Throwable  Description of the Exception
     */
    protected void finalize()
        throws Throwable
    {
        close();
        this.removeInstance();
        super.finalize();

    }
}
