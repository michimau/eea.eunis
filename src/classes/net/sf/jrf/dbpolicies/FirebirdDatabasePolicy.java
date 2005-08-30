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
 * Contributor: Tal (tal@nbase.co.il)
 * Contributor: Mandip (mandip@sundayta.com)
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
package net.sf.jrf.dbpolicies;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.List;

import net.sf.jrf.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;
import org.apache.log4j.Category;

/**
 *  Instances of this class perform Firebird logic and return
 *  Firebird-specific information.
 */
public class FirebirdDatabasePolicy implements DatabasePolicy {

  final static Category LOG = Category.getInstance(FirebirdDatabasePolicy.class.getName());
  private final static String TEXT = "TEXT";
  private final static String CHAR = "CHAR";

  // BEGIN SEQUENCE METHODS
  /**
   * Returns <code>SEQUENCE_SUPPORT_EXTERNAL</code>.
   *
   * @return   <code>SEQUENCE_SUPPORT_EXTERNAL</code>.
   * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_SUPPORT_EXTERNAL
   */
  public int getSequenceSupportType() {
    return DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL;
  }

  /**
   * Returns <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
   *
   * @return   <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
   * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY
   */
  public int getSequenceFetchAfterInsertSupportType() {
    return net.sf.jrf.DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY;
  }

  //////////////////////////////////////////////////////////////////
  // SEQUENCE_SUPPORT_EXTERNAL - required methods -- supported here.
  //////////////////////////////////////////////////////////////////
  /**
   * @param sequenceName  Description of the Parameter
   * @param tableName     Description of the Parameter
   * @return              Description of the Return Value
   * @see                 net.sf.jrf.DatabasePolicy#sequenceSQL(String,String)
   */
  public String sequenceSQL(String sequenceName, String tableName) {

    return "SELECT " + sequenceNextValSQL(sequenceName, tableName) + " FROM rdb$database";
  }

  /**
   * @param sequenceName  Description of the Parameter
   * @param tableName     Description of the Parameter
   * @return              Description of the Return Value
   * @see                 net.sf.jrf.DatabasePolicy#sequenceNextValSQL(String,String) *
   */
  public String sequenceNextValSQL(String sequenceName, String tableName) {
    return "gen_id(" + sequenceName + ", 1)";
  }

  /**
   * @param domain            Description of the Parameter
   * @param stmtExecuter      Description of the Parameter
   * @exception SQLException  Description of the Exception
   * @see                     net.sf.jrf.DatabasePolicy#createSequence(AbstractDomain,StatementExecuter)
   */
  public void createSequence(AbstractDomain domain, StatementExecuter stmtExecuter)
          throws SQLException {
    createSequence(domain, "INCREMENT BY 1 START WITH 1", stmtExecuter);
  }

  /**
   * @param sequenceName        Description of the Parameter
   * @param sequenceParameters  Description of the Parameter
   * @return                    The createSequenceSQL value
   * @see                       net.sf.jrf.DatabasePolicy#getCreateSequenceSQL(String,String)
   */
  public String getCreateSequenceSQL(String sequenceName, String sequenceParameters) {
    if (sequenceParameters == null) {
      return "create generator " + sequenceName;
    }
    return "create generator " + sequenceName + " " + sequenceParameters;

  }

  /**
   * @param domain              Description of the Parameter
   * @param sequenceParameters  Description of the Parameter
   * @param stmtExecuter        Description of the Parameter
   * @exception SQLException    Description of the Exception
   * @see                       #createSequence(AbstractDomain,String,StatementExecuter) *
   */
  public void createSequence(AbstractDomain domain, String sequenceParameters, StatementExecuter stmtExecuter)
          throws SQLException {
    try {
      // TODO -- execute to drop the sequence. Below is a guess.
      stmtExecuter.executeUpdate("drop generator " + domain.getSequenceName());
    } catch (SQLException e) {
      // Ignore this exception since sequence may not be there.
    } catch (Exception e) {
      throw new DatabaseException(e);
    }
    try {
      stmtExecuter.executeUpdate(getCreateSequenceSQL(domain.getSequenceName(), sequenceParameters));
    } catch (SQLException e) {
      throw e;
    } catch (Exception e) {
      throw new DatabaseException(e);
    }
  }

  //////////////////////////////////////////////////////////////////
  // SEQUENCE_SUPPORT_AUTOINCREMENT_.. - not supported here.
  //////////////////////////////////////////////////////////////////

  /**
   * No support here.
   *
   * @return   blank string.
   */
  public String autoIncrementIdentifier() {
    return "";
  }

  /**
   * @param sequenceName  Description of the Parameter
   * @param tableName     Description of the Parameter
   * @return              The findLastInsertedSequenceSql value
   * @see                 net.sf.jrf.DatabasePolicy#getFindLastInsertedSequenceSql(String,String) *
   */
  public String getFindLastInsertedSequenceSql(String sequenceName, String tableName) {
    // TODO -- below is a guess -- FIXME
    return "SELECT curr_id(" + sequenceName + ") FROM rdb$database";
  }

  /**
   * @param tableName   Description of the Parameter
   * @param columnName  Description of the Parameter
   * @param stmt        Description of the Parameter
   * @return            Description of the Return Value
   * @see               net.sf.jrf.DatabasePolicy#findAutoIncrementIdByMethodInvoke(String,String,Statement) *
   */
  public Long findAutoIncrementIdByMethodInvoke(String tableName, String columnName, Statement stmt) {
    return null;
  }
  ////////////////////////////////

  /**
   * @param sqlType    Description of the Parameter
   * @param precision  Description of the Parameter
   * @param scale      Description of the Parameter
   * @return           The numericColumnTypeDefinition value
   * @see              net.sf.jrf.DatabasePolicy#getNumericColumnTypeDefinition(int,int,int) *
   */
  public String getNumericColumnTypeDefinition(int sqlType, int precision, int scale) {
    return DefaultImpls.getNumericColumnTypeDefinition(sqlType, precision, scale);//TODO implement here.
  }

  /**
   * @param executer          Description of the Parameter
   * @exception SQLException  Description of the Exception
   * @see                     net.sf.jrf.DatabasePolicy#initialize(StatementExecuter)
   */
  public synchronized void initialize(StatementExecuter executer)
          throws SQLException {
  }

  /**
   * Returns a blank string. NULL tokens are not allowed in Firebird.
   *
   * @return   blank string. NULL tokens are not allowed in Firebird.
   */
  public String getNullableColumnQualifier() {
    return "";
  }

  /**
   * @return   The primaryKeyQualifiers value
   * @see      net.sf.jrf.DatabasePolicy#getPrimaryKeyQualifiers() *
   */
  public String getPrimaryKeyQualifiers() {
    return "NOT NULL";
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#timestampFunction() *
   */
  public String timestampFunction() {
    return "(cast(current_timestamp as timestamp))";
  }

  /**
   * @param ts  Description of the Parameter
   * @return    Description of the Return Value
   * @see       net.sf.jrf.DatabasePolicy#formatTimestamp(Timestamp) *
   */
  public String formatTimestamp(Timestamp ts) {
    if (ts == null) {
      return "null";
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
    return "cast('" + sdf.format(ts) + "' as timestamp)";
  }


  /**
   * @param sqlDate  Description of the Parameter
   * @return         Description of the Return Value
   * @see            net.sf.jrf.DatabasePolicy#formatDate(Date) *
   */
  public String formatDate(java.sql.Date sqlDate) {
    if (sqlDate == null) {
      return "null";
    }
    return "cast('" + sqlDate.toString() + "' as date)";
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#currentTimestampSQL() *
   */
  public String currentTimestampSQL() {
    return "select current_timestamp from rdb$database";
  }

  /**
   * @param mainTableColumn  Description of the Parameter
   * @param joinTableColumn  Description of the Parameter
   * @return                 Description of the Return Value
   * @see                    net.sf.jrf.DatabasePolicy#outerWhereJoin(String,String) *
   */
  public String outerWhereJoin(String mainTableColumn,
                               String joinTableColumn) {
    return mainTableColumn + " = " + joinTableColumn + " ";
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#timestampColumnType() *
   */
  public String timestampColumnType() {
    return "TIMESTAMP";
  }

  /**
   * @param maxLength            Description of the Parameter
   * @param multiByteCharacters  Description of the Parameter
   * @param variable             Description of the Parameter
   * @param minBlockSize         Description of the Parameter
   * @return                     The textColumnTypeDefinition value
   * @see                        net.sf.jrf.DatabasePolicy#getTextColumnTypeDefinition(int,boolean,boolean,int)
   */
  public String getTextColumnTypeDefinition(int maxLength, boolean multiByteCharacters,
                                            boolean variable, int minBlockSize) {
    // TODO - FIXME
    if (maxLength <= 0 || maxLength > 255) {
      return TEXT;
    }
    String n = (multiByteCharacters ? "N" : "");
    String v = (variable ? "VAR" : "");
    if (maxLength == 1) {
      return n + CHAR + "(1)";
    }
    return v + n + CHAR + "(" + maxLength + ")";
  }

  /**
   * @param maxLength            Description of the Parameter
   * @param multiByteCharacters  Description of the Parameter
   * @param variable             Description of the Parameter
   * @param minBlockSize         Description of the Parameter
   * @return                     The textColumnSqlType value
   * @see                        net.sf.jrf.DatabasePolicy#getTextColumnSqlType(int,boolean,boolean,int)
   */
  public int getTextColumnSqlType(int maxLength, boolean multiByteCharacters,
                                  boolean variable, int minBlockSize) {
    // TODO - FIXME
    if (maxLength <= 0 || maxLength > 255) {
      return java.sql.Types.LONGVARCHAR;
    }
    if (variable) {
      if (maxLength == 1) {
        return java.sql.Types.CHAR;
      }
      return java.sql.Types.VARCHAR;
    }
    return java.sql.Types.CHAR;
  }

  /**
   * @param maxLength     Description of the Parameter
   * @param variable      Description of the Parameter
   * @param minBlockSize  Description of the Parameter
   * @return              The binaryColumnTypeDefinition value
   * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnTypeDefinition(int,boolean,int) *
   */
  public String getBinaryColumnTypeDefinition(int maxLength,
                                              boolean variable, int minBlockSize) {
    // TODO - FIXME
    if (maxLength <= 0 || maxLength > 255) {
      return "IMAGE";
    }
    String v = (variable ? "VAR" : "");
    return v + "BINARY(" + maxLength + ")";
  }

  /**
   * @param maxLength     Description of the Parameter
   * @param variable      Description of the Parameter
   * @param minBlockSize  Description of the Parameter
   * @return              The binaryColumnSqlType value
   * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnSqlType(int,boolean,int) *
   */
  public int getBinaryColumnSqlType(int maxLength, boolean variable, int minBlockSize) {
    // TODO - FIXME
    return variable ? java.sql.Types.VARBINARY : java.sql.Types.BINARY;
  }


  /**
   * @return   The duplicateKeyErrorCode value
   * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorCode() *
   */
  public int getDuplicateKeyErrorCode() {
    // TODO - FIXME
    return 1;
  }

  /**
   * @return   The duplicateKeyErrorText value
   * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorText() *
   */
  public String getDuplicateKeyErrorText() {
    // TODO - FIXME
    return "FFSDF";//
  }

  /**
   * @return   The duplicateKeyCheckType value
   * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyCheckType() *
   */
  public int getDuplicateKeyCheckType() {
    // TODO - FIXME
    return DatabasePolicy.DUPKEYCHECK_CODE;//
  }

  /**
   * @return   The autoIncrementNumericColumnType value
   * @see      net.sf.jrf.DatabasePolicy#getAutoIncrementNumericColumnType() *
   */
  public String getAutoIncrementNumericColumnType() {
    // TODO - FIXME
    return "INTEGER";
  }

  /**
   * @return   The dateColumnType value
   * @see      net.sf.jrf.DatabasePolicy#getDateColumnType() *
   */
  public String getDateColumnType() {
    return "DATE";
  }

  /**
   * @return   The timeColumnType value
   * @see      net.sf.jrf.DatabasePolicy#getTimeColumnType() *
   */
  public String getTimeColumnType() {
    return "TIME";
  }

  /**
   * @param argument  Description of the Parameter
   * @return          Description of the Return Value
   * @see             net.sf.jrf.DatabasePolicy#formatToUpper(String) *
   */
  public String formatToUpper(String argument) {
    return DefaultImpls.formatToUpper(argument);
  }

  /**
   * @param argument  Description of the Parameter
   * @return          Description of the Return Value
   * @see             net.sf.jrf.DatabasePolicy#formatToLower(String) *
   */
  public String formatToLower(String argument) {
    return DefaultImpls.formatToLower(argument);
  }

  /**
   * @param foreignKey  Description of the Parameter
   * @return            The foreignKeySQLExpression value
   * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLExpression(ForeignKey) *
   */
  public String getForeignKeySQLExpression(ForeignKey foreignKey) {
    return "";// TODO
  }

  /**
   * @param foreignKey  Description of the Parameter
   * @return            The foreignKeySQLStatement value
   * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLStatement(ForeignKey) *
   */
  public String getForeignKeySQLStatement(ForeignKey foreignKey) {
    return "";// TODO
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#foreignKeyExpressionsAllowedInCreateTable() *
   */
  public boolean foreignKeyExpressionsAllowedInCreateTable() {
    return true;
  }

  /**
   * @param tableName             Description of the Parameter
   * @param indexType             Description of the Parameter
   * @param columns               Description of the Parameter
   * @param storageSpecification  Description of the Parameter
   * @return                      The createIndexSQL value
   * @see                         net.sf.jrf.DatabasePolicy#getCreateIndexSQL(String,String,List,String) *
   */
  public String getCreateIndexSQL(String tableName, String indexType, List columns, String storageSpecification) {
    return "";// TODO
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#padCHARStrings() *
   */
  public boolean padCHARStrings() {
    return false;
  }

}// FirebirdDatabasePolicy
