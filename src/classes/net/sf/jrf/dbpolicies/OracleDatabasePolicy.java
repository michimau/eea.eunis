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
 * Contributor: Elmar Fasel (efasel@ )
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
 *  Instances of this class perform Oracle-specific logic and return
 *  Oracle-specific information.
 */
public class OracleDatabasePolicy implements DatabasePolicy {

  final static Category LOG = Category.getInstance(OracleDatabasePolicy.class.getName());

  /** holds the bytes per character used for nls conversions */
  private int bytes_per_character;

  /** boolean state if object is initialised */
  private boolean initialised;

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
    return "SELECT " + sequenceNextValSQL(sequenceName, tableName) + " FROM DUAL";
  }

  /**
   * @param sequenceName  Description of the Parameter
   * @param tableName     Description of the Parameter
   * @return              Description of the Return Value
   * @see                 net.sf.jrf.DatabasePolicy#sequenceNextValSQL(String,String) *
   */
  public String sequenceNextValSQL(String sequenceName, String tableName) {
    return sequenceName + ".nextVal";
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
      return "CREATE SEQUENCE " + sequenceName;
    }
    return "CREATE SEQUENCE " + sequenceName + " " + sequenceParameters;
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
      stmtExecuter.executeUpdate("DROP SEQUENCE " + domain.getSequenceName());
    } catch (SQLException e) {
      // Ignore this exception since sequence may not be there.
    } catch (Exception e) {
      throw new DatabaseException(e);
    }
    try {
      if (sequenceParameters == null) {
        sequenceParameters = "";
      }
      stmtExecuter.executeUpdate(
              "CREATE SEQUENCE " + domain.getSequenceName() + " " + sequenceParameters);
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
    return "SELECT " + sequenceName + ".currval FROM DUAL";
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
    if (initialised) {
      return;
    }
    bytes_per_character = getBytes_per_Character(getNLS_NChar_Characterset(executer));
    initialised = true;
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
    return "SYSDATE";
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
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    return "TO_DATE('" + sdf.format(ts) + "','YYYY-MM-DD HH24:MI:SS')";
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
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    return "TO_DATE('" + sdf.format(sqlDate) + "','YYYY-MM-DD')";
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#currentTimestampSQL() *
   */
  public String currentTimestampSQL() {
    return "select SYSDATE from dual";
  }

  /**
   * @param mainTableColumn  Description of the Parameter
   * @param joinTableColumn  Description of the Parameter
   * @return                 Description of the Return Value
   * @see                    net.sf.jrf.DatabasePolicy#outerWhereJoin(String,String) *
   */
  public String outerWhereJoin(String mainTableColumn,
                               String joinTableColumn) {
    return mainTableColumn + " = " + joinTableColumn + "(+)";
  }

  /**
   * @return   Description of the Return Value
   * @see      net.sf.jrf.DatabasePolicy#timestampColumnType() *
   */
  public String timestampColumnType() {
    return "DATE";
  }

  /**
   * @param maxLength                   Description of the Parameter
   * @param multiByteCharacters         Description of the Parameter
   * @param variable                    Description of the Parameter
   * @param minBlockSize                Description of the Parameter
   * @return                            The textColumnTypeDefinition value
   * @exception ConfigurationException  Description of the Exception
   * @see                               net.sf.jrf.DatabasePolicy#getTextColumnTypeDefinition(int,boolean,boolean,int) *
   */
  public String getTextColumnTypeDefinition(int maxLength,
                                            boolean multiByteCharacters,
                                            boolean variable,
                                            int minBlockSize)
          throws ConfigurationException {
    /*
      see
      Basic Elements of Oracle SQL:  Datatypes
      http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a85397/sql_elem.htm#46267
      see also:
      JDBC and NLS
      http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/java.817/a83724/advanc1.htm#1009132
    */
    if (initialised) {
      String n = (multiByteCharacters ? "N" : "");
      maxLength = maxLength * bytes_per_character;
      if (maxLength <= 0 || maxLength > 4000) {
        return n + "CLOB";
      } else if (maxLength == 1) {
        return n + "CHAR(1)";
      }
      if (variable) {
        return n + "VARCHAR2(" + maxLength + ")";
      }
      return n + "CHAR(" + maxLength + ")";
    } else {
      throw new ConfigurationException(
              "You have to call initialize() prior to calling getBytes_per_character().");
    }
  }

  /**
   * @param maxLength                   Description of the Parameter
   * @param multiByteCharacters         Description of the Parameter
   * @param variable                    Description of the Parameter
   * @param minBlockSize                Description of the Parameter
   * @return                            The textColumnSqlType value
   * @exception ConfigurationException  Description of the Exception
   * @see                               net.sf.jrf.DatabasePolicy#getTextColumnSqlType(int,boolean,boolean,int) *
   */
  public int getTextColumnSqlType(int maxLength, boolean multiByteCharacters,
                                  boolean variable, int minBlockSize)
          throws ConfigurationException {
    if (initialised) {
      maxLength = maxLength * bytes_per_character;
      if (maxLength <= 0 || maxLength > 4000) {
        return java.sql.Types.CLOB;
      }

      String v = (variable ? "VAR" : "");
      if (maxLength == 1) {
        return java.sql.Types.CHAR;
      }
      return java.sql.Types.VARCHAR;
    } else {
      throw new ConfigurationException(
              "You have to call initialize() prior to calling getBytes_per_character().");
    }
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
    // see http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a85397/sql_elem.htm#45443
    if (maxLength <= 0 || maxLength > 2000) {
      return "BLOB";
    }
    return "RAW(" + maxLength + ")";
  }

  /**
   * @param maxLength     Description of the Parameter
   * @param variable      Description of the Parameter
   * @param minBlockSize  Description of the Parameter
   * @return              The binaryColumnSqlType value
   * @see                 net.sf.jrf.DatabasePolicy#getBinaryColumnSqlType(int,boolean,int) *
   */
  public int getBinaryColumnSqlType(int maxLength, boolean variable,
                                    int minBlockSize) {
    // see http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a85397/sql_elem.htm#45443
    if (maxLength <= 0 || maxLength > 2000) {
      return java.sql.Types.BLOB;
    }
    if (variable) {
      return java.sql.Types.VARBINARY;
    }
    return java.sql.Types.BINARY;
  }

  /**
   * @return   The duplicateKeyErrorCode value
   * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorCode() *
   */
  public int getDuplicateKeyErrorCode() {
    // see http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a76999/e0.htm#1001560
    return 1;
  }

  /**
   * @return   The duplicateKeyErrorText value
   * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyErrorText() *
   */
  public String getDuplicateKeyErrorText() {
    return "FFSDF";//
  }

  /**
   * @return   The duplicateKeyCheckType value
   * @see      net.sf.jrf.DatabasePolicy#getDuplicateKeyCheckType() *
   */
  public int getDuplicateKeyCheckType() {
    return DatabasePolicy.DUPKEYCHECK_CODE;//
  }

  /**
   * @return   The autoIncrementNumericColumnType value
   * @see      net.sf.jrf.DatabasePolicy#getAutoIncrementNumericColumnType() *
   */
  public String getAutoIncrementNumericColumnType() {
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
   * Returns the NLS_NChar_Characterset of the oracle database.
   * Used for NCHAR, NVARCHAR2 and NCLOB.
   *
   * @param stmtExecuter      <code>StatementExecuter</code> instance to perform the action</code>.
   * @return                  String declaring the used characterset
   * @exception SQLException  Description of the Exception
   */
  private String getNLS_NChar_Characterset(StatementExecuter stmtExecuter)
          throws SQLException {
    // see http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a76966/ch2.htm#97247
    try {
      return stmtExecuter.getSingleRowColAsString(
              "select VALUE from V$NLS_PARAMETERS where PARAMETER='NLS_NCHAR_CHARACTERSET'");
    } catch (SQLException e) {
      throw e;
    } catch (Exception e) {
      throw new DatabaseException(e);
    }
  }

  /**
   * Returns the bytes per character used for the given characterset in oracle
   *
   * @param charset  charset to query
   * @return         bytes per character
   */
  private int getBytes_per_Character(String charset) {
    // see http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a76966/appa.htm#958278
    OracleCharsets ocharsets = new OracleCharsets();
    try {
      return ocharsets.getBytes_per_charset(charset);
    } catch (UndefinedCharSetException ex) {
      // for undefined charsets return 1 (request for any better solution)
      LOG.info("Character set " + charset + " is unknown; assumming 1 byte per character.");
      return 1;
    }
  }

  /**
   * Returns the bytes per character oracle uses
   *
   * @return                            bytes per character
   * @exception ConfigurationException  Description of the Exception
   */
  private int getBytes_per_character()
          throws ConfigurationException {
    // see http://otn.oracle.com/docs/products/oracle8i/doc_library/817_doc/server.817/a76966/appa.htm#958278
    if (initialised) {
      return bytes_per_character;
    } else {
      throw new ConfigurationException("You have to call initialize() prior to calling getBytes_per_character().");
    }
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
    return true;
  }

  /**
   * Returns "NULL"
   *
   * @return   "NULL"
   */
  public String getNullableColumnQualifier() {
    return " NULL";
  }

}// OracleDatabasePolicy
