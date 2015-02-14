package ro.finsiel.eunis.utilities;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import net.sf.jrf.sql.JRFConnection;
import org.apache.log4j.Logger;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * One pool to rule them all
 * A c3p0 initialized with the JRF settings, used to replace all the direct calls to DriverManager.getConnection()
 * User: miahi
 * Date: 2/11/15
 * Time: 8:01 PM
 */
public class TheOneConnectionPool {

    private static final Logger logger = Logger.getLogger(TheOneConnectionPool.class);

    private static DataSource dataSource = null;

    private static synchronized DataSource getDataSource(){
        if(dataSource == null){
            logger.debug("The One Pool is created");

            JRFConnection jrfc = net.sf.jrf.sql.JRFConnectionFactory.create();
            dataSource = (DataSource) jrfc.getDataSource();
        }
        return dataSource;
    }

    public static Connection getConnection() throws SQLException{
        try {
            logger.debug("getConnection Invoked!");
            StackTraceElement[] ste = Thread.currentThread().getStackTrace();
            int first = 2;
            if(ste[first].getClassName().endsWith("TheOneConnectionPool")){
                first++;
            }

            logger.debug("getConnection invoked from " + ste[first]);

            if(ste[first].getClassName().endsWith("MySqlBaseDao") || ste[first].getClassName().endsWith("SQLUtilities")) {
                while(ste[first].getClassName().endsWith("MySqlBaseDao") || ste[first].getClassName().endsWith("SQLUtilities")) first++;
                logger.debug("which is invoked by " + ste[first]);
            }

            Connection c = getDataSource().getConnection();
            if(c != null){
                return c;
            } else {
                throw new SQLException("The connection pool could not return a connection");
            }
        } catch (SQLException e) {
            logger.error(e,e);
            return null;
        }
    }

    /**
     * @deprecated All calls like this should be replaced by the simple getConnection() call and all the parameters should be removed from the initial code.
     */
    public static Connection getConnection(String sql_url, String sql_usr, String sql_pwd) throws SQLException {
        return getConnection();
    }
}
