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
 * Contributor: Darren Senel (dsenel@pscu.net)
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

import net.sf.jrf.column.*;
import net.sf.jrf.column.columnoptions.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.gettersetters.*;
import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.*;
import net.sf.jrf.join.*;

import java.util.List;
import java.util.ArrayList;
import java.lang.reflect.Method;

import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.StringTokenizer;

import org.apache.log4j.Category;

import java.sql.Types;
import java.sql.PreparedStatement;

/***
 ************************************************************************
 *                JE Changes to this file:
 ************************************************************************
 *	1.	Added concept of interface implementations of getters and setters for
 *	     column values to replace reflection.  Reflection is
 *	     used by default.  A new interface called GetterSetter was added
 *		as well as a default implementation called GetterSetterDefaultImpl.
 *		The calls to the static methods that use reflection in this class
 *		have been moved to GetterSetterDefaultImpl.java.
 *
 *		Details:
 *
 *		A.	Added protected "GetterSetter" variable.
 *		B.	In the main contructor, set the value of "A" to
 *			the default implementation, which uses reflection.
 *		C.	Added new constructor to support the "GetterSetter".
 *		D.	decodeToPersistenObject() no longer calls the
 *			static method that uses reflection (This call is
 *			now in GetterSetterDefaultImpl.java).
 *		E.   encodeFromPersistentObject() now calls
 *			getValueFrom(PersistentObject)
 *		F.	copyColumnValueToPersistentObject() no longer
 *			uses test for "i_setter == || "i_setter.length() != 0"
 *			to test for a setter, but rather uses the
 *			GetterSetterImpl.isSetterFunctional() method.
 *			(see GetterSetterDefaultImpl.java).
 *		G.	copyAttribute() follows copyColumnValueToPersistenObject()'s
 *			lead.
 *		H.	getValueFrom() now uses the GetterSetter implementation
 *	 		of "get".
 *		I.	setValueTo() now uses the GetterSetter implmentation of
 *			"set".
 *		J.	Get and set methods added for the GetterSetter implementation.
 *
 *	2.	To support Sybase and other implicit auto-sequence column supporting
 *		database vendor, added methods to determine if column is
 *	     an implicit primary key column (e.g. Sybase IDENTITY).
 *		Details:
 *
 *		A. 	Added getInsertSqlValueFrom()
 *		C.	Added isImplicitInsertColumn()
 *		D.   Added getInsertColumnName()
 *	3.	Class implements cloneable.
 */

/**
 *
 *  Subclass instances of this abstract class represent columns in the table
 *  represented by the domain class.
 *
 *  This abstract class is subclassed for different java data types (like
 *  Integer, String, Boolean, Timestamp, etc).  Adding another data type is
 *  as simple as subclassing, reimplementing the constructors, and
 *  implementing the formatForSql(anObject,aDatabasePolicy),
 *  getColumnClass(), and getColumnValueFrom(JRFResultSet) methods.<p>
 *
 *  <b>Options that can go together..</b><br />
 *
 *  <ol>
 *  <li>The PRIMARY_KEY options should be used by themselves.
 *  <li>The OPTIMISTIC_LOCK option should be used by itself on a
 *      TimestampColumnSpec or IntegerColumnSpec only.
 *  <li>The REQUIRED and UNIQUE options can be used together or separately.
 *  </ol>
 *
 *  <p><b>Examples:</b><p>
 *
 *  For an Integer sequenced primary key use something like this: (REQUIRED
 *  and UNIQUE are ignored when SEQUENCED_PRIMARY_KEY is present so don't
 *  use them)<br />
 *
 *  <code><pre>
 *        new IntegerColumnSpec(
 *             "PersonId",
 *             "getPersonId",
 *             "setPersonId",
 *             DEFAULT_TO_NULL,
 *             SEQUENCED_PRIMARY_KEY);
 *  </pre></code>
 *
 *  For a String natural primary key use something like this: (As opposed
 *  to SEQUENCED_PRIMARY_KEY, the REQUIRED and UNIQUE options are implied
 *  when NATURAL_PRIMARY_KEY is present so you don't need to specify them)<br />
 *
 *  <code><pre>
 *        new StringColumnSpec(
 *             "PersonCode",
 *             "getPersonCode",
 *             "setPersonCode",
 *             DEFAULT_TO_NULL,
 *             NATURAL_PRIMARY_KEY);
 *  </pre></code>
 *
 *  For a String attribute that is required and unique use something like
 *  this:<br />
 *
 *  <code><pre>
 *        new StringColumnSpec(
 *              "Name",
 *              "getName",
 *              "setName",
 *              DEFAULT_TO_NULL,
 *              REQUIRED,
 *              UNIQUE);
 *  </pre></code>
 *
 *  For an attribute that has a non-null default, use something like
 *  this:<br />
 *
 *  <code><pre>
 *        new IntegerColumnSpec(
 *              "Age",
 *              "getAge",
 *              "setAge",
 *              DEFAULT_TO_ZERO);
 *  </pre></code>
 *
 *  or any Integer:<br />
 *
 *  <code><pre>
 *        new IntegerColumnSpec(
 *              "Age",
 *              "getAge",
 *              "setAge",
 *              new Integer(99));
 *  </pre></code>
 *
 *  For a Timestamp that is used as an optimistic lock, use something like
 *  this: (REQUIRED and UNIQUE are ignored when OPTIMISTIC_LOCK is present
 *  so don't use them)<br />
 *
 *  <code><pre>
 *        new TimestampColumnSpec(
 *              "UpdatedOn",
 *              "getUpdatedOn",
 *              "setUpdatedOn",
 *              DEFAULT_TO_NOW,
 *              OPTIMISTIC_LOCK);
 *  </pre></code>
 *
 * Here is an example of an AbstractDomain#buildColumnSpecs() method
 * for a table with a compound primary key.  ColumnSpecs in a compound
 * primary key do not need any options (REQUIRED or UNIQUE) specified.
 *
 * <code><pre>
 * public List buildColumnSpecs()
 *     {
 *     List returnValue = new ArrayList();
 *     returnValue.add(
 *         new CompoundPrimaryKeyColumnSpec(
 *             new IntegerColumnSpec(
 *                 "Id",
 *                  "getId",
 *                 "setId",
 *                 DEFAULT_TO_NULL),
 *             new StringColumnSpec(
 *                 "Code",
 *                 "getCode",
 *                 "setCode",
 *                 DEFAULT_TO_NULL)));
 *     returnValue.add(
 *         new StringColumnSpec(
 *             "Name",
 *             "getName",
 *             "setName",
 *             DEFAULT_TO_NULL,
 *             REQUIRED,
 *             UNIQUE));
 *     return returnValue;
 *     }
 *  </pre></code>
 */
public abstract class AbstractColumnSpec
        implements ColumnSpec, Cloneable {

  /* ===============  Static Final Variables  =============== */
  private static final Category LOG =
          Category.getInstance(AbstractColumnSpec.class.getName());

  // Use these in arguements to buildNameValuePair()
  protected static final String EQUALS = "=";
  protected static final String NOT_EQUALS = "<>";

  /* ===============  Instance Variables  =============== */

  protected String i_propertyName;
  protected String i_columnName;
  protected int i_columnIdx;
  protected String i_getter;
  protected String i_setter;
  protected Object i_default = null;
  // To be removed --
  protected boolean i_required = false;
  protected boolean i_sequencedPrimaryKey = false;
  protected boolean i_naturalPrimaryKey = false;
  protected boolean i_unique = false;
  protected boolean i_subtypeIdentifier = false;
  protected boolean i_optimisticLock = false;
  protected boolean i_writeOnce = false;

  protected Comparable maxValue = null;	// Maximum allowable value.
  protected Comparable minValue = null;	// Minimum allowable value.
  protected List listOfValues = null;	// Acceptable list of values.

  protected GetterSetter i_getterSetterImpl = null;
  protected ColumnOption i_columnOption;	// To be used later.

  /* ===============  Constructors  =============== */

  /** Default constructor **/
  public AbstractColumnSpec() {
    this.i_columnOption = new NullableColumnOption();
  }

  /** Constructs a column specification with column options assuming
   * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
   * @param columnName column name.
   * @param columnOption column options to use.
   * @param getter method name of getter value.
   * @param setter method name of setter value.
   * @param defaultValue value to use for default if column value is null.
   */
  public AbstractColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
                            Object defaultValue) {
    i_columnName = columnName;
    this.i_columnOption = columnOption;
    setColumnOptions(columnOption);	// Backward compatible.
    this.i_getter = getter;
    this.i_setter = setter;
    this.i_default = defaultValue;
    this.i_getterSetterImpl = new GetterSetterDefaultImpl(this.getColumnClass(), getter, setter);
  }

  /** Constructs a column specification with column options and a <code>GetterSetter</code> instance.
   * @param columnName column name.
   * @param columnOption column options to use.
   * @param getterSetterImpl implementation of GetterSetter.
   * @param defaultValue value to use for default if column value is null.
   */
  public AbstractColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue) {
    i_columnName = columnName;
    this.i_columnOption = columnOption;
    setColumnOptions(columnOption);	// Backward compatible.
    this.i_default = defaultValue;
    this.i_getterSetterImpl = getterSetter;
  }

  private void setColumnOptions(ColumnOption columnOption) {
    i_required = columnOption.isRequired();
    i_sequencedPrimaryKey = columnOption.isSequencedPrimaryKey();
    i_naturalPrimaryKey = columnOption.isNaturalPrimaryKey();
    i_unique = columnOption.isUnique();
    i_subtypeIdentifier = columnOption.isSubtypeIdentifier();
    i_optimisticLock = columnOption.isOptimisticLock();
    if (isPrimaryKey())
      i_writeOnce = true;
  }

  /** Constructs an <code>X</code> with three option values.
   * @param columnName name of the column
   * @param getter name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue default value when the return value from the "getter" is null.
   * @param option1  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated Use <code>ColumnOption</code> constructors as an alternative.
   */
  public AbstractColumnSpec(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    int option = 0;

    i_columnName = columnName;
    i_getter = getter;
    i_setter = setter;
    i_default = defaultValue;
    i_getterSetterImpl = new GetterSetterDefaultImpl(this.getColumnClass(), getter, setter); // Old default methodology.

    for (int i = 1; i <= 3; i++) {
      switch (i) {
        case 1:
          option = option1;
          break;
        case 2:
          option = option2;
          break;
        case 3:
          option = option3;
          break;
      }
      if (!i_sequencedPrimaryKey &&
              !i_naturalPrimaryKey &&
              !i_optimisticLock) {
        switch (option) {
          case ColumnSpec.SEQUENCED_PRIMARY_KEY:
            i_sequencedPrimaryKey = true;
            i_required = false;
            i_unique = false;
            i_optimisticLock = false;
            break;
          case ColumnSpec.NATURAL_PRIMARY_KEY:
            i_naturalPrimaryKey = true;
            i_required = true;
            i_unique = true;
            i_optimisticLock = false;
            break;
          case ColumnSpec.OPTIMISTIC_LOCK:
            i_optimisticLock = true;
            i_required = false;
            i_unique = false;
            break;
          case ColumnSpec.SUBTYPE_IDENTIFIER:
            i_subtypeIdentifier = true;
            break;
          case ColumnSpec.REQUIRED:
            i_required = true;
            break;
          case ColumnSpec.UNIQUE:
            i_unique = true;
            break;
        }
      } // if not primary key or optimistic lock
    } // for

    if (this.isOptimisticLock() &&
            i_default == null) {
      i_default = this.optimisticLockDefaultValue();
    }
  }

  /** Constructs an <code>AbstractColumnSpec</code> with no option values supplied.
   * @param columnName name of the column
   * @param getter name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue default value when the return value from the "getter" is null.
   * @deprecated Use <code>ColumnOption</code> constructors as an alternative.
   */
  public AbstractColumnSpec(
          String columnName,
          String getter,
          String setter,
          Object defaultValue) {
    this(columnName,
            getter,
            setter,
            defaultValue,
            0,
            0,
            0);
  }

  /** Constructs an <code>AbstractColumnSpec</code> with one option value.
   * @param columnName name of the column
   * @param getter name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue default value when the return value from the "getter" is null.
   * @param option1  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated Use <code>ColumnOption</code> constructors as an alternative.
   */
  public AbstractColumnSpec(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1) {
    this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            0,
            0);
  }

  /** Constructs an <code>AbstractColumnSpec</code> with two option values.
   * @param columnName name of the column
   * @param getter name of the method to get the column data from the <code>PersistentObject</code>
   * @param setter name of the method to set column data in the <code>PersistentObject</code>.
   * @param defaultValue default value when the return value from the "getter" is null.
   * @param option1  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated Use <code>ColumnOption</code> constructors as an alternative.
   */
  public AbstractColumnSpec(
          String columnName,
          String getter,
          String setter,
          Object defaultValue,
          int option1,
          int option2) {
    this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            option2,
            0);
  }

  /** Constructs an <code>X</code> with three option values and a <code>GetterSetter</code> implementation.
   * @param columnName name of the column
   * @param getterSetterImpl an implementation of <code>GetterSetter</code>.
   * @param defaultValue default value when the return value from the "getter" is null.
   * @param option1  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option2  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @param option3  One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
   * @deprecated Use <code>ColumnOption</code> constructors as an alternative.
   */
  public AbstractColumnSpec(
          String columnName,
          GetterSetter getterSetterImpl,
          Object defaultValue,
          int option1,
          int option2,
          int option3) {
    this(columnName, null, null, defaultValue, option1, option2, option3);
    this.i_getterSetterImpl = getterSetterImpl; // Override reflection.

  }

  /** Returns the primary key column specification for subtype table assuming that
   * this column specification represents the super-class primary key.  If the
   * super class primary key is auto-sequenced, the subtype table key must be
   * natural.
   * @return primary key column specification for subtype tables.
   */
  public ColumnSpec getSubTypePrimaryKeyColumnSpec() throws CloneNotSupportedException {
    if (!this.isPrimaryKey()) {
      throw new RuntimeException(this + ": getSubTypePrimaryKeyColumnSpec() should only be called in primary keys.");
    }
    AbstractColumnSpec other = (AbstractColumnSpec) this.clone();
    if (other.i_sequencedPrimaryKey) {
      other.i_sequencedPrimaryKey = false;
      other.i_naturalPrimaryKey = true;
      other.i_required = true;
    }
    return other;
  }

  /* ===============  Abstract Method Definitions  =============== */

  /**
   * Returns a string representing the given attribute value. The string
   * will be used in an SQL expression.
   *
   * @param obj a value of type 'Object'
   * @return a value of type 'String'
   */
  public abstract String formatForSql(Object obj,
                                      DatabasePolicy dbPolicy);


  /**
   * See IntegerColumnSpec for example of how to implement:
   */
  public abstract Class getColumnClass();


  /**
   * See IntegerColumnSpec for example of how to implement:
   */
  public abstract Object getColumnValueFrom(JRFResultSet r)
          throws SQLException;

  /**
   * See IntegerColumnSpec for example of how to implement:
   */
  protected abstract Object decode(String aString);

  /**
   * Return the type of column to be used in a CREATE TABLE or ALTER TABLE
   * statement.
   *
   * @param dbPolicy a value of type 'DatabasePolicy'
   * @return a value of type 'String'
   */
  public abstract String getSQLColumnType(DatabasePolicy dbPolicy);

  /** @see net.sf.jrf.column.ColumnSpec#setPreparedColumnValueTo(JRFPreparedStatement,Object,int) */
  public abstract void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
          throws SQLException;

  /* ==========  Static Methods  ========== */

  /**
   * Sets the attribute value of a given persistent object using reflection.
   * This is static so it can be used by the JoinColumn subclasses.
   *
   * @param aValue a value of type 'Object'
   * @param aPO a value of type 'PersistentObject'
   * @param setter a value of type 'String'
   * @param valueClass a value of type 'Class'
   */
  public static void setValueTo(Object aValue,
                                PersistentObject aPO,
                                String setter,
                                Class valueClass) {
    Method setMethod = null;

    // Create the parameter list array
    try {
      Class[] parms = new Class[]
      {valueClass};
      // Create the args object
      Object args[] = new Object[]
      {aValue};
      Class poClass = aPO.getClass();
      setMethod = poClass.getMethod(setter, parms);
      setMethod.invoke(aPO, args);
    } catch (Exception e) {
      LOG.error(
              "Reflection Error: " + e
              + " in net.sf.jrf.AbstractColumnSpec.setValueTo(...)"
              + "\nObject: " + aPO
              + " setter: " + setter
              + " arg class: " + valueClass
              + " arg value: " + aValue,
              e);
      throw new ConfigurationException(e.fillInStackTrace().toString());
    }
  } // setValueTo(value, aPO, setter, valueClass)


  /**
   * Get the value of this attribute from aPO.  If the value is null, the
   * default will be returned.  This could be done in the persistent object
   * when the variable is initialized, but the developer might forget to do
   * that.  More importantly, an attribute read from the database might be
   * null which would override the variable initialization.  When the save is
   * executed, this assures that the new default value will be put into the
   * database.
   *
   * <p>Note: The getter can be of the form: "getCustomer.getId"
   *
   * @param aPO a value of type 'PersistentObject'
   * @param getter a value of type 'String' - can be of the form:
   *               "getCustomer.getId"
   * @param defaultValue a value of type 'Object'
   * @return a value of type 'Object'
   */
  public static Object getValueFrom(PersistentObject aPO,
                                    String getter,
                                    Object defaultValue) {
    Object result = null;
    try {
      result = KeyPathHelper.getValueForKeyPath(aPO, getter);
    } catch (KeyPathHelper.KeyPathException e) {
      LOG.error(
              "Reflection Error: " + e.getOriginalException()
              + " in net.sf.jrf.AbstractColumnSpec.getValueFrom(...)"
              + "\nObject: " + aPO
              + " getter: " + getter,
              e);
      throw new DatabaseException(e);
    }

    // Set the default (which may be null) if result is null.
    if (result == null) {
      if (defaultValue != null) {
        LOG.debug(
                "AbstractColumnSpec.getValueFrom(...) returning default "
                + " value of " + defaultValue
                + " for getter " + getter);
      }
      result = defaultValue;
    }

    return result;
  } // getValueFrom(...)


  /**
   * If Column is declared UNIQUE, make sure it doesn't already exist in the
   * table.  This is static so that the CompoundPrimaryKeyColumnSpec can use
   * it too.
   *
   * @param aPO a value of type 'PersistentObject'
   * @param stmtExecuter a value of type 'StatementExecuter'
   * @param pkColumnSpec a value of type 'ColumnSpec'
   * @exception DuplicateRowException if a row with this value already exists.
   */
  public static void validateUnique(PersistentObject aPO,
                                    StatementExecuter stmtExecuter,
                                    ColumnSpec pkColumnSpec,
                                    ColumnSpec attrColumnSpec,
                                    DatabasePolicy dbPolicy,
                                    String tableName)
          throws DuplicateRowException {
    if (!attrColumnSpec.isUnique()) {
      return;
    }
    if (attrColumnSpec.isNaturalPrimaryKey() &&
            !aPO.hasNewPersistentState()) {
      // No need to check natural primary keys that are already
      // inserted even though they are automatically marked UNIQUE.
      return;
    }
    // Make sure this value won't create a duplicate row
    StringBuffer buffer = new StringBuffer();
    buffer
            .append("SELECT count(*) FROM ")
            .append(tableName).append(" ")
            .append("WHERE ")
            .append(attrColumnSpec.buildWhereClause(aPO,
                    EQUALS,
                    tableName,
                    dbPolicy));
    // If this PersistentObject is already in the database, make sure we
    // don't get a match on itself.
    if (!aPO.hasNewPersistentState()) {
      buffer
              .append(" AND ")
              .append(
                      pkColumnSpec.buildWhereClause(
                              aPO,
                              NOT_EQUALS,
                              tableName,
                              dbPolicy));
    }

    int count = 0;
    try {
      count = stmtExecuter.getSingleRowColAsIntValue(buffer.toString());
    } catch (Exception e) {
      throw new DatabaseException(e);
    }
    if (count > 0) {
      throw new DuplicateRowException(
              "Attempt to insert a duplicate value for attribute - "
              + attrColumnSpec.getColumnName());
    }
  } // validateUnique(aPO, statementExecuter, pkColumnSpec, dbPolicy)



  /* ===============  Public Instance Methods  =============== */




  /**
   * "Encode" the given object into a string representation that can be
   * decoded later.  This implementation is pretty basic.  This method will
   * *not* be used for generating SQL.
   *
   * @param obj a value of type 'Object'
   * @return a value of type 'String'
   */
  public String encode(Object obj) {
    return (obj == null ? "null" : obj.toString());
  }


  /**
   * This method is similar in concept to the
   * copyColumnValueToPersistentObject(...)  method, but gets it's value
   * from a String instead of a <code>StatmentExecuter</code>.
   *
   * The String parameter must have been encoded with the
   * encodeFromPersistentObject() method.
   *
   * @see AbstractColumnSpec#encodeFromPersistentObject
   * @param aString a value of type 'String'
   * @param aPO a value of type 'PersistentObject'
   */
  public void decodeToPersistentObject(String aString,
                                       PersistentObject aPO) {
    Object obj = this.decode(aString);
    this.setValueTo(obj, aPO);


    /*  (see setValueTo())
    AbstractColumnSpec.setValueTo(obj,
                                  aPO,
                                  i_setter,
                                  this.getColumnClass());
    */

  }


  /**
   * Convert the attribute for this object to a String that can be
   * unconverted later by the decodeToPersistentObject(...) method.  The
   * results of this method are not to be used in SQL.
   *
   * @see AbstractColumnSpec#decodeToPersistentObject
   * @param aPO a value of type 'PersistentObject'
   * @return a value of type 'String'
   */
  public String encodeFromPersistentObject(PersistentObject aPO) {
    //
    Object obj = getValueFrom(aPO);
    return this.encode(obj);
  }


  /**
   * Copy the value of my column to the appropriate attribute for this
   * persistent object.
   *
   * @param jrfResultSet a value of type 'JRFResultSet'
   * @param aPO a value of type 'PersistentObject'
   * @exception SQLException if an error occurs
   */
  public void copyColumnValueToPersistentObject(JRFResultSet jrfResultSet,
                                                PersistentObject aPO)
          throws SQLException {
    //
    if (!i_getterSetterImpl.setterIsFunctional()) {
      LOG.debug(i_getterSetterImpl + ": copyColumnValueToPersistentObject(" + this.getColumnName() +
              ") : setter is not functional - skipping.");
      return;
    }
    Object columnValue = this.getColumnValueFrom(jrfResultSet);
    if (LOG.isDebugEnabled()) {
      LOG.debug("copyColumnValueToPersistentObject(): [" + columnValue + "] for column [" + this.getColumnName() + "]");
    }
    if (columnValue == null) {
      columnValue = this.getDefault();
    }
    this.setValueTo(columnValue, aPO);
  }


  /**
   * Copy the attribute I represent from one persistent object to another.
   *
   * @param aPO1 a value of type 'PersistentObject'
   * @param aPO2 a value of type 'PersistentObject'
   */
  public void copyAttribute(PersistentObject aPO1,
                            PersistentObject aPO2) {
    //
    if (!i_getterSetterImpl.setterIsFunctional())
      return;
    Object value = this.getValueFrom(aPO1);
    this.setValueTo(value, aPO2);
  }


  /**
   * Note: This method is overridden by CompoundPrimaryKeyColumnSpec to
   * include " AND " between each name-value pair.
   *
   * @param pkOrPersistentObject a value of type 'Object'
   * @param dbPolicy a value of type 'DatabasePolicy'
   * @return a value of type 'String'
   */
  public String buildWhereClause(Object pkOrPersistentObject,
                                 String separator,
                                 String tableAlias,
                                 DatabasePolicy dbPolicy) {
    return this.buildNameValuePair(pkOrPersistentObject,
            separator,
            tableAlias,
            dbPolicy);
  }


  public String buildPreparedWhereClause(String tableAlias) {
    return this.getFullyQualifiedColumnName(tableAlias) + ColumnSpec.EQUALS + "?";
  }

  /**
   * This method is used to build an equals (or not-equals) String for WHERE
   * clauses and UPDATE statements.
   *
   * @param pkOrPersistentObject a value of type 'Object'
   * @param separator a value of type 'String' - use EQUALS or NOT_EQUALS
   *        static final variables.
   * @param tableName a value of type 'String'
   * @param dbPolicy a value of type 'DatabasePolicy'
   * @return a value of type 'String'
   */
  public String buildNameValuePair(Object pkOrPersistentObject,
                                   String separator,
                                   String tableAlias,
                                   DatabasePolicy dbPolicy) {
    StringBuffer buffer =
            new StringBuffer();
    String value = null;
    buffer.append(this.getFullyQualifiedColumnName(tableAlias));
    if (pkOrPersistentObject instanceof PersistentObject) {
      value =
              this.getSqlValueFrom(
                      (PersistentObject) pkOrPersistentObject,
                      dbPolicy);
    } else {
      value = this.formatForSql(pkOrPersistentObject, dbPolicy);
    }
    if (value.equalsIgnoreCase("null")) {
      buffer.append(separator.equals(EQUALS) ? " IS " : " IS NOT ");
    } else {
      buffer.append(separator);
    }
    buffer.append(value);
    return buffer.toString();
  } // buildNameValuePair(...)


  /**
   * Makes sure the PersistentObject object has this attribute (if required).
   *
   * @param aPO a value of type 'PersistentObject'
   * @return a value of type 'Object' - This is the value of the attribute.
   *         This is so subclasses can call super.validateRequired().
   * @exception MissingAttributeException if attribute should be populated
   *            and it is not.
   */
  public Object validateRequired(PersistentObject aPO)
          throws MissingAttributeException {
    if (!this.isRequired()) {
      return null; // since this attribute is not required.
    }
    Object attr = this.getValueFrom(aPO);
    // Ensure aColumnSpec is not null
    if (attr == null) {
      if (i_sequencedPrimaryKey && aPO.hasNewPersistentState()) {
        // OK
        return null;
      }
      throw new MissingAttributeException(
              "Required attribute - "
              + this.getColumnName()
              + "- is a null value.");
    }
    return attr;
  } // validateRequired(aPO)


  /**
   * If this is a unique column (or columns), make sure the value doesn't
   * already exist.
   *
   * @param aPO a value of type 'PersistentObject'
   * @param stmtExecuter a value of type 'StatementExecuter'
   * @param pkColumnSpec a value of type 'ColumnSpec'
   * @param dbPolicy a value of type 'DatabasePolicy'
   * @param tableName a value of type 'String'
   * @exception DuplicateRowException if an error occurs
   */
  public void validateUnique(PersistentObject aPO,
                             StatementExecuter stmtExecuter,
                             ColumnSpec pkColumnSpec,
                             DatabasePolicy dbPolicy,
                             String tableName)
          throws DuplicateRowException {
    AbstractColumnSpec.validateUnique(aPO,
            stmtExecuter,
            pkColumnSpec,
            this,
            dbPolicy,
            tableName);
  }


  /**
   * Get a string representation of the value of this attribute from
   * aPO.  This string can be inserted into a SQL statement.
   *
   * @param aPO a value of type 'PersistentObject'
   * @return a value of type 'String'
   */
  public String getSqlValueFrom(PersistentObject aPO,
                                DatabasePolicy dbPolicy) {
    Object temp = this.getValueFrom(aPO);
    return this.formatForSql(temp, dbPolicy);
  } // getSqlValueFrom(...)


  /**
   * Get the value of this attribute from aPO.  If the value is
   * null, the default value will be returned.
   *
   * @param aPO a value of type 'PersistentObject'
   * @return a value of type 'Object'
   */
  public Object getValueFrom(PersistentObject aPO) {
    return i_getterSetterImpl.get(aPO, i_default);

  } // getValueFrom(...)


  /**
   * This is a pass-through method that passes along my setter and column
   * class.
   *
   * @param aValue a value of type 'Object'
   * @param aPO a value of type 'PersistentObject'
   */
  public void setValueTo(Object aValue,
                         PersistentObject aPO) {

    i_getterSetterImpl.set(aPO, aValue);
  }

  /**
   * Return something like: "Age INTEGER NOT NULL"
   *
   * @return a value of type 'String'
   */
  public String columnDefinitionString(DatabasePolicy dbPolicy) {
    StringBuffer buffer = new StringBuffer();
    buffer.append(getColumnName());
    buffer.append(" ");

    if (this.isPrimaryKey()) {
      if (i_sequencedPrimaryKey &&
              (dbPolicy.getSequenceSupportType() ==
              DatabasePolicy.SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT ||
              dbPolicy.getSequenceSupportType() ==
              DatabasePolicy.SEQUENCE_SUPPORT_AUTOINCREMENT_EXPLICIT)) {

        buffer.append(dbPolicy.getAutoIncrementNumericColumnType());
        buffer.append(" ");
        buffer.append(dbPolicy.autoIncrementIdentifier());
      } else {
        buffer.append(getSQLColumnType(dbPolicy));
        buffer.append(" ");
        buffer.append(dbPolicy.getPrimaryKeyQualifiers());
      }
    } else {
      buffer.append(getSQLColumnType(dbPolicy));
      if (this.isRequired()) {
        buffer.append(" NOT NULL");
      } else if (!this.isPrimaryKey()) {
        buffer.append(dbPolicy.getNullableColumnQualifier());
      }
    }
    return buffer.toString();
  }

  // BEGIN -  Additional methods added to support the implicit primary key
  // insert column.


  /** Returns the requisite value for SQL inserts. By default,
   * <code>getSqlValueFrom()</code> is called.
   * @param aPO persistent object.
   * @param dbPolicy appropriate database policy implementation to use.
   * @return string value for insert in the column.
   */
  public String getInsertSqlValueFrom(PersistentObject aPO,
                                      DatabasePolicy dbPolicy) {
    return getSqlValueFrom(aPO, dbPolicy);
  }

  /** Returns <code>true</code> if this is an implicit primary key insert column.
   * @param dbPolicy appropriate database policy implementation to use.
   * @return <code>true</code> if this is an implicit primary key insert column.
   */
  public final boolean isImplicitInsertColumn(DatabasePolicy dbPolicy) {
    if (i_sequencedPrimaryKey &&
            dbPolicy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT)
      return true;
    return false;
  }

  /** Returns the insert column name to use in <code>InsertSQLBuilder</code>.
   * <code>CompoundPrimaryKeyColumnSpec</code> will need to override this method
   * to support implicit primary key columns.
   * @return column name to use for SQL inserts.
   * @see net.sf.jrf.sqlbuilder.InsertSQLBuilder#buildPreparedSQL(String,List)
   */
  public String getInsertColumnName() {
    return getColumnName();
  }


  /// END methods to support implicit column spec.

  /* ===============  Getters =============== */

  public String getFullyQualifiedColumnName(String tableAlias) {
    if (tableAlias == null ||
            tableAlias.trim().length() == 0) {
      return getColumnName();
    } else {
      return tableAlias + "." + getColumnName();
    }
  }

  /** @see net.sf.jrf.column.ColumnSpec#setPropertyName(String) **/
  public void setPropertyName(String name) {
    this.i_propertyName = name;
  }

  /** @see net.sf.jrf.column.ColumnSpec#getPropertyName() **/
  public String getPropertyName() {
    if (i_propertyName == null) {
      String nameToHandle = i_columnName; // Default to column name
      // Try to figure out the property name.
      // Should be using standard bean formats; if not . . .
      if (i_setter != null && i_setter.startsWith("set") && i_setter.length() > 3) {
        nameToHandle = i_setter.substring(3);
      } else if (i_getter != null) {
        if (i_getter.startsWith("is") && i_getter.length() > 2)
          nameToHandle = i_getter.substring(2);
        else if (i_getter.startsWith("get") && i_getter.length() > 3)
          nameToHandle = i_getter.substring(2);
      }
      int i = 0;
      for (; i < nameToHandle.length(); i++) {
        if (Character.isLowerCase(nameToHandle.charAt(i)))
          break;
      }
      if (i == nameToHandle.length())
        i_propertyName = nameToHandle;
      else
        i_propertyName = Character.toLowerCase(nameToHandle.charAt(0)) + nameToHandle.substring(1);
    }
    return i_propertyName;
  }

  /**
   * @see net.sf.jrf.column.ColumnSpec#isWriteOnce()
   */
  public boolean isWriteOnce() {
    return this.i_writeOnce;
  }

  /**
   * @see net.sf.jrf.column.ColumnSpec#setWriteOnce(boolean)
   */
  public void setWriteOnce(boolean writeOnce) {
    if (!writeOnce && isPrimaryKey())
      return; // Ignore argument.
    this.i_writeOnce = writeOnce;
  }

  /** Updates a <code>PersistentObjectDynaProperty</code> with values from the column specification.
   * @param p <code>PersistentObjectDynaProperty</code> instance.
   */
  public void updatePersistentObjectDynaProperty(net.sf.jrf.domain.PersistentObjectDynaProperty p) {
    p.setRequired(i_required);
    p.setMaxValue(maxValue);
    p.setMinValue(minValue);
    p.setListOfValues(listOfValues);
    p.setDefaultValue(i_default);
    p.setDbColumn(true);
    p.setPrimaryKey(isPrimaryKey());
    p.setWriteOnce(i_writeOnce);
    p.setOptimisticLock(i_optimisticLock);
    p.setGetterSetter(i_getterSetterImpl);
  }

  /** @see net.sf.jrf.column.ColumnSpec#getColumnName() **/
  public String getColumnName() {
    return i_columnName;
  }

  /** Returns the column index for use in <code>java.sql.ResultSet.get()</code> methods.
   * @return index offset, starting at <code>1</code> of this column in an SQL select statement.
   */
  public int getColumnIdx() {
    return i_columnIdx;
  }

  public void setColumnIdx(int columnIdx) {
    this.i_columnIdx = columnIdx;
  }

  public String getGetter() {
    return i_getter;
  }

  public String getSetter() {
    return i_setter;
  }

  public boolean isRequired() {
    return i_required;
  }

  public boolean isSequencedPrimaryKey() {
    return i_sequencedPrimaryKey;
  }

  public boolean isNaturalPrimaryKey() {
    return i_naturalPrimaryKey;
  }

  public boolean isPrimaryKey() {
    return i_naturalPrimaryKey || i_sequencedPrimaryKey;
  }

  public boolean isUnique() {
    return i_unique;
  }

  public boolean isSubtypeIdentifier() {
    return i_subtypeIdentifier;
  }

  public Object getDefault() {
    return i_default;
  }

  public boolean isOptimisticLock() {
    return i_optimisticLock;
  }

  /**
   * CompoundPrimaryKeyColumnSpec uses this to force it's children to
   * "REQUIRED".
   */
  public void setRequired(boolean b) {
    i_required = b;
  }

  /** Returns the implementation of <code>GetterSetter</code>.
   * @return columns specification's <code>GetterSetter</code> implementation.
   * @see net.sf.jrf.column.GetterSetter
   */
  public GetterSetter getGetterSetterImpl() {
    return i_getterSetterImpl;
  }

  /** Sets the implementation of <code>GetterSetter</code>.
   * @param getterSetterImpl <code>GetterSetter</code> implementation.
   * @see net.sf.jrf.column.GetterSetter
   */
  public void setGetterSetterImpl(GetterSetter getterSetterImpl) {
    i_getterSetterImpl = getterSetterImpl;
  }

  /** @see net.sf.jrf.column.ColumnSpec#getPreparedSqlValueString(boolean,DatabasePolicy,String,String)  **/
  public String getPreparedSqlValueString(boolean isInsert, DatabasePolicy dbPolicy,
                                          String sequenceName, String tableName) {
    if (isInsert && i_sequencedPrimaryKey &&
            dbPolicy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL) {
      return dbPolicy.sequenceNextValSQL(sequenceName, tableName);
    }
    return "?";
  }

  /** Validates the column value againsts either a list of values, a specified
   * minimum or maximum value.  This implementation should do for most
   * sub-classes.
   * @param aPO <code>PersistentObject</code> instance to check.
   * @throws InvalidValueException if validation fails.
   * @see net.sf.jrf.exceptions.InvalidValueException
   */
  public Object validateValue(PersistentObject aPO) throws InvalidValueException {
    Object temp = this.getValueFrom(aPO);
    if (maxValue != null && maxValue.compareTo(temp) < 0)
      throw new InvalidValueException(InvalidValueException.TYPE_GREATER_THAN_MAXIMUM,
              maxValue, temp);
    if (minValue != null && minValue.compareTo(temp) > 0)
      throw new InvalidValueException(InvalidValueException.TYPE_LESS_THAN_MINIMUM,
              minValue, temp);
    if (listOfValues != null && !listOfValues.contains(temp))
      throw new InvalidValueException(listOfValues, temp);
    return temp;
  }


  /** Sets the maximum allowable value.
   * @param maxValue implementation of <code>Comparable</code>.
   */
  public void setMaxValue(Comparable maxValue) {
    this.maxValue = maxValue;
  }


  /** Sets the minimum allowable value.
   * @param minValue implementation of <code>Comparable</code>.
   */
  public void setMinValue(Comparable minValue) {
    this.minValue = minValue;
  }


  /** Sets the acceptable list of values for the column.
   * @param listOfValue acceptable list of values.
   */
  public void setListOfValues(List listOfValues) {
    this.listOfValues = listOfValues;
  }

  /**
   * Unless this is overridden, an exception will be thrown.
   * @return a value of type 'Object'
   */
  public Object optimisticLockDefaultValue() {
    throw new ConfigurationException(
            this.getClass().toString() + " cannot be an optimistic lock.");
  }

  /** @return a JoinColumn subclass instance with data from myself. */
  public abstract JoinColumn buildJoinColumn();

} // AbstractColumnSpec
