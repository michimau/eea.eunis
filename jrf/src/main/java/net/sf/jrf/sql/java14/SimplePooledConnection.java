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
package net.sf.jrf.sql.java14;

import java.io.*;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;
import org.apache.log4j.Category;

/**
 * An implementation of <code>PooledConnection</code> designed to work with
 *  <code>SimpleDataSource</code> with Java 1.4 implementations of <code>java.sql.Connection</code>.
 * <strong>NOTE: Version 1.4 methods have NOT been completely tested</strong>.
 */
public class SimplePooledConnection implements javax.sql.PooledConnection, java.sql.Connection
{
    private Vector listeners;// Registered ConnectionEventListeners
    private Connection connection;// The 'real' connection which underlies this
    private Vector connectionStatements;// Statements created for this connection.
    private final static Category LOG = Category.getInstance(SimplePooledConnection.class.getName());
    long lastGetTime = 0L;


    SimplePooledConnection(Connection connection)
    {
        listeners = new Vector();
        this.connection = connection;
        this.connectionStatements = new Vector();
        lastGetTime = System.currentTimeMillis();
    }

    /**
     * @param listener  The feature to be added to the ConnectionEventListener attribute
     * @see             javax.sql.PooledConnection#addConnectionEventListener(ConnectionEventListener) *
     */
    public void addConnectionEventListener(ConnectionEventListener listener)
    {
        if (listeners.contains(listener) == false)
        {
            listeners.addElement(listener);
        }
    }

    /**
     * Returns underlying connection handle <code>toString()</code>. *
     *
     * @return   Description of the Return Value
     */
    public String toString()
    {
        return "SimplePooledConnection: underlying physical connection [" + connection.toString() + "]";
    }

    /**
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#close() *
     */
    public void close()
        throws SQLException
    {
        int i;
        if (LOG.isDebugEnabled())
        {
            LOG.debug("close() on connection with " + connectionStatements.size() + " statements. ");
        }
        for (i = 0; i < connectionStatements.size(); i++)
        {
            Statement s = (Statement) connectionStatements.elementAt(i);
            try
            {
                s.close();
            }
            catch (SQLException e)
            {

            }
        }
        connectionStatements.clear();

        boolean connError = false;
        SQLException err = null;
        try
        {
            connection.commit();
            connError = connection.isClosed();
        }
        catch (SQLException ex)
        {
            err = ex;
            connError = true;
        }
        ConnectionEvent ce;
        if (connError)
        {
            if (err == null)
            {
                err = new SQLException("Connection handle is no longer valid.");
            }
            ce = new ConnectionEvent(this, err);
            for (i = 0; i < listeners.size(); i++)
            {
                ConnectionEventListener cl = (ConnectionEventListener) listeners.elementAt(i);
                cl.connectionErrorOccurred(ce);
            }
        }
        else
        {
            ce = new ConnectionEvent(this);
            for (i = 0; i < listeners.size(); i++)
            {
                ConnectionEventListener cl = (ConnectionEventListener) listeners.elementAt(i);
                cl.connectionClosed(ce);
            }
        }
    }


    /**
     * @return                  The closed value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#isClosed() *
     */
    public boolean isClosed()
        throws SQLException
    {
        return connection.isClosed();
    }

    /**
     * @return                  The connection value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getConnection() *
     */
    public Connection getConnection()
        throws SQLException
    {
        return connection;
    }

    /**
     * @param listener  Description of the Parameter
     * @see             javax.sql.PooledConnection#removeConnectionEventListener(ConnectionEventListener) *
     */
    public void removeConnectionEventListener(ConnectionEventListener listener)
    {
        listeners.removeElement(listener);
    }

    /**
     * @return                  Description of the Return Value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#createStatement() *
     */
    public Statement createStatement()
        throws SQLException
    {
        Statement stmt = connection.createStatement();
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /**
     * @param resultSetType         Description of the Parameter
     * @param resultSetConcurrency  Description of the Parameter
     * @return                      Description of the Return Value
     * @exception SQLException      Description of the Exception
     * @see                         java.sql#createStatement(int,int) *
     */
    public Statement createStatement(int resultSetType, int resultSetConcurrency)
        throws SQLException
    {
        Statement stmt = connection.createStatement(resultSetType, resultSetConcurrency);
        connectionStatements.addElement(stmt);
        return stmt;
    }


    /**
     * @param sql               Description of the Parameter
     * @return                  Description of the Return Value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#prepareStatement(String) *
     */
    public PreparedStatement prepareStatement(String sql)
        throws SQLException
    {
        PreparedStatement stmt = connection.prepareStatement(sql);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /**
     * @param sql                   Description of the Parameter
     * @param resultSetType         Description of the Parameter
     * @param resultSetConcurrency  Description of the Parameter
     * @return                      Description of the Return Value
     * @exception SQLException      Description of the Exception
     * @see                         java.sql#prepareStatement(String,int,int) *
     */
    public PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency)
        throws SQLException
    {
        PreparedStatement stmt = connection.prepareStatement(sql, resultSetType, resultSetConcurrency);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /**
     * @param sql               Description of the Parameter
     * @return                  Description of the Return Value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#prepareCall(String) *
     */
    public CallableStatement prepareCall(String sql)
        throws SQLException
    {
        CallableStatement stmt = connection.prepareCall(sql);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /**
     * @param sql                   Description of the Parameter
     * @param resultSetType         Description of the Parameter
     * @param resultSetConcurrency  Description of the Parameter
     * @return                      Description of the Return Value
     * @exception SQLException      Description of the Exception
     * @see                         java.sql#prepareCall(String,int,int) *
     */
    public CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency)
        throws SQLException
    {
        CallableStatement stmt = connection.prepareCall(sql, resultSetType, resultSetConcurrency);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /**
     * @param sql               Description of the Parameter
     * @return                  Description of the Return Value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#NativeSql(String) *
     */
    public String nativeSQL(String sql)
        throws SQLException
    {
        return connection.nativeSQL(sql);
    }

    /**
     * @param autoCommit        The new autoCommit value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#setAutoCommit(boolean) *
     */
    public void setAutoCommit(boolean autoCommit)
        throws SQLException
    {
        if (!this.getAutoCommit())
        {
            connection.commit();
        }// Failing to do this will cause a host of problems.
        connection.setAutoCommit(autoCommit);
        if (LOG.isDebugEnabled())
        {
            LOG.debug("setAutoCommit(" + autoCommit + ")");
        }
    }

    /**
     * @return                  The autoCommit value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getAutoCommit() *
     */
    public boolean getAutoCommit()
        throws SQLException
    {
        return connection.getAutoCommit();
    }

    /**
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#commit() *
     */
    public void commit()
        throws SQLException
    {
        connection.commit();
    }

    /**
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#rollback() *
     */
    public void rollback()
        throws SQLException
    {
        connection.rollback();
    }

    /**
     * @return                  The metaData value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getMetaData() *
     */
    public DatabaseMetaData getMetaData()
        throws SQLException
    {
        return connection.getMetaData();
    }


    /**
     * @param readOnly          The new readOnly value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#setReadOnly(boolean) *
     */
    public void setReadOnly(boolean readOnly)
        throws SQLException
    {
        connection.setReadOnly(readOnly);
    }

    /**
     * @return                  The readOnly value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getReadOnly() *
     */
    public boolean isReadOnly()
        throws SQLException
    {
        return connection.isReadOnly();
    }

    /**
     * @param catalog           The new catalog value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#setCatalog(String) *
     */
    public void setCatalog(String catalog)
        throws SQLException
    {
        connection.setCatalog(catalog);
    }

    /**
     * @return                  The catalog value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getCatalog() *
     */
    public String getCatalog()
        throws SQLException
    {
        return connection.getCatalog();
    }

    /**
     * @param level             The new transactionIsolation value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#setTransactionIsolation(int) *
     */
    public void setTransactionIsolation(int level)
        throws SQLException
    {
        connection.setTransactionIsolation(level);
    }

    /**
     * @return                  The transactionIsolation value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getTransactionIsolation() *
     */
    public int getTransactionIsolation()
        throws SQLException
    {
        return connection.getTransactionIsolation();
    }

    /**
     * @return                  The warnings value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getWarnings() *
     */
    public SQLWarning getWarnings()
        throws SQLException
    {
        return connection.getWarnings();
    }

    /**
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#clearWarnings() *
     */
    public void clearWarnings()
        throws SQLException
    {
        connection.clearWarnings();
    }


    /**
     * @return                  The typeMap value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#getTypeMap() *
     */
    public java.util.Map getTypeMap()
        throws SQLException
    {
        return connection.getTypeMap();
    }

    /**
     * @param map               The new typeMap value
     * @exception SQLException  Description of the Exception
     * @see                     java.sql#setTypeMap(Map) *
     */
    public void setTypeMap(java.util.Map map)
        throws SQLException
    {
        connection.setTypeMap(map);
    }

    /******************************************************************/
    /** 1.4 new methods ****/
    /******************************************************************/
    /** @see			java.sql#getHoldability() **/
    public int getHoldability() 
                          throws SQLException {
        return connection.getHoldability();
    }

    /** @see			java.sql#setHoldability(int) **/
    public void setHoldability(int holdability) 
                          throws SQLException {
        connection.setHoldability(holdability);
    }

    /** @see		        java.sql#setSavepoint() **/
    public Savepoint setSavepoint()
                       throws SQLException {
        return connection.setSavepoint();
    }

    /** @see		        java.sql#setSavepoint(String) **/
    public Savepoint setSavepoint(String name)
                       throws SQLException {
        return connection.setSavepoint(name);
    }

    /** @see                    java.sql#rollback(Savepoint) **/
    public void rollback(Savepoint savepoint)
              throws SQLException {
         connection.rollback(savepoint);
    }

    /** @see                    java.sql#releaseSavepoint(Savepoint) **/
    public void releaseSavepoint(Savepoint savepoint)
                      throws SQLException {

    }

    /** @see                    java.sql#createStatement(int,int,int) **/
    public Statement createStatement(int resultSetType,
                                 int resultSetConcurrency,
                                 int resultSetHoldability)
                          throws SQLException {
        Statement stmt = connection.createStatement(resultSetType,resultSetConcurrency,resultSetHoldability);
        connectionStatements.addElement(stmt);
        return stmt;
    }


    /** @see                    java.sql#prepareStatement(String,int,int,int) **/
    public PreparedStatement prepareStatement(String sql,int resultSetType,
                                 int resultSetConcurrency,
                                 int resultSetHoldability)
                          throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(sql,resultSetType,resultSetConcurrency,resultSetHoldability);
        connectionStatements.addElement(stmt);
        return stmt;
    }


    /** @see                    java.sql#prepareCall(String,int,int,int) **/
    public CallableStatement prepareCall(String sql,int resultSetType,
                                 int resultSetConcurrency,
                                 int resultSetHoldability)
                          throws SQLException {
        CallableStatement stmt = connection.prepareCall(sql,resultSetType,resultSetConcurrency,resultSetHoldability);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /** @see                    java.sql#prepareStatement(String,int) **/
    public PreparedStatement prepareStatement(String sql, int autoGeneratedKeys) 
                          throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(sql,autoGeneratedKeys);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /** @see                    java.sql#prepareStatement(String,int[]) **/
    public PreparedStatement prepareStatement(String sql, int [] columnIndexes) 
                          throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(sql,columnIndexes);
        connectionStatements.addElement(stmt);
        return stmt;
    }

    /** @see                    java.sql#prepareStatement(String,String[]) **/
    public PreparedStatement prepareStatement(String sql, String [] columnNames) 
                          throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(sql,columnNames);
        connectionStatements.addElement(stmt);
        return stmt;
    }
}
