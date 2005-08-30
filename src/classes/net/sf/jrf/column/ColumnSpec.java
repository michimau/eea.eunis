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
package net.sf.jrf.column;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.List;

import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;
import net.sf.jrf.sql.*;

/**
 * JE Method additions -- see AbstractColumnSpec.java for a
 * complete discussion.
 * Added:
 *public int getMaxLength();
 *public GetterSetter getGetterSetterImpl()
 *public void setGetterSetterImpl(GetterSetter getterSetterImpl)
 *public String getInsertSqlValueFrom(PersistentObject aPO,
 *DatabasePolicy dbPolicy;
 *public boolean fetchAutoIncrementColumnAfterInsert(DatabasePolicy dbPolicy)
 *public boolean isImplicitInsertColumn(DatabasePolicy dbPolicy)
 *public String getInsertColumnName()
 */

/**
 *  Interface that contains the requisite methods to allow the framework
 *  to map an SQL database column to a specific Java object and vice-versa.
 */
public interface ColumnSpec
        extends JRFConstants {

  /* ===============  Abstract Method Definitions  =============== */
  /**
   * Returns a string representing the given attribute value for use in a
   * static SQL expression.
   *
   * @param obj       column object instance.
   * @param dbPolicy  applicable database policy instance.
   * @return          value that may be used in a static SQL expression.
   */
  public String formatForSql(Object obj, DatabasePolicy dbPolicy);


  /**
   * Returns the java class name of the underlying Java Object for the column.
   *
   * @return   java class name of the underlying Java object for the column.
   */
  public abstract Class getColumnClass();


  /**
   * Returns the appropriate object value stored in a
   * <code>JRFResultSet</code>.
   *
   * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
   * See IntegerColumnSpec for an example of how to implement.
   * @return                  column object from <code>java.sql.ResultSet</code> in supplied
   * <code>JRFResultSet</code>.  Primary used by <code>copyColumnValueToPersistentObject()</code>.
   * @exception SQLException  Description of the Exception
   * @see                     #copyColumnValueToPersistentObject(JRFResultSet,PersistentObject)
   * @see                     net.sf.jrf.column.columnspecs.IntegerColumnSpec#getColumnValueFrom(JRFResultSet)
   */
  public abstract Object getColumnValueFrom(JRFResultSet jrfResultSet)
          throws SQLException;


  /**
   * Copies the value of column to the appropriate attribute for this
   * persistent object, normally by using <code>getColumnValueFrom()</code>.
   *
   * @param jrfResultSet      <code>JRFResultSet</code> encapsulating an active <code>java.sql.ResultSet</code>.
   * @param aPO               <code>PersistentObject</code> instance that contains the column attribute.
   * @exception SQLException  if an error occurs setting value from the
   * <code>java.sql.ResultSet</code>.
   * @see                     #getColumnValueFrom(JRFResultSet)
   */
  public void copyColumnValueToPersistentObject(JRFResultSet jrfResultSet,
                                                PersistentObject aPO)
          throws SQLException;


  /**
   * Copies the column attribute from one <code>PersistentObject</code> to another.
   *
   * @param aPO1  source <code>PersistentObject</code>
   * @param aPO2  destination <code>PersistentObject</code>
   * @see         #getValueFrom(PersistentObject)
   * @see         #setValueTo(Object,PersistentObject)
   */
  public void copyAttribute(PersistentObject aPO1,
                            PersistentObject aPO2);


  /**
   * Builds the appropriate where clause name-value pair expression to be used
   * in static SQL.
   * Note: This method is overridden by <code>CompoundPrimaryKeyColumnSpec</code> to
   * include " AND " between each name-value pair.
   *
   * @param separator             normal seperator to use, normally "="
   * @param tableName             appropriate table name.
   * @param dbPolicy              application database policy.
   * @param pkOrPersistentObject  Description of the Parameter
   * @return                      a suitable name-value pair expression for the given object.
   * @see                         #buildNameValuePair(Object,String,String,DatabasePolicy)
   */
  public String buildWhereClause(Object pkOrPersistentObject,
                                 String separator,
                                 String tableName,
                                 DatabasePolicy dbPolicy);

  /**
   * Buids equals (or not-equals) String for WHERE
   * clauses and UPDATE statements.  This method should not be used for
   * CompoundPrimaryKeyColumnSpec instances.  Use #buildWhereClause() instead.
   *
   * @param valueOrPersistentObject  an instance of the <code>PersistentObject</code>
   *						   includes the column attribute or an object
   *						   representing the column itself. Implementations
   *						   will use <code>instanceof</code> to determine which.
   * @param separator                either <code>JRFConstants.EQUALS</code>
   *						   or <code>JRFConstants.NOT_EQUALS</code>
   * @param tableName                table name.
   * @param dbPolicy                 appropriate database policy instance.
   * @return                         an expression in the format "COLUMNNAME = (or !=) VALUE".
   */
  public String buildNameValuePair(Object valueOrPersistentObject,
                                   String separator,
                                   String tableName,
                                   DatabasePolicy dbPolicy);


  /**
   * Validates the column value againsts either a list of values or a specified
   * minimum or maximum value.
   *
   * @param aPO                     <code>PersistentObject</code> instance to check.
   * @return                        The value of the attribute in the provided <code>PersistentObject</code>.
   * @throws InvalidValueException  if validation fails.
   * @see                           net.sf.jrf.exceptions.InvalidValueException
   */
  public Object validateValue(PersistentObject aPO)
          throws InvalidValueException;


  /**
   * Sets the maximum allowable value.
   *
   * @param maxValue  implementation of <code>Comparable</code>.
   */
  public void setMaxValue(Comparable maxValue);


  /**
   * Sets the minimum allowable value.
   *
   * @param minValue  implementation of <code>Comparable</code>.
   */
  public void setMinValue(Comparable minValue);


  /**
   * Sets the acceptable list of values for the column.
   *
   * @param listOfValues  The new listOfValues value
   */
  public void setListOfValues(List listOfValues);

  /**
   * Assures that the <code>PersistentObject</code> object has this attribute (if required).
   *
   * @param aPO                            <code>PersistentObject</code> instance to check.
   * @return                               The value of the attribute in the provided <code>PersistentObject</code>.
   * @exception MissingAttributeException  if attribute should be populated and it is not.
   */
  public Object validateRequired(PersistentObject aPO)
          throws MissingAttributeException;


  /**
   * If Column is declared UNIQUE, make sure it doesn't already exist in the
   * table.
   *
   * @param aPO                        <code>PersistentObject</code> instance that contains the column attribute.
   * @param stmtExecuter               <code>StatementExecuter</code> to run any database validations.
   * @param pkColumnSpec               the primary key <code>ColumnSpec</code>.
   * @param dbPolicy                   Description of the Parameter
   * @param tableName                  Description of the Parameter
   * @exception DuplicateRowException  if a row with this value already exists.
   */
  public void validateUnique(PersistentObject aPO,
                             StatementExecuter stmtExecuter,
                             ColumnSpec pkColumnSpec,
                             DatabasePolicy dbPolicy,
                             String tableName)
          throws DuplicateRowException;


  /**
   * Wraps both the extraction of the column attribute object
   * from the <code>PersistentObject</code> and formatting of the
   * column value for static SQL.
   *
   * @param aPO       <code>PersistentObject</code> instance that contains the column attribute.
   * @param dbPolicy  applicable database policy instance.
   * @return          value that may be used in a static SQL expression.
   * @see             #getValueFrom(PersistentObject)
   * @see             #formatForSql(Object,DatabasePolicy)
   */
  public String getSqlValueFrom(PersistentObject aPO,
                                DatabasePolicy dbPolicy);

  /**
   * Gets the value of this attribute from aPO.  If the value is
   * null, the default value will be returned.
   *
   * @param aPO  <code>PersistentObject</code> instance that contains the column attribute.
   * @return     column attribute value from the provided <code>PersistentObject</code> instance.
   */
  public Object getValueFrom(PersistentObject aPO);


  /**
   * Sets the provided column attribute value in a <code>PersistentObject<code> instance
   * by calling the appropriate set method.
   *
   * @param aValue  column attribute value.
   * @param aPO     <code>PersistentObject</code> instance that contains a set method for the attribute.
   */
  public void setValueTo(Object aValue,
                         PersistentObject aPO);


  /**
   * Converts the attribute(s) in the given <code>PersistentObject</code> to a String that
   * can be decoded later.  The return value from this method is not for use in SQL statements.
   *
   * @param aPO  <code>PersistentObject</code> instance that contains the column attribute.
   * @return     a string encoding of the column attribute value.
   * @see        #decodeToPersistentObject(String,PersistentObject)
   */
  public String encodeFromPersistentObject(PersistentObject aPO);


  /**
   * Converts the string created by <code>encodeFromPersistentObject</code> to the
   * appropriate column attribute object and calls the set method in the <code>PersistentObject</code>
   * to set the value.
   *
   * @param aString  a value of generated by <code>encodeFromPersistentObject()</code>.
   * @param aPO      <code>PersistentObject</code> instance that will contain the decoded column attribute value.
   */
  public void decodeToPersistentObject(String aString,
                                       PersistentObject aPO);


  /* ===============  Getters =============== */
  /**
   * Returns the fully-qualified column name, which will include the
   * provided table alias.
   *
   * @param tableAlias  table alias to use for constructing the result.
   * @return            fully-qualified column name in the format 'tableAlias.columnName'
   */
  public String getFullyQualifiedColumnName(String tableAlias);

  /**
   * Returns the database column name for this attribute.
   *
   * @return   column name for the attribute.
   */
  public String getColumnName();

  /** Sets the property name.
   * @param name property name to set.
   */
  public void setPropertyName(String name);

  /**
   * Returns the property name for this attribute, for use in <code>Reflection</code>
   * and other utilities. This value should be the name returned by <code>PropertyDescriptor.getName()</code>
   * for the bean method on the <code>PersistentObject</code>.
   *
   * @return   property name for the attribute.
   */
  public String getPropertyName();

  /** Returns <code>true</code> if a value for this attribute is written to database only once upon
   * row creation.  Subsequent updates always contain
   * the same initial value.  While primary keys are "write once" columns, oother columns such aa
   * creation date and creation user also qualify.
   * @return "write once" status of the attrbute.
   */
  public boolean isWriteOnce();

  /** Sets the "write once" status of the attribute.
   * @param writeOnce write once status.
   * @see #isWriteOnce()
   */
  public void setWriteOnce(boolean writeOnce);

  /** Updates a <code>PersistentObjectDynaProperty</code> with values from the column specification.
   * @param prop <code>PersistentObjectDynaProperty</code> instance.
   */
  public void updatePersistentObjectDynaProperty(net.sf.jrf.domain.PersistentObjectDynaProperty prop);

  /**
   * Returns the column index for use in <code>java.sql.ResultSet.get()</code> methods.
   *
   * @return   index offset, starting at <code>1</code> of this column in an SQL select statement.
   */
  public int getColumnIdx();

  /**
   * Sets column index for use in <code>java.sql.ResultSet.get()</code> methods.
   *
   * @param columnIdx  The new columnIdx value
   */
  public void setColumnIdx(int columnIdx);

  /**
   * Returns the name of the get method for this attribute.
   *
   * @return   the name of the get method for this attribute.
   */
  public String getGetter();

  /**
   * Returns the name of the set method for this attribute.
   *
   * @return   the name of the set method for this attribute.
   */
  public String getSetter();

  /**
   * Returns <code>true</code> if this column is required in the database.
   *
   * @return   <code>true</code> if this column is required in the database.
   */
  public boolean isRequired();

  /**
   * Returns <code>true</code> if this column is a sequenced primary key.
   *
   * @return   <code>true</code> if this column is a sequenced primary key.
   */
  public boolean isSequencedPrimaryKey();

  /**
   * Returns <code>true</code> if this column is a natural primary key.
   *
   * @return   <code>true</code> if this column is a natural primary key.
   */
  public boolean isNaturalPrimaryKey();

  /**
   * Returns <code>true</code> if this column is a primary key.
   *
   * @return   <code>true</code> if this column is a primary key.
   */
  public boolean isPrimaryKey();

  /**
   * Returns <code>true</code> if this column is unique.
   *
   * @return   <code>true</code> if this column is unique.
   */
  public boolean isUnique();

  /**
   * Returns <code>true</code> if this column a subtype identifier.
   *
   * @return   <code>true</code> if this column a subtype identifier.
   */
  public boolean isSubtypeIdentifier();

  /**
   * Returns the column default value or <code>null</code> if none.
   *
   * @return   the column default value or <code>null</code> if none.
   */
  public Object getDefault();

  /**
   * Returns <code>true</code> if this column is an optimistic lock column.
   ***
   *
   * @return   <code>true</code> if this column is an optimistic lock column.
   */
  public boolean isOptimisticLock();


  /**
   * Returns the implementation of <code>GetterSetter</code>.
   *
   * @return   columns specification's <code>GetterSetter</code> implementation.
   * @see      net.sf.jrf.column.GetterSetter
   */
  public GetterSetter getGetterSetterImpl();

  /**
   * Sets the implementation of <code>GetterSetter</code>.
   *
   * @param getterSetterImpl  <code>GetterSetter</code> implementation.
   * @see                     net.sf.jrf.column.GetterSetter
   */
  public void setGetterSetterImpl(GetterSetter getterSetterImpl);

  /**
   * Returns the requisite value for SQL inserts. By default,
   * <code>getSqlValueFrom()</code> is called.  However,
   * the <code>CompoundPrimaryKeyColumnSpec</code> will need
   * to override this method.
   *
   * @param aPO       persistent object.
   * @param dbPolicy  appropriate database policy implementation to use.
   * @return          string value for insert in the column.
   * @see             net.sf.jrf.sqlbuilder.InsertSQLBuilder#buildSQL(PersistentObject,JDBCHelper,String,List)
   */
  public String getInsertSqlValueFrom(PersistentObject aPO,
                                      DatabasePolicy dbPolicy);

  /**
   * Returns <code>true</code> if this is an implicit primary key insert column.
   *
   * @param dbPolicy  appropriate database policy implementation to use.
   * @return          <code>true</code> if this is an implicit primary key insert column.
   */
  public boolean isImplicitInsertColumn(DatabasePolicy dbPolicy);

  /**
   * Returns the insert column name to use in <code>InsertSQLBuilder</code>.
   * <code>CompoundPrimaryKeyColumnSpec</code> will need to override this method
   * to support implicit primary key columns.
   *
   * @return   column name to use for SQL inserts.
   * @see      net.sf.jrf.sqlbuilder.InsertSQLBuilder#buildPreparedSQL(String,List)
   * @see      net.sf.jrf.sqlbuilder.InsertSQLBuilder#buildSQL(PersistentObject,JDBCHelper,String,List)
   */
  public String getInsertColumnName();


  /**
   * Returns the primary key column specification for the sub type table.
   *
   * @return                                primary key column specification for the subtype table.
   * @exception CloneNotSupportedException  Description of the Exception
   */
  public ColumnSpec getSubTypePrimaryKeyColumnSpec()
          throws CloneNotSupportedException;

  /**
   * Sets the prepared column value specific to the column class type.
   *
   * @param stmt              <code>JRFPreparedStatement</code> instance.
   * @param value             value to set.
   * @param position          position in SQL prepared statement to set.
   * @exception SQLException  Description of the Exception
   */
  public void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
          throws SQLException;

  /**
   * Sets the column option to required.
   *
   * @param b  option value to set.
   * CompoundPrimaryKeyColumnSpec uses this to force it's children to
   * "REQUIRED".
   */
  public void setRequired(boolean b);


  /**
   * Returns the column definition string appropriate for both the
   * column specification and the database vendor suitable for "CREATE TABLE" statements.
   *
   * @param dbPolicy  appropriate database policy instance.
   * @return          syntactically correct column declaration that will work in a "CREATE TABLE"
   *   statement for a particular database vendor.
   */
  public String columnDefinitionString(DatabasePolicy dbPolicy);

  /**
   * Returns value string to use a prepared statement for the particular column.
   *
   * @param isInsert      if <code>true</code> value is for insert statements.
   * @param dbPolicy      Database policy instance to use.
   * @param sequenceName  sequence name.
   * @param tableName     table name.
   * @return              The preparedSqlValueString value
   */
  public String getPreparedSqlValueString(boolean isInsert, DatabasePolicy dbPolicy, String sequenceName, String tableName);

  /**
   * Returns the name-value pair required for a prepared statement.
   *
   * @param tableName  Description of the Parameter
   * @return           generally, 'TABLENAME.COLUMNNAME=?'
   */
  public String buildPreparedWhereClause(String tableName);

}// ColumnSpec
