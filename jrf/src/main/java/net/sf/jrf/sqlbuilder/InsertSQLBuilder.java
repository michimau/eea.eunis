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

/** VM Changes  -- to support implicit insert column.   See buildSQL(). */

/**  Instances of this class build SQL to do INSERT statements. */
public class InsertSQLBuilder
     extends SQLBuilder
{

    final static Category LOG = Category.getInstance(InsertSQLBuilder.class.getName());

    /* ===============  Constructors  =============== */
    /** This constructor throws an exception. */
    public InsertSQLBuilder()
    {
        super();
    }

    /**
     *Constructor for the InsertSQLBuilder object
     *
     * @param domain  Description of the Parameter
     */
    public InsertSQLBuilder(AbstractDomain domain)
    {
        super(domain);
    }

    // Append beginning and column names; used for prepared or static SQL.
    // Returns implicit column specification or -1 if none.
    private int appendBegin(StringBuffer sqlBuffer,
        PersistentObject aPO,
        String tableName,
        List columnSpecs,
        boolean includeImplicitInsertCols)
    {
        sqlBuffer.append(" INSERT INTO ")
            .append(tableName)
            .append(" (");
        Iterator iterator = columnSpecs.iterator();
        ColumnSpec aColumnSpec = null;
        int idx = 0;
        int counter = 0;
        int implicitColumnIdx = -1;
        while (iterator.hasNext())
        {
            idx++;
            aColumnSpec = (ColumnSpec) iterator.next();
            if (!includeImplicitInsertCols && aColumnSpec.isImplicitInsertColumn(i_dbPolicy) &&
                (aPO == null || aColumnSpec.getValueFrom(aPO) == null))
            {
                implicitColumnIdx = idx;
                continue;
            }
            if (++counter > 1)
            {
                sqlBuffer.append(",");
            }
            sqlBuffer.append(includeImplicitInsertCols ? aColumnSpec.getColumnName() : aColumnSpec.getInsertColumnName());
        }
        sqlBuffer.append(")");
        return implicitColumnIdx;
    }


    /**
     * Description of the Method
     *
     * @param tableName    Description of the Parameter
     * @param columnSpecs  Description of the Parameter
     * @return             Description of the Return Value
     */
    public String buildPreparedSQL(String tableName, List columnSpecs)
    {
        checkPolicy();
        StringBuffer sqlBuffer = new StringBuffer();
        int implicitColumnIdx = appendBegin(sqlBuffer, null, tableName, columnSpecs, false);
        Iterator iterator = columnSpecs.iterator();
        int idx = 0;
        int counter = 0;
        sqlBuffer.append(" VALUES(");
        while (iterator.hasNext())
        {
            ColumnSpec aColumnSpec = (ColumnSpec) iterator.next();
            idx++;
            if (idx == implicitColumnIdx)
            {
                continue;
            }
            if (++counter > 1)
            {
                sqlBuffer.append(",");
            }
            if (aColumnSpec.isSequencedPrimaryKey() &&
                i_dbPolicy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL)
            {
                sqlBuffer.append(i_dbPolicy.sequenceNextValSQL(i_domain.getSequenceName(),
                    i_domain.getTableName()));
            }
            else
            {
                sqlBuffer.append(aColumnSpec.getPreparedSqlValueString(true, i_dbPolicy,
                    i_domain.getSequenceName(), i_domain.getTableName()));
            }
        }
        sqlBuffer.append(")");
        return sqlBuffer.toString();
    }// buildPreparedSQL(tableName, columnSpecs)


    /**
     * Builds SQL to insert a row using the columnSpecs and the next
     * available primary key object ID.
     *
     * @param aPO          a value of type 'PersistentObject'
     * @param aJDBCHelper  Description of the Parameter
     * @param tableName    Description of the Parameter
     * @param columnSpecs  Description of the Parameter
     * @return             a value of type 'String'
     * @deprecated         use version without the JDBCHelper value.
     * @see                #buildPreparedSQL(String,List)
     */
    public String buildSQL(PersistentObject aPO,
        JDBCHelper aJDBCHelper,
        String tableName,
        List columnSpecs)
    {
        return buildSQL(aPO, tableName, columnSpecs);
    }

    /**
     * Builds SQL to insert a row using the columnSpecs and the next
     * available primary key object ID.
     *
     * @param aPO          a value of type 'PersistentObject'
     * @param tableName    Description of the Parameter
     * @param columnSpecs  Description of the Parameter
     * @return             a value of type 'String'
     * @see                #buildPreparedSQL(String,List)
     */
    public String buildSQL(PersistentObject aPO,
        String tableName,
        List columnSpecs)
    {
        return buildSQL(aPO, tableName, columnSpecs, false);
    }// buildSQL(PersistentObject, tableName, columnSpecs)

    /**
     * Builds SQL to insert a row using the columnSpecs and the next
     * available primary key object ID.
     *
     * @param aPO                        a value of type 'PersistentObject'
     * @param includeImplicitInsertCols  if <code>true</code> implicit column status will be ignored; all values
     *                      will be inserted.
     * @param tableName                  Description of the Parameter
     * @param columnSpecs                Description of the Parameter
     * @return                           a value of type 'String'
     * @see                              #buildPreparedSQL(String,List)
     */

    public String buildSQL(PersistentObject aPO,
        String tableName,
        List columnSpecs,
        boolean includeImplicitInsertCols)
    {
        checkPolicy();
        StringBuffer sqlBuffer = new StringBuffer();
        int implicitColumnIdx = appendBegin(sqlBuffer, aPO, tableName, columnSpecs, includeImplicitInsertCols);
        Iterator iterator = columnSpecs.iterator();
        int idx = 0;
        int counter = 0;
        sqlBuffer.append(" VALUES(");
        while (iterator.hasNext())
        {
            ColumnSpec aColumnSpec = (ColumnSpec) iterator.next();
            idx++;
            if (idx == implicitColumnIdx)
            {
                continue;
            }
            if (++counter > 1)
            {
                sqlBuffer.append(",");
            }
            if (aColumnSpec.isSequencedPrimaryKey() &&
                i_dbPolicy.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL &&
                aColumnSpec.getValueFrom(aPO) == null)
            {
                sqlBuffer.append(i_dbPolicy.sequenceNextValSQL(i_domain.getSequenceName(),
                    i_domain.getTableName()));
            }
            else
            {
                String sqlValue = includeImplicitInsertCols ?
                    aColumnSpec.getSqlValueFrom(aPO, i_dbPolicy) : aColumnSpec.getInsertSqlValueFrom(aPO, i_dbPolicy);
                sqlBuffer.append(sqlValue);
            }
        }
        sqlBuffer.append(")");
        return sqlBuffer.toString();
    }// buildSQL(PersistentObject, tableName, columnSpecs,ignoreImplicitInsert)

}// InsertSQLBuilder

