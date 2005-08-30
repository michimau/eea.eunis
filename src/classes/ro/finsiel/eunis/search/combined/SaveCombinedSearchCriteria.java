package ro.finsiel.eunis.search.combined;

/**
 * Date: Nov 3, 2003
 * Time: 2:37:16 PM
 */

import ro.finsiel.eunis.search.Utilities;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * This class is used to save combined search criteria.
 * @author finsiel
 */
public class SaveCombinedSearchCriteria {

  // id of session
  private String idSession = null;
  // nature object witch the search was started
  private String natureObject = null;
  // name of the user who made this operation
  private String userName = null;
  // description of the saved search
  private String description = null;
  // name of the jsp page where operation was made
  private String fromWhere = null;
  // sites source data set
  private String SourceDB = null;

  // JDBC driver.
  private String SQL_DRV = "";
  // JDBC url.
  private String SQL_URL = "";
  // JDBC user.
  private String SQL_USR = "";
  // JDBC password.
  private String SQL_PWD = "";
/**
 * Class constructor.
 * @param idsession id session
 * @param natureobject nature object
 * @param username user name
 * @param description search description
 * @param fromWhere page name
 * @param SQL_DRV JDBC driver
 * @param SQL_URL JDBC url
 * @param SQL_USR JDBC user
 * @param SQL_PWD JDBC password
 * @param SourceDB sites source data set
 */
  public SaveCombinedSearchCriteria(String idsession,
                                    String natureobject,
                                    String username,
                                    String description,
                                    String fromWhere,
                                    String SQL_DRV,
                                    String SQL_URL,
                                    String SQL_USR,
                                    String SQL_PWD,
                                    String SourceDB) {
    this.idSession = idsession;
    this.natureObject = natureobject;
    this.userName = username;
    this.description = description;
    this.fromWhere = fromWhere;
    this.SQL_DRV = SQL_DRV;
    this.SQL_URL = SQL_URL;
    this.SQL_USR = SQL_USR;
    this.SQL_PWD = SQL_PWD;
    this.SourceDB = SourceDB;
  }

  /**
   * Save combined search criteria.
   * @return true if save operation was made with success.
   */
  public boolean SaveCriteria() {

    String SQL1 = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;
    boolean saveWithSuccess = false;

    try
    {
      Class.forName(SQL_DRV);

      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL1 = "SELECT * " +
             " FROM EUNIS_COMBINED_SEARCH " +
             " WHERE ID_SESSION = '" + idSession + "' ";

      rs = ps.executeQuery(SQL1);

      String name = userName + CriteriaMaxNumber(userName);
      String descriptionValue = (description != null && !description.equalsIgnoreCase("") ? description : getDescription());
      descriptionValue = Utilities.removeQuotes(descriptionValue);

      if (rs.isBeforeFirst())
      {
        while (!rs.isLast())
        {
          rs.next();
          Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
          Statement ps1 = con1.createStatement();

          String SQL = "INSERT INTO EUNIS_SAVE_COMBINED_SEARCH";
          SQL += "(CRITERIA_NAME, NATURE_OBJECT, ID_NODE,NODE_TYPE, DESCRIPTION, USERNAME, FROM_WHERE)";
          SQL += " VALUES(";
          SQL += "'" + name + "',";
          SQL += "'" + rs.getString("NATURE_OBJECT") + "',";
          SQL += "'" + rs.getString("ID_NODE") + "',";
          SQL += "'" + rs.getString("NODE_TYPE") + "',";
          SQL += "'" + descriptionValue + "',";
          SQL += "'" + userName + "',";
          SQL += "'" + fromWhere + "')";

          ps1.executeUpdate(SQL);

          ps1.close();
          con1.close();
        }
      }

      rs.close();
      ps.close();
      con.close();

      //inser criteria

      Connection con3 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      Statement ps3 = con3.createStatement();

      SQL1 = "SELECT * " +
             " FROM EUNIS_COMBINED_SEARCH_CRITERIA " +
             " WHERE ID_SESSION = '" + idSession + "' " +
             " ORDER BY ID_NODE";

      ResultSet rs3 = ps3.executeQuery(SQL1);

      if (rs3.isBeforeFirst())
      {
        while (!rs3.isLast())
        {
          rs3.next();
          Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
          Statement ps1 = con1.createStatement();

          String SQL = "INSERT INTO EUNIS_SAVE_COMBINED_SEARCH_CRITERIA";
          SQL += "(CRITERIA_NAME, NATURE_OBJECT, ID_NODE, ATTRIBUTE, OPERATOR, FIRST_VALUE, LAST_VALUE)";
          SQL += " VALUES(";
          SQL += "'" + name + "',";
          SQL += "'" + rs3.getString("NATURE_OBJECT") + "',";
          SQL += "'" + rs3.getString("ID_NODE") + "',";
          SQL += "'" + rs3.getString("ATTRIBUTE") + "',";
          SQL += "'" + rs3.getString("OPERATOR") + "',";
          SQL += "'" + rs3.getString("FIRST_VALUE") + "',";
          SQL += "'" + rs3.getString("LAST_VALUE") + "')";

          ps1.executeUpdate(SQL);

          ps1.close();
          con1.close();
        }
      }

      rs3.close();
      ps3.close();
      con3.close();

      //insert SourceDB (if search begin with sites nature object)
      if (natureObject != null && natureObject.equalsIgnoreCase("Sites"))
      {
        long maxIdNode = MaxIdNode(name);

        Connection con2 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
        Statement ps2 = con2.createStatement();

        String SQL = "INSERT INTO EUNIS_SAVE_COMBINED_SEARCH";
        SQL += "(CRITERIA_NAME, NATURE_OBJECT, ID_NODE, NODE_TYPE, DESCRIPTION, USERNAME, FROM_WHERE)";
        SQL += " VALUES(";
        SQL += "'" + name + "',";
        SQL += "'Sites',";
        SQL += "'" + maxIdNode + "',";
        SQL += "'Criteria',";
        SQL += "'" + descriptionValue + "',";
        SQL += "'" + userName + "',";
        SQL += "'" + fromWhere + "')";

        ps2.executeUpdate(SQL);

        ps2.close();
        con2.close();

        Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
        Statement ps1 = con1.createStatement();

        SQL = "INSERT INTO EUNIS_SAVE_COMBINED_SEARCH_CRITERIA";
        SQL += "(CRITERIA_NAME, NATURE_OBJECT, ID_NODE, ATTRIBUTE, OPERATOR, FIRST_VALUE, LAST_VALUE)";
        SQL += " VALUES(";
        SQL += "'" + name + "',";
        SQL += "'Sites',";
        SQL += "'" + maxIdNode + "',";
        SQL += "'SourceDB',";
        SQL += "'is',";
        SQL += "\"" + SourceDB + "\",";
        SQL += "'')";

        ps1.executeUpdate(SQL);

        ps1.close();
        con1.close();
      }
     saveWithSuccess = true;
    }
    catch (Exception e) {
      e.printStackTrace();
    }
    return saveWithSuccess;
  }

  /**
   * Return source data set for sites.
   * @param criteria criteria name (from EUNIS_SAVE_COMBINED_SEARCH_CRITERIA table)
   * @param SQL_DRV JDBC driver
   * @param SQL_URL JDBC url
   * @param SQL_USR JDBC user
   * @param SQL_PWD JDBC password
   * @return sites source data set.
   */
  public static String getSourceDB(String criteria, String SQL_DRV, String SQL_URL, String SQL_USR, String SQL_PWD) {
    String sourceDB = "";
    long maxIdNode = MaxIdNode(criteria, SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);

    try
    {
      Class.forName(SQL_DRV);
      Connection con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      Statement ps = con.createStatement();

      String SQL = "SELECT FIRST_VALUE " +
                   " FROM EUNIS_SAVE_COMBINED_SEARCH_CRITERIA " +
                   " WHERE CRITERIA_NAME ='" + criteria + "' " +
                   " AND NATURE_OBJECT='Sites' " +
                   " AND ID_NODE = '" + maxIdNode + "'";

        ResultSet rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        rs.next();
        sourceDB = rs.getString(1);
      }

      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return sourceDB;
  }

  /**
   * Return max value of ID_NODE field from EUNIS_SAVE_COMBINED_SEARCH table for a criteria name.
   * @param criteria criteria name
   * @return max value.
   */
  private long MaxIdNode(String criteria) {
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;
    long result = 0;

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL = "SELECT MAX(ID_NODE) " +
            " FROM EUNIS_SAVE_COMBINED_SEARCH " +
            " WHERE CRITERIA_NAME ='" + criteria + "' " +
            " AND NATURE_OBJECT='Sites'";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        rs.next();
        result = rs.getLong(1);
      }

      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result + 1;
  }

  /**
   * Return max value of ID_NODE field from EUNIS_SAVE_COMBINED_SEARCH table for a criteria name.
   * @param criteria criteria name
   * @param SQL_DRV JDBC driver
   * @param SQL_URL JDBC url
   * @param SQL_USR JDBC user
   * @param SQL_PWD JDBC password
   * @return max value
   */
  private static long MaxIdNode(String criteria, String SQL_DRV, String SQL_URL, String SQL_USR, String SQL_PWD) {
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;
    long result = 0;

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL = "SELECT MAX(ID_NODE) " +
            " FROM EUNIS_SAVE_COMBINED_SEARCH " +
            " WHERE CRITERIA_NAME ='" + criteria + "' " +
            " AND NATURE_OBJECT='Sites'";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        rs.next();
        result = rs.getLong(1);
      }

      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }

    return result;
  }

  /**
   * Return value of node type field from EUNIS_COMBINED_SEARCH table.
   * @param idsession id session
   * @param natureobject nature object
   * @param idnode id node
   * @return node type field value.
   */
  private String getNodeType(String idsession, String natureobject, String idnode) {
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;
    String result = "";

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL = "SELECT NODE_TYPE " +
            " FROM EUNIS_COMBINED_SEARCH " +
            " WHERE ID_SESSION='" + idsession + "' " +
            " AND NATURE_OBJECT='" + natureobject + "' " +
            " AND ID_NODE='" + idnode + "'";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        rs.next();
        result = rs.getString(1);
      }

      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * Return description of saved combined search.
   * @return  search description
   */

  private String getDescription() {
    String descr = "";
    String descr2 = "";
    String beginText = "";
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      //for first natureobject
      SQL = "SELECT * " +
              " FROM EUNIS_COMBINED_SEARCH_CRITERIA " +
              " WHERE ID_SESSION='" + idSession + "' " +
              " AND NATURE_OBJECT='" + natureObject+ "' " +
              " ORDER BY ID_NODE";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        beginText = "COMBINED SEACH, searching " + natureObject + " having next criteria: ";
        String op = "";
        String current = "";
        String last = "";

        while (!rs.isLast())
        {
          rs.next();

          current = rs.getString("NATURE_OBJECT");

          //for id_node = 0 node_type is ANY or ALL
          if (!current.equalsIgnoreCase(last))
          {
            String nodeType = getNodeType(rs.getString("ID_SESSION"), rs.getString("NATURE_OBJECT"), "0");
            op = (nodeType != null && nodeType.equalsIgnoreCase("any") ? "OR" : "AND");
          }

          boolean bracketClose = false;
          if (!current.equalsIgnoreCase(last) && descr.length() > 0)
          {
            descr += " } ";
            bracketClose = true;
          }

          if (descr.length() > 0)
          {
            if (bracketClose)
              descr += " " + op;
            else
              descr += " AND ";
          }

          if (!current.equalsIgnoreCase(last))
          {
            descr += " FOR " + current + " { ";
            last = current;
          }

          descr += " " + rs.getString("ATTRIBUTE") + " " + rs.getString("OPERATOR") + " " + rs.getString("FIRST_VALUE");

          if (rs.getString("OPERATOR").equalsIgnoreCase("Between"))
            descr += " and " + rs.getString("LAST_VALUE");
        }
      }
      if (descr.length() > 0)
      {
        descr += " } ";
      }

      ps.close();
      con.close();
      rs.close();

      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      //for others natureobject
      SQL = "SELECT * " +
              " FROM EUNIS_COMBINED_SEARCH_CRITERIA " +
              " WHERE ID_SESSION='" + idSession + "' " +
              " AND NATURE_OBJECT<>'" + natureObject+ "' " +
              " ORDER BY NATURE_OBJECT,ID_NODE";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        String op = "";
        String current = "";
        String last = "";

        while (!rs.isLast())
        {
          rs.next();

          current = rs.getString("NATURE_OBJECT");

          //for id_node = 0 node_type is ANY or ALL
          if (!current.equalsIgnoreCase(last))
          {
            String nodeType = getNodeType(rs.getString("ID_SESSION"), rs.getString("NATURE_OBJECT"), "0");
            op = (nodeType != null && nodeType.equalsIgnoreCase("any") ? "OR" : "AND");
          }

          if (rs.isFirst()) descr += " " + op + " ";

          boolean bracketClose = false;
          if (!current.equalsIgnoreCase(last) && descr2.length() > 0)
          {
            descr2 += " } ";
            bracketClose = true;
          }

          if (descr2.length() > 0)
          {
            if (bracketClose)
              descr2 += " " + op;
            else
              descr2 += " AND ";
          }

          if (!current.equalsIgnoreCase(last))
          {
            descr2 += " FOR " + current + " { ";
            last = current;
          }

          descr2 += " " + rs.getString("ATTRIBUTE") + " " + rs.getString("OPERATOR") + " " + rs.getString("FIRST_VALUE");

          if (rs.getString("OPERATOR").equalsIgnoreCase("Between"))
            descr2 += " and " + rs.getString("LAST_VALUE");
        }
      }
      if (descr2.length() > 0)
      {
        descr2 += " } ";
      }

      ps.close();
      con.close();
      rs.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return beginText + descr + descr2;
  }

  /**
   * Expand, in a jsp page, list of saved combined searches made by a user.
   * @param natureObject nature object
   * @param SQL_DRV JDBC driver
   * @param SQL_URL JDBC url
   * @param SQL_USR JDBC user
   * @param SQL_PWD JDBC password
   * @param userName user name
   * @param fromWhere page name
   * @return list of saved searches
   */
  public static String ExpandSaveCriteriaForThisPage(String natureObject,
                                                     String SQL_DRV,
                                                     String SQL_URL,
                                                     String SQL_USR,
                                                     String SQL_PWD,
                                                     String userName,
                                                     String fromWhere) {
    String result = "";
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;
    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL = "SELECT * " +
            " FROM EUNIS_SAVE_COMBINED_SEARCH " +
            " WHERE USERNAME='" + userName + "' " +
            " AND FROM_WHERE='" + fromWhere + "' " +
            " GROUP BY CRITERIA_NAME";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        result = "<table width=\"740\" border=\"0\">";
        while (!rs.isLast())
        {
          rs.next();
          String sourceDB = "";
          if (natureObject != null && natureObject.equalsIgnoreCase("Sites"))
          {
            sourceDB = getSourceDB(rs.getString("CRITERIA_NAME"), SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
            sourceDB = Utilities.removeQuotes(sourceDB);
            sourceDB = sourceDB.replaceAll(" ", "");
          }
          result += "<tr>";
          result += "<td><a title=\"Load criteria\" href=\"javascript:setFormDeleteSaveCriteria('" + fromWhere + "','" + rs.getString("CRITERIA_NAME") + "','" + natureObject + "');\"><img alt=\"Delete\" src=\"images/mini/delete.jpg\" border=\"0\" align=\"absmiddle\"></a>&nbsp;&nbsp;<a title=\"Load criteria\" href=\"javascript:setFormLoadSaveCriteria('" + fromWhere + "','" + rs.getString("CRITERIA_NAME") + "','" + natureObject + "','" + sourceDB + "');\">" + rs.getString("DESCRIPTION") + "</a></td>";
          result += "</tr>";
        }
        result += "</table>";
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * Insert data from EUNIS_SAVE_COMBINED_SEARCH table in EUNIS_COMBINED_SEARCH table;
   * used to load data from saved searches in input fields from jsp page.
   * @param idsession id session
   * @param criterianame criteria name
   * @param natureObject nature object
   * @param SQL_DRV JDBC driver
   * @param SQL_URL JDBC url
   * @param SQL_USR JDBC user
   * @param SQL_PWD JDBC password
   */
  public static void insertEunisCombinedSearch(String idsession,
                                               String criterianame,
                                               String natureObject,
                                               String SQL_DRV,
                                               String SQL_URL,
                                               String SQL_USR,
                                               String SQL_PWD) {
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL = "SELECT * " +
            " FROM EUNIS_SAVE_COMBINED_SEARCH " +
            " WHERE CRITERIA_NAME='" + criterianame + "' ";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        while (!rs.isLast())
        {
          rs.next();

          if (natureObject != null && natureObject.equalsIgnoreCase("Sites"))
          {
            //is not SourceDB
            if (!rs.getString("ID_NODE").equalsIgnoreCase(new Long(MaxIdNode(rs.getString("criteria_name"), SQL_DRV, SQL_URL, SQL_USR, SQL_PWD)).toString()))
            {
              Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
              Statement ps1 = con1.createStatement();

              String SQL1 = "INSERT INTO EUNIS_COMBINED_SEARCH";
              SQL1 += "(ID_SESSION, NATURE_OBJECT, ID_NODE, NODE_TYPE)";
              SQL1 += " VALUES(";
              SQL1 += "'" + idsession + "',";
              SQL1 += "'" + rs.getString("NATURE_OBJECT") + "',";
              SQL1 += "'" + rs.getString("ID_NODE") + "',";
              SQL1 += "'" + rs.getString("NODE_TYPE") + "')";

              ps1.executeUpdate(SQL1);
              ps1.close();
              con1.close();
            }
          } else
          {
            Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            Statement ps1 = con1.createStatement();

            String SQL1 = "INSERT INTO EUNIS_COMBINED_SEARCH";
            SQL1 += "(ID_SESSION, NATURE_OBJECT, ID_NODE, NODE_TYPE)";
            SQL1 += " VALUES(";
            SQL1 += "'" + idsession + "',";
            SQL1 += "'" + rs.getString("NATURE_OBJECT") + "',";
            SQL1 += "'" + rs.getString("ID_NODE") + "',";
            SQL1 += "'" + rs.getString("NODE_TYPE") + "')";

            ps1.executeUpdate(SQL1);
            ps1.close();
            con1.close();
          }
        }
      }

      rs.close();
      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  /**
   * Insert data from EUNIS_SAVE_COMBINED_SEARCH_CRITERIA table in EUNIS_COMBINED_SEARCH_CRITERIA table;
   * used to load data from saved searches in input fields from jsp page.
   * @param idsession id session
   * @param criterianame criteria name
   * @param natureObject nature object
   * @param SQL_DRV JDBC driver
   * @param SQL_URL JDBC url
   * @param SQL_USR JDBC user
   * @param SQL_PWD JDBC password
   */

  public static void insertEunisCombinedSearchCriteria(String idsession,
                                                       String criterianame,
                                                       String natureObject,
                                                       String SQL_DRV,
                                                       String SQL_URL,
                                                       String SQL_USR,
                                                       String SQL_PWD) {
    String SQL = "";
    Connection con = null;
    Statement ps = null;
    ResultSet rs = null;

    try
    {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();

      SQL = "SELECT * " +
            " FROM EUNIS_SAVE_COMBINED_SEARCH_CRITERIA " +
            " WHERE CRITERIA_NAME='" + criterianame + "' ";

      rs = ps.executeQuery(SQL);

      if (rs.isBeforeFirst())
      {
        while (!rs.isLast())
        {
          rs.next();
          if (natureObject != null && natureObject.equalsIgnoreCase("Sites"))
          {
            //is not SourceDB
            if (!rs.getString("ID_NODE").equalsIgnoreCase(new Long(MaxIdNode(rs.getString("criteria_name"), SQL_DRV, SQL_URL, SQL_USR, SQL_PWD)).toString()))
            {
              Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
              Statement ps1 = con1.createStatement();

              String SQL1 = "INSERT INTO EUNIS_COMBINED_SEARCH_CRITERIA";
              SQL1 += "(ID_SESSION, NATURE_OBJECT, ID_NODE, ATTRIBUTE, OPERATOR, FIRST_VALUE, LAST_VALUE)";
              SQL1 += " VALUES(";
              SQL1 += "'" + idsession + "',";
              SQL1 += "'" + rs.getString("NATURE_OBJECT") + "',";
              SQL1 += "'" + rs.getString("ID_NODE") + "',";
              SQL1 += "'" + rs.getString("ATTRIBUTE") + "',";
              SQL1 += "'" + rs.getString("OPERATOR") + "',";
              SQL1 += "'" + rs.getString("FIRST_VALUE") + "',";
              SQL1 += "'" + rs.getString("LAST_VALUE") + "')";

              ps1.executeUpdate(SQL1);
              ps1.close();
              con1.close();
            }
          } else
          {
            Connection con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
            Statement ps1 = con1.createStatement();

            String SQL1 = "INSERT INTO EUNIS_COMBINED_SEARCH_CRITERIA";
            SQL1 += "(ID_SESSION, NATURE_OBJECT, ID_NODE, ATTRIBUTE, OPERATOR, FIRST_VALUE, LAST_VALUE)";
            SQL1 += " VALUES(";
            SQL1 += "'" + idsession + "',";
            SQL1 += "'" + rs.getString("NATURE_OBJECT") + "',";
            SQL1 += "'" + rs.getString("ID_NODE") + "',";
            SQL1 += "'" + rs.getString("ATTRIBUTE") + "',";
            SQL1 += "'" + rs.getString("OPERATOR") + "',";
            SQL1 += "'" + rs.getString("FIRST_VALUE") + "',";
            SQL1 += "'" + rs.getString("LAST_VALUE") + "')";

            ps1.executeUpdate(SQL1);
            ps1.close();
            con1.close();
          }
        }
      }

      rs.close();
      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  /**
   * Return max number from values of CRITERIA_NAME fields for a user (Ex : for 'root0','root1','root2' return 2 for user 'root').
   * @param user user name
   * @return max number
   */

  private Long CriteriaMaxNumber(String user) {
    String SQL1 = "";
    ResultSet rs = null;
    Connection con1 = null;
    Statement st = null;

    Long result = new Long(0);
    try
    {
      Class.forName(SQL_DRV);
      con1 = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL1 = " SELECT MAX(CAST(SUBSTRING(CRITERIA_NAME,LENGTH('" + user + "')+1,LENGTH(CRITERIA_NAME)) AS SIGNED))" +
             " FROM EUNIS_SAVE_COMBINED_SEARCH" +
             " WHERE USERNAME = '" + user + "'";

      st = con1.createStatement();
      rs = st.executeQuery(SQL1);

      if (rs.isBeforeFirst())
      {
        while (!rs.isLast())
        {
          rs.next();
          result = new Long(rs.getLong(1) + 1);
        }
      }

      rs.close();
      st.close();
      con1.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result;
  }

}
