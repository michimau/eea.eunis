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
import net.sf.jrf.*;
import net.sf.jrf.column.ColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;
import net.sf.jrf.util.ForeignKey;

/**  Instances of this class build SQL to do CREATE TABLE statements. */
public class CreateTableSQLBuilder
     extends SQLBuilder
{

    /* ===============  Constructors  =============== */
    /** This constructor throws an exception. */
    public CreateTableSQLBuilder()
    {
        super();
    }

    /**
     *Constructor for the CreateTableSQLBuilder object
     *
     * @param domain  Description of the Parameter
     */
    public CreateTableSQLBuilder(AbstractDomain domain)
    {
        super(domain);
    }

    /**
     * Build SQL to create a table the supplied tableName and columnSpecs
     *
     * @param tableName             The name of the table to create
     * @param columnSpecs           a value of type 'List'
     * @param foreignKeys           List of <code>ForeignKey</code> elements.
     * @param vendorSpecifications  Database vendor-specific expression that is inserted after
     *                        the CREATE TABLE construct to specify specification parameters, usually
     *                        for how the table should be stored physically.
     *                        (e.g. Under Oracle, tablepace, etc).
     * @return                      a syntactically correct, vendor-specific "CREATE TABLE" SQL statement for
     *         an <code>AbstractDomain</code>.
     */
    public String buildSQL(String tableName,
        List columnSpecs, List foreignKeys, String vendorSpecifications)
    {

        return buildSQL(tableName, columnSpecs, foreignKeys, vendorSpecifications, false);
    }

    /**
     * Build SQL to create a table the supplied tableName and columnSpecs
     *
     * @param tableName    The name of the table to create.
     * @param columnSpecs  a value of type 'List'
     * @return             a syntactically correct, vendor-specific "CREATE TABLE" SQL statement for
     *         an <code>AbstractDomain</code>.
     */
    public String buildSQL(String tableName,
        List columnSpecs)
    {

        return buildSQL(tableName, columnSpecs, null, null, false);
    }

    /**
     * Build SQL to create a table the supplied tableName and columnSpecs
     *
     * @param tableName             The name of the table to create.
     * @param columnSpecs           a value of type 'List'
     * @param foreignKeys           List of <code>ForeignKey</code> elements.
     * @param vendorSpecifications  Database vendor-specific expression that is inserted after
     *                        the CREATE TABLE construct to specify specification parameters, usually
     *                        for how the table should be stored physically.
     *                        (e.g. Under Oracle, tablepace, etc).
     * @param makeReadable          if <code>true</code>, make the format human readable
     *               with carriage returns and tabs.  This is useful
     *               for creating script files.
     * @return                      a syntactically correct, vendor-specific "CREATE TABLE" SQL statement for
     *         an <code>AbstractDomain</code>.
     * @see                         net.sf.jrf.util.ForeignKey
     * @see                         net.sf.jrf.DatabasePolicy
     */
    public String buildSQL(String tableName,
        List columnSpecs, List foreignKeys, String vendorSpecifications, boolean makeReadable)
    {
        ColumnSpec aColumnSpec = null;
        ColumnSpec pkColumnSpec = null;

        if (i_dbPolicy == null)
        {
            throw new DatabaseException("The DatabasePolicy has not been set for " + this);
        }

        StringBuffer sqlBuffer = new StringBuffer();
        sqlBuffer.append(" CREATE TABLE ");
        sqlBuffer.append(tableName);
        sqlBuffer.append("(");

        // Define each column
        Iterator iterator = columnSpecs.iterator();
        while (iterator.hasNext())
        {
            aColumnSpec = (ColumnSpec) iterator.next();
            if (makeReadable)
            {
                sqlBuffer.append("\n\t");
            }
            sqlBuffer.append(
                aColumnSpec.columnDefinitionString(i_domain.getDatabasePolicy()));
            sqlBuffer.append(", ");
        }// while

        pkColumnSpec = i_domain.getPrimaryKeyColumnSpec();
        if (pkColumnSpec != null)
        {
            if (makeReadable)
            {
                sqlBuffer.append("\n\t");
            }
            sqlBuffer.append("PRIMARY KEY (");
            sqlBuffer.append(
                pkColumnSpec.getColumnName());
            sqlBuffer.append(")");
        }

        // Determine,  based on the database policy, if we can embedded foreign key constraints
        // in the CREATE TABLE statement.
        /**
         * Stop doing this -- doesn't work with cyclical declarations, which most database allow.
         *if (foreignKeys != null && foreignKeys.size() > 0 &&
         *i_dbPolicy.foreignKeyExpressionsAllowedInCreateTable()) {
         *sqlBuffer.append(",");
         *if (makeReadable)
         *sqlBuffer.append("\n");
         *Iterator iter = foreignKeys.iterator();
         *int i = 0;
         *while (iter.hasNext()) {
         *ForeignKey fk = (ForeignKey) iter.next();
         *if (++i > 1)
         *sqlBuffer.append(",\n");
         *sqlBuffer.append("\t"+i_dbPolicy.getForeignKeySQLExpression(fk));
         *}
         *}
         */
        if (makeReadable)
        {
            sqlBuffer.append("\n");
        }
        sqlBuffer.append("\n)");// end of CREATE TABLE statement
        if (vendorSpecifications != null)
        {
            sqlBuffer.append(vendorSpecifications);
        }
        return sqlBuffer.toString();
    }// buildSQL()

}// CreateTableSQLBuilder

