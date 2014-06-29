/*
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *
 *  http://www.mozilla.org/MPL
 *
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations under
 *  the License.
 *
 *  The Original Code is jRelationalFramework.
 *
 *  The Initial Developer of the Original Code is is.com.
 *  Portions created by is.com are Copyright (C) 2000 is.com.
 *  All Rights Reserved.
 *
 *  Contributor(s): Jonathan Carlson (joncrlsn@users.sf.net)
 *  Contributor(s): ____________________________________
 *
 *  Alternatively, the contents of this file may be used under the terms of
 *  the GNU General Public License (the "GPL") or the GNU Lesser General
 *  Public license (the "LGPL"), in which case the provisions of the GPL or
 *  LGPL are applicable instead of those above.  If you wish to allow use of
 *  your version of this file only under the terms of either the GPL or LGPL
 *  and not to allow others to use your version of this file under the MPL,
 *  indicate your decision by deleting the provisions above and replace them
 *  with the notice and other provisions required by either the GPL or LGPL
 *  License.  If you do not delete the provisions above, a recipient may use
 *  your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.column.columnspecs;

import net.sf.jrf.column.*;
import net.sf.jrf.*;
import net.sf.jrf.join.*;
import net.sf.jrf.sql.*;
import net.sf.jrf.DatabasePolicy;
import java.lang.reflect.Field;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.*;

import java.sql.SQLException;
import java.util.ArrayList;

import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.sql.PreparedStatement;
import java.io.StreamTokenizer;
import java.io.StringReader;
import java.io.IOException;
import org.apache.log4j.Category;
/*
 *  VMChanges
 *
 *  To support Sybase implicit insert identity column:
 *
 *  1.	Added private variable to denote implicit insert column.
 *  2.	Added two methods to set the implicit insert column. One method surveys the
 *  columns to find an implicit one.  Added an overload of addColumn() to include
 *  the requisite database policy needed to find the key.
 *  3.	Added implementation of isImplicitInsertColumn(DatabasePolicy dbPolicy) to always return false;
 *  4.	Added appropriate implementation of fetchAutoIncrementColumnAfterInsert().
 *  5.     Added default implementation of getInsertColumnName();
 *  Created a private method  getInsertColumnName(PersistentObject aPO, DatabasePolicy dbPolicy,boolean isInsert)
 *  Public methods call method with different values for isInsert field.
 *  getFullyQualifiedColumnName() changed to call the private method.
 *  6.	Added implementations of getMaxLength() and setMaxLength() that throw UnsupportedOperationException
 *  since these operations are not applicable.
 *  7.	To implement getInsertSqlValueFrom(PersistentObject aPO, DatabasePolicy dbPolicy):
 *  Created a private method  getInsertSqlValueFrom(PersistentObject aPO, DatabasePolicy dbPolicy,boolean isInsert)
 *  Public methods call method with different values for isInsert field.
 *  getSqlValueFrom() changed to call the private method.
 *  8.	setValueTo() changed to handle implicit key column.
 *  9.	Added getColumnSpecs().
 */
/**
 *  This implementer of ColumnSpec holds multiple AbstractColumnSpec subclass
 *  instances that make up the primary key for a table.
 *
 */
public class CompoundPrimaryKeyColumnSpec
         implements ColumnSpec, Cloneable {

    /*
     *  ===============  Static Variables  ===============
     */
    // Log4j static.
    final static Category LOG = Category.getInstance(CompoundPrimaryKeyColumnSpec.class.getName());

    /**
     *  Description of the Field
     */
    protected static Class s_class = null;

    private List i_columnSpecs = new ArrayList();

    //
    private ColumnSpec implicitInsertColumn = null;

    // Set to external sequence column, if exists.
    private ColumnSpec externalSequenceColumn = null;

    /*
     *  ===============  Constructors  ===============
     */
    /**
     *  Constructor for the CompoundPrimaryKeyColumnSpec object use the method
     *  addColumnSpec(...) in conjunction with this.
     */
    public CompoundPrimaryKeyColumnSpec() { }


    /**
     *  Constructor for the CompoundPrimaryKeyColumnSpec object
     *
     *@param  columnOne  a ColumnSpec
     *@param  columnTwo  a ColumnSpec
     */
    public CompoundPrimaryKeyColumnSpec(
            ColumnSpec columnOne,
            ColumnSpec columnTwo) {
        this.addColumnSpec(columnOne);
        this.addColumnSpec(columnTwo);
    }


    /**
     *  Constructor for the CompoundPrimaryKeyColumnSpec object
     *
     *@param  columnOne    a ColumnSpec
     *@param  columnTwo    a ColumnSpec
     *@param  columnThree  a ColumnSpec
     */
    public CompoundPrimaryKeyColumnSpec(
            ColumnSpec columnOne,
            ColumnSpec columnTwo,
            ColumnSpec columnThree) {
        this(columnOne, columnTwo);
        this.addColumnSpec(columnThree);
    }


    /**
     *  Constructor for the CompoundPrimaryKeyColumnSpec object
     *
     *@param  columnOne    a ColumnSpec
     *@param  columnTwo    a ColumnSpec
     *@param  columnThree  a ColumnSpec
     *@param  columnFour   a ColumnSpec
     */
    public CompoundPrimaryKeyColumnSpec(ColumnSpec columnOne, ColumnSpec columnTwo, ColumnSpec columnThree, ColumnSpec columnFour) {
        this(columnOne, columnTwo, columnThree);
        this.addColumnSpec(columnFour);
    }


    /**
     *  Constructor for the CompoundPrimaryKeyColumnSpec object
     *
     *@param  columnOne    a ColumnSpec
     *@param  columnTwo    a ColumnSpec
     *@param  columnThree  a ColumnSpec
     *@param  columnFour   a ColumnSpec
     *@param  columnFive   a ColumnSpec
     */
    public CompoundPrimaryKeyColumnSpec(ColumnSpec columnOne, ColumnSpec columnTwo, ColumnSpec columnThree, ColumnSpec columnFour, ColumnSpec columnFive) {
        this(columnOne, columnTwo, columnThree, columnFour);
        this.addColumnSpec(columnFive);
    }


    /**
     *  Constructor for the CompoundPrimaryKeyColumnSpec object
     *
     *@param  columnOne    a ColumnSpec
     *@param  columnTwo    a ColumnSpec
     *@param  columnThree  a ColumnSpec
     *@param  columnFour   a ColumnSpec
     *@param  columnFive   a ColumnSpec
     *@param  columnSix    a ColumnSpec
     */
    public CompoundPrimaryKeyColumnSpec(ColumnSpec columnOne, ColumnSpec columnTwo, ColumnSpec columnThree, ColumnSpec columnFour, ColumnSpec columnFive, ColumnSpec columnSix) {
        this(columnOne, columnTwo, columnThree, columnFour, columnFive);
        this.addColumnSpec(columnSix);
    }


    /**
     *  Adds a feature to the ColumnSpec attribute of the
     *  CompoundPrimaryKeyColumnSpec object
     *
     *@param  aColumnSpec  The feature to be added to the ColumnSpec attribute
     */
    public void addColumnSpec(ColumnSpec aColumnSpec) {
        aColumnSpec.setRequired(true);
        i_columnSpecs.add(aColumnSpec);
    }


    /**
     *  Traverses list of columns to determine if an implicit column exists or
     *  external sequence column.
     *
     * (called from <code>AbstractDomain.initConnectionEnvironment()</code>).
     *@param  policy  Database policy implementation.
     */
    public void resolveSequenceColumns(DatabasePolicy policy) {
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            ColumnSpec spec = (ColumnSpec) iterator.next();
            if (spec.isImplicitInsertColumn(policy)) {
                if (implicitInsertColumn != null) {
                         throw new ConfigurationException(
                                this.getClass().toString() +
                                ": there can only be one implicit sequenced column in a compound primary key; "+
                                " already have column "+ implicitInsertColumn.getColumnName());
                }
                implicitInsertColumn = spec;
            }
            else if (spec.isSequencedPrimaryKey() &&
                policy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL) {
                if (externalSequenceColumn != null) {
                        throw new ConfigurationException(
                        this.getClass().toString() +
                        ": there can only be one external sequenced column in a compound primary key; already have column "
                        + externalSequenceColumn.getColumnName());
                }
                externalSequenceColumn = spec;
            }
        }
    }


    /**
     *  Adds a column spec and handles implicit key columns in addition. This
     *  method should be used alternatively to <code>addColumnSpec()</code> for
     *  compound keys with implicit columns.
     *
     *@param  aColumnSpec  column specification.
     *@param  policy       Database policy implementation.
     *@deprecated          no longer supported.
     */
    public void addColumnSpec(ColumnSpec aColumnSpec, DatabasePolicy policy) {
        addColumnSpec(aColumnSpec);
        if (aColumnSpec.isImplicitInsertColumn(policy)) {
            if (implicitInsertColumn != null) {
                throw new ConfigurationException(
                        this.getClass().toString() +
                        ": there can only be one implicit sequenced column in a compound primary key; already have column "
                        + implicitInsertColumn.getColumnName());
            }
            implicitInsertColumn = aColumnSpec;
        }
    }


    // End VM Change 2

    // VM Change -- handle primary key woes for super-tables.
    /**
     *  Gets the subTypePrimaryKeyColumnSpec attribute of the
     *  CompoundPrimaryKeyColumnSpec object
     *
     *@return                                 The subTypePrimaryKeyColumnSpec
     *      value
     *@exception  CloneNotSupportedException  Description of the Exception
     */
    public ColumnSpec getSubTypePrimaryKeyColumnSpec() throws CloneNotSupportedException {
        CompoundPrimaryKeyColumnSpec other = (CompoundPrimaryKeyColumnSpec) this.clone();
        if (other.implicitInsertColumn != null) {
            other.implicitInsertColumn = null;
        }
        return other;
    }


    /**
     *  Ask each of my ColumnSpec instances to get the appropriate column from
     *  the jrfResultSet and stick it into the PersistentObject.
     *
     *@param  jrfResultSet      <code>JRFResultSet</code> encapsulating an
     *      active <code>java.sql.ResultSet</code>.
     *@param  aPO               a value of type 'PersistentObject'
     *@exception  SQLException  if an error occurs
     */
    public void copyColumnValueToPersistentObject(JRFResultSet jrfResultSet,
            PersistentObject aPO)
             throws SQLException {
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (LOG.isDebugEnabled()) {
                LOG.debug("Processing compound key value for " + spec.getColumnName());
            }
            spec.copyColumnValueToPersistentObject(jrfResultSet, aPO);
        }
    }

    /** Updates a <code>PersistentObjectDynaProperty</code> with values from the column specification.
     * @param p <code>PersistentObjectDynaProperty</code> instance.
     */
    public void updatePersistentObjectDynaProperty(net.sf.jrf.domain.PersistentObjectDynaProperty p) {
        throw new UnsupportedOperationException("DynaProperty not applicable to compound columns.");
    }

    /** Not supported for compound primary keys.
      */
    public boolean isWriteOnce() {
        throw new UnsupportedOperationException("isWriteOnce not applicable to compound columns.");
    }

    /** Not supported for compound primary keys.
      */
    public void setWriteOnce(boolean writeOnce) {
        throw new UnsupportedOperationException("isWriteOnce not applicable to compound columns.");
    }


    /**
     *  Convert the attribute for this object to a String that can be
     *  unconverted later by the decodeToPersistentObject(...) method. The
     *  result of this method is not for use in SQL.
     *
     *@param  aPO  a value of type 'PersistentObject'
     *@return      Description of the Returned Value
     */
    public String encodeFromPersistentObject(PersistentObject aPO) {
        StringBuffer buffer = new StringBuffer();
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (spec instanceof TextColumnSpec) {
                buffer.append(net.sf.jrf.column.TextColumnSpec.encodeCompoundKeyTextObject(spec.encodeFromPersistentObject(aPO)));
            } else if (spec.getColumnClass().getName().equals("java.util.Date") || (
                    spec.getColumnClass().getSuperclass() != null &&
                    spec.getColumnClass().getSuperclass().getName().equals("java.util.Date"))) {
                buffer.append("\"" + spec.encodeFromPersistentObject(aPO) + "\"");

            } else {
                buffer.append(spec.encodeFromPersistentObject(aPO));
            }
            if (iterator.hasNext()) {
                buffer.append("|");
            }
        }
        // while
        if (LOG.isDebugEnabled()) {
            LOG.debug("encodeFromPersistentObject(" + aPO + ") = " + buffer.toString());
        }
        return buffer.toString();
    }

    // encodeFromPersistentObject(aPO)


    /**
     *  The String parameter must have been encoded with the
     *  encodeFromPersistentObject(...) method. This is used by
     *  AbstractDomain.decodePrimaryKey(aString). Parse out the String into
     *  tokens. Ask each columnspec to convert the string to the appropriate
     *  object, then for each of my column specs, convert the given String into
     *  a PersistentObject.
     *
     *@param  aString  a value of type 'String'
     *@param  aPO      a value of type 'PersistentObject'
     */
    public void decodeToPersistentObject(String aString,
            PersistentObject aPO) {
        // This method has been changed to use
        // Stream tokenizer so that encoded string may contain quotes, '|'s and so forth.
        StreamTokenizer st = new StreamTokenizer(new StringReader(aString));
        st.whitespaceChars((int) '|', (int) '|');
        Iterator iterator = i_columnSpecs.iterator();
        try {
            while (st.nextToken() != StreamTokenizer.TT_EOF) {
                String token = (st.ttype == StreamTokenizer.TT_NUMBER ? "" + st.nval + "" : st.sval);
                AbstractColumnSpec spec = (AbstractColumnSpec) iterator.next();
                // Unfortunately, StreamTokenizer will return a decimal point for int or short values.
                // Thus, we have to detect if the spec is numeric and scale is zero,
                // blow away the decimal point in the string. Otherwise, getValueFrom() will break.
                if (spec instanceof NumericColumnSpec) {
                    NumericColumnSpec n = (NumericColumnSpec) spec;
                    int idx;
                    if (n.getScale() == 0 && (idx = token.indexOf(".")) != -1) {
                        token = token.substring(0, idx);
                    }
                }
                spec.decodeToPersistentObject(token, aPO);
            }
        } catch (IOException io) {
            // not likely on a StringReader.
        }
        // OLD methodology.
        /*
         *  StringTokenizer tokenizer = new StringTokenizer(aString, "|");
         *  Iterator iterator = i_columnSpecs.iterator();
         *  while (tokenizer.hasMoreTokens())
         *  {
         *  String token = tokenizer.nextToken();
         *  AbstractColumnSpec spec = (AbstractColumnSpec) iterator.next();
         *  spec.decodeToPersistentObject(token, aPO);
         *  }
         */
    }

    // decodeToPersistentObject(aString, aPO)


    /**
     *  This is an override of the method in ColumnSpec.
     *
     *@param  aPO1  a value of type 'PersistentObject'
     *@param  aPO2  a value of type 'PersistentObject'
     */
    public void copyAttribute(PersistentObject aPO1,
            PersistentObject aPO2) {
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            spec.copyAttribute(aPO1, aPO2);
        }
    }

    // copyAttribute(aPO, aPO)


    /**
     *  Build a compound where clause (without the WHERE).
     *
     *@param  aPO        a value of type 'PersistentObject'
     *@param  separator  a value of type 'String'
     *@param  tableName  a value of type 'String'
     *@param  dbPolicy   a value of type 'DatabasePolicy'
     *@return            a value of type 'String'
     */
    public String buildWhereClause(Object aPO,
            String separator,
            String tableName,
            DatabasePolicy dbPolicy) {
        if (!(aPO instanceof PersistentObject)) {
            throw new IllegalArgumentException(
                    "This primary key is compound.  Must pass in a PersistentObject "
                    + "with it's primary keys populated.");
        }
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        StringBuffer buffer = new StringBuffer();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            buffer.append(spec.buildNameValuePair(aPO,
                    separator,
                    tableName,
                    dbPolicy));
            if (iterator.hasNext()) {
                buffer.append(" AND ");
            }
        }
        // for
        return buffer.toString();
    }

    // buildWhereClause(...)


    /**
     *  Description of the Method
     *
     *@param  tableAlias  Description of the Parameter
     *@return             Description of the Return Value
     */
    public String buildPreparedWhereClause(String tableAlias) {
        StringBuffer buf = new StringBuffer();
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            buf.append(spec.buildPreparedWhereClause(tableAlias));
            if (iterator.hasNext()) {
                buf.append(" AND ");
            }
        }
        return buf.toString();
    }


    /**
     *  Make sure the PersistentObject object has these attributes. All compound
     *  primary key columns are required by definition.
     *
     *@param  aPO                            a value of type 'PersistentObject'
     *@return                                Description of the Returned Value
     *@exception  MissingAttributeException  if an error occurs
     */
    public Object validateRequired(PersistentObject aPO)
             throws MissingAttributeException {
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            spec.validateRequired(aPO);
        }
        return null;
    }

    // validateRequired(aPO)


    /**
     *  Return the column names (qualified with their table name/alias) of my
     *  children. The names are separated by commas.
     *
     *@param  tableAlias  a value of type 'String'
     *@return             a value of type 'String'
     */
    public String getFullyQualifiedColumnName(String tableAlias) {
        // VM Change 7
        return getFullyQualifiedColumnName(tableAlias, false);
    }

    // getFullyQualifiedColumnName(tableAlias)


    /**
     *  Return the column names of my children. The names are separated by
     *  commas.
     *
     *@return    a value of type 'String'
     */
    public String getColumnName() {
        return this.getFullyQualifiedColumnName(null);
    }


    /** @see net.sf.jrf.column.ColumnSpec#setPropertyName(String) **/
    public void setPropertyName(String name) {
        throw new UnsupportedOperationException("No property name exists for compound columns.");
    }

    /** @see net.sf.jrf.column.ColumnSpec#getPropertyName() **/
    public String getPropertyName() {
        throw new UnsupportedOperationException("No property name exists for compound columns.");
    }



    /**
     *  Return the SQL values of my children with a comma between each.
     *
     *@param  aPO       a value of type 'PersistentObject'
     *@param  dbPolicy  a value of type 'DatabasePolicy'
     *@return           a value of type 'String'
     */
    public String getSqlValueFrom(PersistentObject aPO,
            DatabasePolicy dbPolicy) {
        // VM Change 7
        return getSqlValueFrom(aPO, dbPolicy, false);
    }


    /**
     *  Return something like "id INTEGER, code VARCHAR(999)" for use in a
     *  CREATE TABLE statement.
     *
     *@param  dbPolicy  a value of type 'DatabasePolicy'
     *@return           a value of type 'String'
     */
    public String columnDefinitionString(DatabasePolicy dbPolicy) {
        StringBuffer buffer = new StringBuffer();
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            buffer.append(spec.columnDefinitionString(dbPolicy));
            if (iterator.hasNext()) {
                buffer.append(", ");
            }
        }
        // for
        return buffer.toString();
    }


    /**
     *  If this is a unique column (or columns), make sure the value doesn't
     *  already exist.
     *
     *@param  aPO                        a value of type 'PersistentObject'
     *@param  stmtExecuter               a value of type 'StatementExecuter'
     *@param  pkColumnSpec               a value of type 'ColumnSpec'
     *@param  dbPolicy                   a value of type 'DatabasePolicy'
     *@param  tableName                  a value of type 'String'
     *@exception  DuplicateRowException  if an error occurs
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
     *  Build a string that represents a name/value pair
     *
     *@param  pkOrPersistentObject  a primary key value or a PersistentObject
     *@param  separator             usually "="
     *@param  tableName             name of the table
     *@param  dbPolicy              a value of type 'DatabasePolicy'
     *@return                       The built name-value pair
     */
    public String buildNameValuePair(Object pkOrPersistentObject,
            String separator,
            String tableName,
            DatabasePolicy dbPolicy) {
        throw new UnsupportedOperationException("buildNameValuePair");
    }


    /**
     *  Sets the ValueTo attribute of the CompoundPrimaryKeyColumnSpec object
     *
     *@param  aValue  The new ValueTo value
     *@param  aPO     The new ValueTo value
     */
    public void setValueTo(Object aValue,
            PersistentObject aPO) {
        if (implicitInsertColumn != null)
                implicitInsertColumn.setValueTo(aValue, aPO);
        else if (externalSequenceColumn != null)
                externalSequenceColumn.setValueTo(aValue, aPO);
        else
            throw new UnsupportedOperationException(
                "setValueTo() should not be used if no implicit auto-increment column or external sequence column exists.");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  aPO                             Description of the Parameter
     *@return                                 The valueFrom value
     *@throws  UnsupportedOperationException
     */
    public Object getValueFrom(PersistentObject aPO) {
        throw new UnsupportedOperationException("getValueFrom");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@throws  UnsupportedOperationException
     */
    public void setColumnIdx() {
        throw new UnsupportedOperationException("setColumnIdx");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The columnIdx value
     *@throws  UnsupportedOperationException
     */
    public int getColumnIdx() {
        throw new UnsupportedOperationException("getColumnIdx");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  idx                             The new columnIdx value
     *@throws  UnsupportedOperationException
     */
    public void setColumnIdx(int idx) {
        throw new UnsupportedOperationException("setColumnIdx");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  obj                             Description of the Parameter
     *@param  dbPolicy                        Description of the Parameter
     *@return                                 Description of the Return Value
     *@throws  UnsupportedOperationException
     */
    public String formatForSql(Object obj, DatabasePolicy dbPolicy) {
        throw new UnsupportedOperationException("formatForSql");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  jrfResultSet                    Description of the Parameter
     *@return                                 The columnValueFrom value
     *@exception  SQLException                Description of the Exception
     *@throws  UnsupportedOperationException
     */
    public Object getColumnValueFrom(JRFResultSet jrfResultSet)
             throws SQLException {
        throw new UnsupportedOperationException("getColumnValueFrom");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  stmt                            The new preparedColumnValueTo
     *      value
     *@param  value                           The new preparedColumnValueTo
     *      value
     *@param  position                        The new preparedColumnValueTo
     *      value
     *@exception  SQLException                Description of the Exception
     *@throws  UnsupportedOperationException
     */
    public void setPreparedColumnValueTo(JRFPreparedStatement stmt, Object value, int position)
             throws SQLException {

        throw new UnsupportedOperationException("setPreparedColumnValueTo");
    }


    /**
     *  Gets the preparedSqlValueString attribute of the
     *  CompoundPrimaryKeyColumnSpec object
     *
     *@param  isInsert      Description of the Parameter
     *@param  dbPolicy      Description of the Parameter
     *@param  sequenceName  Description of the Parameter
     *@param  tableName     Description of the Parameter
     *@return               The preparedSqlValueString value
     */
    public String getPreparedSqlValueString(boolean isInsert, DatabasePolicy dbPolicy, String sequenceName, String tableName) {
        Iterator iterator = i_columnSpecs.iterator();
        ColumnSpec spec;
        StringBuffer out = new StringBuffer();
        int counter = 0;
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (isInsert && spec.equals(implicitInsertColumn)) {
                continue;
            }
            if (++counter > 1) {
                out.append(",");
            }
            out.append(spec.getPreparedSqlValueString(isInsert, dbPolicy, sequenceName, tableName));
        }
        return out.toString();
    }


    /**
     *  Sets the columnIndices attribute of the CompoundPrimaryKeyColumnSpec
     *  object
     *
     *@param  idx  The new columnIndices value
     *@return      Description of the Return Value
     */
    public int setColumnIndices(int idx) {
        Iterator iterator = i_columnSpecs.iterator();
        ColumnSpec spec;
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            spec.setColumnIdx(idx);
            idx++;
        }
        return idx;
    }


    /**
     *  Sets the preparedColumnValues attribute of the
     *  CompoundPrimaryKeyColumnSpec object
     *
     *@param  stmt              The new preparedColumnValues value
     *@param  aPO               The new preparedColumnValues value
     *@param  position          The new preparedColumnValues value
     *@param  isInsert          The new preparedColumnValues value
     *@return                   Description of the Return Value
     *@exception  SQLException  Description of the Exception
     */
    public int setPreparedColumnValues(JRFPreparedStatement stmt, PersistentObject aPO,
            int position, boolean isInsert)
             throws SQLException {
        Iterator iterator = i_columnSpecs.iterator();
        ColumnSpec spec;
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (isInsert && (spec.equals(implicitInsertColumn) || spec.equals(externalSequenceColumn)) ) {
                continue;
            }
            // Call static wrapper so setting gets logged when in debug mode.
            JRFPreparedStatement.setPreparedColumnValue(stmt, spec, spec.getValueFrom(aPO), position);
            position++;
        }
        return position;
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The columnClass value
     *@throws  UnsupportedOperationException
     */
    public Class getColumnClass() {
        throw new UnsupportedOperationException("getColumnClass");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The getter value
     *@throws  UnsupportedOperationException
     */
    public String getGetter() {
        throw new UnsupportedOperationException("getGetter");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The setter value
     *@throws  UnsupportedOperationException
     */
    public String getSetter() {
        throw new UnsupportedOperationException("getSetter");
    }


    /**
     *  Gets the Required attribute of the CompoundPrimaryKeyColumnSpec object
     *  which is always <code>true</code>
     *
     *@return    <code>true</code>.
     */
    public boolean isRequired() {
        return true;
    }


    /**
     *  Gets the SequencedPrimaryKey attribute of the
     *  CompoundPrimaryKeyColumnSpec object
     *
     *@return    The value of SequencedPrimaryKey
     */
    public boolean isSequencedPrimaryKey() {
        return false;
    }


    /**
     *  Gets the NaturalPrimaryKey attribute of the CompoundPrimaryKeyColumnSpec
     *  object
     *
     *@return    The value of NaturalPrimaryKey
     */
    public boolean isNaturalPrimaryKey() {
        return true;
    }


    /**
     *  Gets the SubtypeIdentifier attribute of the CompoundPrimaryKeyColumnSpec
     *  object
     *
     *@return    The value of SubtypeIdentifier
     */
    public boolean isSubtypeIdentifier() {
        return false;
    }


    /**
     *  Gets the PrimaryKey attribute of the CompoundPrimaryKeyColumnSpec object
     *
     *@return    The value of PrimaryKey
     */
    public boolean isPrimaryKey() {
        return true;
    }


    /**
     *  Gets the Unique attribute of the CompoundPrimaryKeyColumnSpec object
     *
     *@return    The value of Unique
     */
    public boolean isUnique() {
        return true;
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The default value
     *@throws  UnsupportedOperationException
     */
    public Object getDefault() {
        throw new UnsupportedOperationException("getDefault");
    }


    /**
     *  Gets the OptimisticLock attribute of the CompoundPrimaryKeyColumnSpec
     *  object
     *
     *@return    The value of OptimisticLock
     */
    public boolean isOptimisticLock() {
        return false;
    }


    /**
     *  The method is a no-op. All compound primary keys are required.
     *
     *@param  b  The new Required value
     */
    public void setRequired(boolean b) { }


    /**
     *  Returns <code>false</code> always. Aggregate keys do not apply to this
     *  feature.
     *
     *@param  dbPolicy  Description of the Parameter
     *@return           <code>false</code>
     */
    public boolean isImplicitInsertColumn(DatabasePolicy dbPolicy) {
        return false;
        // Never -- only specific columns enclosed may apply
    }


    /**
     *  Returns <code>true</code> if an embedded sequence value exists in the
     *  compound key.
     *
     *@return    <code>true</code> if an embedded sequence value exists in the
     *      compound key.
     */
    public boolean hasEmbeddedSequenceColumn() {
        Iterator iterator = i_columnSpecs.iterator();
        ColumnSpec spec;
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (spec.isSequencedPrimaryKey()) {
                return true;
            }
        }
        return false;
    }


    // VM Change 5
    /**
     *  Returns the insert column name to use in <code>InsertSQLBuilder</code>,
     *  which may have to handle implicit key columns.
     *
     *@return    column name to use for SQL inserts.
     */
    public String getInsertColumnName() {
        return this.getFullyQualifiedColumnName(null, true);
    }


    // Handles implicit insert column correctly for using this method for
    // InsertSQLBuilder and other normal uses.
    /**
     *  Gets the fullyQualifiedColumnName attribute of the
     *  CompoundPrimaryKeyColumnSpec object
     *
     *@param  tableAlias  Description of the Parameter
     *@param  isInsert    Description of the Parameter
     *@return             The fullyQualifiedColumnName value
     */
    private String getFullyQualifiedColumnName(String tableAlias, boolean isInsert) {
        ColumnSpec spec = null;
        StringBuffer buffer = new StringBuffer();
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (isInsert && spec.equals(implicitInsertColumn)) {
                continue;
            }
            if (tableAlias != null && tableAlias.length() > 0) {
                buffer.append(tableAlias);
                buffer.append(".");
            }
            buffer.append(spec.getColumnName());
            if (iterator.hasNext()) {
                buffer.append(", ");
            }
        }
        // while
        return buffer.toString();
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  maxLength                       The new maxLength value
     *@throws  UnsupportedOperationException
     */
    public void setMaxLength(int maxLength) {
        // NA
        throw new UnsupportedOperationException("setMaxLength");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The maxLength value
     *@throws  UnsupportedOperationException
     */
    public int getMaxLength() {
        // NA
        throw new UnsupportedOperationException("getMaxLength");
    }


    // VM Change 7

    /**
     *  Returns the requisite value for SQL inserts. If there is an implicit
     *  insert column in this compound key, the return string will <em>not</em>
     *  include the value for the implicit column.
     *
     *@param  aPO       persistent object.
     *@param  dbPolicy  appropriate database policy implementation to use.
     *@return           string value for insert in the column.
     */
    public String getInsertSqlValueFrom(PersistentObject aPO,
            DatabasePolicy dbPolicy) {
        return getSqlValueFrom(aPO, dbPolicy, true);
    }


    /**
     *  Gets the sqlValueFrom attribute of the CompoundPrimaryKeyColumnSpec
     *  object
     *
     *@param  aPO       Description of the Parameter
     *@param  dbPolicy  Description of the Parameter
     *@param  isInsert  Description of the Parameter
     *@return           The sqlValueFrom value
     */
    private String getSqlValueFrom(PersistentObject aPO,
            DatabasePolicy dbPolicy, boolean isInsert) {
        ColumnSpec spec = null;
        Iterator iterator = i_columnSpecs.iterator();
        StringBuffer buffer = new StringBuffer();
        while (iterator.hasNext()) {
            spec = (ColumnSpec) iterator.next();
            if (isInsert && spec.equals(implicitInsertColumn)) {
                continue;
            }
            buffer.append(spec.getSqlValueFrom(aPO, dbPolicy));
            if (iterator.hasNext()) {
                buffer.append(", ");
            }
        }
        // for
        return buffer.toString();
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@return                                 The getterSetterImpl value
     *@throws  UnsupportedOperationException
     */
    public GetterSetter getGetterSetterImpl() {
        throw new UnsupportedOperationException("getGetterSetterImpl");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  getterSetterImpl                The new getterSetterImpl value
     *@throws  UnsupportedOperationException
     */
    public void setGetterSetterImpl(GetterSetter getterSetterImpl) {
        throw new UnsupportedOperationException("setGetterSetterImpl");
    }


    /**
     *@param  aPO                        Description of the Parameter
     *@return                            Description of the Return Value
     *@exception  InvalidValueException  Description of the Exception
     *@see
     *      net.sf.jrf.column.AbstractColumnSpec#validateValue(PersistentObject)
     *      *
     */
    public Object validateValue(PersistentObject aPO) throws InvalidValueException {
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext()) {
            ColumnSpec spec = (ColumnSpec) iterator.next();
            spec.validateValue(aPO);
        }
        return null;
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  maxValue                        The new maxValue value
     *@throws  UnsupportedOperationException
     */
    public void setMaxValue(Comparable maxValue) {
        throw new UnsupportedOperationException("setMaxValue");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  minValue                        The new minValue value
     *@throws  UnsupportedOperationException
     */
    public void setMinValue(Comparable minValue) {
        throw new UnsupportedOperationException("setMinValue");
    }


    /**
     *  Method is not supported. Calling it will generate an <code>UnsupportedOperationException</code>
     *  .
     *
     *@param  listOfValues                    The new listOfValues value
     *@throws  UnsupportedOperationException
     */
    public void setListOfValues(List listOfValues) {
        throw new UnsupportedOperationException("setListOfValue");
    }


    /**
     *  Returns the columns specs.
     *
     *@return    The columnSpecs value
     */
    public List getColumnSpecs() {
        return (List) i_columnSpecs;
    }

}
// CompoundPrimaryKeyColumnSpec


