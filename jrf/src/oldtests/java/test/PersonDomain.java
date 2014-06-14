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
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.column.*;
import java.util.List;


/**
 * This is a Domain class for a sequenced primary key object.  This class is
 * used by DomainTest.
 */
public class PersonDomain
    extends AbstractDomain
  {

  protected void setup()
    {
    this.setTableName("Person");

    this.setSequenceName("PersonTestSequence");
    // Column Specs
    this.addColumnSpec(
        new LongColumnSpec(
            "PersonId",
            "getPersonId",
            "setPersonId",
            ColumnSpec.DEFAULT_TO_NULL,
            ColumnSpec.SEQUENCED_PRIMARY_KEY));
//Subtype is not necessary yet since we can only access via the subtype domain
//class.
//     this.addColumnSpec(
//         new StringColumnSpec(
//             "SubtypeCode",
//             "getSubtypeCode",
//             "setSubtypeCode",
//             ColumnSpec.DEFAULT_TO_NULL,
//             ColumnSpec.SUBTYPE_IDENTIFIER));
    this.addColumnSpec(
        new StringColumnSpec(
            "Name",
            "getName",
            "setName",
            ColumnSpec.DEFAULT_TO_EMPTY_STRING,
            ColumnSpec.REQUIRED,
            ColumnSpec.UNIQUE));
    this.addColumnSpec(
        new ShortColumnSpec(
            "Age",
            "getAge",
            "setAge",
            ColumnSpec.DEFAULT_TO_NULL,
            ColumnSpec.UNIQUE, // unique for testing purposes.
            ColumnSpec.REQUIRED));
    this.addColumnSpec(
        new BooleanColumnSpec(
            "Wealthy",
            "isWealthy",
            "setWealthy",
            ColumnSpec.DEFAULT_TO_FALSE));
    this.addColumnSpec(
        new TimestampColumnSpecDbGen(
            "LastUpdated",
            "getLastUpdated",
            "setLastUpdated",
            ColumnSpec.DEFAULT_TO_NOW,
            ColumnSpec.OPTIMISTIC_LOCK));
    } // setup()


  public PersistentObject newPersistentObject()
    {
    return new Person();
    }


  public Person findForName(String name)
    {
    List list = this.findWhere(
        this.getTableAlias() + ".name = " + this.delimitString(name));
    if (list.size() > 0)
        {
        return (Person) list.get(0);
        }
    return null;
    }

  } // PersonDomain





