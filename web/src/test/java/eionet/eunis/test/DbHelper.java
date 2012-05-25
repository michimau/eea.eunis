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

    private static IDatabaseConnection getConnection() throws ClassNotFoundException, SQLException, DatabaseUnitException {
        Class.forName("org.gjt.mm.mysql.Driver");
        Connection jdbcConnection = DriverManager.getConnection(getJdbcUrl(), getJdbcUser(), getJdbcPassword());
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

    private static void validateTestDbConnection() {
        if (!getJdbcUrl().toLowerCase().contains("test")) {
            throw new RuntimeException("DB name should contain string \"test\". Then we are sure that it is not live database.");
        }
    }

    public static IDataSet getXmlDataSet(String fileName) throws DataSetException, IOException {
        return new FlatXmlDataSetBuilder().build(DbHelper.class.getClassLoader().getResourceAsStream(fileName));
    }

    /**
     * exctract data from DB and create xml files.
     *
     * @param args
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {
        IDatabaseConnection dbConnection = null;
        // database connection
        try {
            dbConnection = getConnection();
            // partial database export
            QueryDataSet partialDataSet = new QueryDataSet(dbConnection);
            partialDataSet.addTable("dc_index");
            partialDataSet.addTable("chm62edt_country");
            partialDataSet.addTable("chm62edt_species",
            "select * from  chm62edt_species where scientific_name IN ('Salmo trutta', 'Cerchysiella laeviscuta');");
            partialDataSet
            .addTable(
                    "chm62edt_nature_object",
                    "select * from chm62edt_nature_object where id_nature_object in "
                    + "(select id_nature_object from chm62edt_species where scientific_name  IN ('Salmo trutta', 'Cerchysiella laeviscuta'))");
            partialDataSet
            .addTable(
                    "chm62edt_nature_object_attributes",
                    "select * from chm62edt_nature_object_attributes where id_nature_object in "
                    + "(select id_nature_object from chm62edt_species where scientific_name  IN ('Salmo trutta', 'Cerchysiella laeviscuta'))");

            FlatXmlDataSet.write(partialDataSet, new FileOutputStream("seed-redlist-species.xml"));

            // full database export
            /*
             * IDataSet fullDataSet = connection.createDataSet(); FlatXmlDataSet.write(fullDataSet, new
             * FileOutputStream("c:/Projects/EEA/EUNIS2/full.xml"));
             */

            // dependent tables database export: export table X and all tables that
            // have a PK which is a FK on X, in the right order for insertion
            /*
             * String[] depTableNames = TablesDependencyHelper.getAllDependentTables( connection, "X" ); IDataSet depDataset =
             * connection.createDataSet( depTableNames ); FlatXmlDataSet.write(depDataset, new FileOutputStream("dependents.xml"));
             */
        } finally {
            dbConnection.close();
        }

    }

}
