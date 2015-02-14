package net.sf.jrf.sql.c3p0;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import net.sf.jrf.JRFProperties;
import net.sf.jrf.exceptions.ConfigurationException;
import net.sf.jrf.sql.LocalDataSourceGenerator;
import org.apache.log4j.Category;

import javax.sql.DataSource;
import java.beans.PropertyVetoException;
import java.util.Properties;

/**
 * Implementation of jRelationalFramework data source using the c3p0 library
 * http://www.mchange.com/projects/c3p0/
 * http://taskman.eionet.europa.eu/issues/20084
 */
public class C3P0DataSourceGenerator implements LocalDataSourceGenerator {
    private final static Category LOG = Category.getInstance(C3P0DataSourceGenerator.class.getName());

    /**
     * Initializes the data source with a c3p0 data source. Check http://www.mchange.com/projects/c3p0/ for more details
     *
     * @param dbtype                      Description of the Parameter
     * @param p                           Description of the Parameter
     * @return                            Description of the Return Value
     * @exception ConfigurationException  Description of the Exception
     * @see                               net.sf.jrf.sql.LocalDataSourceGenerator#findLocalDataSource(String,Properties) *
     */
    @Override
    public DataSource findLocalDataSource(String dbtype, Properties p) throws ConfigurationException {

        ComboPooledDataSource cpds = new ComboPooledDataSource();
        try{

            cpds.setDriverClass( JRFProperties.resolveRequiredStringProperty(p, dbtype + ".driver",
                    "driver specification class is mandatory.") );
            cpds.setJdbcUrl( JRFProperties.resolveRequiredStringProperty(p, dbtype + ".url",
                    "URL for database is mandatory.") );
            cpds.setUser(JRFProperties.resolveRequiredStringProperty(p, dbtype +
                    ".user", "User name is mandatory"));
            cpds.setPassword(JRFProperties.resolveStringProperty(p, dbtype + ".password", ""));
            cpds.setMinPoolSize(JRFProperties.resolveIntProperty(p, dbtype + ".minpoolsize", 1));
            cpds.setMaxPoolSize(JRFProperties.resolveIntProperty(p, dbtype + ".maxpoolsize", 10));
            cpds.setPreferredTestQuery(JRFProperties.resolveStringProperty(p, dbtype + ".testsql", null));

            // http://www.mchange.com/projects/c3p0/#tomcat-specific
            // Not sure if this is only needed when the datasource is directly served by Tomcat and not when it's application managed
            cpds.setPrivilegeSpawnedThreads(JRFProperties.resolveBooleanProperty(p, dbtype + ".c3p0.privilegeSpawnedThreads", false));
            cpds.setContextClassLoaderSource(JRFProperties.resolveStringProperty(p, dbtype + ".c3p0.contextClassLoaderSource", "caller"));

            // test idle connections every 30 seconds
            cpds.setIdleConnectionTestPeriod(JRFProperties.resolveIntProperty(p, dbtype + ".c3p0.idleConnectionTestPeriod", 0));
            // test connection on pool return
            cpds.setTestConnectionOnCheckin(JRFProperties.resolveBooleanProperty(p, dbtype + ".c3p0.testConnectionOnCheckin", false));

            // http://www.mchange.com/projects/c3p0/#maxIdleTimeExcessConnections
            cpds.setMaxIdleTimeExcessConnections(JRFProperties.resolveIntProperty(p, dbtype + ".c3p0.maxIdleTimeExcessConnections", 0));

            // prepared statements cache
            // http://www.mchange.com/projects/c3p0/#maxStatements
            cpds.setMaxStatements(JRFProperties.resolveIntProperty(p, dbtype + ".c3p0.maxStatements", 0));

            // debug for pool depletion
            // http://www.mchange.com/projects/c3p0/#unreturnedConnectionTimeout
            cpds.setUnreturnedConnectionTimeout(JRFProperties.resolveIntProperty(p, dbtype + ".c3p0.unreturnedConnectionTimeout", 0));

            // http://www.mchange.com/projects/c3p0/#debugUnreturnedConnectionStackTraces
            cpds.setDebugUnreturnedConnectionStackTraces(JRFProperties.resolveBooleanProperty(p, dbtype + ".c3p0.debugUnreturnedConnectionStackTraces", false));


            LOG.debug(cpds.toString());
        } catch (PropertyVetoException pve){
            throw new ConfigurationException(pve);
        }

        return cpds;
    }
}
