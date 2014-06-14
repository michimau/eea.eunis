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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import net.sf.jrf.DatabasePolicy;
import net.sf.jrf.column.ColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;

import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.join.*;

/**
 *  Instances of this class build SQL to do SELECT statements.  This has
 *  it's own instance so that variables can be changed without affecting the
 *  domain object.  For purposes of selecting, subtype tables are treated
 *  like join tables.
 */
public class SelectSQLBuilder
     extends SQLBuilder
{

    /** Copy of the JoinTable object list */
    protected List i_joinTables = null;

    protected String i_where = null;
    protected String i_orderBy = null;
    protected boolean i_useANSIJoins = true;
    protected StringBuffer sqlBuffer = new StringBuffer();


    /* ===============  Constructors  =============== */
    /** This constructor throws an exception. */
    public SelectSQLBuilder()
    {
        super();
    }


    /**
     *Constructor for the SelectSQLBuilder object
     *
     * @param domain        Description of the Parameter
     * @param useANSIJoins  Description of the Parameter
     */
    public SelectSQLBuilder(AbstractDomain domain, boolean useANSIJoins)
    {
        this(domain);
        i_useANSIJoins = useANSIJoins;
    }

    /**
     *Constructor for the SelectSQLBuilder object
     *
     * @param domain  Description of the Parameter
     */
    public SelectSQLBuilder(AbstractDomain domain)
    {
        super(domain);
        // This list is a clone
        i_joinTables = domain.getJoinTables();
        JoinTable subtypeTable = domain.getSubtypeTable();
        if (subtypeTable != null)
        {//  assuming this list is a clone of the actual
            i_joinTables.add(subtypeTable);
        }
        setColumnIndices();
    }


    /**
     * Adds a feature to the JoinTable attribute of the SelectSQLBuilder object
     *
     * @param aJoinTable  The feature to be added to the JoinTable attribute
     */
    public void addJoinTable(JoinTable aJoinTable)
    {
        i_joinTables.add(aJoinTable);
        setColumnIndices();

    }


    /**
     * Create and add a new JoinTable instance with no join columns.  It is
     * assumed the user will manually set the joins using the setWhereString()
     * method.  This string can be of the form: 'Video' or 'Video V' (where V
     * is the table alias)
     *
     * @param tableName  a value of type 'String'
     */
    public void addJoinTable(String tableName)
    {
        i_joinTables.add(new JoinTable(tableName, "", ""));
        setColumnIndices();
    }


    /**
     * Create and add a new OuterJoinTable instance with no join columns.  It
     * is assumed the user will manually set the joins using the
     * setWhereString() method.  This string can be of the form: 'Video' or
     * 'Video V' (with table alias)
     *
     * @param tableName  a value of type 'String'
     */
    public void addOuterJoinTable(String tableName)
    {
        i_joinTables.add(new OuterJoinTable(tableName, "", ""));
        setColumnIndices();
    }


    /**
     * This should be a where string without the WHERE.
     *
     * @param whereString  a value of type 'String'
     */
    public void setWhere(String whereString)
    {
        i_where = whereString;
    }


    /**
     * This should be an orderBy string without the 'ORDER BY'.
     *
     * @param orderByString  a value of type 'String'
     */
    public void setOrderBy(String orderByString)
    {
        i_orderBy = orderByString;
    }


    /**
     * Set to true when ANSI joins are required.  ANSI joins look like this:<br>
     * <br>
     * <tt>SELECT col1 FROM table1<tt><br>
     * <tt>JOIN table2 ON table1.col1=table2.col1<tt><br>
     * <tt>WHERE table1.col3='something'
     *
     * @param b  a value of type 'boolean'
     */
    public void setUseANSIJoins(boolean b)
    {
        i_useANSIJoins = b;
    }


    /**
     * Gets the useANSIJoins attribute of the SelectSQLBuilder object
     *
     * @return   The useANSIJoins value
     */
    public boolean getUseANSIJoins()
    {
        return i_useANSIJoins;
    }

    // Make this method private???
    /**
     * Sets the column indices. The framework no longer uses the <code>String</code>
     * version of <code>java.sql.ResultSet</code>.
     */
    public void setColumnIndices()
    {
        int idx = 1;
        Iterator iterator = i_columnSpecs.iterator();
        while (iterator.hasNext())
        {
            ColumnSpec colSpec = (ColumnSpec) iterator.next();
            if (colSpec instanceof CompoundPrimaryKeyColumnSpec)
            {
                CompoundPrimaryKeyColumnSpec cpk = (CompoundPrimaryKeyColumnSpec) colSpec;
                idx = cpk.setColumnIndices(idx);
            }
            else
            {
                colSpec.setColumnIdx(idx++);
            }
        }
        iterator = i_joinTables.iterator();
        while (iterator.hasNext())
        {
            JoinTable aJoinTable = (JoinTable) iterator.next();
            idx = aJoinTable.setColumnIndices(idx);
        }
    }

    /**
     * Build the SQL using the information I have.  The SQL
     * generated by this includes the joined columns.
     *
     * @return   a value of type 'String'
     */
    public String buildSQL()
    {
        List v = null;
        Iterator iterator = null;
        JoinTable aJoinTable = null;
        JoinColumn aJoinColumn = null;

        sqlBuffer.setLength(0);
        sqlBuffer.append(" SELECT ");

        // SELECT columns for this main table
        iterator = i_columnSpecs.iterator();
        while (iterator.hasNext())
        {// columns for this table
            ColumnSpec colSpec = (ColumnSpec) iterator.next();
            sqlBuffer.append(colSpec.getFullyQualifiedColumnName(i_tableAlias));
            if (iterator.hasNext())
            {
                sqlBuffer.append(", ");
            }
        }// while

        // SELECT columns for the join table(s)
        iterator = i_joinTables.iterator();
        while (iterator.hasNext())
        {// join columns
            aJoinTable = (JoinTable) iterator.next();
            aJoinTable.buildSelectColumnString(sqlBuffer);
        }// while

        // FROM clause
        sqlBuffer.append(" FROM ");
        this.buildFromTableName(sqlBuffer, i_tableName, i_tableAlias);

        boolean whereAdded = false;

        if (i_useANSIJoins)
        {
            // JOIN clause(s)
            iterator = i_joinTables.iterator();
            while (iterator.hasNext())
            {
                aJoinTable = (JoinTable) iterator.next();
                sqlBuffer.append(aJoinTable.buildANSIJoin(i_tableAlias));
            }
        }
        else
        {
            // Add any join tables to the FROM clause and specify joins in the
            // WHERE clause
            iterator = i_joinTables.iterator();
            while (iterator.hasNext())
            {
                aJoinTable = (JoinTable) iterator.next();
                aJoinTable.buildFromString(sqlBuffer);
            }// while

            // WHERE clause
            iterator = i_joinTables.iterator();
            if (iterator.hasNext())
            {
                sqlBuffer.append(" WHERE ");
                whereAdded = true;
            }
            while (iterator.hasNext())
            {
                aJoinTable = (JoinTable) iterator.next();
                sqlBuffer.append(
                    aJoinTable.buildNonANSIJoin(i_tableAlias,
                    i_dbPolicy));
                if (iterator.hasNext())
                {
                    sqlBuffer.append(" AND ");
                }
            }// while
        }// else we're using non-ANSI joins

        // Add the manual WHERE clauses
        if (i_where != null &&
            i_where.trim().length() > 0)
        {
            if (whereAdded)
            {
                sqlBuffer.append(" AND ");
            }
            else
            {
                sqlBuffer.append(" WHERE ");
            }
            sqlBuffer.append(i_where);
        }
        if (i_orderBy != null &&
            i_orderBy.trim().length() > 0)
        {
            sqlBuffer.append(" ORDER BY ");
            sqlBuffer.append(i_orderBy);
        }

        return sqlBuffer.toString();
    }// buildSQL()


    /**
     * Returns SQL statement that will count the rows for the given primary key column spec.
     * It is assumed that execution of this SQL will result in a 0 or a 1.
     *
     * @param tableName             name of table.
     * @param primaryKeyColumnSpec  table's primary key column specification.
     * @param aPO                   <code>PersistentObject</code> instance whose values will be used for the query.
     * @param dbPolicy              applicable <code>DatabasePolicy</code> instance.
     * @return                      SQL statement to obtain count of given primary key column for a table.
     */
    public String buildCountSQL(String tableName,
        ColumnSpec primaryKeyColumnSpec,
        PersistentObject aPO,
        DatabasePolicy dbPolicy)
    {
        sqlBuffer.setLength(0);
        sqlBuffer.append("SELECT COUNT(*) FROM ");
        sqlBuffer.append(tableName);
        sqlBuffer.append(" WHERE ");
        sqlBuffer.append(
            primaryKeyColumnSpec.buildWhereClause(
            aPO, "=", tableName, dbPolicy));
        return sqlBuffer.toString();
    }


    /**
     * If there is a table alias, this would concatenate the table name and
     * table alias like this 'Customer c' for a FROM clause.
     *
     * @param tableName   table name.
     * @param tableAlias  table alias.
     * @param sqlBuffer   buffer to append result.
     */
    public static void buildFromTableName(StringBuffer sqlBuffer, String tableName, String tableAlias)
    {
        sqlBuffer.append(tableName);
        if (!tableName.equals(tableAlias))
        {
            sqlBuffer.append(" ");
            sqlBuffer.append(tableAlias);
        }
    }

}// SelectSQLBuilder

