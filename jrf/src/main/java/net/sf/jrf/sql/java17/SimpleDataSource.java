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
 * Contributor: James Evans (jevans@vmguys.com)
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
package net.sf.jrf.sql.java17;

import java.io.*;
import java.lang.reflect.Method;
import java.sql.*;
import java.util.*;
import java.util.logging.Logger;
import javax.naming.*;
import javax.sql.*;
import org.apache.log4j.Category;

/**
 * A relatively simple, but workable version of a data source connection pool.
 * This implementation does not spawn a clean up thread and does not wrap
 * any underlying JDBC class other than the requisite <code>Connection</code>
 * class.
 * <p>
 * A trim method does exist for applications to use to trim the connection pool.
 */
public class SimpleDataSource implements javax.sql.ConnectionPoolDataSource,
    javax.sql.DataSource, ConnectionEventListener, javax.naming.Referenceable,
    javax.naming.spi.ObjectFactory, java.io.Serializable, java.rmi.Remote
{

    private final static Category LOG = Category.getInstance(SimpleDataSource.class.getName());

    private int timeout = 10;// login time for data source.
    private long waitForConnTime = 3000L;// Time to block on ready connection queue.
    private long staleConnectionCheckInterval = 300 * 1000L;// Interval to check for stale connections.
    private String i_url = null;// URF  for database
    private String i_driverClass = null;// Vendor class name for driver.
    private String i_user = null;// User name for connect
    private String i_password = null;// Password for connect.
    private String testSql = null;// Test SQL to test for stale connections.
    private Object driver = null;// Instance of the vendor driver.
    private int poolMin = 1;// Minimum pool size.
    private int poolMax = 10;// Maximum pool size.
    private Vector pooledConnections;// Pool of created connections
    private Vector readyQueue;


    /** Constructs a simple data source */
    public SimpleDataSource()
    {
        pooledConnections = new Vector();// initially empty
        readyQueue = new Vector();// initially empty
    }

    /**
     * Constructs a data source with given parameters.
     *
     * @param driverClass  driver class name
     * @param url          URL for database connection.
     * @param user         user name.
     * @param password     password to use.
     */
    public SimpleDataSource(
        String driverClass,
        String url,
        String user,
        String password)
    {
        this();
        setDriverClassName(driverClass);
        setUser(user);
        setPassword(password);
        setURL(url);
    }// Queue of available (non-used) PooledConnections

    static
    {
    }

    /**
     * Returns parameter information for the connection
     *
     * @return           Description of the Return Value
     */
    public String toString()
    {
        return "Driver class: " + i_driverClass + "\n" +
            "URL: " + i_url + "\n" +
            "User: " + i_user + "\n" +
            "Password: " + i_password + "\n" +
            "Test SQL: " + testSql + "\n" +
            "Min Pool Size: " + poolMin + "\n" +
            "Max Pool Size: " + poolMax + "\n" +
            "Login time out: " + timeout + "\n";
    }

    /**
     * Sets the amount of time in seconds to lag before connection should
     * be tested to see if it is still valid. Default value is <code>300</code> seconds
     * or <code>5</code> minutes.
     *
     * @param staleConnectionCheckInterval  connection check interval in seconds.
     * @see                                 #setTestSql(String)
     */
    public void setStaleConnectionCheckInterval(int staleConnectionCheckInterval)
    {
        this.staleConnectionCheckInterval = (long) staleConnectionCheckInterval * 1000L;
    }

    /**
     * Gets the amount of time in seconds to lag before connection should
     * be tested to see if it is still valid.
     *
     * @return   param staleConnectionCheckInterval maximum pool size.
     * @see      #setStaleConnectionCheckInterval(int)
     */
    public int getStaleConnectionCheckInterval()
    {
        return (int) (this.staleConnectionCheckInterval / 1000L);
    }

    /**
     * Sets the maximum pool size. Default value is <code>10</code>
     *
     * @param poolMax  maximum pool size.
     */
    public void setPoolMax(int poolMax)
    {
        this.poolMax = poolMax;
    }

    /**
     * Gets the maximum pool size. Default value is <code>10</code>
     *
     * @return   maximum pool size.
     */
    public int getPoolMax()
    {
        return this.poolMax;
    }

    /**
     * Gets the maximum pool size. Default value is <code>1</code>
     *
     * @param poolMin  minimum pool size.
     */
    public void setPoolMin(int poolMin)
    {
        this.poolMin = poolMin;
    }

    /**
     * Gets the miniumn pool size. Default value is <code>1</code>
     *
     * @return   miniumn pool size.
     */
    public int getPoolMin()
    {
        return this.poolMin;
    }

    /**
     * Sets driver class name
     *
     * @param driverClass  driver class name
     */
    public void setDriverClassName(String driverClass)
    {
        i_driverClass = driverClass;
    }

    /**
     * Gets driver class name
     *
     * @return   driver class name
     */
    public String getDriverClassName()
    {
        return i_driverClass;
    }

    /**
     * Sets URL for database connection.
     *
     * @param url  URL for database connection.
     */
    public void setURL(String url)
    {
        i_url = url;
    }

    /**
     * Gets URL for database connection.
     *
     * @return   URL for database connection.
     */
    public String getURL()
    {
        return i_url;
    }

    /**
     * Sets testing SQL for database connection. The test
     * should be a fairly simple statement to validate that
     * a connection is still valid (e.g. "select getdate()" under
     * Sybase or "select sysdate from dual" under Oracle).
     *
     * @param testSql  test SQL statement to use for validating a connection.
     */
    public void setTestSql(String testSql)
    {
        this.testSql = testSql;
    }

    /**
     * Gets test sql for database connection.
     *
     * @return   test sql for database connection.
     */
    public String getTestSql()
    {
        return this.testSql;
    }

    /**
     * Sets user for database connection.
     *
     * @param user  user for database connection.
     */
    public void setUser(String user)
    {
        i_user = user;
    }

    /**
     * Gets user for database connection.
     *
     * @return   user for database connection.
     */
    public String getUser()
    {
        return i_user;
    }

    /**
     * Sets password for database connection.
     *
     * @param password  password for database connection.
     */
    public void setPassword(String password)
    {
        i_password = password;
    }

    /**
     * Gets password for database connection.
     *
     * @return   assword for database connection.
     */
    public String setPassword()
    {
        return i_password;
    }

    /**
     * @return                     The reference value
     * @exception NamingException  Description of the Exception
     * @see                        javax.naming.Referenceable#getReference() *
     */
    public Reference getReference()
        throws NamingException
    {
        String className = this.getClass().getName();
        Reference ref = new Reference(className, className, null);
        Object value;
        if (i_driverClass != null)
        {
            ref.add(new StringRefAddr("DriverClassName", i_driverClass));
        }
        if (i_url != null)
        {
            ref.add(new StringRefAddr("URL", i_url));
        }
        if (i_user != null)
        {
            ref.add(new StringRefAddr("User", i_user));
        }
        if (i_password != null)
        {
            ref.add(new StringRefAddr("Password", i_password));
        }
        if (testSql != null)
        {
            ref.add(new StringRefAddr("TestSql", testSql));
        }
        ref.add(new StringRefAddr("PoolMax", Integer.toString(getPoolMax())));
        ref.add(new StringRefAddr("PoolMin", Integer.toString(getPoolMin())));
        ref.add(new StringRefAddr("StaleConnectionCheckInterval", Integer.toString(getStaleConnectionCheckInterval())));
        return ref;
    }

    /**
     * @param refObj         Description of the Parameter
     * @param name           Description of the Parameter
     * @param nameCtx        Description of the Parameter
     * @param env            Description of the Parameter
     * @return               The objectInstance value
     * @exception Exception  Description of the Exception
     * @see                  javax.naming.spi.ObjectFactory#getObjectInstance(Object,Name,Context,Hashtable) *
     */
    public Object getObjectInstance(Object refObj, Name name, Context nameCtx, java.util.Hashtable env)
        throws Exception
    {
        Reference ref = (Reference) refObj;
        RefAddr refadr;
        String className = ref.getClassName();
        if (className.equals(this.getClass().getName()))
        {
            if ((refadr = ref.get("DriverClassName")) != null)
            {
                setDriverClassName((String) refadr.getContent());
            }
            if ((refadr = ref.get("URL")) != null)
            {
                setURL((String) refadr.getContent());
            }
            if ((refadr = ref.get("User")) != null)
            {
                setUser((String) refadr.getContent());
            }
            if ((refadr = ref.get("Password")) != null)
            {
                setPassword((String) refadr.getContent());
            }
            if ((refadr = ref.get("TestSql")) != null)
            {
                setTestSql((String) refadr.getContent());
            }
            if ((refadr = ref.get("PoolMin")) != null)
            {
                setPoolMax(Integer.valueOf((String) refadr.getContent()).intValue());
            }
            if ((refadr = ref.get("PoolMax")) != null)
            {
                setPoolMin(Integer.valueOf((String) refadr.getContent()).intValue());
            }
            if ((refadr = ref.get("StaleConnectionTestInterval")) != null)
            {
                setStaleConnectionCheckInterval(Integer.valueOf((String) refadr.getContent()).intValue());
            }
            return this;
        }
        else
        {
            return null;
        }
    }

    /**
     * @param event  Description of the Parameter
     * @see          javax.sql.ConnectionEventListener#connectionClosed(ConnectionEvent) *
     */
    public void connectionClosed(ConnectionEvent event)
    {
        // See SimplePooledConnection.close()
        if (LOG.isDebugEnabled())
        {
            LOG.debug("connectionClosed(" + event.getSource() + ")");
        }
        if (pooledConnections.contains(event.getSource()))
        {
            synchronized (readyQueue)
            {
                readyQueue.addElement(event.getSource());
                // Unblock waiting threads - see getPooledConnection()
                readyQueue.notifyAll();
                if (LOG.isDebugEnabled())
                {
                    LOG.debug("connectionClosed(" + event + "); ready queue size is " + readyQueue.size());
                }
            }
        }
    }


    /**
     * @param event  Description of the Parameter
     * @see          javax.sql.ConnectionEventListener#connectionClosed(ConnectionEvent) *
     */
    public void connectionErrorOccurred(ConnectionEvent event)
    {
        // See SimplePooledConnection.close()
        LOG.error("connectionErrorOccurred(" + event + ")", event.getSQLException());
        if (pooledConnections.contains(event.getSource()))
        {
            synchronized (readyQueue)
            {
                readyQueue.remove(event.getSource());
            }
            synchronized (pooledConnections)
            {
                pooledConnections.remove(event.getSource());

            }
        }
    }

    /** Trims the queue to the mininum size specified * */
    public synchronized void trimPool()
    {
        // If ready queue is smaller than or equal to the minimum, there is nothing to do.
        if (readyQueue.size() <= poolMin)
        {
            return;
        }
        int reduction = readyQueue.size() - poolMin;
        for (int i = 0; i < reduction; i++)
        {
            pooledConnections.removeElement(readyQueue.elementAt(0));
            readyQueue.removeElementAt(0);
        }
    }

    /**
     * @return                  The connection value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.DataSource#getConnection() *
     */
    public Connection getConnection()
        throws SQLException
    {
        return (Connection) getPooledConnection(i_user, i_password);
    }

    /**
     * @return                  The pooledConnection value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.ConnectionPoolDataSource#getPooledConnection() *
     */
    public PooledConnection getPooledConnection()
        throws SQLException
    {
        return getPooledConnection(i_user, i_password);
    }

    /**
     * @param user              Description of the Parameter
     * @param password          Description of the Parameter
     * @return                  The connection value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.DataSource#getConnection(String,String) *
     */
    public Connection getConnection(String user, String password)
        throws SQLException
    {
        return (Connection) getPooledConnection(user, password);
    }

    /**
     * @param user              Description of the Parameter
     * @param password          Description of the Parameter
     * @return                  The pooledConnection value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.ConnectionPoolDataSource#getPooledConnection(String,String) *
     */
    public PooledConnection getPooledConnection(String user, String password)
        throws SQLException
    {
        checkDriver();
        PooledConnection pc = null;
        ///////////////////////////////////////////////////////////////////////
        // First check the readyQueue and distribute a PooledConnection from
        // there if available.
        ///////////////////////////////////////////////////////////////////////
        pc = checkReadyQueue(false);// false = don't block on queue for a connection.
        if (pc != null)
        {
            LOG.debug("getPooledConnection(" + user + "," + password + "): readyQueue has a connection; queue size is now " +
                readyQueue.size());
            return pc;
        }
        ///////////////////////////////////////////////////////////////////////
        // There's nothing available in the readyQueue - check to
        // see if the Pool has reached maximum capacity.
        // If not, create a new connection.
        ///////////////////////////////////////////////////////////////////////
        synchronized (pooledConnections)
        {
            if (pooledConnections.size() < poolMax)
            {
                pc = new SimplePooledConnection(DriverManager.getConnection(i_url, user, password));
                pc.addConnectionEventListener(this);
                pooledConnections.add(pc);
                if (LOG.isDebugEnabled())
                {
                    LOG.debug("getPooledConnection(" + user + "," + password + "): new connection created; pool size is now " +
                        pooledConnections.size());
                }
                return pc;
            }
        }
        if (LOG.isDebugEnabled())
        {
            LOG.debug("getPooledConnection(" + user + "," + password + ") called with maximum connections " + (poolMax) +
                " busy; blocking for 3 seconds to hope for a connection release.");
        }
        pc = checkReadyQueue(true);// true = block for a queue for a connection.
        if (pc == null)
        {
            throw new SQLException("Maximum connections (" + poolMax + ") in use. Unable to provide a connection.");
        }
        return pc;
    }

    private PooledConnection checkReadyQueue(boolean waitForConnection)
    {
        synchronized (readyQueue)
        {
            long now;
            if (readyQueue.size() == 0)
            {
                if (!waitForConnection)
                {
                    return null;
                }
                now = System.currentTimeMillis();
                long endTime = now + waitForConnTime;
                while (now < endTime && readyQueue.size() == 0)
                {
                    try
                    {
                        readyQueue.wait(endTime - now);
                    }
                    catch (InterruptedException e)
                    {
                        Thread.currentThread().interrupt();
                    }
                    now = System.currentTimeMillis();
                }
            }
            while (readyQueue.size() > 0)
            {
                SimplePooledConnection pc = null;
                now = System.currentTimeMillis();
                pc = (SimplePooledConnection) readyQueue.remove(0);// LRU PooledConnection reuse
                // Make sure it isn't stale -- testsql must exist.
                // Last "get" time is used, which should normally translate to the last touched
                // time for the connection.  If not, no harm is done to check the connection.
                if (this.testSql != null && (now - pc.lastGetTime) > staleConnectionCheckInterval)
                {
                    try
                    {
                        Statement s = pc.createStatement();
                        LOG.debug("Testing a stale connection with [" + testSql + "]");
                        s.execute(testSql);
                        s.close();
                    }
                    catch (SQLException ex)
                    {
                        LOG.debug("Found stale connection. " + testSql + " failed: " + ex.getMessage());
                        synchronized (pooledConnections)
                        {
                            pooledConnections.remove(pc);
                        }
                        continue;
                    }
                }
                pc.lastGetTime = now;
                return pc;
            }
        }
        return null;
    }



    /**
     * @return                  The logWriter value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.ConnectionPoolDataSource#getLogWriter() *
     */
    public PrintWriter getLogWriter()
        throws SQLException
    {
        checkDriver();
        return DriverManager.getLogWriter();
    }

    /**
     * @param w                 The new logWriter value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.ConnectionPoolDataSource#setLogWriter(PrintWriter) *
     */
    public void setLogWriter(PrintWriter w)
        throws SQLException
    {
        checkDriver();
        DriverManager.setLogWriter(w);
    }

    /**
     * @param timeout           The new loginTimeout value
     * @exception SQLException  Description of the Exception
     * @see                     javax.sql.ConnectionPoolDataSource#setLoginTimeout(int) *
     */
    public void setLoginTimeout(int timeout)
        throws SQLException
    {
        this.timeout = timeout;
        checkDriver();
        DriverManager.setLoginTimeout(timeout);
    }

    /**
     * @return   The loginTimeout value
     * @see      javax.sql.ConnectionPoolDataSource#getLoginTimeout() *
     */
    public int getLoginTimeout()
    {
        return this.timeout;
    }

    /*
     * New since 1.7
     */

    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        throw new SQLFeatureNotSupportedException();
    }

    @Override
    public <T> T unwrap(Class<T> iface) throws SQLException {
        throw new SQLException();
    }

    @Override
    public boolean isWrapperFor(Class<?> iface) throws SQLException {
        return false;
    }

    /*
     * Private
     */
    private Properties getProperties(String user, String password)
    {
        Properties p = new Properties();
        p.put("user", user);
        if (password != null)
        {
            p.put("password", password);
        }
        return p;
    }

    private void checkDriver()
        throws SQLException
    {
        if (driver != null)
        {
            return;
        }
        try
        {
            driver = Class.forName(i_driverClass).newInstance();
        }
        catch (Exception e)
        {
            LOG.error("Unable to create driver.", e);
            throw new SQLException("Unable to create driver: Exception was: " +
                e.getClass().getName() + ": msg " + e.getMessage());
        }
    }
}

