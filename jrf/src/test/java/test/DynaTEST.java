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
import net.sf.jrf.rowhandlers.*;
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.util.*;
import net.sf.jrf.column.*;
import net.sf.jrf.column.datawrappers.*;
import net.sf.jrf.exceptions.*;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Clob;
import java.sql.Blob;
import testgen.base.*;
import testgen.base.domains.*;
import testgen.comp.*;
import testgen.comp.domains.*;
import java.util.Properties;
import java.util.List;
import java.util.HashSet;
import java.util.Iterator;
import java.io.*;
import junit.framework.TestCase;
import junit.framework.Test;
import junit.framework.TestSuite;
import java.util.Calendar;
import org.apache.log4j.Category;
import net.sf.jrf.util.*;

import org.apache.commons.beanutils.BasicDynaClass;
import org.apache.commons.beanutils.DynaBean;
import org.apache.commons.beanutils.DynaProperty;
/**
 */
public class DynaTEST
    extends TestCase
  {

  private GroupPersonsDomain 		   i_groupPersonsDomain = null;
  private PersonsDomain 		   i_personsDomain = null;
  private GroupTypesDomain		   i_groupTypesDomain = null;
  private Master2Domain			   i_master2Domain = null;
  private Master3Domain			   i_master3Domain = null;
  private Detail2Domain			   i_detail2Domain = null;
  private Detail3Domain			   i_detail3Domain = null;
  private DOWTestKeyDomain		   i_dowKeyDomain = null;
  private DOWTestNullDomain		   i_dowNullDomain = null;
  private LOVTestDomain			   i_lovTestDomain = null;

  private DbCheckBaseDomain		   i_dbCheckBaseDomain = null;
  private DbCheckMissingColDomain 	   i_dbCheckMissingColDomain = null;
  private DbCheckNewColDomain		   i_dbCheckNewColDomain = null;
  private DbCheckScaleChangeDomain	   i_dbCheckScaleChangeDomain = null;
  private DbCheckSizeChangeDomain	   i_dbCheckSizeChangeDomain = null;
  private DbCheckTypeChangeDomain	   i_dbCheckTypeChangeDomain = null;
  private DbCheckNullChangeDomain          i_dbCheckNullChangeDomain = null;
  private PersistentObjectDynaClass c;

  private static final Category LOG = Category.getInstance(DynaTEST.class.getName());

  static {
    JRFProperties.getProperties().setProperty("useAutoSetupNewColumnMethodology","NO");
  }

  public DynaTEST(String testName)
  {
    super(testName);
  }


  public void tearDown() {
    System.out.println(getName()+" test is complete.");
  }

  public void setUp()
  {
    i_groupPersonsDomain = new GroupPersonsDomain();
    i_personsDomain = new PersonsDomain();
    i_groupTypesDomain = new GroupTypesDomain();
    i_master2Domain = new Master2Domain();
    i_master3Domain = new Master3Domain();
    i_detail2Domain = new Detail2Domain();
    i_detail3Domain = new Detail3Domain();
    i_dowKeyDomain = new DOWTestKeyDomain();
    i_dowNullDomain = new DOWTestNullDomain();
    i_lovTestDomain = new LOVTestDomain();
    i_dbCheckNewColDomain = new DbCheckNewColDomain();
    c = PersistentObjectDynaClass.createPersistentObjectDynaClass(
			i_dbCheckNewColDomain,
			net.sf.jrf.domain.PersistentObjectDynaBeanBase.class);
    LOG.info(c.toString());
  }

  public static Test suite() {
	TestSuite result = new TestSuite();
	for (int i = 0; i < TESTS.length; i++) {
		result.addTest(new  DynaTEST(TESTS[i]));
	}
	return result;
  }

  static private String TESTS[] = {
	"test000",
	"test001",
	"test002",
	"test003",
	"test004",
	"test005"
  };

  /***
	test000()
        is based on the following specification in source/xml/testdb.xml.
        Change the xml and the test will fail.
	Table tableName="DbCheckTest" objectName="DbCheckNewCol" description="DbCheckTest" 
		Column name="ID"
			objectName="ID"
			jrfImpl="IntegerColumnSpec"
			isPrimaryKey="true"
		/ 
		 Column name="Field1"
			objectName="Field1"
			nullable="false"
			jrfImpl="DoubleColumnSpec"
			precision="10"
			default="new Double(1.2)"
			maxValue="new Double(6.1)"
			minValue="new Double(4.3)"
			scale="2"
			description="Just a test"
		/ 
		 Column name="Field2"
			objectName="Field2"
			jrfImpl="IntegerColumnSpec"
			maxValue="new Integer(14)"
			description="Just a test"
		/ 
		 Column name="Name"
			objectName="Name"
			jrfImpl="StringColumnSpec"
			size="75"
			nullable="true"
			description="Name"
		 
		  ListOfValues value="John"/ 
		  ListOfValues value="Marcia"/ 
		  ListOfValues value="Susan"/ 
		 /Column 
			Column name="createDate"
			objectName="CreateDate"
			jrfImpl="DateColumnSpec"
			description="A date."
			writeOnce="true"
		/

	 /Table 


  **/
  public void test000() throws Exception {
	DynaProperty[] props = c.getDynaProperties();
	HashSet check = new HashSet();
	check.add("ID");
	check.add("field1");
	check.add("field2");
	check.add("name");
	check.add("encodedKey");
	check.add("createDate");

	for (int i = 0; i <props.length; i++) {
		PersistentObjectDynaProperty dp = PersistentObjectDynaProperty.getPOProperty(props[i]);
		if (dp == null)
			continue;
		if (dp.getName().equals("ID")) {
			this.assertTrue(dp.isRequired());
			this.assertNotNull(dp.getGetterSetter());
			//this.assertEquals(java.lang.Integer.class,dp.getType());
			this.assertEquals(int.class,dp.getType());
			this.assertTrue(dp.isDbColumn());
			this.assertTrue(dp.getMaxValue() == null);
			this.assertTrue(dp.getMinValue() == null);
			this.assertTrue(dp.getReadMethodName() == null);
			this.assertTrue(dp.getWriteMethodName() == null);
			this.assertTrue(dp.getListOfValues() == null);
			this.assertEquals(new Integer(0),dp.getDefaultValue());
			this.assertTrue(dp.isWriteOnce());
			check.remove("ID");	
		}
		else if (dp.getName().equals("field1")) {
			this.assertTrue(dp.isRequired());
			//this.assertEquals(java.lang.Double.class,dp.getType());
			this.assertEquals(double.class,dp.getType());
			this.assertNotNull(dp.getGetterSetter());
			this.assertTrue(dp.isDbColumn());
			this.assertEquals(new Double(6.1),dp.getMaxValue());
			this.assertEquals(new Double(4.3),dp.getMinValue());
			this.assertTrue(dp.getReadMethodName() == null);
			this.assertTrue(dp.getWriteMethodName() == null);
			this.assertTrue(dp.getListOfValues() == null);
			this.assertEquals(new Double(1.2),dp.getDefaultValue());
			this.assertTrue(dp.isWriteOnce() == false);
			check.remove("field1");	
		}
		else if (dp.getName().equals("field2")) {
			this.assertTrue(dp.isRequired());
			//this.assertEquals(java.lang.Integer.class,dp.getType());
			this.assertEquals(int.class,dp.getType());
			this.assertNotNull(dp.getGetterSetter());
			this.assertTrue(dp.isDbColumn());
			this.assertEquals(new Integer(0),dp.getDefaultValue());
			this.assertTrue(dp.getMinValue() == null);
			this.assertTrue(dp.getReadMethodName() == null);
			this.assertTrue(dp.getWriteMethodName() == null);
			this.assertTrue(dp.getListOfValues() == null);
			this.assertEquals(new Integer(14),dp.getMaxValue());
			this.assertTrue(dp.isWriteOnce() == false);
			check.remove("field2");	
		}
		else if (dp.getName().equals("name")) {
			this.assertTrue(dp.isRequired() == false);
			this.assertNotNull(dp.getGetterSetter());
			this.assertEquals(java.lang.String.class,dp.getType());
			this.assertTrue(dp.isDbColumn());
			this.assertTrue(dp.getMaxValue() == null);
			this.assertTrue(dp.getMinValue() == null);
			this.assertTrue(dp.getReadMethodName() == null);
			this.assertTrue(dp.getWriteMethodName() == null);
			this.assertNotNull(dp.getListOfValues());
			this.assertTrue(dp.getDefaultValue() == null);
			this.assertTrue(dp.isWriteOnce() == false);
			check.remove("name");
			// TODO handle list when generator is ready.	
		}
		else if (dp.getName().equals("encodedKey")) {
			this.assertTrue(dp.isRequired() == false);
			this.assertTrue(dp.getGetterSetter() == null);
			this.assertEquals("getEncodedKey",dp.getReadMethodName());
			this.assertNull(dp.getWriteMethodName());
			this.assertEquals(java.lang.String.class,dp.getType());
			this.assertTrue(dp.isDbColumn() == false);
			this.assertTrue(dp.getMaxValue() == null);
			this.assertTrue(dp.getMinValue() == null);
			this.assertTrue(dp.getListOfValues() == null);
			this.assertTrue(dp.isWriteOnce() == false);
			this.assertTrue(dp.getDefaultValue() == null);
			check.remove("encodedKey");
		}
		else if (dp.getName().equals("createDate")) {
			this.assertTrue(dp.isRequired() == true);
			this.assertTrue(dp.getGetterSetter() != null);
			this.assertTrue(dp.isDbColumn());
			this.assertTrue(dp.getReadMethodName() == null);
			this.assertTrue(dp.getWriteMethodName() == null);
			this.assertEquals(java.util.Date.class,dp.getType());
			this.assertTrue(dp.getMinValue() == null);
			this.assertTrue(dp.getMaxValue() == null);
			this.assertTrue(dp.getListOfValues() == null);
			this.assertTrue(dp.isWriteOnce());
			check.remove("createDate");
		}
	}	
	if (check.size() != 0)
		this.fail("class does not contain all properties. Missing: "+check);
	
  }

  // Test creating a bean and generate a PO from it.
  public void test001() throws Exception {
	DynaBean bean = c.newInstance();
	PersistentObjectDynaClass.resetBean((PersistentObjectDynaBean) bean);
	// Set some legit values.
	bean.set("ID",new Integer(33));
	bean.set("field2",new Integer(11));
	bean.set("field1",new Double(2.3));
	bean.set("name","John");
	// Try bad values.
	try {
		bean.set("junk","jadd");
		this.fail("Junk does not exist as a property.");
	}
	catch (Exception ex) {
	}
	// Generate PO.
	DbCheckNewCol po = (DbCheckNewCol) PersistentObjectDynaClass.beanToPersistentObject((PersistentObjectDynaBean) bean);
	this.assertEquals(33,po.getID());
	this.assertEquals("John",po.getName());
	this.assertEquals(11,po.getField2());
	this.assertEquals("33",po.getEncodedKey());
	this.assertTrue(po.hasNewPersistentState());
	this.assertEquals(2.3,po.getField1(),0); 
	this.assertTrue(po.hasNewPersistentState());

 }

 // Test reset to default values.
 public void test002() throws Exception {
	DynaBean bean = c.newInstance();
	PersistentObjectDynaClass.resetBean((PersistentObjectDynaBean) bean);
	//this.assertTrue(bean.get("ID") == null);	
	Object o = bean.get("ID");
	this.assertEquals(new Integer(0),bean.get("ID"));	
	this.assertEquals(new Double(1.2),bean.get("field1"));	
	//this.assertTrue(bean.get("field2") == null);
	this.assertEquals(new Integer(0),bean.get("field2"));
	this.assertNull(bean.get("name"));
	
	DbCheckNewCol po = (DbCheckNewCol) PersistentObjectDynaClass.beanToPersistentObject(
						(PersistentObjectDynaBean) bean);
	this.assertEquals(0,po.getID());
	this.assertNull(po.getName());
	this.assertEquals(0,po.getField2());
	this.assertTrue(po.hasNewPersistentState());
	this.assertEquals(1.2,po.getField1(),0); 

 }

 // Test updating bean with PersistentObject.
 public void test003() throws Exception {
	DbCheckNewCol po = new DbCheckNewCol();
	po.setID(44);
	po.setName("Marcia");
	po.setField1(2.33);
	DynaBean bean = c.newInstance();
        PersistentObjectDynaClass.persistentObjectToBean(po,(PersistentObjectDynaBean) bean);
	this.assertEquals(new Integer(44),bean.get("ID"));	
	this.assertEquals(new Double(2.33),bean.get("field1"));	
	this.assertEquals("Marcia",bean.get("name"));
	this.assertEquals(bean.get("field2"),new Integer(0));
 }

 // Test updating existing PersistentObject with a bean
 // (i.e. mimick a user interface process where an existing PO is 
 // posted as a bean, edited, and then converted back to the
 // PO for database update.
 public void test004() throws Exception {
	// Assume this is pulled from a database.
	DbCheckNewCol po = new DbCheckNewCol();
	po.setID(44);
	po.setName("Marcia");
	po.setField1(2.33);
	po.setField2(9);
	po.forceCurrentPersistentState(); // Simulate pull for DB

	DynaBean bean = c.newInstance();
        PersistentObjectDynaClass.persistentObjectToBean(po,(PersistentObjectDynaBean) bean);

	// Now simulate user interfaces by updating different values in the bean.
	// Field1 is left untouched.
	bean.set("name","John");
	bean.set("field2",new Integer(7));
	bean.set("ID",new Integer(44444)); 	// Should be ignored.

	// Set the values from the bean into the existing PO (Must likely saved on 
	// a session handle).
	PersistentObjectDynaClass.beanToPersistentObject((PersistentObjectDynaBean) bean,po);

	// Now check the goods.
	this.assertEquals("John",po.getName());
	this.assertEquals(7,po.getField2());
	this.assertEquals(2.33,po.getField1(),0); 
	this.assertEquals(44,po.getID());
	this.assertTrue(po.hasModifiedPersistentState());

	// Record then gets updated to the DB.
 }

 // Test no-change return by setting bean to all existing values.
 public void test005() throws Exception {
	DbCheckNewCol po = new DbCheckNewCol();
	po.setID(44);
	po.setName("Marcia");
	po.setField1(2.33);
	po.setField2(9);
	java.util.Date now = new java.util.Date();
	po.setCreateDate(now);
	po.forceCurrentPersistentState(); // Simulate pull for DB

	DynaBean bean = c.newInstance();
        PersistentObjectDynaClass.persistentObjectToBean(po,(PersistentObjectDynaBean) bean);

	bean.set("name","Marcia");
	bean.set("field2",new Integer(9));
	bean.set("field1",new Double(2.33));
	bean.set("ID",new Integer(44444)); 	// Should be ignored.
	bean.set("createDate",null);		// ditto	
        PersistentObjectDynaClass.beanToPersistentObject((PersistentObjectDynaBean) bean,po);
	// Make sure date is untouched
	this.assertEquals(now,po.getCreateDate());
	this.assertEquals(44,po.getID());
	this.assertTrue(po.hasCurrentPersistentState());
 }
}
