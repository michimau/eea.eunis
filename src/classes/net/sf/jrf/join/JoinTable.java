/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations under
 * the License.
 *
 * The Original Code is jRelationalFramework.
 *
 * The Initial Developer of the Original Code is is.com.
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: Jonathan Carlson (joncrlsn@users.sf.net)
 * Contributor: ____________________________________
 *
 * Alternatively, the contents of this file may be used under the terms of
 * the GNU General Public License (the "GPL") or the GNU Lesser General
 * Public license (the "LGPL"), in which case the provisions of the GPL or
 * LGPL are applicable instead of those above.  If you wish to allow use of
 * your version of this file only under the terms of either the GPL or LGPL
 * and not to allow others to use your version of this file under the MPL,
 * indicate your decision by deleting the provisions above and replace them
 * with the notice and other provisions required by either the GPL or LGPL
 * License.  If you do not delete the provisions above, a recipient may use
 * your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.join;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import java.util.StringTokenizer;

import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.domain.*;

import net.sf.jrf.exceptions.*;
import net.sf.jrf.sql.*;

/**  Instances of this class represent a plain old inner join. */
public class JoinTable {

  protected String i_tableName = null;
  protected String i_tableAlias = null;
  /** This is used to do the table join */
  protected String i_mainColumnNames = null;
  /** This is used to do the table join */
  protected String i_joinColumnNames = null;

  /** List of JoinColumn objects */
  protected List i_joinColumns = new ArrayList();
  /** List of JoinTable objects */
  protected List i_joinTables = new ArrayList();

  /* ===============  Constructors  =============== */
  /**
   * Construct an instance that is ready to be used.
   *
   * @param tableName        a value of type 'String' - This can include an alias
   * @param mainColumnNames  a value of type 'String'
   * @param joinColumnNames  a value of type 'String'
   */
  public JoinTable(
          String tableName,
          String mainColumnNames,
          String joinColumnNames) {
    this.setTableName(tableName);
    i_mainColumnNames = mainColumnNames;
    i_joinColumnNames = joinColumnNames;
  }

  /**
   * Add a subclass instance of JoinColumn.
   *
   * @param aJoinColumn  a value of type 'JoinColumn'
   */
  public void addJoinColumn(JoinColumn aJoinColumn) {
    i_joinColumns.add(aJoinColumn);
  }

  /**
   * This vector holds subclass instances of JoinColumn.
   *
   * @return   a value of type 'List'
   */
  public List getJoinColumns() {
    return i_joinColumns;
  }

  /**
   * If the name looks like this: 'Customer c', then put 'Customer' into the
   * tableName variable and put 'c' into the tableAlias variable.
   * <em>Aliases are no longer required since the only reason for using them is to distinguish
   * columns of the same name between joined tables in a SQL select statement.  The framework no longer uses
   * <code>java.sql.ResultSet.getX(String)</code>, but always uses <code>java.sql.ResultSet.getX(int)</code>. Therefore,
   * table aliases are not required.</em>.
   *
   * @param s  a value of type 'String'
   */
  public void setTableName(String s) {
    String result[] = net.sf.jrf.domain.AbstractDomain.parseEntityArgument(s, "Join table");
    i_tableName = result[0];
    i_tableAlias = result[1];
  }

  /**
   * Gets the tableName attribute of the JoinTable object
   *
   * @return   The tableName value
   */
  public String getTableName() {
    return i_tableName;
  }

  /**
   * @param alias  The new tableAlias value
   * @deprecated   no longer required.
   */
  public void setTableAlias(String alias) {
    i_tableAlias = alias;
  }


  /**
   * Gets the tableAlias attribute of the JoinTable object
   *
   * @return   The tableAlias value
   */
  public String getTableAlias() {
    return i_tableAlias;
  }

  /**
   * This should be a string of column names separated by commas if there is
   * more than one.
   *
   * @return   a value of type 'String'
   */
  public String getMainColumnNames() {
    return i_mainColumnNames;
  }

  /**
   * This would be a string of comma-separated column name(s) like:<br />
   * "id,code" or just "id"
   *
   * @param mainColumnNames  a value of type 'String'
   */
  public void setMainColumnNames(String mainColumnNames) {
    i_mainColumnNames = mainColumnNames;
  }

  /**
   * This should be a string of column names separated by commas if there is
   * more than one.
   *
   * @return   a value of type 'String'
   */
  public String getJoinColumnNames() {
    return i_joinColumnNames;
  }

  /**
   * This would be a string of comma-separated column name(s) like:<br />
   * "id,code" or just "id"
   *
   * @param joinColumnNames  a value of type 'String'
   */
  public void setJoinColumnNames(String joinColumnNames) {
    i_joinColumnNames = joinColumnNames;
  }

  /**
   * Add an instance of JoinTable that will be joined with this JoinTable.
   *
   * @param aJoinTable  a value of type 'JoinTable'
   */
  public void addJoinTable(JoinTable aJoinTable) {
    i_joinTables.add(aJoinTable);
  }

  /**
   * This vector holds instances of JoinTable.
   *
   * @return   a value of type 'List'
   */
  public List getJoinTables() {
    return i_joinTables;
  }


  /**
   * Build an ANSI join statement.
   *
   * @param mainTableAlias  Description of the Parameter
   * @return                a value of type 'String'
   */
  public String buildANSIJoin(String mainTableAlias) {
    StringBuffer sqlBuffer = new StringBuffer();
    StringTokenizer mainTokenizer =
            new StringTokenizer(i_mainColumnNames, ",");
    StringTokenizer joinTokenizer =
            new StringTokenizer(i_joinColumnNames, ",");

    sqlBuffer.append(" ");
    sqlBuffer.append(this.ansiJoinCommand());
    sqlBuffer.append(" ");
    sqlBuffer.append(i_tableName);
    if (!i_tableAlias.equals(i_tableName)) {
      sqlBuffer.append(" ");
      sqlBuffer.append(i_tableAlias);
    }
    sqlBuffer.append(" ON ");

    while (mainTokenizer.hasMoreTokens()) {
      if (!joinTokenizer.hasMoreTokens()) {
        throw new ConfigurationException(
                "The join columns for JoinTable "
                + i_tableName + " are mismatched.");
      }
      sqlBuffer.append(mainTableAlias);
      sqlBuffer.append(".");
      sqlBuffer.append(mainTokenizer.nextToken());
      sqlBuffer.append("=");
      sqlBuffer.append(i_tableAlias);
      sqlBuffer.append(".");
      sqlBuffer.append(joinTokenizer.nextToken());
      if (mainTokenizer.hasMoreTokens()) {
        sqlBuffer.append(" AND ");
      }
    }// while (mainTokenizer.hasMoreTokens())

    //
    // Process any extra name/value pairs.  If we have more join tokens than
    // main tokens, then they should be in the form of a name/value pair.
    // For example, notice the <code>Type='Home'</code> below:
    //
    //   JoinTable joinTable =
    //        new OuterJoinTable(
    //            "CustomerPhone",
    //            "Id",                      // Customer column(s)
    //            "CustomerId,Type='Home'"); // CustomerPhone column(s)
    //
    while (joinTokenizer.hasMoreTokens()) {
      // We have more join tokens than main tokens.
      // This is OK if the extra join tokens are a name/value pair.
      String nameValuePair = joinTokenizer.nextToken();
      if (nameValuePair.indexOf("=") < 1) {// Must be in the form of: "Type='Home'"
        throw new ConfigurationException(
                "The join columns for JoinTable "
                + i_tableName + " are mismatched.");
      }
      sqlBuffer.append(" AND ");
      sqlBuffer.append(i_tableAlias);
      sqlBuffer.append(".");
      sqlBuffer.append(nameValuePair);
    }// while

    Iterator iterator = i_joinTables.iterator();
    while (iterator.hasNext()) {
      JoinTable joinTable = (JoinTable) iterator.next();
      sqlBuffer.append(joinTable.buildANSIJoin(i_tableAlias));
    }// while

    return sqlBuffer.toString();
  }// buildANSIJoin(mainTableAlias)


  /**
   * Build a non-standard join that goes into the WHERE clause.  Match up
   * the main column names with the join column names.
   *
   * @param dbPolicy        a value of type 'DatabasePolicy'
   * @param mainTableAlias  Description of the Parameter
   * @return                a value of type 'String'
   */
  public String buildNonANSIJoin(String mainTableAlias,
                                 DatabasePolicy dbPolicy) {
    StringBuffer sqlBuffer = new StringBuffer();
    StringTokenizer mainTokenizer =
            new StringTokenizer(i_mainColumnNames, ",");
    StringTokenizer joinTokenizer =
            new StringTokenizer(i_joinColumnNames, ",");
    while (mainTokenizer.hasMoreTokens()) {
      if (!joinTokenizer.hasMoreTokens()) {
        throw new ConfigurationException(
                "The join columns for JoinTable "
                + i_tableName + " are mismatched.");
      }
      sqlBuffer.append(
              this.buildWhereJoin(
                      mainTableAlias + "." + mainTokenizer.nextToken(),
                      i_tableAlias + "." + joinTokenizer.nextToken(),
                      dbPolicy));
      if (mainTokenizer.hasMoreTokens()) {
        sqlBuffer.append(" AND ");
      }
    }// while (mainTokenizer.hasMoreTokens())

    //
    // Process any extra name/value pairs.  If we have more join tokens than
    // main tokens, then they should be in the form of a name/value pair.
    // For example, notice the <code>Type='Home'</code> below:
    //
    //   JoinTable joinTable =
    //        new OuterJoinTable(
    //            "CustomerPhone",
    //            "Id",                      // Customer column(s)
    //            "CustomerId,Type='Home'"); // CustomerPhone column(s)
    //
    while (joinTokenizer.hasMoreTokens()) {
      String nameValuePair = joinTokenizer.nextToken();
      int ix = nameValuePair.indexOf("=");
      if (ix < 1) {// Must be in the form of: "Type='Home'"
        throw new ConfigurationException(
                "The join columns for JoinTable "
                + i_tableName + " are mismatched.");
      }
      String name = nameValuePair.substring(0, ix);
      String value = nameValuePair.substring(ix + 1);
      name = i_tableAlias + "." + name;
      sqlBuffer.append(" AND ");
      sqlBuffer.append(this.buildWhereJoin(value, name, dbPolicy));
    }// while

    Iterator iterator = i_joinTables.iterator();
    while (iterator.hasNext()) {
      JoinTable joinTable = (JoinTable) iterator.next();
      sqlBuffer.append(" AND ");
      sqlBuffer.append(joinTable.buildNonANSIJoin(i_tableAlias,
              dbPolicy));
    }// while

    return sqlBuffer.toString();
  }// buildNonANSIJoin(mainTableAlias, dbPolicy)


  /**
   * Description of the Method
   *
   * @param aJRFResultSet     Description of the Parameter
   * @param aPO               Description of the Parameter
   * @exception SQLException  Description of the Exception
   */
  public void copyColumnValuesToPersistentObject(JRFResultSet aJRFResultSet,
                                                 PersistentObject aPO)
          throws SQLException {
    JoinColumn aJoinColumn = null;
    JoinTable aJoinTable = null;

    // Iterate through my columns.
    Iterator iterator = i_joinColumns.iterator();
    while (iterator.hasNext()) {
      aJoinColumn = (JoinColumn) iterator.next();
      aJoinColumn.copyColumnValueToPersistentObject(aJRFResultSet, aPO);
    }

    // Iterate through my join tables.
    iterator = i_joinTables.iterator();
    while (iterator.hasNext()) {
      aJoinTable = (JoinTable) iterator.next();
      aJoinTable.copyColumnValuesToPersistentObject(aJRFResultSet, aPO);
    }
  }// assignColumnValuesToPersistentObject(...)

  /**
   * Sets the columnIndices attribute of the JoinTable object
   *
   * @param idx  The new columnIndices value
   * @return     Description of the Return Value
   */
  public int setColumnIndices(int idx) {
    JoinColumn aJoinColumn = null;
    JoinTable aJoinTable = null;
    Iterator iterator = i_joinColumns.iterator();
    while (iterator.hasNext()) {
      aJoinColumn = (JoinColumn) iterator.next();
      aJoinColumn.setColumnIdx(idx++);
    }

    // Iterate through my join tables.
    iterator = i_joinTables.iterator();
    while (iterator.hasNext()) {
      aJoinTable = (JoinTable) iterator.next();
      idx = aJoinTable.setColumnIndices(idx);
    }
    return idx;
  }

  /**
   * Description of the Method
   *
   * @param sqlBuffer  Description of the Parameter
   */
  public void buildSelectColumnString(StringBuffer sqlBuffer) {
    JoinColumn aJoinColumn = null;
    JoinTable aJoinTable = null;

    // Iterate through my columns.
    Iterator iterator = i_joinColumns.iterator();
    while (iterator.hasNext()) {
      sqlBuffer.append(", ");
      aJoinColumn = (JoinColumn) iterator.next();
      aJoinColumn.buildSelectColumnString(sqlBuffer, i_tableAlias);
    }

    // Iterate through my join tables.
    iterator = i_joinTables.iterator();
    while (iterator.hasNext()) {
      aJoinTable = (JoinTable) iterator.next();
      aJoinTable.buildSelectColumnString(sqlBuffer);
    }
  }// buildSelectColumnString(aStringBuffer)


  /**
   * Add a list of table names to the StringBuffer like this:<br />
   * 'Video V, Media M, Genre G'
   *
   * @param sqlBuffer  a value of type 'StringBuffer'
   */
  public void buildFromString(StringBuffer sqlBuffer) {
    JoinTable aJoinTable = null;
    sqlBuffer.append(", ");

    net.sf.jrf.sqlbuilder.SelectSQLBuilder.buildFromTableName(sqlBuffer, i_tableName, i_tableAlias);
    // Iterate through my join tables and recursively call this same method
    // against them.
    Iterator iterator = i_joinTables.iterator();
    while (iterator.hasNext()) {
      aJoinTable = (JoinTable) iterator.next();
      aJoinTable.buildFromString(sqlBuffer);
    }
  }// buildFromString(aStringBuffer)


  /**
   * Return something like "JOIN" or "LEFT OUTER JOIN", etc...
   * Subclasses override.
   *
   * @return   a value of type 'String'
   */
  protected String ansiJoinCommand() {
    return "INNER JOIN";
  }


  /**
   * This method is overridden by the OuterJoinTable subclass.  In the case
   * of outer join, this returns a non-standard SQL name/value pair to be
   * used in a where clause join.  i.e. <code>T1.id = T2.id(+)</code> (Oracle)
   *
   * @param mainColumnName  a value of type 'String'
   * @param joinColumnName  a value of type 'String'
   * @param dbPolicy        a value of type 'DatabasePolicy'
   * @return                a value of type 'String'
   */
  protected String buildWhereJoin(String mainColumnName,
                                  String joinColumnName,
                                  DatabasePolicy dbPolicy) {
    // I don't do anything with the dbPolicy, but my subclass does.
    return mainColumnName + "=" + joinColumnName;
  }

}// JoinTable
