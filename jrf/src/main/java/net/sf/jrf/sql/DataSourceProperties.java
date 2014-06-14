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
package net.sf.jrf.sql;

import java.sql.*;
import java.util.*;
import net.sf.jrf.*;
import net.sf.jrf.exceptions.ConfigurationException;

/**
 * Class that holds datasource-specific properties. The properties
 *   stored in this class are:
 * <ol>
 * <li> <code>DatabaseMetaData<code> properties.  Value may be set
 * 	after a connection has been established.
 * <li> <code>DatabasePolicy</code> implementation to use.
 * <li> Various driver-specific properties that are unfortunately not included
 *      in <code>java.sql.DatabaseMetaData</code>.  For example, you may specify
 *      here whether <code>Clob</code>s are supported by the driver.
 * </ol>
 *
 * @see   net.sf.jrf.DatabasePolicy
 */
public class DataSourceProperties implements Cloneable
{
    private DatabaseMetaData metaData;
    private DatabasePolicy policy = null;
    private Class policyClass;

    private boolean ansiJoinSupported = true;
    private boolean bigDecimalSupported = false;
    private boolean preparedSetBooleanSupported = false;
    private boolean binaryStreamsSupported = false;
    private boolean resultSetGetBooleanSupported = false;
    private boolean blobSupported = false;
    private boolean clobSupported = false;
    private boolean transactionsForDropAndCreateSupported = false;
    private boolean commitAndRollbackSupported = true;

    private String dbType;

    /**
     * Constructs a <code>DataSourceProperties</code> instance.
     * Set methods must be called to make this class useful.
     */
    public DataSourceProperties() { }

    /**
     * Constructs a <code>DataSourceProperties</code> instance
     * using <code>Properties</code> instance.  The framework JRF properties will be searched for
     * a value if the values is not found in the supplied <code>Properties</code>
     * argument.
     *
     * @param p                           <code>Properties</code> instance to check first for a key value.  Value
     * will be sought in JRF framework properties if not found in <code>p</code>.
     * @exception ConfigurationException  Description of the Exception
     * @throws ConfigurationException     if policy <code>Class</code> instance could not be found or
     *  policy instance could not be created.
     */
    public DataSourceProperties(Properties p)
        throws ConfigurationException
    {
        this(JRFConnectionFactory.findDbType(p), p);
    }


    /**
     * Constructs a <code>DataSourceProperties</code> instance
     * using the supplied database type key and <code>Properties</code>
     * instance.  The framework JRF properties will be searched for
     * a value if the values is not found in the supplied <code>Properties</code>
     * argument.
     *
     * @param dbType                      database type key to use in searching for properties.
     * @param p                           <code>Properties</code> instance to check first for a key value.  Value
     * will be sought in JRF framework properties if not found in <code>p</code>.
     * @exception ConfigurationException  Description of the Exception
     * @throws ConfigurationException     if policy <code>Class</code> instance could not be found or
     *  policy instance could not be created.
     */
    public DataSourceProperties(String dbType, Properties p)
        throws ConfigurationException
    {
        this.dbType = dbType;
        transactionsForDropAndCreateSupported =
            JRFProperties.resolveBooleanProperty(p, dbType + ".transactionsForDropAndCreateSupported", false);
        ansiJoinSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".ansiJoinSupported", true);
        bigDecimalSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".bigDecimalSupported", true);
        preparedSetBooleanSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".preparedSetBooleanSupported", true);
        resultSetGetBooleanSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".resultSetGetBooleanSupported", false);
        blobSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".blobSupported", false);
        clobSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".clobSupported", false);
        commitAndRollbackSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".commitAndRollbackSupported", true);
        binaryStreamsSupported = JRFProperties.resolveBooleanProperty(p, dbType + ".binaryStreamsSupported", true);
        setDatabasePolicy(JRFProperties.resolveRequiredStringProperty(p, dbType + ".databasePolicy",
            "An implementation of 'jrf.sf.net.DatabasePolicy' must be specified to obtain a database connection."));
    }

    /**
     * Gets an instance based on the default JRF <code>Properties</code>
     * settings.
     *
     * @return   <code>DataSourceProperties</code> instance using default
     * JRF <code>Properties</code> settings.
     */
    public static DataSourceProperties getInstance()
    {
        return new DataSourceProperties(JRFProperties.getRequiredStringProperty("dbtype",
            "Unable to create DataSourceProperties instance; dbtype must be specified."),
            JRFProperties.getProperties());
    }

    /**
     * Returns a description of all properties.
     *
     * @return   a description of all set properties.
     */
    public String toString()
    {
        return "\n" +
            "dbtype = " + dbType + "\n" +
            "ANSI joins supported  = " + ansiJoinSupported + "\n" +
            "BigDecimal supported  = " + bigDecimalSupported + "\n" +
            "BinaryStreams  supported  = " + binaryStreamsSupported + "\n" +
            "Commits/Rollbacks supported  = " + commitAndRollbackSupported + "\n" +
            "Prepared set Boolean supported  = " + preparedSetBooleanSupported + "\n" +
            "Result set get Boolean supported  = " + resultSetGetBooleanSupported + "\n" +
            "Support transactions for drop and create  = " + transactionsForDropAndCreateSupported + "\n" +
            "Blob supported  = " + blobSupported + "\n" +
            "Clob supported  = " + clobSupported + "\n" +
            "Policy class = " + policyClass + "\n";
    }

    /**
     * Sets the name if the implementation class of
     * <code>net.sf.jrf.DatabasePolicy</code>.
     *
     * @param databasePolicyImplClassName  name of policy implementation class.
     * @throws ConfigurationException      if policy <code>Class</code> instance could not be found or
     *  policy instance could not be created.
     */
    public void setDatabasePolicy(String databasePolicyImplClassName)
        throws ConfigurationException
    {
        try
        {
            policyClass = java.lang.Class.forName(databasePolicyImplClassName);
        }
        catch (Exception e)
        {
            throw new ConfigurationException(e,
                "Unable to to find class " + databasePolicyImplClassName);
        }
        policy = createPolicy(policyClass);
    }

    /**
     * Sets the implementation instance of
     * <code>net.sf.jrf.DatabasePolicy</code>.
     *
     * @param policy              The new databasePolicy value
     */
    public void setDatabasePolicy(DatabasePolicy policy)
    {
        this.policy = policy;
    }

    /**
     * Returns applicable <code>DatabasePolicy</code> instance
     * for the data source.
     *
     * @return   applicable <code>DatabasePolicy</code> instance.
     */
    public DatabasePolicy getDatabasePolicy()
    {
        return policy;
    }

    /**
     * Creates a database policy instance.
     *
     * @param c                        <code>DatabasePolicy</code> implementation class.
     * @return                         Description of the Return Value
     * @throws ConfigurationException  if policy instance could not be created.
     */
    public static DatabasePolicy createPolicy(Class c)
    {
        try
        {
            return (DatabasePolicy) c.newInstance();
        }
        catch (Exception e)
        {
            throw new ConfigurationException(e, "Unable to instantiate " + c);
        }
    }

    /**
     * Returns <code>true</code> if ANSI joins are supported by
     * data source.
     *
     * @return   <code>true</code> if ANSI joins are supported by data source.
     */
    public boolean isAnsiJoinSupported()
    {
        return this.ansiJoinSupported;
    }

    /**
     * Sets whether ANSI joins are supported by data source.
     *
     * @param b  if <code>true</code>, ANSI joins are supported by data source.
     */
    public void setAnsiJoinSupported(boolean b)
    {
        this.ansiJoinSupported = b;
    }

    /**
     * Sets whether binary streams are supported by data source.
     *
     * @param b  if <code>true</code>, binary streams are supported by data source.
     */
    public void setBinaryStreamSupported(boolean b)
    {
        this.binaryStreamsSupported = b;
    }

    /**
     * Returns <code>true</code> if binary streams are supported by data source.
     *
     * @return   <code>true</code>, binary streams are supported by data source.
     */
    public boolean isBinaryStreamSupported()
    {
        return this.binaryStreamsSupported;
    }

    /**
     * Sets database meta data instance. TODO
     *
     * @param metaData  <code>DatabaseMetaData</code> instance.
     */
    public void setDatabaseMetaData(DatabaseMetaData metaData)
    {
        this.metaData = metaData;
    }

    /**
     * Sets whether prepared statement set <code>BigDecimal</code> is supported.
     *
     * @param bigDecimalSupported  if <code>true</code> prepared statement set <code>BigDecimal</code>
     * is supported.
     */
    public void setBigDecimalSupported(boolean bigDecimalSupported)
    {
        this.bigDecimalSupported = bigDecimalSupported;
    }

    /**
     * Returns <code>true</code> if  prepared statement <code>BigDecimal</code> is supported.
     *
     * @return   <code>true</code> if prepared statement set <code>BigDecimal</code>
     * is supported.
     */
    public boolean isBigDecimalSupported()
    {
        return bigDecimalSupported;
    }


    /**
     * Sets whether a result set get <code>Boolean</code> is supported.
     *
     * @param resultSetGetBooleanSupported  if <code>true</code> result set get <code>Boolean</code>
     * is supported.
     */
    public void setResultSetGetBooleanSupported(boolean resultSetGetBooleanSupported)
    {
        this.resultSetGetBooleanSupported = resultSetGetBooleanSupported;
    }

    /**
     * Returns <code>true</code> if  prepared statement set <code>Boolean</code> is supported.
     *
     * @return   <code>true</code> if result set get <code>Boolean</code>
     */
    public boolean isResultSetGetBooleanSupported()
    {
        return resultSetGetBooleanSupported;
    }

    /**
     * Sets whether prepared statement set <code>Boolean</code> is supported.
     *
     * @param preparedSetBooleanSupported  if <code>true</code> prepared statement set <code>Boolean</code>
     * is supported.
     */
    public void setPreparedSetBooleanSupported(boolean preparedSetBooleanSupported)
    {
        this.preparedSetBooleanSupported = preparedSetBooleanSupported;
    }

    /**
     * Returns <code>true</code> if prepared statement set <code>Boolean</code> is supported.
     *
     * @return   <code>true</code> if prepared statement set <code>Boolean</code>
     * is supported.
     */
    public boolean isPreparedSetBooleanSupported()
    {
        return preparedSetBooleanSupported;
    }

    /**
     * Sets whether <code>Blob</code> is supported.
     *
     * @param blobSupported   The new blobSupported value
     */
    public void setBlobSupported(boolean blobSupported)
    {
        this.blobSupported = blobSupported;
    }

    /**
     * Returns <code>true</code> if <code>Blob</code> is supported.
     *
     * @return   <code>true</code>if <code>Blob</code>s are supported.
     */
    public boolean isBlobSupported()
    {
        return this.blobSupported;
    }

    /**
     * Sets whether <code>Clob</code> is supported.
     *
     * @param clobSupported   The new clobSupported value
     */
    public void setClobSupported(boolean clobSupported)
    {
        this.clobSupported = clobSupported;
    }

    /**
     * Returns <code>true</code> if <code>Clob</code> is supported.
     *
     * @return   <code>true</code>if <code>Clob</code>s are supported.
     */
    public boolean isClobSupported()
    {
        return this.clobSupported;
    }

    /**
     * Sets whether commits and rollbacks should be supported. EJB context applications
     * should set this value to <code>false</code>.  All commits and rollbacks in <code>
     * JRFConnection</code> will be 'no-ops'.
     *
     * @param commitAndRollbackSupported  if <code>false</code>, commits and rollbacks will
     * never be done.
     */
    public void setCommitAndRollbackSupported(boolean commitAndRollbackSupported)
    {
        this.commitAndRollbackSupported = commitAndRollbackSupported;
    }

    /**
     * Return <code>true</code> if commits and rollbacks should be supported.
     *
     * @return   if <code>false</code>, commits and rollbacks will
     */
    public boolean isCommitAndRollbackSupported()
    {
        return this.commitAndRollbackSupported;
    }

    /**
     * Sets whether transactions are supported for drop and create table actions.
     * To clarify JDBC details, some database vendors or particular connections
     * do not support the following JDBC call sequence:
     * <pre>
     * connection.setAutoCommit(false)
     * Statement s = connection.createStatement();
     * s.executeUpdate("Drop table A");
     * s.close();
     * s.executeUpdate("Drop table B");
     * connection.commit();
     * </pre>
     * On such connections, the sequence has to be:
     * <pre>
     * connection.setAutoCommit(true)
     * Statement s = connection.createStatement();
     * s.executeUpdate("Drop table A");
     * s.close();
     * s.executeUpdate("Drop table B");
     * </pre>
     *
     * @param transactionsForDropAndCreateSupported  if <code>true</code> transactions
     *		are permitted for drop and create table SQL statements.
     */
    public void setTransactionsForDropAndCreateSupported(
        boolean transactionsForDropAndCreateSupported)
    {
        this.transactionsForDropAndCreateSupported = transactionsForDropAndCreateSupported;
    }

    /**
     * Returns <code>true</code> if transactions are supported for drop and create table actions.
     *
     * @return   <code>true</code> if transactions are permitted for drop and create tables SQL statements.
     * @see      #setTransactionsForDropAndCreateSupported(boolean)
     */
    public boolean isTransactionsForDropAndCreateSupported()
    {
        return this.transactionsForDropAndCreateSupported;
    }

    /**
     * Return a copy with a newly instantiated database policy.
     *
     * @return                                a clone of this instance with a new <code>DatabasePolicy</code>
     * @exception CloneNotSupportedException  Description of the Exception
     */
    public Object clone()
        throws CloneNotSupportedException
    {
        DataSourceProperties clone = (DataSourceProperties) super.clone();
        clone.setDatabasePolicy(createPolicy(this.policyClass));
        return clone;
    }
}
