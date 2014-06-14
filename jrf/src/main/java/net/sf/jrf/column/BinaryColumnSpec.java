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

import java.sql.Types;
import net.sf.jrf.*;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.domain.*;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;

/**  Sub-class of <code>SizedColumnSpec</code> for all binary fields. */
public abstract class BinaryColumnSpec extends SizedColumnSpec
{

    protected int i_sqlType = java.sql.Types.BINARY;// validateReq

    /**Constructor for the BinaryColumnSpec object */
    public BinaryColumnSpec()
    {
        super();
    }

    /**
     * Constructs a <code>BinaryColumnSpec</code> with column options assuming
     * reflection will be used for getting and setting values in the <code>PersistentObject</code>.
     *
     * @param columnName    column name.
     * @param columnOption  <code>ColumnOption</code> instance to use.
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  value to use for default if column value is null.
     */
    public BinaryColumnSpec(String columnName, ColumnOption columnOption, String getter, String setter,
        Object defaultValue)
    {
        super(columnName, columnOption, getter, setter, defaultValue);
    }

    /**
     * Constructs a <code>BinaryColumnSpec</code> with column options and a <code>GetterSetter</code> instance.
     *
     * @param columnName        column name.
     * @param columnOption      <code>ColumnOption</code> instance to use.
     * @param defaultValue      value to use for default if column value is null.
     * @param getterSetter      Description of the Parameter
     */
    public BinaryColumnSpec(String columnName, ColumnOption columnOption, GetterSetter getterSetter, Object defaultValue)
    {
        super(columnName, columnOption, getterSetter, defaultValue);
    }


    /**
     * Constructs a <code>BinaryColumnSpec</code> with three option values.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option3       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public BinaryColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1,
        int option2,
        int option3)
    {
        super(columnName, getter, setter, defaultValue, option1, option2, option3);
    }

    /**
     * Constructs a <code>BinaryColumnSpec</code> with no option values supplied.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public BinaryColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue)
    {
        super(columnName,
            getter,
            setter,
            defaultValue,
            0,
            0,
            0);
    }

    /**
     * Constructs a <code>BinaryColumnSpec</code> with one option value.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public BinaryColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1)
    {
        super(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            0,
            0);
    }

    /**
     * Constructs a <code>BinaryColumnSpec</code> with two option values.
     *
     * @param columnName    name of the column
     * @param getter        name of the method to get the column data from the <code>PersistentObject</code>
     * @param setter        name of the method to set column data in the <code>PersistentObject</code>.
     * @param defaultValue  default value when the return value from the "getter" is null.
     * @param option1       One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2       Description of the Parameter
     * @deprecated          Use <code>ColumnOption</code> constructors as an alternative.
     */
    public BinaryColumnSpec(
        String columnName,
        String getter,
        String setter,
        Object defaultValue,
        int option1,
        int option2)
    {
        this(columnName,
            getter,
            setter,
            defaultValue,
            option1,
            option2,
            0);
    }

    /**
     * Constructs a <code>BinaryColumnSpec</code> with three option values and a <code>GetterSetter</code> implementation.
     *
     * @param columnName        name of the column
     * @param getterSetterImpl  an implementation of <code>GetterSetter</code>.
     * @param defaultValue      default value when the return value from the "getter" is null.
     * @param option1           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option2           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @param option3           One the six column option constants from <code>JRFConstants</code> or zero to denote no option.
     * @deprecated              Use <code>ColumnOption</code> constructors as an alternative.
     */
    public BinaryColumnSpec(
        String columnName,
        GetterSetter getterSetterImpl,
        Object defaultValue,
        int option1,
        int option2,
        int option3)
    {
        super(columnName, getterSetterImpl, defaultValue, option1, option2, option3);

    }

    /**
     * @param policy  The new sqlType value
     * @see           net.sf.jrf.column.SizedColumnSpec#setSqlType(DatabasePolicy) *
     */
    public void setSqlType(DatabasePolicy policy)
    {
        i_sqlType = policy.getBinaryColumnSqlType(super.i_maxLength, super.i_variable, super.i_blockSize);
    }

    /**
     * Returns column type.
     *
     * @param dbPolicy  a value of type 'DatabasePolicy'
     * @return          a value of type 'String'
     */
    public String getSQLColumnType(DatabasePolicy dbPolicy)
    {
        return dbPolicy.getBinaryColumnTypeDefinition(i_maxLength, i_variable, i_blockSize);
    }

    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public JoinColumn buildJoinColumn()
    {
        throw new RuntimeException("Cannot join binary columns");
    }

    /**
     * Throws exception, since static SQL is not supported for this column specification.
     *
     * @param obj       Description of the Parameter
     * @param dbPolicy  Description of the Parameter
     * @return          Description of the Return Value
     */
    public String formatForSql(Object obj, DatabasePolicy dbPolicy)
    {
        throw new RuntimeException("static SQL not supported for binary data.");
    }// formatForSql(...)


    /**
     * Throws exception, since static SQL is not supported for this column specification.
     *
     * @param aString  Description of the Parameter
     * @return         Description of the Return Value
     */
    public Object decode(String aString)
    {
        throw new RuntimeException("static SQL not supported for binary data.");
    }


    /**
     * This is an override of the superclass implementation.  This method adds
     * a check to make sure the string is not empty or blank.
     *
     * @param aPO                            a value of type 'PersistentObject'
     * @return                               a value of type 'Object'
     * @exception MissingAttributeException  if an error occurs
     */
    public Object validateRequired(PersistentObject aPO)
        throws MissingAttributeException
    {
        // just make sure is is not null
        return super.validateRequired(aPO);
    }

}
