package ro.finsiel.eunis.search.sites.advanced;

import java.util.Vector;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;

/**
 * Class used for sites advanced search.
 * @author finsiel
 */
public class SitesAdvancedSearch {
  private String SQL_DRV = "";
  private String SQL_URL = "";
  private String SQL_USR = "";
  private String SQL_PWD = "";
  private int SQL_LIMIT = 1000;

  private Vector Tables = new Vector();
  private Vector Operands = new Vector();
  private Vector MinValues = new Vector();
  private Vector MaxValues = new Vector();;

  private int resultCount = 0;

  private String SourceDB = "''";

  /**
   * Ctor.
   */
  public void SitesAdvancedSearch() {
  }

  /**
   * Setter for sourcedb property.
   * @param sourcedb sourcedb.
   */
  public void SetSourceDB(String sourcedb) {
    SourceDB = sourcedb;
  }

  /**
   * Initialization method.
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
   * Limit the result output of the queries.
   * @param SQLLimit Limit.
   */
  public void SetSQLLimit(int SQLLimit) {
    SQL_LIMIT = SQLLimit;
  }

  private int FindCriteria(String Table, String Operand, String ValueMin, String ValueMax) {
    int pos = -1;
    int i;
    String sTable;
    String sOperand;
    String sValueMin;
    String sValueMax;

    if (!this.Tables.isEmpty()) {
      for (i = 0; i < this.Tables.size(); i++) {
        sTable = (String) this.Tables.elementAt(i);
        if (sTable.equalsIgnoreCase(Table)) {
          sOperand = (String) this.Operands.elementAt(i);
          sValueMin = (String) this.MinValues.elementAt(i);
          sValueMax = (String) this.MaxValues.elementAt(i);
          if (sOperand.equalsIgnoreCase(Operand) &&
                  sValueMin.equalsIgnoreCase(ValueMin) &&
                  sValueMax.equalsIgnoreCase(ValueMax)) {
            pos = i;
          }
        }
      }
    }
    return pos;
  }

  /**
   * Add a new filter to the search criteria.
   * @param Table Table.
   * @param Operand Operand.
   * @param ValueMin Minimum value.
   * @param ValueMax Maximum value.
   */
  public void AddCriteria(String Table, String Operand, String ValueMin, String ValueMax) {
    int pos = -1;

    if (null == Table || null == Operand || null == ValueMin) return;
    if (Table.length() > 0 && Operand.length() > 0) {
      if (Operand.equalsIgnoreCase("Equal") && ValueMin.length() == 0) {
        return;
      }
      if (Operand.equalsIgnoreCase("Contains") && ValueMin.length() == 0) {
        return;
      }
      if (Operand.equalsIgnoreCase("Between") && ValueMin.length() == 0) {
        return;
      }
      if (Operand.equalsIgnoreCase("Between") && ValueMax.length() == 0) {
        return;
      }


      if (!this.Tables.isEmpty()) {
        pos = this.FindCriteria(Table, Operand, ValueMin, ValueMax);
      }
      if (pos == -1) {
        this.Tables.addElement(Table);
        this.Operands.addElement(Operand);
        this.MinValues.addElement(ValueMin);
        this.MaxValues.addElement(ValueMax);
      }
    }
  }

  /**
   * Remove a search filter.
   * @param Table Table.
   * @param Operand Relation operator.
   * @param ValueMin Minimum value.
   * @param ValueMax Maximum value.
   */
  public void RemoveCriteria(String Table, String Operand, String ValueMin, String ValueMax) {
    int pos;

    if (!this.Tables.isEmpty()) {
      pos = this.FindCriteria(Table, Operand, ValueMin, ValueMax);
      if (pos != -1) {
        this.Tables.remove(pos);
        this.Operands.remove(pos);
        this.MinValues.remove(pos);
        this.MaxValues.remove(pos);
      }
    }
  }

  /**
   * Clear all search filters.
   */
  public void ClearCriteria() {
    this.Tables.clear();
    this.Operands.clear();
    this.MinValues.clear();
    this.MaxValues.clear();
  }


  private String GetID(String value, String table, String idcolumn, String valuecolumn) {
    String SQL = "";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String result = "-1";

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      if (valuecolumn == null || valuecolumn.length() == 0) {
        valuecolumn = "NAME";
      }
      if (idcolumn == null || idcolumn.length() == 0) {
        idcolumn = "ID_" + table.toUpperCase();
      }
      SQL = "SELECT " + idcolumn + " FROM CHM62EDT_" + table.toUpperCase();
      SQL += " WHERE " + valuecolumn + "='" + value + "'";

      if (SQL.length() > 0) {
        ps = con.prepareStatement(SQL);
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
      return result;
    }


    return result;
  }

  /**
   * Build the search filter.
   * @return WHERE search condition.
   */
  public String BuildFilter() {
    String filter = "";
    String attributesFilter = "";
    String sitesFilter = "";
    String sitesSQL = "";
    String sTable;
    String sOperand;
    String sValueMin;
    String sValueMax;
    int i;

    if (!this.Tables.isEmpty()) {

      for (i = 0; i < this.Tables.size(); i++) {
        sTable = (String) this.Tables.elementAt(i);
        sOperand = (String) this.Operands.elementAt(i);
        sValueMin = (String) this.MinValues.elementAt(i);
        sValueMax = (String) this.MaxValues.elementAt(i);

        if (sTable.equalsIgnoreCase("Name")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " WHERE NAME LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " WHERE NAME = '" + sValueMin + "'";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Code")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES";
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " WHERE ID_SITE LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " WHERE ID_SITE = '" + sValueMin + "'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " WHERE ID_SITE > '" + sValueMin + "'";
            sitesSQL += " AND ID_SITE < '" + sValueMax + "'";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("DesignationYear")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " LEFT(DESIGNATION_DATE,4) = '" + sValueMin + "'";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " LEFT(DESIGNATION_DATE,4) LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " RIGHT(DESIGNATION_DATE,4) >= " + sValueMin;
            sitesSQL += " AND RIGHT(DESIGNATION_DATE,4) <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Area")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " AREA = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " AREA LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " AREA >= " + sValueMin;
            sitesSQL += " AND AREA <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Size")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " AREA = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " AREA LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " AREA >= " + sValueMin;
            sitesSQL += " AND AREA <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Length")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " 'LENGTH' = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " 'LENGTH' LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " 'LENGTH' >= " + sValueMin;
            sitesSQL += " AND 'LENGTH' <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Longitude")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " LONGITUDE = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " LONGITUDE LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " LONGITUDE >= " + sValueMin;
            sitesSQL += " AND LONGITUDE <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Latitude")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " LATITUDE = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " LATITUDE LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " LATITUDE >= " + sValueMin;
            sitesSQL += " AND LATITUDE <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("MinimumAltitude")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " ALT_MIN = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " ALT_MIN LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " ALT_MIN >= " + sValueMin;
            sitesSQL += " AND ALT_MIN <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("MaximumAltitude")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " ALT_MAX = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " ALT_MAX LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " ALT_MAX >= " + sValueMin;
            sitesSQL += " AND ALT_MAX <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("MeanAltitude")) {
          sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES WHERE ";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " ALT_MEAN = " + sValueMin;
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " ALT_MEAN LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " ALT_MEAN >= " + sValueMin;
            sitesSQL += " AND ALT_MEAN <= " + sValueMax;
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Designation")) {
          sitesSQL = "SELECT DISTINCT `CHM62EDT_SITES`.`ID_NATURE_OBJECT`";
          sitesSQL += " FROM CHM62EDT_SITES ";
          sitesSQL += " INNER JOIN `CHM62EDT_DESIGNATIONS` ON (`CHM62EDT_DESIGNATIONS`.`ID_DESIGNATION` = `CHM62EDT_SITES`.`ID_DESIGNATION` AND `CHM62EDT_DESIGNATIONS`.`ID_GEOSCOPE` = `CHM62EDT_SITES`.`ID_GEOSCOPE`)";
          sitesSQL += " WHERE";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " (`CHM62EDT_DESIGNATIONS`.`DESCRIPTION` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " (`CHM62EDT_DESIGNATIONS`.`DESCRIPTION` = '" + sValueMin + "')";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("HumanActivity")) {
          sitesSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          sitesSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          sitesSQL += " INNER JOIN `CHM62EDT_SITES` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_SITES`.`ID_NATURE_OBJECT`)";
          sitesSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          sitesSQL += " INNER JOIN `CHM62EDT_HUMAN_ACTIVITY` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_HUMAN_ACTIVITY`.`ID_HUMAN_ACTIVITY`)";
          sitesSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'HUMAN_ACTIVITY')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " AND (`CHM62EDT_HUMAN_ACTIVITY`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " AND (`CHM62EDT_HUMAN_ACTIVITY`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " AND (`CHM62EDT_HUMAN_ACTIVITY`.`ID_HUMAN_ACTIVITY` >= " + GetID(sValueMin, "HUMAN_ACTIVITY", "", "") + ")";
            sitesSQL += " AND (`CHM62EDT_HUMAN_ACTIVITY`.`ID_HUMAN_ACTIVITY` <= " + GetID(sValueMax, "HUMAN_ACTIVITY", "", "") + ")";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Motivation")) {
          sitesSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          sitesSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          sitesSQL += " INNER JOIN `CHM62EDT_SITES` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_SITES`.`ID_NATURE_OBJECT`)";
          sitesSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          sitesSQL += " INNER JOIN `CHM62EDT_MOTIVATION` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_MOTIVATION`.`ID_MOTIVATION`)";
          sitesSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'MOTIVATION')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " AND (`CHM62EDT_MOTIVATION`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " AND (`CHM62EDT_MOTIVATION`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            sitesSQL += " AND (`CHM62EDT_MOTIVATION`.`ID_MOTIVATION` >= " + GetID(sValueMin, "MOTIVATION", "", "") + ")";
            sitesSQL += " AND (`CHM62EDT_MOTIVATION`.`ID_MOTIVATION` <= " + GetID(sValueMax, "MOTIVATION", "", "") + ")";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Country")) {
          sitesSQL = "SELECT DISTINCT `CHM62EDT_SITES`.`ID_NATURE_OBJECT`";
          sitesSQL += " FROM `CHM62EDT_SITES`";
          sitesSQL += " INNER JOIN `CHM62EDT_NATURE_OBJECT_GEOSCOPE` ON (`CHM62EDT_SITES`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT_GEOSCOPE`.`ID_NATURE_OBJECT`)";
          sitesSQL += " INNER JOIN `CHM62EDT_COUNTRY` ON (`CHM62EDT_NATURE_OBJECT_GEOSCOPE`.`ID_GEOSCOPE` = `CHM62EDT_COUNTRY`.`ID_GEOSCOPE`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " WHERE (`CHM62EDT_COUNTRY`.`AREA_NAME_EN` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " WHERE (`CHM62EDT_COUNTRY`.`AREA_NAME_EN` LIKE '%" + sValueMin + "%')";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        if (sTable.equalsIgnoreCase("RegionCode")) {
          sitesSQL = "SELECT DISTINCT `CHM62EDT_SITES`.`ID_NATURE_OBJECT`";
          sitesSQL += " FROM `CHM62EDT_SITES`";
          sitesSQL += " INNER JOIN `CHM62EDT_SITE_ATTRIBUTES` ON (`CHM62EDT_SITES`.`ID_SITE` = `CHM62EDT_SITE_ATTRIBUTES`.`ID_SITE`)";
          sitesSQL += " INNER JOIN `CHM62EDT_REGION_CODES` ON (`CHM62EDT_SITE_ATTRIBUTES`.`VALUE` = `CHM62EDT_REGION_CODES`.`ID_REGION_CODE`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            sitesSQL += " WHERE (`CHM62EDT_REGION_CODES`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            sitesSQL += " WHERE (`CHM62EDT_REGION_CODES`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (SourceDB != null && !SourceDB.equalsIgnoreCase("")) {
            sitesSQL += " AND `CHM62EDT_SITES`.`SOURCE_DB` IN (" + SourceDB + ")";
          }
        }
        //execute every attribute query
        attributesFilter += " AND ID_NATURE_OBJECT IN (" + ExecuteSQL(sitesSQL, "'") + ")";
        //System.out.println("attributesFilter=" + attributesFilter);
      } //end for
      sitesFilter = " WHERE 1=1 " + attributesFilter;
      //execute final query
      sitesSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_SITES";
      sitesSQL += sitesFilter;
      // removed WHERE because is added automatically by JRF (findWere())
      filter += " ID_NATURE_OBJECT IN (" + ExecuteSQL(sitesSQL, "'") + ")";
    }
//    System.out.println("filter = " + filter);
    return filter;
  }

  private String ExecuteSQL(String SQL, String Delimiter) {
    String result = "";
    int resCount = 0;
    StringBuffer resultbuf = new StringBuffer();

    Connection con = null;
    PreparedStatement ps = null;

    try {
      Class.forName(SQL_DRV);
      con = DriverManager.getConnection(SQL_URL, SQL_USR, SQL_PWD);

      if (SQL.length() > 0) {
        resultCount = 0;
        ResultSet rs = null;
        ps = con.prepareStatement(SQL);
//        System.out.println("Executing(SitesAdvancedSearch): "+SQL);
        rs = ps.executeQuery();

        if (rs.isBeforeFirst()) {
          rs.last();
          resCount = rs.getRow();
          if (resCount > 0) {
            rs.beforeFirst();
            resultbuf.ensureCapacity(resCount * 6);
          }
        }

        while (rs.next()) {
          resultCount++;
          if (resultCount <= SQL_LIMIT) {
//            result+=Delimiter+rs.getString(1)+Delimiter;
//            result+=",";
            resultbuf.append(Delimiter).append(rs.getString(1)).append(Delimiter);
            resultbuf.append(",");
          }
        }
        if (resultCount >= SQL_LIMIT) {
//          System.out.println("<<< SQL LIMIT of "+SQL_LIMIT+" reached!. The results might not be concludent! >>>");
        }

        result = resultbuf.toString();
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
      return "";
    }

    //System.out.println("Result: "+result);
    return result;
  }

  /**
   * Return the results count resulted from execution of this query.
   * @return Results count.
   */
  public int getResultCount() {
    return resultCount;
  }
}