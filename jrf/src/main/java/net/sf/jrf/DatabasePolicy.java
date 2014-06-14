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
 * Contributor: James Evans (jevans@vmguys.com)
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
package net.sf.jrf;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;
import net.sf.jrf.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.sql.*;
import net.sf.jrf.util.ForeignKey;

/**
 * This interface provides information and
 * functionality that is specific to the
 * database vendor that cannot be obtained from the information provided in
 * <code>java.sql.DatabaseMetaData</code>.
 * <p>
 * The methods in this interface either:
 * <ul>
 * <li> Return
 * SQL expressions or statements specific to the vendor or
 * <li> Excecute vendor-specific SQL or JDBC calls to perform some function.
 * <li> Return support level information for a particular database feature (e.g. sequence type support).
 * </ul>
 * <p>
 * <h3>Sequence Implementation Notes</h3>
 * <p>
 * <p>
 * <h4>External Sequence Implementation Overview (External sequences are created independent of any single table)
	</h4>
 * <table border=4>
 *    <thead>
 *      <tr align='left'bgcolor='gold'>
 *        <th>Method</th><th>Comments</th>
 *     </tr>
 *    </thead>
 *    <tbody>
 *    <tr align='left'>
 *    <th>sequenceNextValSQL()</th>
 *    <th>This method should return the SQL expression for next sequence value (e.g. seq.NEXTVAL)</th> 
 *     </tr>
 *    <tr align='left'>
 *    <th>sequenceSQL()</th>
 *    <th>Ordinarily, this method should be implemented as <code>"SELECT "+sequenceNextValSQL()"</code>.</th> 
 *     </tr>
 *    <tr align='left'>
 *    <th>getCreateSequenceSQL()</th>
 *    <th>Return the full SQL to create the sequence.</th> 
 *     </tr>
 *    <tr align='left'>
 *    <th>createSequence() (both overloads)</th>
 *    <th>Until a separate method is created for dropping sequence, implementation should include issuing an 
	  SQL statement to drop the sequence.</th> 
 *    </tr>
 *    </tbody>
 * </table>
 * <p>
 * <h4>Internal Sequence Implementation Overview (Internal sequences are "internal" to a particular database table)
  </h4>
 * <table border=4>
 *    <thead>
 *      <tr align='left'bgcolor='gold'>
 *        <th>Method</th><th>Comments</th>
 *     </tr>
 *    </thead>
 *    <tbody>
 *    <tr align='left'>
 *    <th>autoIncrementIdentifier()</th>
 *    <th>This method should return the SQL expression that denotes an internal sequence for a "CREATE TABLE" statement.</th>
 *     </tr>
 *    <tr align='left'>
 *    <th>getAutoIncrementNumericColumnType()</th>
 *    <th>Some database vendors insist on a specific database numeric type "CREATE TABLE" statements."</th> 
 *    </tr>
 *    </tbody>
 * </table>
 * @see   java.sql.DatabaseMetaData
 */
public interface DatabasePolicy
{

    /**
     * Constant to denote no support for database sequences, auto-increment
     * or otherwise.
     *
     * @see   #getSequenceSupportType()
     */
    public final static int SEQUENCE_SUPPORT_NONE = 0;

    /**
     * Constant to denote support for auto-incrementing database sequences
     * where the name and the value of the column must be included
     * in the insert statement. Normally the value is set to null.
     * Given a table with and ID and a NAME, an example SQL statement would
     * be:
     * <pre>
     *  INSERT INTO X (ID,NAME) VALUES(NULL,'Jones')
     * </pre>
     *
     * @see   #getSequenceSupportType()
     */
    public final static int SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT = 1;

    /**
     * Constant to denote support for auto-incrementing database sequences
     * where the name and the value of the column must <em>not</em> be included
     * in the insert statement.
     * Given a table with and ID and a NAME, an example SQL statement would
     * be:
     * <pre>
     *  INSERT INTO X (NAME) VALUES('Jones')
     * </pre>
     *
     * @see   #getSequenceSupportType()
     */
    public final static int SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT = 2;

    /**
     * Constant to denote support for external sequences.  In other
     * words, the database supports sequences where the value is constructed separate from an
     * actual table.   A sequence function must exist
     * if the database has this sequence support type.
     * Given a table with and ID and a NAME, an example SQL statement would
     * be:
     * <pre>
     *  INSERT INTO X (ID,NAME) VALUES(aseq.nextval,'Jones')
     * </pre>
     *
     * @see   #sequenceSQL(String,String)
     * @see   #getSequenceSupportType()
     */
    public final static int SEQUENCE_SUPPORT_EXTERNAL = 3;

    /**
     * Constant to denote that database does not support fetching sequences
     * after an insert operation at all.  (<em>A database type that returns this
     * value for <code>getSequenceFetchAfterInsertSupportType()</code> is, of course, 
     * incapable of implementing the application scenario of a sequenced
     * master table and accompanying detail tables that use the master's sequence value as
     * a foreign key</em>).
     *
     * @see   #getSequenceFetchAfterInsertSupportType()
     */
    public final static int SEQUENCE_FETCHAFTERINSERTSUPPORT_NONE = 0;

    /**
     * Constant return for <code>getSequenceFetchAfterInsertSupportType</code> denoting
     * that
     * inserted sequence may be obtained via call to vendor statement or connection
     * class method.
     * It is possible for a particular database to support this
     * method of fetching an sequence value after an insert irrespective
     * of the sequence support type.
     *
     * @see   #getSequenceFetchAfterInsertSupportType()
     * @see   #getSequenceSupportType()
     * @see   #findAutoIncrementIdByMethodInvoke(String,String,Statement)
     */
    public final static int SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE = 1;

    /**
     * Constant return for <code>getSequenceFetchAfterInsertSupportType</code> denoting
     * that
     * inserted sequence may be obtained via a vendor-specifc SQL statement.
     * It is possible for a particular database to support this
     * method of fetching an sequence value after an insert irrespective
     * of the sequence support type.
     *
     * @see   #getSequenceFetchAfterInsertSupportType()
     * @see   #findAutoIncrementIdByMethodInvoke(String,String,Statement)
     */
    public final static int SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY = 2;


    /**
     * Returns support type for sequence ids that lets
     * <code>AbstractDomain</code> know how to fetch the most
     * recently inserted sequence value.
     *
     * @return   <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_NONE</code>,
     *	<code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>,
     *	or <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE</code>.
     * @see      #SEQUENCE_FETCHAFTERINSERTSUPPORT_NONE
     * @see      #SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE
     * @see      #SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY
     * @see      net.sf.jrf.domain.AbstractDomain
     */
    public int getSequenceFetchAfterInsertSupportType();

    /**
     * Returns the sequence support type for this database.
     *
     * @return   <code>SEQUENCE_SUPPORT_NONE</code>,
     *	<code>SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT</code>,
     *	<code>SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT</code> or
     *	<code>SEQUENCE_SUPPORT__EXTERNAL</code>.
     * @see      #SEQUENCE_SUPPORT_NONE
     * @see      #SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT
     * @see      #SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT
     * @see      #SEQUENCE_SUPPORT_EXTERNAL
     */
    public int getSequenceSupportType();

    //////////////////////////////////////////////////////////////////
    // SEQUENCE_SUPPORT_EXTERNAL - required methods.
    //////////////////////////////////////////////////////////////////

    /**
     * Returns a SQL string to get the next sequence number for a table.  When
     * executed, this SQL should return a one column, one row result set with
     * an integer. <em>If sequence support is <code>SEQUENCE_SUPPORT_EXTERNAL</code>
     * this, method must return a value. </em>.
     *
     * @param sequenceName  name of the sequence.
     * @param tableName     Description of the Parameter
     * @return              SQL statement that may be used to fetch the <i>next</i> sequence
     * value.
     * @see                 #SEQUENCE_SUPPORT_EXTERNAL
     */
    public String sequenceSQL(String sequenceName, String tableName);

    /**
     * Creates a sequence for the given domain object.
     *
     * @param domain            <code>AbstractDomain</code> instance that contains the sequence.
     * @param stmtExecuter      <code>StatementExecuter</code> instance to use to issue one or more
     * SQL statements to create the sequence.
     * @exception SQLException  if an error occurs running the SQL statement.
     * @see                     #createSequence(AbstractDomain,String,StatementExecuter)
     * @see                 #SEQUENCE_SUPPORT_EXTERNAL
     */
    public void createSequence(AbstractDomain domain,
        StatementExecuter stmtExecuter)
        throws SQLException;

    /**
     * Returns a stand-alone SQL statement that may be used to create a sequence.
     * This method only applies
     * to database that have a support type of <code>SEQUENCE_SUPPORT_EXTERNAL</code>.
     * If the sequence already exists, it will be reset to the beginning (usually 0).
     *
     * @param sequenceParameters  database vendor-specific parameters.
     * @param sequenceName        Description of the Parameter
     * @return                    an SQL statement that may be used to create a sequence.
     * @see                       #createSequence(AbstractDomain,String,StatementExecuter)
     * @see                       #SEQUENCE_SUPPORT_EXTERNAL
     */
    public String getCreateSequenceSQL(String sequenceName, String sequenceParameters);

    /**
     * Creates a sequence for the given domain object with additional storage paramters.
     * This method only applies
     * to database that have a support type of <code>SEQUENCE_SUPPORT_EXTERNAL</code>.
     * If the sequence already exists, it will be reset to the beginning (usually 0).
     *
     * @param domain              <code>AbstractDomain</code> instance that contains the sequence.
     * @param sequenceParameters  database vendor-specific parameters.
     * @param stmtExecuter        <code>StatementExecuter</code> instance to use to issue one or more
     * SQL statements to create the sequence.
     * @exception SQLException    if an error occurs running the SQL statement.
     * @see                       #getCreateSequenceSQL(String,String)
     * @see                       #SEQUENCE_SUPPORT_EXTERNAL
     */
    public void createSequence(AbstractDomain domain, String sequenceParameters,
        StatementExecuter stmtExecuter)
        throws SQLException;
    //////////////////////////////////////////////////////////////////
    // SEQUENCE_SUPPORT_AUTOINCREMENT_.. - required methods.
    //////////////////////////////////////////////////////////////////

    /**
     * Returns the SQL expression that denotes an auto-increment
     * identifier column if supported by the database vendor. This value
     * is used for SQL create table statements.  Implementations that
     * do not support auto-increment columns should return <code>null</code>.
     *
     * @return   the SQL expression for auto-increment identifier columns or
     * <code>null</code> if not supported.
     */
    public String autoIncrementIdentifier();

    /**
     * When auto-increments are supported, returns the Integer column
     * type definition for auto-increment columns to be used in create table statements.
     * Normally, "INTEGER" will suffice. However, under Sybase,
     * this requires NUMERIC(11,0).  Other database vendors may have
     * similar problems.
     *
     * @return   auto-increment column type definition.
     * @see      net.sf.jrf.column.columnspecs.IntegerColumnSpec
     * @see      #SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT
     * @see      #SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT
     */
    public String getAutoIncrementNumericColumnType();


    //////////////////////////////////////////////////////////////////
    // SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE  required method.
    //////////////////////////////////////////////////////////////////

    /**
     * Returns a SQL expression to get the next sequence number for a table.
     * The return value from this method is to be used in an SQL insert
     * insert statement and most often may not be able to be executed
     * as a stand-alone statement.
     * <em>If sequence support is <code>SEQUENCE_SUPPORT_EXTERNAL</code>
     * this, method must return a value. </em>.
     *
     * @param sequenceName  name of the sequence.
     * @param tableName     name of the table.
     * @return              SQL expressnion that may be used to fetch the <i>next</i> sequence
     * value.
     * @see                 #sequenceSQL(String,String)
     * @see                 #SEQUENCE_SUPPORT_EXTERNAL
     */
    public String sequenceNextValSQL(String sequenceName, String tableName);

    /**
     * Returns the SQL statement to use to fetch
     * last sequence number if the
     * fetch-after-insert support type is <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
     *
     * @param sequenceName  sequence name, if applicable (<code>SEQUENCE_SUPPORT_EXTERNAL</code>.
     * @param tableName     table name, which some vendors may require.
     * @return              SQL construct that may be used to fetch the last inserted sequence number
     * identifier number.  <code>AbstractDomain<code> will use this construct
     * to fetch next value.
     * @see                 #getSequenceFetchAfterInsertSupportType()
     * @see                 net.sf.jrf.domain.AbstractDomain
     * @see                 #SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY
     * @see                 #SEQUENCE_SUPPORT_EXTERNAL
     */
    public String getFindLastInsertedSequenceSql(String sequenceName, String tableName);

    //////////////////////////////////////////////////////////////////
    // SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY -- required method
    //////////////////////////////////////////////////////////////////

    /**
     * Returns the <i>last</i> auto-increment identifier value
     * set for this table and column by invoking a vendor-specific method on the
     * <code>Statement</code> or <code>Connection</code> class.
     * <b><i>NOTE: implementers of <code>DataSource</code> sometimes wrap the actual
     * <code>Statement</code> class and should always wrap the <code>Connection</code> class.
     * Implementations may often have to cast to <code>Connection</code> or <code>Statement</code>
     * wrapper values to the datasource-specific versions with the understanding that
     * a method exists to obtain the actual vendor handles.
     * </i></b>
     *
     * @param tableName   requisite table name.
     * @param stmt        <code>Statement</code> instance.
     * @param columnName  Description of the Parameter
     * @return            last auto-increment value.
     * @see               #SEQUENCE_FETCHAFTERINSERTSUPPORT_METHODINVOKE
     */
    public Long findAutoIncrementIdByMethodInvoke(String tableName, String columnName, Statement stmt);

    // END SEQUENCES //////////////////////////////////////


    /**
     * Initializes private policy instance variables by
     * querying the database.  The framework calls this method when
     * a connection is made for the first time on a particular
     * <code>DataSource</code> in <code>JRFConnection</code>.  An example
     * implementation of this method is to determine the database character
     * set.
     *
     * @param executer       Description of the Parameter
     * @throws SQLException  is an error occurs accessing the
     *			database.
     * @see                  net.sf.jrf.sql.JRFConnection#assureDatabaseConnection()
     */
    public void initialize(StatementExecuter executer)
        throws SQLException;

    /**
     * Returns the string value the denotes the current timestamp function.
     * The return value from this method may be used in an SQL statement, prepared or static.
     *
     * @return   SQL statement to fetch current time stamp.
     */
    public String timestampFunction();


    /**
     * Returns the SQL function expression for a given string argument
     * that converts the argument to upper case.  For example:
     * <pre>
     * public String formatToUpper(String value) {
     *		return "UPPER("+value+")";
     * }
     * </pre>
     *
     * @param argument  String argument to format.
     * @return          SQL expression that converts the argument to upper case.
     */
    public String formatToUpper(String argument);


    /**
     * Returns the SQL function expression for a given string argument
     * that converts the argument to lower case.  For example:
     * <pre>
     * public String formatToLower(String value) {
     *		return "LOWER("+value+")";
     * }
     * </pre>
     *
     * @param argument  String argument to format.
     * @return          SQL expression that converts the argument to lower case.
     */
    public String formatToLower(String argument);


    /**
     * Returns an SQL expression that formats provided <code>Timestamp</code> value.
     * The formatted return value may be used in a full SQL statement.
     *
     * @param ts  <code>Timestamp</code> value to format.
     * @return    a syntactically correct SQL expression that formats the <code>Timestamp</code> argument.
     */
    public String formatTimestamp(Timestamp ts);

    /**
     * Returns an SQL expression that formats the provided <code>java.sql.Date</code> value
     * The formatted return value may be used in a full SQL statement.
     *
     * @param sqlDate  <code>java.sql.Date</code> value to format.
     * @return         a syntactically correct SQL expression that formats the
     * <code>java.sql.date</code> argument.
     */
    public String formatDate(java.sql.Date sqlDate);

    /**
     * Returns the full SQL statement that may be used
     * to obtain the current time stamp.
     *
     * @return   full SQL statement to return current time stamp.
     */
    public String currentTimestampSQL();

    /**
     * Returns the name-value pair that represents the vendor-specific
     * SQL outer join expression (e.g. Oracle: Tb1.Id= Tb2.id(+)).
     *
     * @param mainTableColumn  main table column expression.
     * @param joinTableColumn  join table column expression.
     * @return                 name-value pair that represenst vendor-specific outer join
     * expression.
     */
    public String outerWhereJoin(String mainTableColumn,
        String joinTableColumn);

    /**
     * Returns the SQL expression that denotes a time stamp
     * column type to be used in create table SQL statements.
     *
     * @return   SQL express that denotes  time stamp column.
     */
    public String timestampColumnType();


    /**
     * Returns any extra qualifying attributes for a primary key
     * column.  Some database vendors choke if "NOT NULL" is placed
     * after an SQL column definition for a primary key.  Implementations
     * that do need any attributes should return a blank string.
     *
     * @return   The primaryKeyQualifiers value
     */
    public String getPrimaryKeyQualifiers();


    /**
     * Returns the SQL expression that can be used to declare
     * a foreign key relationship in a CREATE TABLE statement.
     *
     * @param foreignKey  foreign key information.
     * @return            SQL expression that may be used to declare
     *		  a foreign key relationship in a CREATE TABLE statement.
     * @see               #getForeignKeySQLStatement(ForeignKey)
     * @see               #foreignKeyExpressionsAllowedInCreateTable()
     * @see               net.sf.jrf.util.ForeignKey
     */
    public String getForeignKeySQLExpression(ForeignKey foreignKey);

    /**
     * Returns a syntactically correct SQL statement that may be executed to create a foreign key relationship
     * externally from the CREATE TABLE statement.
     *
     * @param foreignKey  foreign key information.
     * @return            SQL expression that may be used to declare
     *		  a foreign key relationship in a CREATE TABLE statement.
     * @see               #getForeignKeySQLExpression(ForeignKey)
     * @see               net.sf.jrf.util.ForeignKey
     */
    public String getForeignKeySQLStatement(ForeignKey foreignKey);


    /**
     * Returns <code>true</code> if a foreign key can be created in the context of
     * an SQL CREATE TABLE statement.
     *
     * @return   <code>true</code> if a foreign key can be created in the context of
     * an SQL CREATE TABLE statement.
     * @see      #getForeignKeySQLExpression(ForeignKey)
     */
    public boolean foreignKeyExpressionsAllowedInCreateTable();

    /**
     * Returns the SQL statement to necessary to create an index based on
     *  specifications.
     *
     * @param tableName             name of the table that gets the index.
     * @param indexType             vendor-specific declaration of index type (e.g. unigue, primary key, etc.)
     * @param columns               list of <code>String</code> column names.
     * @param storageSpecification  optional database-specific storage information.
     * @return                      a fully qualified SQL statement that may be executed to create a table index.
     */
    public String getCreateIndexSQL(String tableName, String indexType, List columns, String storageSpecification);

    /**
     *Returns the column type definition for numeric columns based
     * on type, precision and scale parameters. Database vary wildly
     * on what is required.
     *
     * @param sqlType    one of the <code>java.sql.Types</code> constants.
     * @param precision  total number of digits including digits to the right of the decimal.
     * @param scale      number of digits to the right of the decimal.
     * @return           database-specific column definition string for the numeric column type.
     */
    public String getNumericColumnTypeDefinition(int sqlType, int precision, int scale);

    /**
     * Returns the create table column definition for text columns based on the
     * supplied maximum length, whether the data is variable, multibyte,
     * and minimum  block size required.  Database vendors differ on what type
     * of columns definition is required based these parameters.  Accurate
     * implementations of this method will allow the <code>AbstractDomain.createTable()</code>
     * method work efficiently and correctly for a given database vendor.
     *
     * @param maxLength            maximum length of the field.
     * @param multiByteCharacters  if <code>true</code> use multibyte characters.
     * @param variable             if <code>true</code> length is variable.
     * @param minBlockSize         minimum block size required, if applicable (zero denotes none).
     * @return                     column definition string for text field based on maximum length.
     */
    public String getTextColumnTypeDefinition(int maxLength, boolean multiByteCharacters,
        boolean variable, int minBlockSize);

    /**
     * Returns the <code>java.sql.Types</code> value based on the
     * supplied maximum length, whether the data is variable, multibyte,
     * and minimum  block size required.  Database vendors differ on what type
     * of columns type is required based these parameters.
     *
     * @param maxLength            maximum length of the field.
     * @param multiByteCharacters  if <code>true</code> use multibyte characters.
     * @param variable             if <code>true</code> length is variable.
     * @param minBlockSize         minimum block size required (zero denotes none).
     * @return                     <code>java.sql.Types</code> value.
     */
    public int getTextColumnSqlType(int maxLength, boolean multiByteCharacters,
        boolean variable, int minBlockSize);

    /**
     * Returns the column definition for binary columns based on the
     * supplied maximum length, whether the data is variable
     * and minimum  block size required.  Database vendors differ on what type
     * of columns definition is required based these parameters. The return
     * value should be the optimal expression that may be used in a create
     * table statement.
     *
     * @param maxLength     maximum length of the field.
     * @param variable      if <code>true</code> length is variable.
     * @param minBlockSize  minimum block size required (zero denotes none).
     * @return              column definition string for text field based on maximum length.
     */
    public String getBinaryColumnTypeDefinition(int maxLength,
        boolean variable, int minBlockSize);


    /**
     * Returns the <code>java.sql.Types</code> value based on the
     * supplied maximum length, whether the data is variable, multibyte,
     * and minimum  block size required.  Database vendors differ on what type
     * of columns type is required based these parameters.
     *
     * @param maxLength            maximum length of the field.
     * @param variable             if <code>true</code> length is variable.
     * @param minBlockSize         minimum block size required (zero denotes none).
     * @return                     <code>java.sql.Types</code> value.
     */
    public int getBinaryColumnSqlType(int maxLength, boolean variable, int minBlockSize);

    /**
     * Return constant from <code>getDuplicateKeyCheckType()</code> for specifying that
     * duplicate row exceptions should be determined by examing the text of
     * <code>java.sql.SQLException.getMessage()</code>.
     *
     * @see   #getDuplicateKeyCheckType()
     * @see   #getDuplicateKeyErrorText()
     */
    public final static int DUPKEYCHECK_TEXT = 0;

    /**
     * Return constant from <code>getDuplicateKeyCheckType()</code> for specifying that
     * duplicate row exceptions should be determined by examing the value of
     * <code>java.sql.SQLException.getErrorCode()</code>.
     *
     * @see   #getDuplicateKeyCheckType()
     * @see   #getDuplicateKeyErrorCode()
     */
    public final static int DUPKEYCHECK_CODE = 1;

    /**
     * Returns the error code associated with a duplicate key exception.  This error
     * is the vendor error returned from <code>java.sql.SQLException.getErrorCode()</code>
     * when a duplicate key error is encountered.
     *
     * @return   error code associated with duplicate key insert operations.
     * @see      #getDuplicateKeyErrorText()
     * @see      #DUPKEYCHECK_CODE
     */
    public int getDuplicateKeyErrorCode();

    /**
     * Returns a very explicit string that denotes a unique key violation.
     * This method is useful for databases that do not support specific error codes via
     * <code>java.sql.SQLException.getErrorCode()</code>
     *
     * @return   requisite text to denote unique key violation.
     * @see      #getDuplicateKeyErrorCode()
     * @see      #DUPKEYCHECK_TEXT
     */
    public String getDuplicateKeyErrorText();

    /**
     * Returns one of two contants that specify how to check for duplicate key errors.
     *
     * @return   <code>DUPKEYCHECK_TEXT</code> or <code>DUPKEYCHECK_CODE</code>.
     * @see      #DUPKEYCHECK_TEXT
     * @see      #DUPKEYCHECK_CODE
     * @see      #getDuplicateKeyErrorCode()
     * @see      #getDuplicateKeyErrorText()
     */
    public int getDuplicateKeyCheckType();

    /**
     * Returns the SQL expression that denotes a date column type.
     * The return value may be used in create table statements.
     *
     * @return   SQL expression that denotes a date column type.
     */
    public String getDateColumnType();

    /**
     * Returns the SQL expression that denotes a time column type.
     * The return value may be used in create table statements.
     *
     * @return   SQL expression that denotes a time column type.
     */
    public String getTimeColumnType();


    /**
     * Returns <code>true</code> if columns declared as <code>CHAR</code>
     * must be padded to the length of the string column for <code>PreparedStatement</code>s.
     * In other words,  a <code>true</code> return from this method will force <code>JRFPreparedStatement</code>
     * to pad the input value up to the maximum length of the string.
     *
     * @return   <code>true</code> if CHAR strings must be padded for prepared statement.
     * @see      net.sf.jrf.column.SizedColumnSpec#getMaxLength()
     */
    public boolean padCHARStrings();

    /**
     * Returns the qualifier used in a <code>CREATE TABLE</code> statement to
     * qualify a nullable column.  Most databases require <code>NULL</code>.
     *
     * @return   qualifier to denote a nullable column in an SQL <code>CREATE TABLE</code> statement.
     */
    public String getNullableColumnQualifier();

}// DatabasePolicy

