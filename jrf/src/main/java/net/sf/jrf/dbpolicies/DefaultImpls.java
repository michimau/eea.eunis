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
package net.sf.jrf.dbpolicies;

import java.sql.Types;
import java.util.Iterator;
import java.util.List;
import net.sf.jrf.util.*;
/**
 * A class that contains static methods for some default
 * standard implementations of the methods in <code>DatabasePolicy</code>.
 *
 * @see   net.sf.jrf.DatabasePolicy
 */
public class DefaultImpls
{

    private DefaultImpls() { }

    /**
     *  Returns the column type definition for numeric columns based
     * on number of digits and precision arguments. This is a default/fallback implementation
     * of the policy method.
     *
     * @param sqlType    one of the <code>java.sql.Types</code> constants.
     * @param precision  precision value; a zero value denotes database maximum.
     * @param scale      scale value.
     * @return           database-specific column definition string.
     */
    public static String getNumericColumnTypeDefinition(int sqlType, int precision, int scale)
    {
        switch (sqlType)
        {
            case java.sql.Types.INTEGER:
                return "INTEGER";
            case java.sql.Types.SMALLINT:
                return "SMALLINT";
            case java.sql.Types.DOUBLE:
                return "DOUBLE";
            case java.sql.Types.TINYINT:
                return "NUMERIC(1)";
            case java.sql.Types.FLOAT:
                return "FLOAT";
            case java.sql.Types.BIGINT:
            default:
                if (precision == 0)
                {
                    return "NUMERIC";
                }
                return "NUMERIC(" + precision + "," + scale + ")";
        }
    }

    /**
     * @param argument  Description of the Parameter
     * @return          Description of the Return Value
     * @see             net.sf.jrf.DatabasePolicy#formatToUpper(String) *
     */
    public static String formatToUpper(String argument)
    {
        return "UPPER(" + argument + ")";
    }

    /**
     * @param argument  Description of the Parameter
     * @return          Description of the Return Value
     * @see             net.sf.jrf.DatabasePolicy#formatToLower(String) *
     */
    public static String formatToLower(String argument)
    {
        return "LOWER(" + argument + ")";
    }

    /**
     * @param foreignKey  Description of the Parameter
     * @return            The foreignKeySQLExpression value
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLExpression(ForeignKey) *
     */
    public static String getForeignKeySQLExpression(ForeignKey foreignKey)
    {
        StringBuffer result = new StringBuffer();
        result.append("constraint " + foreignKey.getConstraintName() + " foreign key (");
        Iterator iter = foreignKey.getLocalTableColumns().iterator();
        int i = 0;
        while (iter.hasNext())
        {
            if (++i > 1)
            {
                result.append(",");
            }
            result.append((String) iter.next());
        }
        result.append(") references " + foreignKey.getReferencedTableName() + " (");
        i = 0;
        iter = foreignKey.getReferencedTableColumns().iterator();
        while (iter.hasNext())
        {
            if (++i > 1)
            {
                result.append(",");
            }
            result.append((String) iter.next());
        }
        result.append(")");
        return result.toString();
    }

    /**
     * @param foreignKey  Description of the Parameter
     * @return            The foreignKeySQLStatement value
     * @see               net.sf.jrf.DatabasePolicy#getForeignKeySQLStatement(ForeignKey) *
     */
    public static String getForeignKeySQLStatement(ForeignKey foreignKey)
    {
        StringBuffer result = new StringBuffer();
        result.append("alter table " + foreignKey.getLocalTableName() + " add " +
            getForeignKeySQLExpression(foreignKey));
        return result.toString();
    }


}

