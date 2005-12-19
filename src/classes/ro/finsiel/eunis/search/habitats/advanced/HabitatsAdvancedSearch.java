package ro.finsiel.eunis.search.habitats.advanced;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.Vector;

/**
 * Class used for habitats->advanced search.
 * @author finsiel
 */
public class HabitatsAdvancedSearch {
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

  /**
   * Ctor.
   */
  public void HabitatsAdvancedSearch() {

  }

  /**
   * Initializations.
   * @param SQL_DRIVER_NAME JDBC Driver.
   * @param SQL_DRIVER_URL JDBC url
   * @param SQL_DRIVER_USERNAME JDBC user
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
   * Set the limit of retrieved results.
   * @param SQLLimit Limit of results
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
   * Add a new search criteria.
   * @param Table Name of the table.
   * @param Operand Relation operator.
   * @param ValueMin Min value.
   * @param ValueMax Max value.
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
      if (Operand.equalsIgnoreCase("Regex") && ValueMin.length() == 0) {
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
   * Remove a search criteria.
   * @param Table Table name
   * @param Operand Relation operator.
   * @param ValueMin Min value
   * @param ValueMax Max value.
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
   * Clear all search criteria.
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
   * Build where filter for SQL query.
   * @return WHERE filter.
   */
  public String BuildFilter() {
    String filter = "";
    String attributesFilter = "";
    String habitatsFilter = "";
    String habitatsSQL = "";
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

        if (sTable.equalsIgnoreCase("ScientificName")) {
          habitatsSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE SCIENTIFIC_NAME LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE SCIENTIFIC_NAME = '" + sValueMin + "'";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE SCIENTIFIC_NAME REGEXP '" + sValueMin + "'";
          }
        }
        if (sTable.equalsIgnoreCase("Code")) {
          habitatsSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT";
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE EUNIS_HABITAT_CODE LIKE '%" + sValueMin + "%' OR CODE_ANNEX1 LIKE '%" + sValueMin + "%'";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE EUNIS_HABITAT_CODE = '" + sValueMin + "' OR CODE_ANNEX1 = '" + sValueMin + "'";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE EUNIS_HABITAT_CODE REGEXP '" + sValueMin + "' OR CODE_ANNEX1 REGEXP '" + sValueMin + "'";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " WHERE (EUNIS_HABITAT_CODE BETWEEN '%" + sValueMin + "%' AND '%" + sValueMax + "%')";
            habitatsSQL += " OR (CODE_ANNEX1 BETWEEN '%" + sValueMin + "%' AND '%" + sValueMax + "%')";
          }
        }
        if (sTable.equalsIgnoreCase("LegalInstruments")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_HABITAT`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT_CLASS_CODE` ON (`CHM62EDT_HABITAT`.`ID_HABITAT` = `CHM62EDT_HABITAT_CLASS_CODE`.`ID_HABITAT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_CLASS_CODE` ON (`CHM62EDT_HABITAT_CLASS_CODE`.`ID_CLASS_CODE` = `CHM62EDT_CLASS_CODE`.`ID_CLASS_CODE`)";
          habitatsSQL += " WHERE (`CHM62EDT_CLASS_CODE`.`LEGAL` = 1)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_CLASS_CODE`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_CLASS_CODE`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_CLASS_CODE`.`NAME` LIKE '%" + sValueMin + "%')";
          }
        }
        if (sTable.equalsIgnoreCase("SourceDatabase")) {
          habitatsSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT WHERE ";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            if (sValueMin.equalsIgnoreCase("EUNIS")) {
              //habitatsSQL+="CODE_ANNEX1 IS NULL";
              habitatsSQL += "CHM62EDT_HABITAT.ID_HABITAT>=1 and  CHM62EDT_HABITAT.ID_HABITAT<10000";
            } else {
              //habitatsSQL+="CODE_ANNEX1 IS NOT NULL";
              habitatsSQL += "CHM62EDT_HABITAT.ID_HABITAT>10000";
            }
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            if (sValueMin.equalsIgnoreCase("EUNIS")) {
              //habitatsSQL+="CODE_ANNEX1 IS NULL";
              habitatsSQL += "CHM62EDT_HABITAT.ID_HABITAT >=1 and CHM62EDT_HABITAT.ID_HABITAT<10000";
            } else {
              //habitatsSQL+="CODE_ANNEX1 IS NOT NULL";
              habitatsSQL += "CHM62EDT_HABITAT.ID_HABITAT>10000";
            }
          }
        }
        if (sTable.equalsIgnoreCase("Country")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_REPORTS`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_REPORTS`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_COUNTRY` ON (`CHM62EDT_REPORTS`.`ID_GEOSCOPE` = `CHM62EDT_COUNTRY`.`ID_GEOSCOPE`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE (`CHM62EDT_COUNTRY`.`AREA_NAME_EN` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE (`CHM62EDT_COUNTRY`.`AREA_NAME_EN` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE (`CHM62EDT_COUNTRY`.`AREA_NAME_EN` REGEXP '" + sValueMin + "')";
          }
        }
        if (sTable.equalsIgnoreCase("Biogeoregion")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_REPORTS`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_REPORTS`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_REPORTS`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_BIOGEOREGION` ON (`CHM62EDT_REPORTS`.`ID_GEOSCOPE_LINK` = `CHM62EDT_BIOGEOREGION`.`ID_GEOSCOPE`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE (`CHM62EDT_BIOGEOREGION`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE (`CHM62EDT_BIOGEOREGION`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE (`CHM62EDT_BIOGEOREGION`.`NAME` REGEXP '" + sValueMin + "')";
          }
        }

        if (sTable.equalsIgnoreCase("LegalInstrument")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` FROM `CHM62EDT_HABITAT`";
          habitatsSQL += " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
          habitatsSQL += " INNER JOIN `DC_INDEX` `DC_INDEX_REFERENCE` ON (`DC_INDEX`.`REFERENCE` = `DC_INDEX_REFERENCE`.`REFCD`)";
          habitatsSQL += " INNER JOIN `DC_TITLE` ON (`DC_INDEX_REFERENCE`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE (`DC_TITLE`.`TITLE` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE (`DC_TITLE`.`TITLE` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE (`DC_TITLE`.`TITLE` LIKE '%" + sValueMin + "%')";
          }
        }

        if (sTable.equalsIgnoreCase("Author")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` FROM `CHM62EDT_HABITAT`";
          habitatsSQL += " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
          habitatsSQL += " INNER JOIN `DC_SOURCE` ON (`DC_INDEX`.`ID_DC` = `DC_SOURCE`.`ID_DC`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE (`DC_SOURCE`.`SOURCE` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE (`DC_SOURCE`.`SOURCE` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE (`DC_SOURCE`.`SOURCE` LIKE '%" + sValueMin + "%')";
          }
        }

        if (sTable.equalsIgnoreCase("Title")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` FROM `CHM62EDT_HABITAT`";
          habitatsSQL += " INNER JOIN `CHM62EDT_NATURE_OBJECT` ON (`CHM62EDT_HABITAT`.`ID_NATURE_OBJECT` = `CHM62EDT_NATURE_OBJECT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `DC_INDEX` ON (`CHM62EDT_NATURE_OBJECT`.`ID_DC` = `DC_INDEX`.`ID_DC`)";
          habitatsSQL += " INNER JOIN `DC_TITLE` ON (`DC_INDEX`.`ID_DC` = `DC_TITLE`.`ID_DC`)";
          if (sOperand.equalsIgnoreCase("Between")) {
            sOperand = "Equal";
          }
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " WHERE (`DC_TITLE`.`TITLE` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " WHERE (`DC_TITLE`.`TITLE` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " WHERE (`DC_TITLE`.`TITLE` LIKE '%" + sValueMin + "%')";
          }
        }

        if (sTable.equalsIgnoreCase("Altitude")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_ALTITUDE` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_ALTITUDE`.`ID_ALTITUDE`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'ALTITUDE')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_ALTITUDE`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_ALTITUDE`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_ALTITUDE`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_ALTITUDE`.`ID_ALTITUDE` >= " + GetID(sValueMin, "ALTITUDE", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_ALTITUDE`.`ID_ALTITUDE` <= " + GetID(sValueMax, "ALTITUDE", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Chemistry")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_CHEMISTRY` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_CHEMISTRY`.`ID_CHEMISTRY`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'CHEMISTRY')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_CHEMISTRY`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_CHEMISTRY`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_CHEMISTRY`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_CHEMISTRY`.`ID_CHEMISTRY` >= " + GetID(sValueMin, "CHEMISTRY", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_CHEMISTRY`.`ID_CHEMISTRY` <= " + GetID(sValueMax, "CHEMISTRY", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Climate")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_CLIMATE` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_CLIMATE`.`ID_CLIMATE`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'CLIMATE')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_CLIMATE`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_CLIMATE`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_CLIMATE`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_CLIMATE`.`ID_CLIMATE` >= " + GetID(sValueMin, "CLIMATE", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_CLIMATE`.`ID_CLIMATE` <= " + GetID(sValueMax, "CLIMATE", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Cover")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_COVER` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_COVER`.`ID_COVER`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'COVER')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_COVER`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_COVER`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_COVER`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_COVER`.`ID_COVER` >= " + GetID(sValueMin, "COVER", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_COVER`.`ID_COVER` <= " + GetID(sValueMax, "COVER", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Depth")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_DEPTH` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_DEPTH`.`ID_DEPTH`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'DEPTH')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_DEPTH`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_DEPTH`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_DEPTH`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_DEPTH`.`ID_DEPTH` >= " + GetID(sValueMin, "DEPTH", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_DEPTH`.`ID_DEPTH` <= " + GetID(sValueMax, "DEPTH", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Geomorph")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_GEOMORPH` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_GEOMORPH`.`ID_GEOMORPH`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'GEOMORPH')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_GEOMORPH`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_GEOMORPH`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_GEOMORPH`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_GEOMORPH`.`ID_GEOMORPH` >= " + GetID(sValueMin, "GEOMORPH", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_GEOMORPH`.`ID_GEOMORPH` <= " + GetID(sValueMax, "GEOMORPH", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Humidity")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_HUMIDITY` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_HUMIDITY`.`ID_HUMIDITY`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'HUMIDITY')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_HUMIDITY`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_HUMIDITY`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_HUMIDITY`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_HUMIDITY`.`ID_HUMIDITY` >= " + GetID(sValueMin, "HUMIDITY", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_HUMIDITY`.`ID_HUMIDITY` <= " + GetID(sValueMax, "HUMIDITY", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("LifeForm")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_LIFE_FORM` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_LIFE_FORM`.`ID_LIFE_FORM`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'LIFE_FORM')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_LIFE_FORM`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_LIFE_FORM`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_LIFE_FORM`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_LIFE_FORM`.`ID_LIFE_FORM` >= " + GetID(sValueMin, "ID_LIFE_FORM", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_LIFE_FORM`.`ID_LIFE_FORM` <= " + GetID(sValueMax, "ID_LIFE_FORM", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("LightIntensity")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_LIGHT_INTENSITY` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_LIGHT_INTENSITY`.`ID_LIGHT_INTENSITY`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'LIGHT_INTENSITY')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_LIGHT_INTENSITY`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_LIGHT_INTENSITY`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_LIGHT_INTENSITY`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_LIGHT_INTENSITY`.`ID_LIGHT_INTENSITY` >= " + GetID(sValueMin, "LIGHT_INTENSITY", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_LIGHT_INTENSITY`.`ID_LIGHT_INTENSITY` <= " + GetID(sValueMax, "LIGHT_INTENSITY", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Marine")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_MARINE` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_MARINE`.`ID_MARINE`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'MARINE')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_MARINE`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_MARINE`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_MARINE`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_MARINE`.`ID_MARINE` >= " + GetID(sValueMin, "MARINE", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_MARINE`.`ID_MARINE` <= " + GetID(sValueMax, "MARINE", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Salinity")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_SALINITY` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_SALINITY`.`ID_SALINITY`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'SALINITY')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_SALINITY`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_SALINITY`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_SALINITY`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_SALINITY`.`ID_SALINITY` >= " + GetID(sValueMin, "SALINITY", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_SALINITY`.`ID_SALINITY` <= " + GetID(sValueMax, "SALINITY", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Spatial")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_SPATIAL` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_SPATIAL`.`ID_SPATIAL`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'SPATIAL')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_SPATIAL`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_SPATIAL`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_SPATIAL`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_SPATIAL`.`ID_SPATIAL` >= " + GetID(sValueMin, "SPATIAL", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_SPATIAL`.`ID_SPATIAL` <= " + GetID(sValueMax, "SPATIAL", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Substrate")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_SUBSTRATE` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_SUBSTRATE`.`ID_SUBSTRATE`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'SUBSTRATE')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_SUBSTRATE`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_SUBSTRATE`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_SUBSTRATE`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_SUBSTRATE`.`ID_SUBSTRATE` >= " + GetID(sValueMin, "SUBSTRATE", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_SUBSTRATE`.`ID_SUBSTRATE` <= " + GetID(sValueMax, "SUBSTRATE", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Temporal")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_TEMPORAL` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_TEMPORAL`.`ID_TEMPORAL`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'TEMPORAL')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_TEMPORAL`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_TEMPORAL`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_TEMPORAL`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_TEMPORAL`.`ID_TEMPORAL` >= " + GetID(sValueMin, "TEMPORAL", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_TEMPORAL`.`ID_TEMPORAL` <= " + GetID(sValueMax, "TEMPORAL", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Tidal")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_TIDAL` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_TIDAL`.`ID_TIDAL`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'TIDAL')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_TIDAL`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_TIDAL`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_TIDAL`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_TIDAL`.`ID_TIDAL` >= " + GetID(sValueMin, "TIDAL", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_TIDAL`.`ID_TIDAL` <= " + GetID(sValueMax, "TIDAL", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Water")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_WATER` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_WATER`.`ID_WATER`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'WATER')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_WATER`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_WATER`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_WATER`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_WATER`.`ID_WATER` >= " + GetID(sValueMin, "WATER", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_WATER`.`ID_WATER` <= " + GetID(sValueMax, "WATER", "", "") + ")";
          }
        }
        if (sTable.equalsIgnoreCase("Usage")) {
          habitatsSQL = "SELECT DISTINCT `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT`";
          habitatsSQL += " FROM `CHM62EDT_NATURE_OBJECT_REPORT_TYPE`";
          habitatsSQL += " INNER JOIN `CHM62EDT_HABITAT` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_NATURE_OBJECT` = `CHM62EDT_HABITAT`.`ID_NATURE_OBJECT`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_REPORT_TYPE` ON (`CHM62EDT_NATURE_OBJECT_REPORT_TYPE`.`ID_REPORT_TYPE` = `CHM62EDT_REPORT_TYPE`.`ID_REPORT_TYPE`)";
          habitatsSQL += " INNER JOIN `CHM62EDT_USAGE` ON (`CHM62EDT_REPORT_TYPE`.`ID_LOOKUP` = `CHM62EDT_USAGE`.`ID_USAGE`)";
          habitatsSQL += " WHERE (`CHM62EDT_REPORT_TYPE`.`LOOKUP_TYPE` = 'USAGE')";
          if (sOperand.equalsIgnoreCase("Equal")) {
            habitatsSQL += " AND (`CHM62EDT_USAGE`.`NAME` = '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Regex")) {
            habitatsSQL += " AND (`CHM62EDT_USAGE`.`NAME` REGEXP '" + sValueMin + "')";
          }
          if (sOperand.equalsIgnoreCase("Contains")) {
            habitatsSQL += " AND (`CHM62EDT_USAGE`.`NAME` LIKE '%" + sValueMin + "%')";
          }
          if (sOperand.equalsIgnoreCase("Between")) {
            habitatsSQL += " AND (`CHM62EDT_USAGE`.`ID_USAGE` >= " + GetID(sValueMin, "USAGE", "", "") + ")";
            habitatsSQL += " AND (`CHM62EDT_USAGE`.`ID_USAGE` <= " + GetID(sValueMax, "USAGE", "", "") + ")";
          }
        }

        habitatsSQL += " AND (CHM62EDT_HABITAT.ID_HABITAT<>'-1' AND CHM62EDT_HABITAT.ID_HABITAT<>'10000') ";
        //execute every attribute query
        attributesFilter += " AND ID_NATURE_OBJECT IN (" + ExecuteSQL(habitatsSQL, "") + ")";
      } //end for
      habitatsFilter = " WHERE 1=1 " + attributesFilter;
      //execute final query
      habitatsSQL = "SELECT DISTINCT ID_NATURE_OBJECT FROM CHM62EDT_HABITAT";
      habitatsSQL += habitatsFilter;
      // removed WHERE because is added automatically by JRF (findWere())
      filter += " ID_NATURE_OBJECT IN (" + ExecuteSQL(habitatsSQL, "") + ")";
    }
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
//        System.out.println("Executing: "+SQL);
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
      System.out.println("SQL = " + SQL);
      e.printStackTrace();
      return "";
    }

    return result;
  }

  /**
   * Count the number of found habitats.
   * @return Results of count.
   */
  public int getResultCount() {
    return resultCount;
  }
}
