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
package net.sf.jrf.sqlbuilder;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.column.ColumnSpec;
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.*;

import net.sf.jrf.sql.*;
import org.apache.log4j.Category;

/**  Instances of this class build SQL to do UPDATE statements. */
public class UpdateSQLBuilder
     extends SQLBuilder
{

    final static Category LOG = Category.getInstance(UpdateSQLBuilder.class.getName());

    /* ===============  Constructors  =============== */
    /** This constructor throws an exception. */
    public UpdateSQLBuilder()
    {
        super();
    }

    /**
     *Constructor for the UpdateSQLBuilder object
     *
     * @param domain  Description of the Parameter
     */
    public UpdateSQLBuilder(AbstractDomain domain)
    {
        super(domain);
    }



    /**
     * Description of the Method
     *
     * @param tableName    Description of the Parameter
     * @param columnSpecs  Description of the Parameter
     * @return             Description of the Return Value
     */
    public String buildPreparedSQL(String tableName,
        List columnSpecs)
    {
        return buildSQL(true, null, tableName, columnSpecs);
    }

    /**
     * Build SQL to update a row using the columnSpecs.
     *
     * @param aPO          a value of type 'PersistentObject'
     * @param columnSpecs  a value of type 'List'
     * @param tableName    Description of the Parameter
     * @return             a value of type 'String'
     * @deprecated         no longer used by the framework.
     */
    public String buildSQL(PersistentObject aPO,
        String tableName,
        List columnSpecs)
    {
        return buildSQL(false, aPO, tableName, columnSpecs);
    }// buildSQL(PersistentObject)


    private static Integer getNewOptimIntColumn(Integer oldVersion)
    {
        return new Integer(oldVersion.intValue() + 1);
    }

    private String buildSQL(boolean prepared,
        PersistentObject aPO,
        String tableName,
        List columnSpecs)
    {
        ColumnSpec aColumnSpec = null;
        ColumnSpec pkColumnSpec = null;
        ColumnSpec lockingColumnSpec = null;

        checkPolicy();

        StringBuffer sqlBuffer = new StringBuffer();
        sqlBuffer.append(" UPDATE ");
        sqlBuffer.append(tableName);
        sqlBuffer.append(" SET ");
        int count = 0;
        // Create an assignment expression for each column
        Iterator iterator = columnSpecs.iterator();
        while (iterator.hasNext())
        {
            aColumnSpec = (ColumnSpec) iterator.next();
            if (aColumnSpec.isPrimaryKey())
            {
                pkColumnSpec = aColumnSpec;// save for later
            }
            else
            {// not a primary key

                if (count > 0)
                {// BUG Fix -- PK may not be the first column in the list.
                    sqlBuffer.append(", ");
                }
                count++;
                sqlBuffer.append(
                    aColumnSpec.getColumnName());
                sqlBuffer.append(" = ");
                if (aColumnSpec.isOptimisticLock())
                {
                    lockingColumnSpec = aColumnSpec;// save for later
                    if (aColumnSpec instanceof TimestampColumnSpecDbGen)
                    {
                        sqlBuffer.append(i_dbPolicy.timestampFunction());
                    }
                    else
                    {// Assume it's an IntegerColumnSpec

                        if (prepared)
                        {
                            sqlBuffer.append("?");
                        }
                        else
                        {
                            Integer oldVersion = (Integer) aColumnSpec.getValueFrom(aPO);
                            sqlBuffer.append(aColumnSpec.formatForSql(getNewOptimIntColumn(oldVersion), i_dbPolicy));
                        }
                    }
                }
                else
                {// it's not an optimistic lock

                    // If this is a time stamp column that is only
                    // stamped on insert, it is NEVER part of an update statement,
                    // so skip it.
                    if (aColumnSpec instanceof TimestampColumnSpecDbGen)
                    {
                        TimestampColumnSpecDbGen tc = (TimestampColumnSpecDbGen) aColumnSpec;
                        if (tc.isInsertOnly())
                        {
                            continue;
                        }
                    }
                    if (prepared)
                    {
                        sqlBuffer.append(aColumnSpec.getPreparedSqlValueString(false, i_dbPolicy,
                            i_domain.getSequenceName(), i_domain.getTableName()));
                    }
                    else
                    {
                        sqlBuffer.append(
                            aColumnSpec.getSqlValueFrom(aPO,
                            i_dbPolicy));
                    }
                }

            }// else not a primary key
        }// while
        // Create the WHERE clause
        sqlBuffer.append(" WHERE ");
        if (prepared)
        {
            if (pkColumnSpec == null)
            {
                throw new RuntimeException(
                    "CRITICAL error: " + tableName + " has no primary key column spec." + sqlBuffer.toString());
            }
            sqlBuffer.append(pkColumnSpec.buildPreparedWhereClause(tableName));
        }
        else
        {
            sqlBuffer.append(
                pkColumnSpec.buildWhereClause(aPO,
                ColumnSpec.EQUALS,
                tableName,
                i_dbPolicy));
        }
        // Append to WHERE statement if we have an optimistic lock.
        if (lockingColumnSpec != null)
        {
            // If object was changed (probably by someone else) since last being
            // read, this will prevent the update from occurring.
            sqlBuffer.append(" AND ");
            sqlBuffer.append(
                lockingColumnSpec.getFullyQualifiedColumnName(tableName));
            sqlBuffer.append(" = ");
            if (prepared)
            {
                sqlBuffer.append(" ? ");
            }
            else
            {
                sqlBuffer.append(
                    lockingColumnSpec.getSqlValueFrom(aPO, i_dbPolicy));
            }
        }
        return sqlBuffer.toString();
    }// buildSQL(PersistentObject)

}// UpdateSQLBuilder

