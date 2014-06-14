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
package test;

import net.sf.jrf.sql.*;
import net.sf.jrf.*;
import net.sf.jrf.domain.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.join.*;
import net.sf.jrf.join.joincolumns.*;
import java.util.List;
import net.sf.jrf.exceptions.DomainException;

/**
 * This is a Domain class for a natural primary key object.  This class is
 * used by DomainTest.
 */
public class PartDomain
    extends AbstractDomain
  {

  protected void setup()
    {
    this.setTableName("Part");
    PersistentObjectCache.setCacheAll(this.getClass(),true);
    // Column Specs
    this.addColumnSpec(
        new StringColumnSpec(
            "Code",  // Column Name
            "getCode",
            "setCode",
            DEFAULT_TO_NULL,
            NATURAL_PRIMARY_KEY));
    this.addColumnSpec(
        new StringColumnSpec(
            "Name",
            "getName",
            "setName",
            DEFAULT_TO_NULL,
            REQUIRED,
            UNIQUE));
    this.addColumnSpec(
        new IntegerColumnSpec(
            "ManufacturerId",
            "getManufacturerId",
            "setManufacturerId",
            DEFAULT_TO_NULL));
    this.addColumnSpec(
        new StringColumnSpec(
            "ManufacturerCode",
            "getManufacturerCode",
            "setManufacturerCode",
            DEFAULT_TO_NULL));
    this.addColumnSpec(
        new IntegerColumnSpec(
            "Version",
            "getVersion",
            "setVersion",
            DEFAULT_TO_ZERO,
            OPTIMISTIC_LOCK));

    // Join Table(s)
    JoinTable joinTable =
            new OuterJoinTable(
                "Manufacturer",  // table name
                "ManufacturerId,ManufacturerCode", // main (left) table columns
                "Id,Code");      // right join table columns
    joinTable.addJoinColumn(
        new StringJoinColumn(
            "Name",                   // Column Name
            "ManufacturerName",       // Alias in case of column name conflict
            "setManufacturerName"));  // Setter method name
    this.addJoinTable(joinTable);
    } // setup()


  public PersistentObject newPersistentObject()
    {
    return new Part();
    }


  /**
   * Custom SQL for doing a specialized search.
   *
   * @param s a value of type 'String'
   * @return a value of type 'List'
   */
  public List findNameStartingWith(String s)
          throws DomainException
    {
    return this.findWhere(
        this.getTableAlias() + ".Name LIKE '" + s + "%'");
    }


  } // PartDomain





