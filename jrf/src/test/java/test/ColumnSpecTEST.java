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
import net.sf.jrf.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;

import java.sql.Timestamp;

import junit.framework.TestCase;


/**
 *
 */
public class ColumnSpecTEST
    extends TestCase
  {


  public ColumnSpecTEST(String testName)
    {
    super(testName);
    }


  /**
   * This method occurs before each test method is executed.
   */
  public void setUp()
    {
    }


  public void testNormal()
          throws Exception
    {
    ColumnSpec attr = null;

    attr = new IntegerColumnSpec(
        "PersonId",
        "getPersonId",
        "setPersonId",
        ColumnSpec.DEFAULT_TO_NULL,
        ColumnSpec.SEQUENCED_PRIMARY_KEY);
    this.assertEquals("PersonId", attr.getColumnName());
    this.assertEquals("getPersonId", attr.getGetter());
    this.assertEquals("setPersonId", attr.getSetter());
    this.assertNull(attr.getDefault());
    this.assertTrue(attr.isPrimaryKey());
    this.assertTrue(!attr.isOptimisticLock());
    this.assertTrue(!attr.isUnique());
    this.assertTrue(!attr.isRequired());

    attr = new StringColumnSpec(
        "Name",
        "getName",
        "setName",
        ColumnSpec.DEFAULT_TO_EMPTY_STRING,
        ColumnSpec.UNIQUE,
        ColumnSpec.REQUIRED);
    this.assertEquals(String.class, attr.getDefault().getClass());
    this.assertTrue(!attr.isPrimaryKey());
    this.assertTrue(!attr.isOptimisticLock());
    this.assertTrue(attr.isUnique());
    this.assertTrue(attr.isRequired());

    attr = new IntegerColumnSpec(
        "Age",
        "getAge",
        "setAge",
        ColumnSpec.DEFAULT_TO_ZERO);
    this.assertTrue(attr.getDefault() instanceof Integer);
    this.assertTrue(!attr.isPrimaryKey());
    this.assertTrue(!attr.isOptimisticLock());
    this.assertTrue(!attr.isUnique());
    this.assertTrue(!attr.isRequired());

    attr = new BooleanColumnSpec(
        "Intelligent",
        "isIntelligent",
        "setIntelligent",
        ColumnSpec.DEFAULT_TO_FALSE);
    this.assertTrue(attr.getDefault() instanceof Boolean);
    this.assertTrue(!attr.isPrimaryKey());
    this.assertTrue(!attr.isOptimisticLock());
    this.assertTrue(!attr.isUnique());
    this.assertTrue(!attr.isRequired());

    attr = new TimestampColumnSpec(
        "UpdatedOn",
        "getUpdatedOn",
        "setUpdatedOn",
        ColumnSpec.DEFAULT_TO_NOW,
        ColumnSpec.OPTIMISTIC_LOCK);
    this.assertTrue(attr.getDefault() instanceof Timestamp);
    this.assertTrue(!attr.isPrimaryKey());
    this.assertTrue(attr.isOptimisticLock());
    this.assertTrue(!attr.isUnique());
    this.assertTrue(!attr.isRequired());

    } // test999Normal()



  public void testUnusual()
          throws Exception
    {
    ColumnSpec attr = null;

    attr = new IntegerColumnSpec(
        "Irrelevant",
        "getIrrelevant",
        "setIrrelevant",
        ColumnSpec.DEFAULT_TO_NULL,
        ColumnSpec.SEQUENCED_PRIMARY_KEY,
        ColumnSpec.OPTIMISTIC_LOCK,
        ColumnSpec.REQUIRED);
    this.assertTrue(attr.isPrimaryKey());
    this.assertTrue(!attr.isOptimisticLock());
    this.assertTrue(!attr.isUnique());
    this.assertTrue(!attr.isRequired());

    attr = new IntegerColumnSpec(
        "Irrelevant",
        "getIrrelevant",
        "setIrrelevant",
        ColumnSpec.DEFAULT_TO_NULL,
        ColumnSpec.REQUIRED,
        ColumnSpec.UNIQUE,
        ColumnSpec.OPTIMISTIC_LOCK);
    this.assertTrue(!attr.isPrimaryKey());
    this.assertTrue(attr.isOptimisticLock());
    this.assertTrue(!attr.isUnique());
    this.assertTrue(!attr.isRequired());
    } // test999Unusual()



  } // ColumnSpecTEST
