package ro.finsiel.eunis.search;

import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.StringTokenizer;

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
  private String SourceDB = "''";
  private int resultCount = 0;

  /**
   * Creates a new CombinedSearch object.
   */
  public void CombinedSearch() {
  }

  /**
   * Setter for sourcedb property.
   * @param sourcedb sourcedb.
   */
  public void SetSourceDB(String sourcedb) {
    SourceDB = sourcedb;
  }

  /**
   * Initialization method for this object.
   * @param SQL_DRIVER_NAME JDBC driver.
   * @param SQL_DRIVER_URL JDBC url.
   * @param SQL_DRIVER_USERNAME JDBC username.
   * @param SQL_DRIVER_PASSWORD JDBC password.
   */
  public void Init(String SQL_DRIVER_NAME, String SQL_DRIVER_URL,
                   String SQL_DRIVER_USERNAME, String SQL_DRIVER_PASSWORD) {
    SQL_DRV = SQL_DRIVER_NAME;
    SQL_URL = SQL_DRIVER_URL;
    SQL_USR = SQL_DRIVER_USERNAME;
    SQL_PWD = SQL_DRIVER_PASSWORD;
  }

  /**
   * Limit the results computed.
   * @param SQLLimit Limit.
   */
  public void SetSQLLimit(int SQLLimit) {
    SQL_LIMIT = SQLLimit;
  }

  public boolean DeleteResults(String IdSession, String NatureObject) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH_RESULTS";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";
      if (NatureObject.equalsIgnoreCase("Species")) {
        SQL += " AND ID_NATURE_OBJECT_SPECIES > 0";
      }
      if (NatureObject.equalsIgnoreCase("Habitat")) {
        SQL += " AND ID_NATURE_OBJECT_HABITATS > 0";
      }
      if (NatureObject.equalsIgnoreCase("Sites")) {
        SQL += " AND ID_NATURE_OBJECT_SITES > 0";
      }

//      System.out.println("SQL = " + SQL);

      ps = con.prepareStatement(SQL);
      ps.execute();
      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean AddResult(String IdSession, String NatureObject, String IdNatureObject) {
    boolean result = false;

    StringBuffer SQL = new StringBuffer();
    Connection con = null;
    Statement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      ps = con.createStatement();
      StringTokenizer tokenizer = new StringTokenizer(IdNatureObject, ",");

      SQL.append("ALTER TABLE EUNIS_COMBINED_SEARCH_RESULTS DISABLE KEYS");
      ps.execute(SQL.toString());

      int poscount = tokenizer.countTokens();
//      System.out.println("poscount = " + poscount);
      int pos = 0;
      int max_results = poscount;
//      int max_results=3;

      SQL = new StringBuffer();
      SQL.ensureCapacity(65000);
      SQL.append("INSERT INTO EUNIS_COMBINED_SEARCH_RESULTS");
      SQL.append(" (ID_SESSION,ID_NATURE_OBJECT,");
      SQL.append(" ID_NATURE_OBJECT_SPECIES,ID_NATURE_OBJECT_HABITATS,ID_NATURE_OBJECT_SITES,");
      SQL.append(" ID_NATURE_OBJECT_COMBINATION_1,ID_NATURE_OBJECT_COMBINATION_2,ID_NATURE_OBJECT_COMBINATION_3)");
      SQL.append(" VALUES ");
      while (tokenizer.hasMoreElements() && pos < max_results) {
        pos++;
        SQL.append("(");
        SQL.append("'" + IdSession + "',");
        //SQL.append("'" + NatureObject + "',");
        //!!!VI!!!
        SQL.append("-1,");
        if (SQL.length() > 64000) {
          if (NatureObject.equalsIgnoreCase("Species")) {
            SQL.append(tokenizer.nextElement().toString().trim() + ",-1,-1,");
          }
          if (NatureObject.equalsIgnoreCase("Habitat")) {
            SQL.append("-1," + tokenizer.nextElement().toString().trim() + ",-1,");
          }
          if (NatureObject.equalsIgnoreCase("Sites")) {
            SQL.append("-1,-1," + tokenizer.nextElement().toString().trim() + ",");
          }
          SQL.append("-1,-1,-1)");

          //ro.finsiel.eunis.admin.FileUtils.dumpToFile(SQL.toString(),false);
          ps.executeUpdate(SQL.toString());
          //System.out.println(SQL.toString());

          SQL = new StringBuffer();
          SQL.ensureCapacity(65000);
          SQL.append("INSERT INTO EUNIS_COMBINED_SEARCH_RESULTS");
          SQL.append(" (ID_SESSION,ID_NATURE_OBJECT,");
          SQL.append(" ID_NATURE_OBJECT_SPECIES,ID_NATURE_OBJECT_HABITATS,ID_NATURE_OBJECT_SITES,");
          SQL.append(" ID_NATURE_OBJECT_COMBINATION_1,ID_NATURE_OBJECT_COMBINATION_2,ID_NATURE_OBJECT_COMBINATION_3)");
          SQL.append(" VALUES ");
        } else {
          if (NatureObject.equalsIgnoreCase("Species")) {
            SQL.append(tokenizer.nextElement().toString().trim() + ",-1,-1,");
          }
          if (NatureObject.equalsIgnoreCase("Habitat")) {
            SQL.append("-1," + tokenizer.nextElement().toString().trim() + ",-1,");
          }
          if (NatureObject.equalsIgnoreCase("Sites")) {
            SQL.append("-1,-1," + tokenizer.nextElement().toString().trim() + ",");
          }
          SQL.append("-1,-1,-1)");
          if (pos < max_results) {
            SQL.append(",");
          }
        }
      }
      if (SQL.length() > 0) {
        //ro.finsiel.eunis.admin.FileUtils.dumpToFile(SQL.toString(),false);
        ps.executeUpdate(SQL.toString());
        //System.out.println(SQL.toString());
      }

      SQL = new StringBuffer();
      SQL.append("ALTER TABLE EUNIS_COMBINED_SEARCH_RESULTS ENABLE KEYS");
      ps.execute(SQL.toString());
      ps.close();

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean ChangeCriteria(String IdNode, String IdSession, String NatureObject, String Criteria) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "UPDATE EUNIS_COMBINED_SEARCH";
      SQL += " SET NODE_TYPE='" + Criteria + "'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();
      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean ChangeAttribute(String IdNode, String IdSession, String NatureObject, String Attribute) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " SET ATTRIBUTE='" + Attribute + "'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();
      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean ChangeOperator(String IdNode, String IdSession, String NatureObject, String Operator) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " SET OPERATOR='" + Operator + "'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      if (Operator.equalsIgnoreCase("Between")) {
        SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
        SQL += " SET LAST_VALUE='enter value here...'";
        SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
        SQL += " AND ID_SESSION = '" + IdSession + "'";
        SQL += " AND ID_NODE = '" + IdNode + "'";

        ps = con.prepareStatement(SQL);
        ps.execute();

      } else {
        SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
        SQL += " SET LAST_VALUE=''";
        SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
        SQL += " AND ID_SESSION = '" + IdSession + "'";
        SQL += " AND ID_NODE = '" + IdNode + "'";

        ps = con.prepareStatement(SQL);
        ps.execute();
      }

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean ChangeFirstValue(String IdNode, String IdSession, String NatureObject, String FirstValue) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " SET FIRST_VALUE='" + FirstValue + "'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();
      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean ChangeLastValue(String IdNode, String IdSession, String NatureObject, String LastValue) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " SET LAST_VALUE='" + LastValue + "'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();
      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public String BuildFilter(String IdNode, String IdSession, String NatureObject) {
    String result = "";

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "SELECT * FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      //System.out.println("SQL = " + SQL);

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      if (rs.isBeforeFirst()) {
        rs.next();
        if (NatureObject.equalsIgnoreCase("Species")) {
          ro.finsiel.eunis.search.species.advanced.SpeciesAdvancedSearch sas;
          sas = new ro.finsiel.eunis.search.species.advanced.SpeciesAdvancedSearch();
          sas.SetSQLLimit(SQL_LIMIT);
          sas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
          sas.AddCriteria(rs.getString("ATTRIBUTE"), rs.getString("OPERATOR"), rs.getString("FIRST_VALUE"), rs.getString("LAST_VALUE"));
          result = sas.BuildFilter();
          resultCount = sas.getResultCount();
//          System.out.println("resultCount = " + resultCount);
        }
        if (NatureObject.equalsIgnoreCase("Habitat")) {
          ro.finsiel.eunis.search.habitats.advanced.HabitatsAdvancedSearch has;
          has = new ro.finsiel.eunis.search.habitats.advanced.HabitatsAdvancedSearch();
          has.SetSQLLimit(SQL_LIMIT);
          has.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
          has.AddCriteria(rs.getString("ATTRIBUTE"), rs.getString("OPERATOR"), rs.getString("FIRST_VALUE"), rs.getString("LAST_VALUE"));
          result = has.BuildFilter();
          resultCount = has.getResultCount();
//          System.out.println("resultCount = " + resultCount);
        }
        if (NatureObject.equalsIgnoreCase("Sites")) {
          ro.finsiel.eunis.search.sites.advanced.SitesAdvancedSearch sas;
          sas = new ro.finsiel.eunis.search.sites.advanced.SitesAdvancedSearch();
          sas.SetSourceDB(SourceDB);
          sas.SetSQLLimit(SQL_LIMIT);
          sas.Init(SQL_DRV, SQL_URL, SQL_USR, SQL_PWD);
          sas.AddCriteria(rs.getString("ATTRIBUTE"), rs.getString("OPERATOR"), rs.getString("FIRST_VALUE"), rs.getString("LAST_VALUE"));
          result = sas.BuildFilter();
          resultCount = sas.getResultCount();
//          System.out.println("resultCount = " + resultCount);
        }
      }

      rs.close();
      ps.close();
      con.close();

      return result;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }
  }
  /**
   * Interpret search criteria (tree).
   * @param IdNode ID of the node
   * @param IdSession SESSION id.
   * @param NatureObject Nature object(species/habs/sites).
   * @return Criteria.
   */
  public String InterpretCriteria(String IdNode, String IdSession, String NatureObject) {
    String result = "";

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "SELECT * FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      //System.out.println("SQL = " + SQL);

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      if (rs.isBeforeFirst()) {
        rs.next();
        result = "<strong>" + ro.finsiel.eunis.search.Utilities.SplitString(rs.getString("ATTRIBUTE")) + "</strong> ";
        result += "<em>" + rs.getString("OPERATOR") + "</em> ";
        result += "<u>" + rs.getString("FIRST_VALUE") + "</u>";
        if (rs.getString("OPERATOR").equalsIgnoreCase("Between")) {
          result += " <em>AND</em> <u>" + rs.getString("LAST_VALUE") + "</u>";
        }
      }

      rs.close();
      ps.close();
      con.close();

      return result;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }
  }

  public boolean DeleteBranch(String IdNode, String IdSession, String NatureObject) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE LIKE '" + IdNode + "%'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE LIKE '" + IdNode + "%'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  /**
   * Delete all search criterias set.
   * @param IdSession ID session.
   * @param NatureObject Nature object (species/habs/sites).
   * @param Attribute Attribute.
   * @return true if cleared.
   */
  public boolean DeleteRoot(String IdSession, String NatureObject, String Attribute) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      ps.close();
      con.close();

      result = this.CreateInitialBranch(IdSession, NatureObject, Attribute);
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  /**
   * Delete all search criterias set.
   * @param IdSession ID session.
   * @param NatureObject Nature object (species/habs/sites).
   * @param Attribute Attribute.
   * @return true if cleared.
   */
  public boolean DeleteRootNoInitialize(String IdSession, String NatureObject, String Attribute) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      ps.close();
      con.close();

      result = true;

    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  /**
   * Insert a new branch into search tree.
   * @param IdNode id of the parent.
   * @param IdSession SESSION ID.
   * @param NatureObject nature object.
   * @param Attribute attribute.
   * @return true if inserted.
   */
  public boolean InsertBranch(String IdNode, String IdSession, String NatureObject, String Attribute) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String IdNodeNew = "";

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      //obtin ultimul nod child al nodului curent
      if (IdNode.length() == 1) {
        SQL = "SELECT * FROM EUNIS_COMBINED_SEARCH";
        SQL += " WHERE ID_SESSION = '" + IdSession + "'";
        SQL += " AND NATURE_OBJECT = '" + NatureObject + "'";
        SQL += " AND LENGTH(ID_NODE) = " + IdNode.length();
        SQL += " ORDER BY ID_NODE DESC";
      } else {
        SQL = "SELECT * FROM EUNIS_COMBINED_SEARCH";
        SQL += " WHERE ID_NODE LIKE '" + IdNode.substring(0, IdNode.length() - 1) + "%'";
        SQL += " AND ID_SESSION = '" + IdSession + "'";
        SQL += " AND NATURE_OBJECT = '" + NatureObject + "'";
        SQL += " AND LENGTH(ID_NODE) = " + IdNode.length();
        SQL += " ORDER BY ID_NODE DESC";
      }

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      Integer LastNumber = new Integer(0);

      if (rs.next()) {
        if (IdNode.length() == 1) {
          LastNumber = new Integer(rs.getString("ID_NODE"));
          LastNumber = new Integer(LastNumber.intValue() + 1);
        } else {
          //System.out.println("LastNumber = " + rs.getString("ID_NODE").substring(rs.getString("ID_NODE").length()-1));
          LastNumber = new Integer(rs.getString("ID_NODE").substring(rs.getString("ID_NODE").length() - 1));
          //System.out.println("LastNumber = " + LastNumber);
          LastNumber = new Integer(LastNumber.intValue() + 1);
        }

        rs.close();

        if (LastNumber.intValue() > 9) {
          return result;
        }

        if (IdNode.length() == 1) {
          IdNodeNew = LastNumber.toString();
        } else {
          IdNodeNew = IdNode.substring(0, IdNode.length() - 1) + LastNumber.toString();
        }

        SQL = "INSERT INTO EUNIS_COMBINED_SEARCH";
        SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,NODE_TYPE)";
        SQL += " VALUES(";
        SQL += "'" + IdSession + "',";
        SQL += "'" + NatureObject + "',";
        SQL += "'" + IdNodeNew + "',";
        SQL += "'Criteria')";

        ps = con.prepareStatement(SQL);
        ps.execute();

        SQL = "INSERT INTO EUNIS_COMBINED_SEARCH_CRITERIA";
        SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,ATTRIBUTE,OPERATOR,FIRST_VALUE,LAST_VALUE)";
        SQL += " VALUES(";
        SQL += "'" + IdSession + "',";
        SQL += "'" + NatureObject + "',";
        SQL += "'" + IdNodeNew + "',";
        SQL += "'" + Attribute + "',";
        SQL += "'Equal',";
        SQL += "'enter value here...',";
        SQL += "'')";

        ps = con.prepareStatement(SQL);
        ps.execute();

        ps.close();
        con.close();

        result = true;
      } else {
        System.out.println("Unexpected error adding branch!");
      }
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean ComposeBranch(String IdNode, String IdSession, String NatureObject) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "UPDATE EUNIS_COMBINED_SEARCH";
      SQL += " SET NODE_TYPE='All'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "INSERT INTO EUNIS_COMBINED_SEARCH";
      SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,NODE_TYPE)";
      SQL += " VALUES(";
      SQL += "'" + IdSession + "',";
      SQL += "'" + NatureObject + "',";
      SQL += "'" + IdNode + ".1',";
      SQL += "'Criteria')";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "UPDATE EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " SET ID_NODE='" + IdNode + ".1'";
      SQL += " WHERE NATURE_OBJECT = '" + NatureObject + "'";
      SQL += " AND ID_SESSION = '" + IdSession + "'";
      SQL += " AND ID_NODE = '" + IdNode + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public boolean CreateInitialBranch(String IdSession, String NatureObject, String Attribute) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH";
      SQL += " WHERE ID_SESSION='" + IdSession + "'";
      SQL += " AND NATURE_OBJECT='" + NatureObject + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE ID_SESSION='" + IdSession + "'";
      SQL += " AND NATURE_OBJECT='" + NatureObject + "'";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "INSERT INTO EUNIS_COMBINED_SEARCH";
      SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,NODE_TYPE)";
      SQL += " VALUES(";
      SQL += "'" + IdSession + "',";
      SQL += "'" + NatureObject + "',";
      SQL += "'0',";
      SQL += "'All')";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "INSERT INTO EUNIS_COMBINED_SEARCH";
      SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,NODE_TYPE)";
      SQL += " VALUES(";
      SQL += "'" + IdSession + "',";
      SQL += "'" + NatureObject + "',";
      SQL += "'1',";
      SQL += "'Criteria')";

      ps = con.prepareStatement(SQL);
      ps.execute();

      SQL = "INSERT INTO EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,ATTRIBUTE,OPERATOR,FIRST_VALUE,LAST_VALUE)";
      SQL += " VALUES(";
      SQL += "'" + IdSession + "',";
      SQL += "'" + NatureObject + "',";
      SQL += "'1',";
      SQL += "'" + Attribute + "',";
      SQL += "'Equal',";
      SQL += "'enter value here...',";
      SQL += "'')";

      ps = con.prepareStatement(SQL);
      ps.execute();

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  public String createCriteria(String IdSession, String NatureObject) {
    String where = "";
    String SQL = "";
    String p_operator = "";
    String SQLModelStart = "";
    String SQLModelEnd = "";

    String NodeType = "";
    String IdNode = "";

    Connection con = null;
    PreparedStatement ps = null;

    ResultSet rs = null;
    ResultSet rsa = null;
    ResultSet rsb = null;
    ResultSet rsc = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQLModelStart = "SELECT ";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH`.`ID_NODE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH`.`NODE_TYPE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA`.`ATTRIBUTE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA`.`OPERATOR`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA`.`FIRST_VALUE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA`.`LAST_VALUE` ";
      SQLModelStart += "FROM ";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH` ";
      SQLModelStart += "LEFT OUTER JOIN `EUNIS_COMBINED_SEARCH_CRITERIA` ON (`EUNIS_COMBINED_SEARCH`.`ID_SESSION` = `EUNIS_COMBINED_SEARCH_CRITERIA`.`ID_SESSION`) AND (`EUNIS_COMBINED_SEARCH`.`NATURE_OBJECT` = `EUNIS_COMBINED_SEARCH_CRITERIA`.`NATURE_OBJECT`) AND (`EUNIS_COMBINED_SEARCH`.`ID_NODE` = `EUNIS_COMBINED_SEARCH_CRITERIA`.`ID_NODE`) ";
      SQLModelStart += "WHERE (`EUNIS_COMBINED_SEARCH`.`ID_SESSION`='" + IdSession + "') ";
      SQLModelStart += "AND (`EUNIS_COMBINED_SEARCH`.`NATURE_OBJECT`='" + NatureObject + "') ";
      SQLModelEnd += "ORDER BY ";
      SQLModelEnd += "`EUNIS_COMBINED_SEARCH`.`ID_NODE` ";

      SQL = SQLModelStart;
      SQL += "AND (`EUNIS_COMBINED_SEARCH`.`ID_NODE`='0') ";
      SQL += SQLModelEnd;
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();
      if (rs.next()) {
        p_operator = rs.getString("NODE_TYPE");
      }
      rs.close();

      SQL = SQLModelStart;
      SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH`.`ID_NODE`)=1) ";
      SQL += "AND (`EUNIS_COMBINED_SEARCH`.`ID_NODE`<>'0') ";
      SQL += SQLModelEnd;
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      where += "[ ";
      while (rs.next()) {
        IdNode = rs.getString("ID_NODE");
        NodeType = rs.getString("NODE_TYPE");
        if (NodeType.equalsIgnoreCase("Criteria")) {
          where += "#" + IdNode + "#";
        } else {
          SQL = SQLModelStart;
          SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH`.`ID_NODE`)=3) ";
          SQL += "AND (`EUNIS_COMBINED_SEARCH`.`ID_NODE` LIKE '" + IdNode + ".%') ";
          SQL += SQLModelEnd;
          ps = con.prepareStatement(SQL);
          rsa = ps.executeQuery();

          if (rsa.isBeforeFirst()) {
            where += "[ ";
            while (rsa.next()) {
              IdNode = rsa.getString("ID_NODE");
              NodeType = rsa.getString("NODE_TYPE");
              if (NodeType.equalsIgnoreCase("Criteria")) {
                where += "#" + IdNode + "#";
              } else {
                SQL = SQLModelStart;
                SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH`.`ID_NODE`)=5) ";
                SQL += "AND (`EUNIS_COMBINED_SEARCH`.`ID_NODE` LIKE '" + IdNode + ".%') ";
                SQL += SQLModelEnd;
                ps = con.prepareStatement(SQL);
                rsb = ps.executeQuery();

                if (rsb.isBeforeFirst()) {
                  where += "[ ";
                  while (rsb.next()) {
                    IdNode = rsb.getString("ID_NODE");
                    NodeType = rsb.getString("NODE_TYPE");
                    if (NodeType.equalsIgnoreCase("Criteria")) {
                      where += "#" + IdNode + "#";
                    } else {
                      SQL = SQLModelStart;
                      SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH`.`ID_NODE`)=7) ";
                      SQL += "AND (`EUNIS_COMBINED_SEARCH`.`ID_NODE` LIKE '" + IdNode + ".%') ";
                      SQL += SQLModelEnd;
                      ps = con.prepareStatement(SQL);
                      rsc = ps.executeQuery();

                      if (rsc.isBeforeFirst()) {
                        where += "[ ";
                        while (rsc.next()) {
                          IdNode = rsc.getString("ID_NODE");

                          where += "#" + IdNode + "#";

                          if (!rsc.isLast()) {
                            if (rsb.getString("NODE_TYPE").equalsIgnoreCase("Any")) where += " OR ";
                            if (rsb.getString("NODE_TYPE").equalsIgnoreCase("All")) where += " AND ";
                          }
                        }
                        where += " ]";
                      }
                      rsc.close();
                    }

                    if (!rsb.isLast()) {
                      if (rsa.getString("NODE_TYPE").equalsIgnoreCase("Any")) where += " OR ";
                      if (rsa.getString("NODE_TYPE").equalsIgnoreCase("All")) where += " AND ";
                    }
                  }
                  where += " ]";
                }
                rsb.close();
              }

              if (!rsa.isLast()) {
                if (rs.getString("NODE_TYPE").equalsIgnoreCase("Any")) where += " OR ";
                if (rs.getString("NODE_TYPE").equalsIgnoreCase("All")) where += " AND ";
              }
            }
            where += " ]";
          }
          rsa.close();
        }
        if (!rs.isLast()) {
          if (p_operator.equalsIgnoreCase("Any")) where += " OR ";
          if (p_operator.equalsIgnoreCase("All")) where += " AND ";
        }
      }
      where += " ]";

      rs.close();
      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
      return where;
    }

    return where;
  }


  public String calculateCriteria(String IdSession, String NatureObject) {
    String where = "";
    String SQL = "";
    String p_operator = "";
    String SQLModelStart = "";
    String SQLModelEnd = "";

    String NodeType = "";
    String IdNode = "";

    Connection con = null;
    PreparedStatement ps = null;

    ResultSet rs = null;
    ResultSet rsa = null;
    ResultSet rsb = null;
    ResultSet rsc = null;

    String SQLnodes = "";
    String snode = "";
    String snodes = "";
    String snodea = "";
    String snodesa = "";
    String snodeb = "";
    String snodesb = "";
    String snodec = "";
    String snodesc = "";

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQLModelStart = "DELETE FROM EUNIS_COMBINED_SEARCH_TEMP";
      SQLModelStart += " WHERE (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_SESSION`='" + IdSession + "') ";
      SQLModelStart += " AND (`EUNIS_COMBINED_SEARCH_TEMP`.`NATURE_OBJECT`='" + NatureObject + "') ";
      ps = con.prepareStatement(SQLModelStart);
      ps.execute();

      SQLModelStart = "DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA_TEMP";
      SQLModelStart += " WHERE (`EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`ID_SESSION`='" + IdSession + "') ";
      SQLModelStart += " AND (`EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`NATURE_OBJECT`='" + NatureObject + "') ";
      ps = con.prepareStatement(SQLModelStart);
      ps.execute();

//      System.out.println("delete done");

      SQLModelStart = "SELECT * FROM EUNIS_COMBINED_SEARCH";
      SQLModelStart += " WHERE (`EUNIS_COMBINED_SEARCH`.`ID_SESSION`='" + IdSession + "') ";
      SQLModelStart += " AND (`EUNIS_COMBINED_SEARCH`.`NATURE_OBJECT`='" + NatureObject + "') ";
      ps = con.prepareStatement(SQLModelStart);
      rs = ps.executeQuery();
      while (rs.next()) {
        SQL = "INSERT INTO EUNIS_COMBINED_SEARCH_TEMP";
        SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,NODE_TYPE)";
        SQL += " VALUES(";
        SQL += "'" + rs.getString("ID_SESSION") + "',";
        SQL += "'" + rs.getString("NATURE_OBJECT") + "',";
        SQL += "'" + rs.getString("ID_NODE") + "',";
        SQL += "'" + rs.getString("NODE_TYPE") + "'";
        SQL += ")";
        ps = con.prepareStatement(SQL);
        ps.execute();
      }
      rs.close();

      SQLModelStart = "SELECT * FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQLModelStart += " WHERE (`EUNIS_COMBINED_SEARCH_CRITERIA`.`ID_SESSION`='" + IdSession + "') ";
      SQLModelStart += " AND (`EUNIS_COMBINED_SEARCH_CRITERIA`.`NATURE_OBJECT`='" + NatureObject + "') ";
      ps = con.prepareStatement(SQLModelStart);
      rs = ps.executeQuery();
      while (rs.next()) {
        SQL = "INSERT INTO EUNIS_COMBINED_SEARCH_CRITERIA_TEMP";
        SQL += "(ID_SESSION,NATURE_OBJECT,ID_NODE,ATTRIBUTE,OPERATOR,FIRST_VALUE,LAST_VALUE)";
        SQL += " VALUES(";
        SQL += "'" + rs.getString("ID_SESSION") + "',";
        SQL += "'" + rs.getString("NATURE_OBJECT") + "',";
        SQL += "'" + rs.getString("ID_NODE") + "',";
        SQL += "'" + rs.getString("ATTRIBUTE") + "',";
        SQL += "'" + rs.getString("OPERATOR") + "',";
        SQL += "'" + rs.getString("FIRST_VALUE") + "',";
        SQL += "'" + rs.getString("LAST_VALUE") + "'";
        SQL += ")";
        ps = con.prepareStatement(SQL);
        ps.execute();
      }
      rs.close();

//      System.out.println("populate done");

      SQLModelStart = "SELECT ";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_TEMP`.`NODE_TYPE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`ATTRIBUTE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`OPERATOR`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`FIRST_VALUE`,";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`LAST_VALUE` ";
      SQLModelStart += "FROM ";
      SQLModelStart += "`EUNIS_COMBINED_SEARCH_TEMP` ";
      SQLModelStart += "LEFT OUTER JOIN `EUNIS_COMBINED_SEARCH_CRITERIA_TEMP` ON (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_SESSION` = `EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`ID_SESSION`) AND (`EUNIS_COMBINED_SEARCH_TEMP`.`NATURE_OBJECT` = `EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`NATURE_OBJECT`) AND (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE` = `EUNIS_COMBINED_SEARCH_CRITERIA_TEMP`.`ID_NODE`) ";
      SQLModelStart += "WHERE (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_SESSION`='" + IdSession + "') ";
      SQLModelStart += "AND (`EUNIS_COMBINED_SEARCH_TEMP`.`NATURE_OBJECT`='" + NatureObject + "') ";
      SQLModelEnd += "ORDER BY ";
      SQLModelEnd += "`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE` ";

      SQL = SQLModelStart;
      SQL += "AND (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`='0') ";
      SQL += SQLModelEnd;
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();
      if (rs.next()) {
        p_operator = rs.getString("NODE_TYPE");
      }
      rs.close();

      SQL = SQLModelStart;
      SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`)=1) ";
      SQL += "AND (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`<>'0') ";
      SQL += SQLModelEnd;
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      where += "[ ";
      snodes = "";
      while (rs.next()) {
        snode = "";
        IdNode = rs.getString("ID_NODE");
        NodeType = rs.getString("NODE_TYPE");
        if (NodeType.equalsIgnoreCase("Criteria")) {
          where += "#" + IdNode + "#";
          snode = BuildFilter(IdNode, IdSession, NatureObject);
          //System.out.println("snode = " + snode);
        } else {
          SQL = SQLModelStart;
          SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`)=3) ";
          SQL += "AND (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE` LIKE '" + IdNode + ".%') ";
          SQL += SQLModelEnd;
          ps = con.prepareStatement(SQL);
          rsa = ps.executeQuery();

          if (rsa.isBeforeFirst()) {
            where += "[ ";
            snodesa = "";
            while (rsa.next()) {
              snodea = "";
              IdNode = rsa.getString("ID_NODE");
              NodeType = rsa.getString("NODE_TYPE");
              if (NodeType.equalsIgnoreCase("Criteria")) {
                where += "#" + IdNode + "#";
                snodea = BuildFilter(IdNode, IdSession, NatureObject);
                //System.out.println("snodea = " + snodea);
              } else {
                SQL = SQLModelStart;
                SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`)=5) ";
                SQL += "AND (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE` LIKE '" + IdNode + ".%') ";
                SQL += SQLModelEnd;
                ps = con.prepareStatement(SQL);
                rsb = ps.executeQuery();

                if (rsb.isBeforeFirst()) {
                  where += "[ ";
                  snodesb = "";
                  while (rsb.next()) {
                    snodeb = "";
                    IdNode = rsb.getString("ID_NODE");
                    NodeType = rsb.getString("NODE_TYPE");
                    if (NodeType.equalsIgnoreCase("Criteria")) {
                      where += "#" + IdNode + "#";
                      snodeb = BuildFilter(IdNode, IdSession, NatureObject);
                      //System.out.println("snodeb = " + snodeb);
                    } else {
                      SQL = SQLModelStart;
                      SQL += "AND (LENGTH(`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE`)=7) ";
                      SQL += "AND (`EUNIS_COMBINED_SEARCH_TEMP`.`ID_NODE` LIKE '" + IdNode + ".%') ";
                      SQL += SQLModelEnd;
                      ps = con.prepareStatement(SQL);
                      rsc = ps.executeQuery();

                      if (rsc.isBeforeFirst()) {
                        where += "[ ";
                        snodesc = "";
                        while (rsc.next()) {
                          snodec = "";
                          IdNode = rsc.getString("ID_NODE");

                          where += "#" + IdNode + "#";
                          snodec = BuildFilter(IdNode, IdSession, NatureObject);
                          //System.out.println("snodec = " + snodec);

                          snodesc += snodec;
                          if (!rsc.isLast()) {
                            if (rsb.getString("NODE_TYPE").equalsIgnoreCase("Any")) {
                              where += " OR ";
                              snodesc += " OR ";
                            }
                            if (rsb.getString("NODE_TYPE").equalsIgnoreCase("All")) {
                              where += " AND ";
                              snodesc += " AND ";
                            }
                          }
                        }
                        where += " ]";
                      }
                      rsc.close();
                      //System.out.println("snodesc = " + snodesc);
                      //create filter from this level criterias
                      SQLnodes = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_" + NatureObject.toUpperCase();
                      SQLnodes += " WHERE (" + snodesc + ")";
                      //System.out.println("SQLnodes = " + SQLnodes);
                      snodeb = "ID_NATURE_OBJECT IN (" + ExecuteFilterSQL(SQLnodes, "") + ")";
                      //System.out.println("snodeb (facut din snodesc) = " + snodeb);
                    }
                    snodesb += snodeb;
                    if (!rsb.isLast()) {
                      if (rsa.getString("NODE_TYPE").equalsIgnoreCase("Any")) {
                        where += " OR ";
                        snodesb += " OR ";
                      }
                      if (rsa.getString("NODE_TYPE").equalsIgnoreCase("All")) {
                        where += " AND ";
                        snodesb += " AND ";
                      }
                    }
                  }
                  where += " ]";
                }
                rsb.close();
                //System.out.println("snodesb = " + snodesb);
                //create filter from this level criterias
                SQLnodes = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_" + NatureObject.toUpperCase();
                SQLnodes += " WHERE (" + snodesb + ")";
                //System.out.println("SQLnodes = " + SQLnodes);
                snodea = "ID_NATURE_OBJECT IN (" + ExecuteFilterSQL(SQLnodes, "") + ")";
                //System.out.println("snodea (facut din snodesb) = " + snodea);
              }
              snodesa += snodea;
              if (!rsa.isLast()) {
                if (rs.getString("NODE_TYPE").equalsIgnoreCase("Any")) {
                  where += " OR ";
                  snodesa += " OR ";
                }
                if (rs.getString("NODE_TYPE").equalsIgnoreCase("All")) {
                  where += " AND ";
                  snodesa += " AND ";
                }
              }
            }
            where += " ]";
          }
          rsa.close();
          //System.out.println("snodesa = " + snodesa);
          //create filter from this level criterias
          SQLnodes = "SELECT ID_NATURE_OBJECT FROM CHM62EDT_" + NatureObject.toUpperCase();
          SQLnodes += " WHERE (" + snodesa + ")";
          //System.out.println("SQLnodes = " + SQLnodes);
          //System.out.println("ce se executa ca sa obtin snode = " + ExecuteFilterSQL(SQLnodes,""));
          snode = "ID_NATURE_OBJECT IN (" + ExecuteFilterSQL(SQLnodes, "") + ")";
          //System.out.println("snode (facut di snodesa) = " + snode);
        }
        snodes += snode;
        if (!rs.isLast()) {
          if (p_operator.equalsIgnoreCase("Any")) {
            where += " OR ";
            snodes += " OR ";
          }
          if (p_operator.equalsIgnoreCase("All")) {
            where += " AND ";
            snodes += " AND ";
          }
        }
      }
      where += " ]";
      rs.close();

      ps.close();
      con.close();
      //System.out.println("snodes = " + snodes);
    } catch (Exception e) {
      e.printStackTrace();
      return where;
    }

    return snodes;
  }

  /**
   * Insert &nbsp; into a string
   * @param spaces Number of spaces.
   * @return Formatted string.
   */
  private String Spaces(int spaces) {
    String result = "";

    for (int i = 0; i < spaces; i++) {
      result = result + "&nbsp;";
    }

    return result;
  }

  public String FormatCriteria(String where) {
    String result = "";
    int ident = -1;
    int i = 0;
    char c;

    for (i = 0; i < where.length(); i++) {
      c = where.charAt(i);
      if (c == '(') {
        ident++;
        result += c;
        result += "<br />" + Spaces(ident * 3);
      } else {
        if (c == ')') {
          result += "<br />" + Spaces(ident * 3);
          result += c;
          ident--;
          result += "<br />" + Spaces(ident * 3);
        } else {
          result += c;
        }
      }
    }

    return result;
  }

  /**
   * Execute an sql.
   * @param SQL SQL.
   * @param Delimiter LIMIT
   */
  public String ExecuteFilterSQL(String SQL, String Delimiter) {

    String result = "";

    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      if (SQL.length() > 0) {
        resultCount = 0;
        ResultSet rs = null;
        ps = con.prepareStatement(SQL);
        //System.out.println("Executing: "+SQL);
        rs = ps.executeQuery();
        result = "";
        while (rs.next()) {
          resultCount++;
          if (resultCount < SQL_LIMIT) {
            result += Delimiter + rs.getString(1) + Delimiter;
            result += ",";
          }
        }
        if (resultCount >= SQL_LIMIT) {
//          System.out.println("<<< SQL LIMIT of "+SQL_LIMIT+" reached!. The results might not be concludent! >>>");
        }
        if (result.length() > 0) {
          if (result.substring(result.length() - 1).equalsIgnoreCase(",")) {
            result = result.substring(0, result.length() - 1);
          }
        } else {
          result = "-1";
        }
        rs.close();
        ps.close();
      }
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
      //System.out.println("SQL = " + SQL);
      return "";
    }

    return result;
  }

  /**
   * Execute an sql.
   * @param SQL SQL.
   * @return First column.
   */
  public String ExecuteSQL(String SQL) {
    String result = "";

    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);
      if (SQL.length() > 0) {
        ResultSet rs = null;
        ps = con.prepareStatement(SQL);
        //System.out.println("Executing: "+SQL);
        rs = ps.executeQuery();
        if (rs.next()) {
          result = rs.getString(1);
        }
        rs.close();
        ps.close();
      }
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
      return "";
    }

    return result;
  }

  public String CreateList(String IdSession, String NatureObject) {
    String SQL = "";
    String result = "";

    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);

      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      ResultSet rs = null;

      if (NatureObject.equalsIgnoreCase("Species")) {
        SQL = "SELECT ID_NATURE_OBJECT_SPECIES";
      }
      if (NatureObject.equalsIgnoreCase("Habitat")) {
        SQL = "SELECT ID_NATURE_OBJECT_HABITATS";
      }
      if (NatureObject.equalsIgnoreCase("Sites")) {
        SQL = "SELECT ID_NATURE_OBJECT_SITES";
      }
      if (NatureObject.equalsIgnoreCase("Combination_1")) {
        SQL = "SELECT ID_NATURE_OBJECT_COMBINATION_1";
      }
      if (NatureObject.equalsIgnoreCase("Combination_2")) {
        SQL = "SELECT ID_NATURE_OBJECT_COMBINATION_2";
      }
      if (NatureObject.equalsIgnoreCase("Combination_3")) {
        SQL = "SELECT ID_NATURE_OBJECT_COMBINATION_3";
      }
      SQL += " FROM EUNIS_COMBINED_SEARCH_RESULTS";
      SQL += " WHERE ID_SESSION='" + IdSession + "'";
      if (NatureObject.equalsIgnoreCase("Species")) {
        SQL += " AND ID_NATURE_OBJECT_SPECIES>0";
      }
      if (NatureObject.equalsIgnoreCase("Habitat")) {
        SQL += " AND ID_NATURE_OBJECT_HABITATS>0";
      }
      if (NatureObject.equalsIgnoreCase("Sites")) {
        SQL += " AND ID_NATURE_OBJECT_SITES>0";
      }
      if (NatureObject.equalsIgnoreCase("Combination_1")) {
        SQL += " AND ID_NATURE_OBJECT_COMBINATION_1>0";
      }
      if (NatureObject.equalsIgnoreCase("Combination_2")) {
        SQL += " AND ID_NATURE_OBJECT_COMBINATION_2>0";
      }
      if (NatureObject.equalsIgnoreCase("Combination_3")) {
        SQL += " AND ID_NATURE_OBJECT_COMBINATION_3>0";
      }

      //System.out.println("Executing: "+SQL);
      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();
      while (rs.next()) {
        result += rs.getString(1) + ",";
      }

      if (result.length() == 0) {
        result = "-1";
      } else {
        result = result.substring(0, result.length() - 1);
      }

      rs.close();
      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
      return "";
    }

    return result;
  }

  //we create a list from an already populated EUNIS_COMBINED_SEARCH column
  public String CreateSpecialList(String IdSession, int ColumnIndex) {
    String SQL = "";
    String result = "";

    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);

      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      ResultSet rs = null;

      if (ColumnIndex == 1) {
        SQL = "ID_NATURE_OBJECT_COMBINATION_1";
      }
      if (ColumnIndex == 2) {
        SQL = "ID_NATURE_OBJECT_COMBINATION_2";
      }
      SQL += " FROM EUNIS_COMBINED_SEARCH_RESULTS";
      SQL += " WHERE ID_SESSION='" + IdSession + "'";
      if (ColumnIndex == 1) {
        SQL += " AND ID_NATURE_OBJECT_COMBINATION_1>0";
      }
      if (ColumnIndex == 2) {
        SQL += " AND ID_NATURE_OBJECT_COMBINATION_2>0";
      }

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();
      while (rs.next()) {
        result += rs.getString(1) + ",";
      }

      if (result.length() == 0) {
        result = "-1";
      } else {
        result = result.substring(0, result.length() - 1);
      }

      rs.close();
      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
      return "";
    }

    return result;
  }

  public boolean DeleteSessionData(String IdSession) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    Statement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_RESULTS";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_TEMP";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA_TEMP";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";
      ps = con.createStatement();
      ps.execute(SQL);

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }
    return result;
  }

  public boolean DeleteAllTemporaryData() {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    Statement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_RESULTS";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_TEMP";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      ps = con.createStatement();
      ps.execute(SQL);

      SQL = " DELETE FROM EUNIS_COMBINED_SEARCH_CRITERIA_TEMP";
      ps = con.createStatement();
      ps.execute(SQL);

      ps.close();
      con.close();

      result = true;
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }
    return result;
  }

  public boolean CheckExistingSessionData(String IdSession) {
    boolean result = false;

    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      SQL = "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      rs.next();
      if (rs.getInt(1) > 0) {
        rs.close();
        result = true;
        return result;
      }
      rs.close();

      SQL = "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_CRITERIA";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      rs.next();
      if (rs.getInt(1) > 0) {
        rs.close();
        result = true;
        return result;
      }
      rs.close();

      SQL = "SELECT COUNT(*) FROM EUNIS_COMBINED_SEARCH_RESULTS";
      SQL += " WHERE ID_SESSION = '" + IdSession + "'";

      ps = con.prepareStatement(SQL);
      rs = ps.executeQuery();

      rs.next();
      if (rs.getInt(1) > 0) {
        rs.close();
        result = true;
        return result;
      }
      rs.close();

      ps.close();
      con.close();
    } catch (Exception e) {
      e.printStackTrace();
      return result;
    }

    return result;
  }

  /**
   * Count search results.
   * @return reusults count.
   */
  public int getResultCount() {
    return resultCount;
  }
}
