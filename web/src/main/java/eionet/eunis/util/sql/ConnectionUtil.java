/**
 *
 */
package eionet.eunis.util.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ResourceBundle;

/**
 * @author Risto Alt
 *
 */
public class ConnectionUtil {
    /**
     *
     * @return Connection
     * @throws DataSourceException
     * @throws SQLException
     * @throws ServiceException
     */
    public static Connection getSimpleConnection() throws SQLException {

        ResourceBundle props = ResourceBundle.getBundle("jrf");

        String drv = props.getString("mysql.driver");
        if (drv == null || drv.trim().length() == 0)
            throw new SQLException("Failed to get connection, missing property: mysql.driver");

        String url = props.getString("mysql.url");
        if (url == null || url.trim().length() == 0)
            throw new SQLException("Failed to get connection, missing property: mysql.url");

        String usr = props.getString("mysql.user");
        if (usr == null || usr.trim().length() == 0)
            throw new SQLException("Failed to get connection, missing property: mysql.user");

        String pwd = props.getString("mysql.password");
        if (pwd == null || pwd.trim().length() == 0)
            throw new SQLException("Failed to get connection, missing property: mysql.password");

        try {
            Class.forName(drv);
            return ro.finsiel.eunis.utilities.TheOneConnectionPool.getConnection(url, usr, pwd);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Failed to get connection, driver class not found: " + drv, e);
        }
    }
}
