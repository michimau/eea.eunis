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
 * Contributor: James Evans (jevans@vmguys.com)
 * Contributor: Darren Senel (dsenel@pscu.net)
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
import java.util.Hashtable;
import javax.naming.*;
import javax.sql.*;
import net.sf.jrf.*;
import net.sf.jrf.exceptions.*;
import org.apache.log4j.Category;

/**
 * The normal way of creating <code>JRFConnection</code> handles in the framework will be through
 * the use of one of the factory methods in this class.
 */
public class JRFConnectionFactory
{
    private static Object defaultDataSource = null;	// XADataSource or DataSource 
    private static DataSourceProperties defaultDataSourceProperties = null;
    private static net.sf.jrf.exceptions.ConfigurationException loadDefaultsException = null;
    private static boolean defaultLoadAttempted = false;
    private static LocalDataSourceGenerator localDataSourceGenerator = null;
    private final static Category LOG = Category.getInstance(JRFConnectionFactory.class.getName());

    private JRFConnectionFactory() { }

    static
    {
        // Set up local data source generator. If available. 
        String genClass = null;
        try
        {
            genClass = JRFProperties.getStringProperty("localdatasourcegeneratorimpl");
            if (genClass != null)
            {
                localDataSourceGenerator = (LocalDataSourceGenerator) java.lang.Class.forName(genClass).newInstance();
            }
        }
        catch (Exception ex)
        {
            LOG.warn("Unable to instantiate " + genClass + ". Local data sources cannot be used.");
        }
    }

    /**
     * Creates <code>JRFConnection</code> handle using properties specified in
     * JRF properties file.
     *
     * @return   a <code>JRFConnection</code> handle that is ready to be used by an application.
     */
    public static JRFConnection create()
    {
        // Do we have defaults?
        if (defaultLoadAttempted)
        {
            if (loadDefaultsException != null)
            {
                throw loadDefaultsException;
            }
            try {
		return new JRFConnection(defaultDataSource,
					(DataSourceProperties) defaultDataSourceProperties.clone());
            }
            catch (CloneNotSupportedException ex) {
		throw new InternalError();
            }
        }
        JRFConnection conn = null;
        defaultLoadAttempted = true;
        try
        {
            conn = create(new Properties());
        }
        catch (net.sf.jrf.exceptions.ConfigurationException ce)
        {
            loadDefaultsException = ce;
            throw ce;
        }
        // Set default values.
        defaultDataSource = conn.dataSource;
        defaultDataSourceProperties = conn.getDataSourceProperties();
        LOG.info("A default JRFConnection handle has been created with:\n" +
            "DataSource = " + defaultDataSource + "\n" +
            "DataSource Properties = " + defaultDataSourceProperties + "\n");
        return conn;
    }

    /**
     * Creates <code>JRFConnection</code> handle using specified properties.  Any property value
     * that is not included in the parameter will be obtained from the JRF properites file.
     *
     * @param p  <code>Properties</code> instance to use to construct a <code>JRFConnection</code> handle.
     * @return   a <code>JRFConnection</code> handle that is ready to be used by an application.
     */
    public static JRFConnection create(Properties p)
    {
        String dbtype = findDbType(p);
        Object dataSource;
        DataSourceProperties dataSourceProperties;
        String conntype = JRFProperties.resolveRequiredStringProperty(p, dbtype + ".conntype",
            "Must be 'jndi' or 'local'");
        dataSourceProperties = new DataSourceProperties(dbtype, p);
        if (conntype.equals("jndi"))
        {
            dataSource = findJNDIDataSource(dbtype, p);
        }
        else if (conntype.equals("local"))
        {
	    if (localDataSourceGenerator == null)
		throw new net.sf.jrf.exceptions.ConfigurationException(
			"Local data sources cannot be used; bad or no implementation of "+
			"net.sf.jrf.sql.LocalDataSourceGenerator specified.");
            dataSource = localDataSourceGenerator.findLocalDataSource(dbtype, p);
        }
        else
        {
            throw new net.sf.jrf.exceptions.ConfigurationException(dbtype + "." + conntype + ": value must be 'local' or 'jndi'");
        }
	JRFConnection result = new JRFConnection(dataSource,dataSourceProperties);
        // Set dedicated connection properties.
        result.setDedicatedConnection(JRFProperties.resolveBooleanProperty(p, "dedicatedConnection", false));
        return result;
    }

    /**
     * Determine data base type.
     *
     * @param p  Description of the Parameter
     * @return   Description of the Return Value
     */
    static String findDbType(Properties p)
    {
        return JRFProperties.resolveRequiredStringProperty(p, "dbtype",
            "Value must be supplied to construct a proper database connection.");
    }

    /**
     * Creates a data source using the context parameters provided in <code>JRF.properties</code>.
     *
     * @param dbtype                                            name of database type.
     * @param p                                                 <code>Properties</code> instance.
     * @return                                                  <code>DataSource</code> or <code>XADataSource</code>
     *							        instance.
     * @throws net.sf.jrf.exceptions.ConfigurationException  if DataSource cannot be obtained. 
     */
    public static Object findJNDIDataSource(String dbtype, Properties p)
        throws net.sf.jrf.exceptions.ConfigurationException
    {
        String dataSourceName = JRFProperties.resolveRequiredStringProperty(p, dbtype + ".datasourcename",
            "Data source name is mandatory.");
        String jndiContextFactoryName = JRFProperties.resolveStringProperty(p, dbtype + ".jndiContextFactoryName", null);
        String jndiProviderURL = JRFProperties.resolveStringProperty(p, dbtype + ".jndiProviderURL", null);
        try
        {
            return findDataSource(dataSourceName, jndiContextFactoryName, jndiProviderURL);
        }
        catch (Exception ex)
        {
            throw new net.sf.jrf.exceptions.ConfigurationException(ex, "Unable to fetch JNDI data source for name: " + dataSourceName + "\n" +
                "Context factory: " + jndiContextFactoryName + "\n" +
                "Provider URL: " + jndiProviderURL);
        }
    }

    /**
     * Creates a data source based on the supplied parameters.  Users may wish
     * to create <code>java.sql.DataSources</code> distinct from specific
     * JDBCHelpers and AbstractDomains and use <code>AbstractDomain.setDataSource()</code>
     * where needed.
     *
     * @param dataSourceName              name of datasource to look up.
     * @param providerURL                 provider URL of the data source.
     * @param contextFactoryName          name of the factory
     * @return                            <code>DataSource</code> or <code>XADataSource</code>
     *			      		  instance.
     * @exception InstantiationException  Description of the Exception
     * @exception IllegalAccessException  Description of the Exception
     * @exception NamingException         Description of the Exception
     */
    public static Object findDataSource(String dataSourceName, String contextFactoryName, String providerURL)
        throws InstantiationException, IllegalAccessException, NamingException
    {

        if (dataSourceName == null)
        {
            throw new IllegalArgumentException("Datasource name cannot be null " +
                "createDataSource(" + dataSourceName + "," + contextFactoryName + "," + providerURL + ")");
        }
        Context lookupContext = null;
        if (contextFactoryName == null && providerURL == null)
        {
            Context initCtx = new InitialContext();
            lookupContext = (Context) initCtx.lookup("java:comp/env");
            if (lookupContext == null)
            {
                lookupContext = initCtx;
            }// Non-standard implementation (e.g. Orion).
        }
        else
        {
            if (contextFactoryName == null || providerURL == null)
            {
                throw new IllegalArgumentException("Either both context factory and provider URL must be null or both must be" +
                    " specified: " +
                    "createDataSource(" + dataSourceName + "," + contextFactoryName + "," + providerURL + ")");
            }
            Hashtable e = new Hashtable();
            e.put(Context.INITIAL_CONTEXT_FACTORY, contextFactoryName);
            e.put(Context.PROVIDER_URL, providerURL);
            lookupContext = new InitialContext(e);
        }
        Object obj;
        obj = lookupContext.lookup(dataSourceName);
        if (!(obj instanceof javax.sql.DataSource) && !(obj instanceof javax.sql.XADataSource) )
        {
            String error;
            if (obj instanceof javax.naming.Reference)
            {
                Reference ref = (Reference) obj;
                error = "Returned object for " + dataSourceName + " as a javax.Naming.Reference instead of "
                    + "a DataSource. Reference.toString() =[" + ref + "]\n(Reference.getClassName() = [" + ref.getClassName() + "])" +
                    "(most likely does not implement java.rmi.Remote) Reference.getClassFactoryClassName() = ["
                    + ref.getFactoryClassName() + "]\n" +
                    "Reference.getFactoryClassLocation() = [" + ref.getFactoryClassLocation() + "]";
            }
            else
            {
                error = "Unexpected data type returned for " + dataSourceName + " not a DataSource: " +
                    obj.getClass().getName() + ": " + obj;
            }
            LOG.error(error);
            throw new NamingException(error);
        }
        lookupContext.close();
        return obj;
    }
}
