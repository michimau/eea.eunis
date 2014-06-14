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
 * The Initial Developer of the Original Code is is.com (bought by wamnet.com).
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: James Evans (jevans@vmguys.com)
 * Contributor: _____________________________________
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
package net.sf.jrf.sql;

import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.*;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

import net.sf.jrf.JRFProperties;
import net.sf.jrf.column.ColumnSpec;

import net.sf.jrf.exceptions.*;
import net.sf.jrf.sqlbuilder.*;
import org.apache.log4j.Category;

/**
 * Sub-class of prepared statements that handles
 * SQL select by where clause and optional order by.
 *
 * @see   net.sf.jrf.column.ColumnSpec
 */
public class JRFSelectWhereOrderByPreparedStatement extends JRFAdHocPreparedStatement
{
    /** log4j category for debugging and errors */
    private final static Category LOG = Category.getInstance(JRFSelectWhereOrderByPreparedStatement.class.getName());

    /**
     * Constructs instance.
     *
     * @param sqlBuilder            appropriate <code>SelectSQLBuilder</code>.
     * @param whereClause           syntactically correct prepared where clause.
     * @param orderBy               optional order by clause. May be <code>null</code>.
     * @param tableAlias            Description of the Parameter
     * @param columnSpecs           Description of the Parameter
     * @param dataSourceProperties  Description of the Parameter
     * @see                         #get(String)
     */
    JRFSelectWhereOrderByPreparedStatement(SelectSQLBuilder sqlBuilder,
        String whereClause, String orderBy, String tableAlias, List columnSpecs, DataSourceProperties
        dataSourceProperties)
    {
        // Set super class up so protected setPrimaryKeyPreparedValues() can be called.
        super(null, columnSpecs, dataSourceProperties);
        // Build the SQL
        sqlBuilder.setWhere(whereClause);
        sqlBuilder.setOrderBy(orderBy);
        super.sql = sqlBuilder.buildSQL();
    }

}

