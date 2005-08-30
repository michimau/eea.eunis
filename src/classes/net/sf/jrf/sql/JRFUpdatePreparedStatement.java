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
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.domain.PersistentObject;

import net.sf.jrf.exceptions.*;
import net.sf.jrf.sqlbuilder.*;
import org.apache.log4j.Category;

/**
 * Sub-class of prepared statements that handles
 * SQL updates using column specifications.
 *
 * @see   net.sf.jrf.column.ColumnSpec
 */
public class JRFUpdatePreparedStatement extends JRFPrimaryKeyPreparedStatement {
  /** log4j category for debugging and errors */
  private final static Category LOG = Category.getInstance(JRFUpdatePreparedStatement.class.getName());

  // List of column specs
  private ArrayList colSpecs = new ArrayList();
  private ColumnSpec optimColumnLockSpec = null;

  private ProcessOptimLockColumn processOptimLockColumn = null;

  /**
   * Constructs an instance.
   *
   * @param sqlBuilder            appropriate <code>UpdateSQLBuilder</code> instance that maps to the
   * <code>AbstractDomain</code> sub-class with the primary key.
   * @param colSpecs              list of <code>ColumnSpec</code>s.
   * @param tableName             name of table.
   * @param dataSourceProperties  Description of the Parameter
   */
  JRFUpdatePreparedStatement(UpdateSQLBuilder sqlBuilder,
                             List colSpecs,
                             String tableName,
                             DataSourceProperties dataSourceProperties) {
    super(dataSourceProperties);
    // Build the sql.
    super.sql = sqlBuilder.buildPreparedSQL(tableName, colSpecs);
    // Preprocess the column list and add all columns that are not
    // PK or optimistic locks.
    Iterator iterator = colSpecs.iterator();
    ColumnSpec aColumnSpec;
    while (iterator.hasNext()) {
      aColumnSpec = (ColumnSpec) iterator.next();
      if (aColumnSpec.isPrimaryKey()) {
        super.setPrimaryKeyColumnSpec(aColumnSpec);
      } else {// not a primary key

        if (aColumnSpec.isOptimisticLock()) {
          optimColumnLockSpec = aColumnSpec;
          if (aColumnSpec instanceof TimestampColumnSpecDbGen) {
            processOptimLockColumn = new ProcessTimestampColumn();
            continue;// This one does NOT get added.
          } else {// This one gets added.
            if (optimColumnLockSpec
                    instanceof net.sf.jrf.column.columnspecs.IntegerColumnSpec) {
              processOptimLockColumn = new ProcessInteger();
            } else if (optimColumnLockSpec
                    instanceof net.sf.jrf.column.columnspecs.ShortColumnSpec) {
              processOptimLockColumn = new ProcessShort();
            } else if (optimColumnLockSpec
                    instanceof net.sf.jrf.column.columnspecs.LongColumnSpec) {
              processOptimLockColumn = new ProcessLong();
            } else {
              throw new ConfigurationException("Unable to support " + optimColumnLockSpec.getColumnClass() +
                      "for optimistic lock column; expecting Short, Long or Integer");
            }
          }
        }
        if (!skipColumn(false, aColumnSpec)) {
          this.colSpecs.add(aColumnSpec);
        }
      }
    }
    // Got everything we need to go.
  }

  /**
   * Using the list of <code>ColumnSpec</code> instances, set the
   * prepared statement values from parameter.
   *
   * @param obj            Object that contains parameters to set.
   * @throws SQLException  if a JDBC set parameter method fails.
   */
  public void setPreparedValues(Object obj)
          throws SQLException {
    PersistentObject aPO = (PersistentObject) obj;
    if (processOptimLockColumn != null) {
      processOptimLockColumn.pre(aPO);
    }// Add op-lock column value = current + 1 (see above)
    Iterator iterator = colSpecs.iterator();
    int idx = 1;
    ColumnSpec aColumnSpec;
    while (iterator.hasNext()) {
      aColumnSpec = (ColumnSpec) iterator.next();
      setPreparedColumnValue(aColumnSpec, aColumnSpec.getValueFrom(aPO), idx);
      idx++;
    }
    idx = super.setPrimaryKeyPreparedValues(idx, obj);
    if (processOptimLockColumn != null) {
      processOptimLockColumn.post(idx, aPO);
    }// Put current op-lock column value.
  }

  private class ProcessTimestampColumn implements ProcessOptimLockColumn {
    public void pre(PersistentObject obj) {
    }

    public void post(int idx, PersistentObject aPO)
            throws SQLException {
      setPreparedColumnValue(optimColumnLockSpec,
              optimColumnLockSpec.getValueFrom(aPO), idx);
    }
  }

  private abstract class ProcessNumberColumn implements ProcessOptimLockColumn {
    Object currentValue;

    public void post(int idx, PersistentObject obj)
            throws SQLException {
      setPreparedColumnValue(optimColumnLockSpec, currentValue, idx);
    }
  }

  private class ProcessInteger extends ProcessNumberColumn {
    public void pre(PersistentObject aPO) {
      // Handle op lock columns new value.
      currentValue = optimColumnLockSpec.getValueFrom(aPO);
      int next = ((Integer) currentValue).intValue() + 1;
      if (next == Integer.MAX_VALUE) {
        next = 0;
      }
      optimColumnLockSpec.setValueTo(new Integer(next), aPO);
    }
  }

  private class ProcessShort extends ProcessNumberColumn {
    public void pre(PersistentObject aPO) {
      // Handle op lock columns new value.
      currentValue = optimColumnLockSpec.getValueFrom(aPO);
      short next = ((Short) currentValue).shortValue();
      next++;
      if (next == Short.MAX_VALUE) {
        next = 0;
      }
      optimColumnLockSpec.setValueTo(new Short(next), aPO);
    }
  }

  private class ProcessLong extends ProcessNumberColumn {
    public void pre(PersistentObject aPO) {
      // Handle op lock columns new value.
      currentValue = optimColumnLockSpec.getValueFrom(aPO);
      long next = ((Long) currentValue).longValue() + 1L;
      if (next == Long.MAX_VALUE) {
        next = 0L;
      }
      optimColumnLockSpec.setValueTo(new Long(next), aPO);
    }
  }

  private interface ProcessOptimLockColumn {
    public void pre(PersistentObject obj);

    public void post(int idx, PersistentObject obj)
            throws SQLException;
  }
}

