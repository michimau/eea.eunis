package ro.finsiel.eunis.search.advanced;


import java.sql.*;


/**
 * Class used for combined search.
 * @author finsiel
 */
public class CombinedSearch {
    private String SQL_DRV = "";
    private String SQL_URL = "";
    private String SQL_USR = "";
    private String SQL_PWD = "";
    private int SQL_LIMIT = 1000;

    /**
     * Ctor.
     */
    public CombinedSearch() {// SQL_DRV="org.gjt.mm.mysql.Driver";
        // SQL_URL="jdbc:mysql://localhost/eunis2";
        // SQL_USR="root";
        // SQL_PWD="";
    }

    /**
     * Initializations.
     * @param SQL_DRIVER_NAME JDBC driver.
     * @param SQL_DRIVER_URL JDBC url.
     * @param SQL_DRIVER_USERNAME JDBC user.
     * @param SQL_DRIVER_PASSWORD JDBC passw.
     */
    public void Init(String SQL_DRIVER_NAME, String SQL_DRIVER_URL,
            String SQL_DRIVER_USERNAME, String SQL_DRIVER_PASSWORD) {
        SQL_DRV = SQL_DRIVER_NAME;
        SQL_URL = SQL_DRIVER_URL;
        SQL_USR = SQL_DRIVER_USERNAME;
        SQL_PWD = SQL_DRIVER_PASSWORD;
    }

    /**
     * Limit the results searched.
     * @param SQLLimit Limit.
     */
    public void SetSQLLimit(int SQLLimit) {
        SQL_LIMIT = SQLLimit;
    }

    /**
     * Execute an sql.
     * @param SQL SQL.
     * @param Delimiter Delimiter (LIMIT).
     * @return Criteria.
     * @throws ClassNotFoundException JDBC.
     * @throws SQLException JDBC.
     */
    public String ExecuteSQL(String SQL, String Delimiter) throws ClassNotFoundException, SQLException {
        String result = "";
        int resCount = 0;
        StringBuffer resultbuf = new StringBuffer();

        Class.forName(SQL_DRV);

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }

        if (SQL.length() > 0) {
            ResultSet rs = null;

            ps = con.prepareStatement(SQL);
            // System.out.println("Executing: "+SQL);
            rs = ps.executeQuery();

            if (rs.isBeforeFirst()) {
                rs.last();
                resCount = rs.getRow();
                if (resCount > 0) {
                    rs.beforeFirst();
                    resultbuf.ensureCapacity(resCount * 6);
                }
            }

            while (rs.next() && rs.getRow() <= SQL_LIMIT) {
                // result+=Delimiter+rs.getString(1)+Delimiter;
                // result+=",";
                resultbuf.append(Delimiter).append(rs.getString(1)).append(Delimiter);
                resultbuf.append(",");
            }

            result = resultbuf.toString();

            if (result.length() > 0) {
                if (result.substring(result.length() - 1).equalsIgnoreCase(",")) {
                    result = result.substring(0, result.length() - 1);
                }
            }
            rs.close();
        }
        // System.out.println("Result: "+result);
        return result;
    }

}
