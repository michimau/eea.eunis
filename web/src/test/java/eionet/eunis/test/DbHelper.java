package eionet.eunis.test;

import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

import org.dbunit.DatabaseUnitException;
import org.dbunit.PropertiesBasedJdbcDatabaseTester;
import org.dbunit.database.DatabaseConfig;
import org.dbunit.database.DatabaseConnection;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;
import org.dbunit.dataset.DataSetException;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSetBuilder;
import org.dbunit.ext.mysql.MySqlDataTypeFactory;
import org.dbunit.operation.DatabaseOperation;

import ro.finsiel.eunis.utilities.SQLUtilities;

/**
 * Helper class for db related stuff - connection, etc
 *
 * @author Enriko Käsper
 */

public class DbHelper {

    private static Properties appProperties;
    private static SQLUtilities sqlUtil;

    /**
     * Set up test database connections and initialise dataset if it is given.
     * @param datasetFileName XML file name with test data.
     * @throws Exception
     */
    public static void handleSetUpOperation(String datasetFileName) throws Exception {

        validateTestDbConnection();

        System.setProperty(PropertiesBasedJdbcDatabaseTester.DBUNIT_DRIVER_CLASS, getJdbcDriver());
        System.setProperty(PropertiesBasedJdbcDatabaseTester.DBUNIT_CONNECTION_URL, getJdbcUrl());
        System.setProperty(PropertiesBasedJdbcDatabaseTester.DBUNIT_USERNAME, getJdbcUser());
        System.setProperty(PropertiesBasedJdbcDatabaseTester.DBUNIT_PASSWORD, getJdbcPassword());

        if (datasetFileName != null) {
            final IDatabaseConnection conn = getConnection();
            final IDataSet data = getXmlDataSet(datasetFileName);
            try {
                DatabaseOperation.CLEAN_INSERT.execute(conn, data);
            } finally {
                conn.close();
            }

        }
    }

    protected static IDatabaseConnection getConnection() throws ClassNotFoundException, SQLException, DatabaseUnitException {
        return getConnection(false);
    }
    
    protected static IDatabaseConnection getConnection(boolean liveBase) throws ClassNotFoundException, SQLException, DatabaseUnitException {
        Class.forName("com.mysql.jdbc.Driver");
        Connection jdbcConnection = null; 
        if (liveBase){
            jdbcConnection = ro.finsiel.eunis.utilities.TheOneConnectionPool.getConnection(getJdbcUrlLive(), getJdbcUserLive(), getJdbcPasswordLive());
        } else {
            jdbcConnection = ro.finsiel.eunis.utilities.TheOneConnectionPool.getConnection(getJdbcUrl(), getJdbcUser(), getJdbcPassword());
        }
        IDatabaseConnection connection = new DatabaseConnection(jdbcConnection);
        DatabaseConfig config = connection.getConfig();
        config.setProperty(DatabaseConfig.PROPERTY_DATATYPE_FACTORY, new MySqlDataTypeFactory());

        return connection;
    }

    public static SQLUtilities getSqlUtilities() {
        if (sqlUtil == null) {
            validateTestDbConnection();
            sqlUtil = new SQLUtilities();
            sqlUtil.Init(getJdbcDriver(), getJdbcUrl(), getJdbcUser(), getJdbcPassword());
        }
        return sqlUtil;
    }

    public static String getAppProperty(String key) {

        if (appProperties == null) {
            try {
                appProperties = new Properties();
                appProperties.load(DbHelper.class.getClassLoader().getResourceAsStream("test.properties"));
            } catch (Exception fatal) {
                fatal.printStackTrace();
                throw new RuntimeException(fatal);
            }
        }
        return appProperties.getProperty(key);
    }

    public static String getJdbcUser() {
        return getAppProperty("db.unitest.usr");
    }

    public static String getJdbcPassword() {
        return getAppProperty("db.unitest.pwd");
    }

    public static String getJdbcUrl() {
        return getAppProperty("db.unitest.url");
    }

    public static String getJdbcDriver() {
        return getAppProperty("db.unitest.drv");
    }
    
    public static String getJdbcUserLive() {
        return getAppProperty("mysql.user");
    }

    public static String getJdbcPasswordLive() {
        return getAppProperty("mysql.password");
    }

    public static String getJdbcUrlLive() {
        return getAppProperty("mysql.url");
    }

    public static String getJdbcDriverLive() {
        return getAppProperty("mysql.driver");
    }
    

    private static void validateTestDbConnection() {
        if (!getJdbcUrl().toLowerCase().contains("test")) {
            throw new RuntimeException("DB name should contain string \"test\". Then we are sure that it is not live database.");
        }
    }

    public static IDataSet getXmlDataSet(String fileName) throws DataSetException, IOException {
        FlatXmlDataSetBuilder builder = new FlatXmlDataSetBuilder();
        builder.setColumnSensing(true);
        return builder.build(DbHelper.class.getClassLoader().getResourceAsStream(fileName));
    }
    
}
