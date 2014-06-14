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
import java.io.*;
import junit.framework.TestCase;
import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Category;


/**
 *  This tests the Domain framework using an Oracle database.
 */
public class DomainTEST
    extends TestCase
  {

  private PersonDomain     		   i_personDomain = null;
  private PartDomain       		   i_partDomain = null;
  private ManufacturerDomain 		   i_manufacturerDomain = null;
  private EmployeeDomain   		   i_employeeDomain = null;
  private TestByteArrayDomain		   i_byteArrayDomain = null;
  private TestClobDomain	 	   	   i_clobDomain = null;
  private TestBlobDomain 		   i_blobDomain = null;
  private TestBinaryStreamDomain 	   i_binaryStreamDomain = null;
  private CompoundSeqTest1Domain 	   i_compSeqTest1Domain = null;
  private static String dbType;
  private static Long s_jonathanID = null;
  private static HashSet doNotRun; 

  private static Manufacturer s_manufacturer = null;

  private static final Category LOG = Category.getInstance(DomainTEST.class.getName());

  private static String joe = PersonDomain.class.getName();

  public DomainTEST(String testName) {
	super(testName);
  }

  public static String getCreateTableParams() {
	if (dbType.equals("mysql") && JRFProperties.propertyIsTrue("mysql.useInnoDB"))
		return "TYPE=InnoDB";	
	return null;
  }

  static {
        dbType = JRFProperties.getStringProperty("dbtype","");
  	// Keep a hash of tests that should NOT be run for vendor type.
	doNotRun = new HashSet();
        if (!JRFProperties.propertyIsTrue(dbType+".binarystreamsupport")) {
  		doNotRun.add("test910TestBinaryStream");
	}
        if (!JRFProperties.propertyIsTrue(dbType+".blobsupport")) {
  		doNotRun.add("test920TestBlob");
	}
        if (!JRFProperties.propertyIsTrue(dbType+".clobsupport")) {
        	doNotRun.add("test930TestClob");
        	doNotRun.add("test931TestClob");
        	doNotRun.add("test932TestClob");
	}
	// TODO -- add another property in DataSourceProperties for binary column support.
	if (dbType.equals("postgres")) {
 		doNotRun.add("test901TestByteArray");
 		doNotRun.add("test902TestByteArray");
 		doNotRun.add("test903TestByteArray");
 		doNotRun.add("test600TestCompSeq");	// FIXME -- this should work. Find out why it doesn't.
	}
	else if (dbType.equals("mysql")) {	// MySQL jar has problems with timestamp columns -- 
 		doNotRun.add("test500TimestampOptimisticLocking"); 
 		doNotRun.add("test030UpdateSequencedKey");
  		doNotRun.add("test500SubtypeTable");
	}
	else if (dbType.equals("hsql")) {
 		doNotRun.add("test600TestCompSeq");	// Not supported currently.
	}
  }
  private static final String [] TESTS = {
 "test000Setup",
 "test010InsertSequencedKey",
 "test011InsertCompoundKey",
 "test012InsertNaturalKey",
 "test020ReadSequencedKey",
 "test020ReadNaturalKey",
 "test020ReadCompoundKey",
 "test021ReadCompoundKey",
 "test023ReadCompoundKey",
 "test025ValidateSequencedKey",
 "test025ValidateNaturalKey",
 "test025ValidateCompoundKey",
 "test030UpdateSequencedKey",
 "test030UpdateNaturalKey",
 "test030UpdateCompoundKey",
 "test040DeleteSequencedKey",
 "test041DeleteNaturalKey",
 "test050ReturnSavedObject",
 "test020ResultPageIterator",
 "test500IntegerOptimisticLocking",
 "test500TimestampOptimisticLocking",
 "test500EncodeDecodeCompoundPrimaryKey",
 "test500EncodeDecodeSinglePrimaryKey",
 "test500ManualTransaction",
 "test500SubtypeTable",
 "test600TestCompSeq",
 "test900DeleteCompoundKey",
 "test901TestByteArray",
 "test902TestByteArray",
 "test903TestByteArray",
 "test910TestBinaryStream",
 "test920TestBlob",
 "test930TestClob",
 "test931TestClob",
 "test932TestClob",
 "cleanUp"
  };


     public static Test suite() {
	TestSuite result = new TestSuite();
	for (int i = 0; i < TESTS.length; i++) {
		if (!doNotRun.contains(TESTS[i]) ) 
			result.addTest(new  DomainTEST(TESTS[i]));
	}
	return result;
     }

  /**
   * This method occurs before each test method is executed.
   */
  public void setUp()
    {

    i_partDomain = new PartDomain();
    i_manufacturerDomain = new ManufacturerDomain();
    i_personDomain = new PersonDomain();
    i_employeeDomain = new EmployeeDomain();
    i_compSeqTest1Domain = new CompoundSeqTest1Domain(); 

    } // setUp()


   public void cleanUp() throws Exception {
    boolean ignoreErrors = true;
    i_personDomain.dropTable(ignoreErrors);
    i_partDomain.dropTable(ignoreErrors);
    i_manufacturerDomain.dropTable(ignoreErrors);
    i_employeeDomain.dropTable(ignoreErrors);
    i_binaryStreamDomain = new TestBinaryStreamDomain();
    i_binaryStreamDomain.dropTable(ignoreErrors);
    i_byteArrayDomain = new TestByteArrayDomain();
    i_byteArrayDomain.dropTable(ignoreErrors);
    i_clobDomain = new TestClobDomain();
    i_clobDomain.dropTable(ignoreErrors);
    i_blobDomain = new TestBlobDomain();
    i_blobDomain.dropTable(ignoreErrors);
    i_compSeqTest1Domain = new CompoundSeqTest1Domain(); 
    i_compSeqTest1Domain.dropTable(ignoreErrors);
   }

  public void tearDown() {
        System.out.println(getName()+" test is complete. ");
  }

  public void test000Setup()
          throws Exception
  {
    cleanUp();
    String tableparams = getCreateTableParams();
    try {
        i_personDomain.createTable(null,tableparams);
        i_partDomain.createTable(null,tableparams);
        i_manufacturerDomain.createTable(null,tableparams);
        i_employeeDomain.createTable(null,tableparams);
    	i_compSeqTest1Domain.createTable(null,tableparams);
	DatabasePolicy dp = i_compSeqTest1Domain.getDatabasePolicy();
	if (dp.getSequenceSupportType() == DatabasePolicy.SEQUENCE_SUPPORT_EXTERNAL ) {
		// Create the sequence since createTable() does not currently support
		// automatic creation of an external sequence for embedded sequences in 
		// compound primary keys.
		JRFConnection conn = i_compSeqTest1Domain.getJRFConnection();
		dp.createSequence(
			i_compSeqTest1Domain,null,conn.getStatementExecuter());
		conn.commit();
		conn.close();
	}
    }
    catch (Exception e) {
        System.out.println("Setup failed.  Test aborted.");
        e.printStackTrace();
        System.exit(1);
    }
  } // test000Setup()



  public void test010InsertSequencedKey()
          throws Exception
    {
    Person person = null;
    Person savedPerson = null;

    person = new Person();
    person.setName("Darryl");
    person.setAge(new Short((short)27));
    person.setWealthy(false);
    savedPerson = (Person) i_personDomain.save(person);

    person = new Person();
    person.setName("CJ");
    person.setAge(new Short((short)24));
    person.setWealthy(true);
    i_personDomain.save(person);

    person = new Person();
    person.setName("Karin");
    person.setAge(new Short((short)33));
    person.setWealthy(true);
    i_personDomain.save(person);

    person = new Person();
    this.assertTrue(person.hasNewPersistentState());
    person.setName("Jonathan");
    person.setAge(new Short((short)34));
    person.setWealthy(false);
    this.assertNull(person.getLastUpdated());
    savedPerson = (Person)
            i_personDomain.save(person);
    this.assertNotNull(savedPerson);
    s_jonathanID = savedPerson.getPersonId(); // will be used later
    this.assertNotNull(s_jonathanID);
    this.assertTrue(savedPerson.hasCurrentPersistentState());
    this.assertNotNull(savedPerson.getLastUpdated());
    this.assertTrue(
        !savedPerson.getLastUpdated().equals(JRFConstants.CURRENT_TIMESTAMP));
    } // test010InsertSequencedKey()


  public void test011InsertCompoundKey()
          throws Exception
    {
    Manufacturer manufacturer = null;
    Manufacturer savedManufacturer = null;

    manufacturer = new Manufacturer();
    this.assertTrue(manufacturer.hasNewPersistentState());
    manufacturer.setId(new Integer(123));
    manufacturer.setCode("ACME1");
    s_manufacturer = manufacturer; // We'll use this later
    manufacturer.setName("Acme Mfgr 1");
    i_manufacturerDomain.save(manufacturer);

    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(456));
    manufacturer.setCode("ACME2");
    manufacturer.setName("Acme Mfgr 2");
    i_manufacturerDomain.save(manufacturer);

    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(789));
    manufacturer.setCode("ACME3");
    manufacturer.setName("Acme Mfgr 3");
    savedManufacturer = (Manufacturer)
            i_manufacturerDomain.save(manufacturer);
    this.assertTrue(savedManufacturer.hasCurrentPersistentState());
    this.assertEquals("ACME3", savedManufacturer.getCode());
    this.assertEquals("Acme Mfgr 3", savedManufacturer.getName());

    // This one is not referred to in Part table.
    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(9999));
    manufacturer.setCode("ACME4");
    manufacturer.setName("Acme Mfgr 4");
    i_manufacturerDomain.save(manufacturer);

    // These rows are being inserted so the paging mechanism can be tested.
    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(10001));
    manufacturer.setCode("TEST1");
    manufacturer.setName("Test Mfgr 1");
    i_manufacturerDomain.save(manufacturer);
    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(10002));
    manufacturer.setCode("TEST2");
    manufacturer.setName("Test Mfgr 2");
    i_manufacturerDomain.save(manufacturer);
    } // test011InsertTestCompoundKey()


  /**
   * This table uses a natural primary key that the developer must assign.
   */
  public void test012InsertNaturalKey()
          throws Exception
    {
    Part part = null;
    Part savedPart = null;
    i_partDomain.setReturnSavedObject(false);

    part = new Part();
    this.assertTrue(part.hasNewPersistentState());
    part.setCode("WSH001");
    part.setName("Washer");
    part.setManufacturerId(new Integer(123));
    part.setManufacturerCode("ACME1");
    i_partDomain.save(part);
    this.assertTrue("part should have current persistent state because "
                + "ReturnSavedObject is set to false in the domain",
                part.hasCurrentPersistentState());

    part = new Part();
    part.setCode("GRM020");
    part.setName("Grommet");
    part.setManufacturerId(new Integer(456));
    part.setManufacturerCode("ACME2");
    i_partDomain.save(part);

    part = new Part();
    part.setCode("WDG002");
    part.setName("Widget");
    // Don't set Manufacturer Id and Code since we need to test outer join
    // part.setManufacturerId(new Integer(789));
    // part.setManufacturerCode("ACME3")

    i_partDomain.setReturnSavedObject(true);
    savedPart = (Part) i_partDomain.save(part);
    /** No longer tested -- no timestamps in this table.

    this.assertTrue("part should have dead persistent state because "
                + "ReturnSavedObject is set to true in the domain",
                part.hasDeadPersistentState());
    */
    // If after the save, the part is not found, then the outer join logic
    // is not working.
    this.assertNotNull("Outer join logic not working", savedPart);
    this.assertTrue(savedPart.hasCurrentPersistentState());
    this.assertEquals("Widget", savedPart.getName());
    this.assertEquals("WDG002", savedPart.getCode());
    /* No time stamp columns = no dead state! JGE
    try
        {
        i_partDomain.save(part);
        this.fail("DatabaseException not thrown when saving a \"dead\" part");
        }
    catch(DatabaseException de)
        {  // We expect this to happen
        }
    */
    } // test012InsertNaturalKey


  public void test020ReadSequencedKey()
          throws Exception
    {
    List v = null;
    Person person = null;

    v = i_personDomain.findAll();
    this.assertEquals(4, v.size());

    person = (Person) i_personDomain.find(s_jonathanID);
    this.assertNotNull(person);
    this.assertEquals("Jonathan", person.getName());
    this.assertNotNull(person.getLastUpdated());

    } // test020ReadSequencedKey()


  public void test020ReadNaturalKey()
          throws Exception
    {
    List v = null;
    Part part = null;

    v = i_partDomain.findAll();
    this.assertEquals(3, v.size());
    part = (Part) i_partDomain.find("GRM020");
    this.assertNotNull(part);
    this.assertEquals("Grommet", part.getName());
    // make sure the join worked OK.
    this.assertNotNull(part.getManufacturerName());
    this.assertEquals("Acme Mfgr 2", part.getManufacturerName());

    v = i_partDomain.findNameStartingWith("Gro");
    this.assertEquals(1, v.size());
    } // test020ReadNaturalKey()


  public void test020ReadCompoundKey()
          throws Exception
    {
    List v = null;
    Manufacturer manufacturer1 = null;
    Manufacturer manufacturer2 = null;

    v = i_manufacturerDomain.findAll();
    this.assertEquals(6, v.size());
    manufacturer1 = (Manufacturer) v.get(0);
    manufacturer2 = (Manufacturer)
            i_manufacturerDomain.find(manufacturer1);
    this.assertNotNull(manufacturer2);
    this.assertEquals(manufacturer1.getName(),manufacturer2.getName());
    } // test020ReadCompoundKey()


  public void test021ReadCompoundKey()
          throws Exception
    {
    // Test both primary key application row handler and handling of Compound key
    // record retrieval for prepared statements in AbstractDomain.
    Manufacturer manufacturer1 = null;
    List v = null;
    v = i_manufacturerDomain.findAll();
    manufacturer1 = (Manufacturer) v.get(0);
    ApplicationRowHandlerPrimaryKey pkHandler = new ApplicationRowHandlerPrimaryKey();
    Manufacturer result = (Manufacturer) i_manufacturerDomain.find(manufacturer1, pkHandler);
    this.assertNotNull(result);


    } // test021ReadCompoundKey()

  public void test023ReadCompoundKey()
          throws Exception {
    // Test the ability to throw an IllegalArgumentException for a non-compound key arg on find()
    try {
        i_manufacturerDomain.find("BADKEY");
        fail("IllegalArgumentException shhould have been thrown.");
    }
    catch (IllegalArgumentException ex) {
    }
  }

  public void test025ValidateSequencedKey()
          throws Exception
    {
    Person person = new Person();
    try
        { // Age is required.
        i_personDomain.validate(person);
        this.fail("MissingAttributeException should have been thrown.");
        }
    catch (MissingAttributeException e)
        { }
    // This test is set up for using validateUnique(). If not in use,
    // don't test.
    if (!checkSupport("supportValidateUnique","validateUnique is not in use. Skipping test."))
        return;

    // Test the DuplicateRowException on an insert
    person = new Person();
    person.setAge(new Short((short)12));
    person.setName("Jonathan");
    try
        { // "Jonathan" is already in the database.
        i_personDomain.validate(person);
        this.fail("DuplicateRowException should have been thrown.");
        }
    catch (DuplicateRowException e)
        { }

    // Test the DuplicateRowException on an update
    person = (Person) i_personDomain.find(new Long(1));
    person.setName("Jonathan");
    try
        { // Name matches one ("Jonathan") already in the database.
        i_personDomain.validate(person);
        this.fail("DuplicateRowException should have been thrown.");
        }
    catch (DuplicateRowException e)
        { }
    } // test025ValidateSequencedKey()



  public void test025ValidateNaturalKey()
          throws Exception
    {
    Part part = null;

    // Testing the missing attribute and duplicate row stuff
    part = new Part();
    // Set everything but the primary key
    part.setName("Howdy Doody");
    part.setManufacturerId(new Integer(8888));
    part.setManufacturerCode("ACMEx");
    try
        { // Natural primary key should always be required.
        i_partDomain.validate(part);
        this.fail("MissingAttributeException should have been thrown.");
        }
    catch (MissingAttributeException e)
        { }

    part = new Part();
    part.setCode("ELB012");
    part.setManufacturerId(new Integer(123));
    part.setManufacturerCode("ACME1");
    try
        { // Name is missing.
        i_partDomain.validate(part);
        this.fail("MissingAttributeException should have been thrown.");
        }
    catch (MissingAttributeException e)
        { }

    boolean dupKeySupport = checkSupport("supportDuplicateKeyErrorCheck","Duplicate error checks not in use. Skipping part of test.");
    if (checkSupport("supportValidateUnique","validateUnique is not in use. Skipping part of test."))
    {
            part.setName("Widget"); // intentionally duplicate
        try
         { // Name matches one already in the database.
                i_partDomain.validate(part);
                this.fail("DuplicateRowException should have been thrown by AbstractDomain.validate().");
         }
            catch (DuplicateRowException e)
         { }
    }
    else if (dupKeySupport)
       {
         part.setName("DUPTEST1");
         part.forceNewPersistentState();
             i_partDomain.save(part);
         try {	// Try to insert the same value.
            part.forceNewPersistentState();
                i_partDomain.save(part);
                this.fail("DuplicateRowException should have been thrown by AbstractDomain.save().");
           }
              catch (DuplicateRowException e)
           { }
              catch (Exception ex)
           {
             if (ex instanceof DatabaseException) {
                DatabaseException d = (DatabaseException) ex;
                Exception wrapped = d.getOriginalException();
                if (wrapped instanceof SQLException) {
                   SQLException s = (SQLException) wrapped;
                   this.fail("SQLException thrown instead of DuplicateRowException. Error code was "+s.getErrorCode()+
                    ". This code should be the one returned from DatabasePolicy.getDuplicateKeyErrorCode()\n"+s.getMessage());
                }
            }
            else
             throw ex;
           }
          }


    } // test025ValidateNaturalKey()


  public void test025ValidateCompoundKey()
          throws Exception
    {
    Manufacturer manufacturer = null;

    // Test the duplicate and missing attribute stuff.
    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(1));
    manufacturer.setCode("BOGUS");
    try
        { // Name is missing
        i_manufacturerDomain.validate(manufacturer);
        this.fail("MissingAttributeException should have been thrown.");
        }
    catch (MissingAttributeException e)
        { }
    manufacturer.setName("Acme Mfgr 2");
    if (!checkSupport("supportValidateUnique","validateUnique is not in use. Skipping test."))
        return;
    try
        { // Name matches an existing db row.
        i_manufacturerDomain.validate(manufacturer);
        this.fail("DuplicatRowException should have been thrown.");
        }
    catch (DuplicateRowException e)
        { }
    } // test025ValidateCompoundKey()


  public void test030UpdateSequencedKey()
          throws Exception
    {
    List v = null;
    Person person = null;
    Person updatedPerson = null;

    // Find a person in the database and update him.
    person = (Person) i_personDomain.find(new Long(1));
    this.assertNotNull(person);
    this.assertTrue(person.hasCurrentPersistentState());
    person.setAge(new Short((short)88));
    this.assertTrue(person.hasModifiedPersistentState());
    Timestamp oldTimestamp = person.getLastUpdated();
    updatedPerson = (Person) i_personDomain.save(person);
    this.assertTrue(updatedPerson.hasCurrentPersistentState());

    // Make sure the age was updated.
    this.assertEquals(new Short((short)88), updatedPerson.getAge());

    // Make sure the optimistic lock timestamp was updated.
    this.assertNotNull(oldTimestamp);
    this.assertNotNull(updatedPerson.getLastUpdated());
    this.assertTrue(
        !oldTimestamp.equals(updatedPerson.getLastUpdated()));
    } // test020UpdateSequencedKey()


  public void test030UpdateNaturalKey()
          throws Exception
    {
    List v = null;
    Part part = null;
    Part updatedPart = null;

    // Find a part in the database and update it.
    part = (Part) i_partDomain.find("WDG002");
    this.assertTrue(part.hasCurrentPersistentState());
    part.setName("Woodget");
    this.assertTrue(part.hasModifiedPersistentState());
    updatedPart = (Part) i_partDomain.save(part);
    this.assertTrue(updatedPart.hasCurrentPersistentState());

    // Make sure the name was updated.
    this.assertEquals("Woodget", updatedPart.getName());
    part = (Part) i_partDomain.find("WDG002");
    this.assertEquals("Woodget", part.getName());
    } // test030UpdateNaturalKey()


  public void test030UpdateCompoundKey()
          throws Exception
    {
    List v = null;
    Manufacturer manufacturer = null;
    Manufacturer updatedManufacturer = null;

    // Find a manufacturer in the database and update it.
    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(789));
    manufacturer.setCode("ACME3");
    manufacturer = (Manufacturer)
            i_manufacturerDomain.find(manufacturer);
    this.assertTrue(manufacturer.hasCurrentPersistentState());
    manufacturer.setName("Changed Acme Mfgr 3");
    this.assertTrue(manufacturer.hasModifiedPersistentState());
    updatedManufacturer = (Manufacturer)
            i_manufacturerDomain.save(manufacturer);
    this.assertTrue(updatedManufacturer.hasCurrentPersistentState());

    // Make sure the name was updated.
    this.assertEquals("Changed Acme Mfgr 3", updatedManufacturer.getName());

    // Make double sure the name was updated after finding it.
    manufacturer = (Manufacturer)
            i_manufacturerDomain.find(manufacturer);
    this.assertEquals("Changed Acme Mfgr 3", manufacturer.getName());
    } // test030UpdateCompoundKey()


  public void test040DeleteSequencedKey()
          throws Exception
    {
    Person person = null;

    // Make sure it exists.
    person = (Person) i_personDomain.find(new Long(1));
    this.assertNotNull(person);

    // Delete it.
    i_personDomain.delete(person);

    // Make sure it was deleted.
    person = (Person) i_personDomain.find(new Long(1));
    this.assertNull(person);
    } // test040DeleteSequencedKey()


  /**
   * This needs to happen before the CompoundKey table is deleted since we
   * join with it.
   */
  public void test041DeleteNaturalKey()
          throws Exception
    {
    Part part = null;

    // Make sure it exists.
    part = (Part) i_partDomain.find("WSH001");
    this.assertNotNull(part);

    // Delete it.
    i_partDomain.delete(part);

    // Make sure it was deleted.
    part = (Part) i_partDomain.find("WSH001");
    this.assertNull(part);
    } // test041DeleteNaturalKey()


  public void test050ReturnSavedObject()
          throws Exception
    {
    Person person = null;
    Person savedPerson = null;

    person = new Person();
    person.setName("Mark");
    person.setAge(new Short((short)31));
    person.setWealthy(true);
    this.assertNull(person.getLastUpdated());
    i_personDomain.setReturnSavedObject(true);        // just being explicit
    savedPerson = (Person)
            i_personDomain.save(person);
    this.assertNotNull(savedPerson);
    this.assertNotNull(savedPerson.getLastUpdated());

    person = new Person();
    person.setName("Amy");
    person.setAge(new Short((short)35));
    person.setWealthy(true);
    this.assertNull(person.getLastUpdated());
    i_personDomain.setReturnSavedObject(false);  // Setting to FALSE
    try
        {
        savedPerson = (Person)
                i_personDomain.save(person);
        this.assertNull(savedPerson);
        this.assertNull(person.getLastUpdated());
        }
    finally
        { i_personDomain.setReturnSavedObject(true); }
    }


  public void test020ResultPageIterator()
          throws Exception
    {
    ResultPageIterator iterator =
            new ResultPageIterator(i_manufacturerDomain, 2/*size of a page*/)
                  {
                  protected List doFind(AbstractDomain domain)
                    {
                    // Not necessary to cast the domain here since findAll()
                    // is an AbstractDomain method.
                    return domain.findOrderBy(domain.getTableAlias() + ".Id");
                    }
                  };

    //  Test the nextPage() method.

    List list = null;
    list = iterator.nextPage();
    this.assertEquals(2, list.size());
    Manufacturer mfg = (Manufacturer) list.get(0);
    this.assertEquals("ACME1", mfg.getCode());
    this.assertTrue(iterator.hasNext());
    this.assertEquals(2, iterator.nextIndex());
    this.assertEquals(-1, iterator.previousIndex());

    mfg = (Manufacturer) list.get(1);
    this.assertEquals("ACME2", mfg.getCode());

    list = iterator.nextPage();
    this.assertEquals(2, list.size());
    mfg = (Manufacturer) list.get(0);
    this.assertEquals("ACME3", mfg.getCode());
    this.assertTrue(iterator.hasNext());
    this.assertEquals(3, iterator.nextIndex());

    list = iterator.nextPage();
    this.assertEquals(2, list.size());
    mfg = (Manufacturer) list.get(0);
    this.assertEquals("TEST1", mfg.getCode());
    this.assertTrue(!iterator.hasNext());
    this.assertEquals(3, iterator.nextIndex()); // stays at the end

    // Make sure reset() works properly.

    iterator.reset();
    this.assertEquals(-1, iterator.previousIndex());
    this.assertEquals(1, iterator.nextIndex());

    list = iterator.nextPage();
    this.assertTrue(iterator.hasNext());

    list = iterator.nextPage();
    mfg = (Manufacturer) list.get(0);
    this.assertEquals("ACME3", mfg.getCode());
    this.assertTrue(iterator.hasNext());

    list = iterator.nextPage();
    this.assertTrue(!iterator.hasNext());

    // Test the previousPage() method.

    this.assertTrue(iterator.hasPrevious());
    list = iterator.previousPage();
    mfg = (Manufacturer) list.get(0);
    this.assertEquals("ACME3", mfg.getCode());
    this.assertTrue(iterator.hasPrevious());
    this.assertEquals(3, iterator.nextIndex());

    list = iterator.previousPage();
    mfg = (Manufacturer) list.get(0);
    this.assertEquals("ACME1", mfg.getCode());
    this.assertTrue(!iterator.hasPrevious());
    this.assertEquals(-1, iterator.previousIndex());
    }


  public void test500IntegerOptimisticLocking()
          throws Exception
    {
    Part changedPart = null;
    Part part = (Part) i_partDomain.find("GRM020");
    this.assertNotNull("Part GRM020 should have been found", part);
    part.markModifiedPersistentState();

     // update version column in db
    Integer oldVersion = part.getVersion();
    Part newPart = (Part) i_partDomain.save(part);
    // JE -- had to change because new version of code is now returned
    try
        {
       newPart.setVersion(oldVersion);
        // change state from Dead to Modified
        newPart.forceModifiedPersistentState();
        // save part with old version number
        i_partDomain.save(newPart);
        this.fail("ObjectHasChangedException was not thrown");
        }
    catch (ObjectHasChangedException e)
        {
        // This is what we expected would happen
        changedPart = (Part) e.getChangedObject();
        }

    this.assertEquals(changedPart.getVersion(),newPart.getVersion());
        //               new Integer(part.getVersion().intValue()+1));

    // Now make sure we can save the changed object
    changedPart.markModifiedPersistentState();
    i_partDomain.save(changedPart);
    }


  public void test500TimestampOptimisticLocking()
          throws Exception
    {
    Person changedPerson = null;
    Person person = (Person) i_personDomain.find(s_jonathanID);
    this.assertNotNull("Person sould have been found", person);
    person.markModifiedPersistentState();

     // update timestamp lock in db
    i_personDomain.save(person);

    try
        {
        // force state from Dead to Modified
        person.forceModifiedPersistentState();
        // save person with old timestamp
        i_personDomain.save(person);
        this.fail("ObjectHasChangedException was not thrown");
        }
    catch (ObjectHasChangedException e)
        {
        // This is what we expected to happen
        changedPerson = (Person) e.getChangedObject();
        }

    // Now make sure we can save the changed object
    changedPerson.markModifiedPersistentState();
    i_personDomain.save(changedPerson);
    }

    // Updated to includes quotes and bars in string.
  public void test500EncodeDecodeCompoundPrimaryKey()
          throws Exception
    {
    Manufacturer manufacturer = null;
    manufacturer = new Manufacturer();
    manufacturer.setId(new Integer(123));
    manufacturer.setCode("A\"C|ME1");
    manufacturer.setName("Acme Mfgr");
    String pkString = i_manufacturerDomain.encodePrimaryKey(manufacturer);
    //this.assertEquals("123|A\"C|ME1\"", pkString);
    manufacturer =
            (Manufacturer) i_manufacturerDomain.decodePrimaryKey(pkString);
    this.assertEquals(new Integer(123), manufacturer.getId());
    this.assertEquals("A\"C|ME1", manufacturer.getCode());
    this.assertNull(manufacturer.getName());
    }



  public void test500EncodeDecodeSinglePrimaryKey()
          throws Exception
    {
    Part part = new Part();
    part.setCode("WS\"H|1");
    part.setName("Washer");
    part.setManufacturerId(new Integer(123));
    part.setManufacturerCode("ACME1");
    String pkString = i_partDomain.encodePrimaryKey(part);
    //this.assertEquals("WSH001", pkString);
    part = (Part) i_partDomain.decodePrimaryKey(pkString);
    this.assertEquals("WS\"H|1", part.getCode());
    }


  /**
   * Test for bug #114415 - Oracle wants 0-23 hours, not 1-24 hours.  Also,
   * Timestamp(0) has a special meaning in some systems, so verify that it
   * gets saved and retrieved appropriately.
  public void test500Timestamp0()
          throws Exception
    {
    Manufacturer manufacturer = (Manufacturer)
            i_manufacturerDomain.find(s_manufacturer);
    this.assertNotNull("Manufacturer sould have been found", manufacturer);
    manufacturer.setLastValidated(new Timestamp(0));  // any old timestamp
    i_manufacturerDomain.save(manufacturer);
    manufacturer = (Manufacturer) i_manufacturerDomain.find(s_manufacturer);
    this.assertEquals(new Timestamp(0),
                      manufacturer.getLastValidated());
    }

   */

  /**
   * Test that "manual" transactions get rolled back as expected.
   */
  public void test500ManualTransaction()
          throws Exception
    {

    Person person = null;
    Manufacturer mfg = null;
    JRFWriteTransaction wt = new JRFWriteTransaction();
    String previousName = null;
    try
    {
        mfg = (Manufacturer) i_manufacturerDomain.find(s_manufacturer);
       previousName = mfg.getName();
        mfg.setName("Changed-Acme Mfgr 1");
        person = (Person) i_personDomain.find(s_jonathanID);
        // Age is required so this should force a rollback during the save.
        person.setAge(null);
       wt.addDomain(i_personDomain);
       wt.addDomain(i_manufacturerDomain);
       wt.beginTransaction();
        i_manufacturerDomain.save(mfg);	// This should succeed.
        i_personDomain.save(person); // This should fail since age is null
        this.fail("Saving of person with null age did not fail");
        // This endTransaction() is here even though we know it will
        // never be called because it would be here under normal
        // circumstances.
        wt.endTransaction();
    }
    catch (MissingAttributeException e)
    {
       wt.abortTransaction();	// Abort should rollback and return value to previous name.
    }
    catch (Exception ex) {
        this.fail("Should have thrown MissingAttributeException but instead threw: "+
                ex.getClass().getName()+": "+ex.getMessage());
    }

    // Make sure the manufacturer save was rolled back as expected.
    mfg = (Manufacturer) i_manufacturerDomain.find(s_manufacturer);
    this.assertEquals(previousName, mfg.getName());
    }


  /**
   * Test the subtype tabling code.
   */
  public void test500SubtypeTable()
          throws Exception
    {
    Object tempObj = null;

    // Test the ability for the supertype domain to return subtype instances
    List list = i_personDomain.findAll();
    this.assertEquals("There should be 5 person/employees", 5, list.size());

    // Save a couple of employees.
    Employee emp = new Employee();
    emp.setName("Joe");
    emp.setAge(new Short((short)42));
    emp.setWealthy(true);
    emp.setDepartmentCode("IT");
    emp.setManagerPersonId(s_jonathanID);
    tempObj = i_employeeDomain.save(emp);
    this.assertNotNull(tempObj);
    this.assertEquals(Employee.class, tempObj.getClass());
    emp = (Employee) tempObj;
    Long joeID = emp.getPersonId();

    emp = new Employee();
    emp.setName("Dave");
    emp.setAge(new Short((short)22));
    emp.setWealthy(false);
    emp.setDepartmentCode("IT");
    emp.setManagerPersonId(s_jonathanID);
    emp = (Employee) i_employeeDomain.save(emp);
    Long daveID = emp.getPersonId();

    // Turn an existing Person instance into a subtype Employee instance
    tempObj = i_personDomain.find(s_jonathanID);
    this.assertEquals(Person.class, tempObj.getClass());
    Person person = (Person) tempObj;

    tempObj = i_employeeDomain.convertToSubtypePersistentObject(person);
    this.assertEquals(Employee.class, tempObj.getClass());
    emp = (Employee) i_employeeDomain.convertToSubtypePersistentObject(person);
    emp.setDepartmentCode("IT");
    emp.setManagerPersonId(joeID);
    tempObj = i_employeeDomain.save(emp);
    this.assertEquals(Employee.class, tempObj.getClass());

    // Verify that all the saved employees are found.
    list = i_employeeDomain.findAll();
    this.assertEquals("There should be 3 employees", 3, list.size());

    tempObj = i_employeeDomain.find(joeID);
    this.assertEquals(Employee.class, tempObj.getClass());
    emp = (Employee) tempObj;
    // check one column from the super table and one from the sub table
    this.assertEquals(new Short((short)42), emp.getAge());
    this.assertEquals(s_jonathanID, emp.getManagerPersonId());

    // Make some changes and test the update mechanism.
    emp.setManagerPersonId(daveID);
    emp.setName("Joseph");  // Joe wants his full name in the db
    tempObj = i_employeeDomain.save(emp);
    this.assertEquals(Employee.class, tempObj.getClass());
    emp = (Employee) tempObj;
    this.assertEquals("Joseph", emp.getName());
    this.assertEquals(daveID, emp.getManagerPersonId());

    // Test the ability for the supertype domain to return subtype instances
    list = i_personDomain.findAll();
    this.assertEquals("There should be 7 person/employees", 7, list.size());

    // These tests don't work since using a Person domain returns a Person
    // instance.  In the future it will be useful to have supertype Domains
    // be able to return subtype instances based on a column value.
    //tempObj = i_personDomain.find(s_jonathanID);
    //this.assertEquals(Employee.class, tempObj.getClass());
    //tempObj = i_personDomain.findForName("Dave");
    //this.assertEquals(Employee.class, tempObj.getClass());
    }

  public void test600TestCompSeq() throws Exception {

	// Just insert a new record and no exception should be thrown.
	CompoundSeqTest1 cs = new CompoundSeqTest1();
	cs.setSecondCode(22);
	cs.setName("TESTING");
    	i_compSeqTest1Domain.update(cs);
	List result = i_compSeqTest1Domain.findAll();
	this.assertEquals(1,result.size());
  }


  public void test900DeleteCompoundKey()
          throws Exception
    {
    // Make sure it exists.
    Manufacturer manufacturer = (Manufacturer)
            i_manufacturerDomain.find(s_manufacturer);
    this.assertNotNull(manufacturer);

    // Delete it
    i_manufacturerDomain.delete(manufacturer);

    // Make sure it was deleted.
    manufacturer = (Manufacturer)
            i_manufacturerDomain.find(s_manufacturer);
    this.assertNull(manufacturer);
    } // test900DeleteCompoundKey


  public void test901TestByteArray()
          throws Exception {
    runByteArrayTest(10000,true);
  }

  public void test902TestByteArray()
          throws Exception {
    runByteArrayTest(250,true);
  }

  public void test903TestByteArray()
          throws Exception {
    runByteArrayTest(250,false);
  }

  private void runByteArrayTest(int size, boolean variable) throws Exception {
    String key = "1";
    // Simple create -- with params as is.
    TestByteArrayDomain.maxLength = size;
    TestByteArrayDomain.variable = variable;
    setUpByteArrayTable();
    TestByteArrayObj obj = new TestByteArrayObj();
    obj.setCode(key);

    SetupInputData setup = new SetupInputData();
    obj.setData(setup.createByteArray());
    i_byteArrayDomain.save(obj);
     TestByteArrayObj returned = (TestByteArrayObj) i_byteArrayDomain.find(key);
     this.assertNotNull(returned);
    this.assertNotNull(returned.getData());
    setup.resolveInputReturn(returned.getData());
  }

  private void setUpByteArrayTable()
  {
    i_byteArrayDomain = new TestByteArrayDomain();
    i_byteArrayDomain.dropTable(true);
    try
        {
       String tableparams = getCreateTableParams();
       i_byteArrayDomain.createTable(null,tableparams);
        }
    catch (Exception e)
        {
        System.out.println(getName()+": set up failed.  Test aborted.");
        e.printStackTrace();
        System.exit(1);
        }
    }


  public void test910TestBinaryStream()
          throws Exception {
        String key = "789";
        setupBinaryStreamTable();
        TestBinaryStream tbCreate = new TestBinaryStream();
        InputStreamHandler setup = new InputStreamHandler();
        tbCreate.setId(key);
        tbCreate.setData( setup.createInputStreamWrapper() );
        i_binaryStreamDomain.save(tbCreate);
        LOG.debug(getName()+" successful save.");
        // Refetch
        i_binaryStreamDomain.find(key,setup);
  }



  public void test920TestBlob()
          throws Exception {
        String key = "456";
        setupBlobTable();
        TestBlob tbCreate = new TestBlob();
        tbCreate.setId(key);
        BlobHandler setup = new BlobHandler();
        tbCreate.setMessage( setup.createBlobWrapper() );
        i_blobDomain.save(tbCreate);
        i_blobDomain.find(key,setup);
  }
  public void test930TestClob() throws Exception {
        testClob(20000,true,true);
  }
  public void test931TestClob() throws Exception {
        testClob(200000,false,true);
  }
  public void test932TestClob() throws Exception {
        testClob(200000,true,false);
  }

  private void testClob(int maxLength,boolean variable, boolean multibyte) throws Exception {
        TestClobDomain.maxLength = maxLength;
        TestClobDomain.variable = variable;
        TestClobDomain.multibyte = multibyte;
        setupClobTable();
        String key = "123";
        ClobHandler ch = new ClobHandler(getName(),LOG);
        TestClob tcCreate = new TestClob();
        tcCreate.setId(key);
        tcCreate.setMessage( ch.getWrapper() );
        i_clobDomain.save(tcCreate);
        i_clobDomain.find(key,ch);

  }

  private class ClobHandler implements ApplicationRowHandler {
        private int dataLength;
        private ClobWrapper w = new ClobWrapper();
        boolean supportCharacterStreamSet = checkSupport(dbType+".setpreparedcharacterstream",
                "PreparedStatement.setCharacterStream() not supported and will not be called.");
        Category log;
        String testName;
        ClobHandler(String testName, Category log) throws IOException {
            this.log = log;
            this.testName = testName;
            File f = new File("build.xml");
            dataLength = (int) f.length();
            if (supportCharacterStreamSet)
                w.setInput( new BufferedReader(new FileReader(f)),dataLength );
            else
                w.setInput(new FileInputStream(f), dataLength );
        }
        public Object getResult() {
            return w;
        }
        public void clear() {
        }

        public boolean processRow(PersistentObject aPO) {

            TestClob tc = (TestClob) aPO;
            assertNotNull(tc.getMessage());
            try {
                Clob c = tc.getMessage().getClob();
                int retLen = (int) c.length();
                    assertEquals("Length of saved data should be "+dataLength+"; it is "+retLen,
                        retLen,dataLength);
                InputStream stream = c.getAsciiStream();
                assertNotNull(stream);
                long skipped = stream.skip( c.position("project name",1) );
                if (skipped == -1)
                    fail("skip() failure -- 'project name' not found.");
                System.out.println(testName+" It worked. Skipped is "+skipped);
            }
            catch (Exception ex) {
                fail("Clob exception thrown: "+ex.getMessage());
            }
            return false;
        }
        ClobWrapper getWrapper() {
            return w;
        }
  }

  private boolean checkSupport(String key, String context) {
        if (JRFProperties.propertyIsTrue(key)) {
            return true;
        }
        System.out.println(key+": In "+getName()+": "+context);
        return false;
  }

  private void setupClobTable() {
    i_clobDomain = new TestClobDomain();
    i_clobDomain.dropTable(true);
    try
        {
       String tableparams = getCreateTableParams();
       i_clobDomain.createTable(null,tableparams);
        }
    catch (Exception e)
        {
        System.out.println(getName()+": set up failed.  Test aborted.");
        e.printStackTrace();
        System.exit(1);
        }
    }

  private void setupBlobTable() {
    i_blobDomain = new TestBlobDomain();
    i_blobDomain.dropTable(true);
    try
        {
       String tableparams = getCreateTableParams();
       i_blobDomain.createTable(null,tableparams);
        }
    catch (Exception e)
        {
        System.out.println(getName()+": set up failed.  Test aborted.");
        e.printStackTrace();
        System.exit(1);
        }
    }

  private void setupBinaryStreamTable() {
    i_binaryStreamDomain = new TestBinaryStreamDomain();
    i_binaryStreamDomain.dropTable(true);
    try
        {
       String tableparams = getCreateTableParams();
       i_binaryStreamDomain.createTable(null,tableparams);
        }
    catch (Exception e)
        {
        System.out.println(getName()+": set up failed.  Test aborted.");
        e.printStackTrace();
        System.exit(1);
        }
    }

  private static class SetupInputData {

        private ByteArrayOutputStream bout;
        private TestObject testObj;

        SetupInputData()  throws IOException {
            bout = new ByteArrayOutputStream();
            ObjectOutputStream oStream = new ObjectOutputStream(bout);
            testObj = new TestObject();
            oStream.writeObject( testObj );
        }

        InputStreamWrapper createInputStreamWrapper() {
            return new InputStreamWrapper( createSerializedStream(),bout.size() );
        }

        BlobWrapper createBlobWrapper() {
            BlobWrapper b = new BlobWrapper();
            b.setInput( createSerializedStream(), bout.size() );
            return b;
        }

        byte [] createByteArray() {
            return bout.toByteArray();
        }

        int getSerializedLength() {
            return bout.size();
        }

        private InputStream createSerializedStream() {
            return new ByteArrayInputStream(bout.toByteArray());
        }

        void resolveInputReturn(byte [] b) {
            resolveInputReturn(new ByteArrayInputStream( b ), false );
        }

        void resolveInputReturn(InputStream stream)  {
            resolveInputReturn(stream,false);
        }

        private void resolveInputReturn(InputStream stream, boolean checkAvailable) {
            if (checkAvailable) {
                try {
                    int available = stream.available();
                    assertEquals("OOPS. TestObject serialized size is "
                            +bout.size()+"; available is: "+available, available, bout.size() );
                }
                catch (IOException ex) {
                    fail("IOException thrown on available: "+ex.getMessage());
                }
            }
            ObjectInputStream inObj;
            TestObject testObjRet = null;
            try {
                inObj = new ObjectInputStream(stream);
                testObjRet = (TestObject) inObj.readObject();

            }
            catch (Exception ex) {
                    fail("Exception thrown for restoring serialized TestObject: "+ex.getMessage());
            }
            if (!testObj.equals(testObjRet))
                fail("Returned test object is "+testObjRet+"; should be "+testObj);
        }
  }

  private static class InputStreamHandler extends SetupInputData implements ApplicationRowHandler {
            InputStreamHandler() throws IOException {
                super();
            }
            public Object getResult() {
                return null;
            }
            public void clear() {
            }
            public boolean processRow(PersistentObject aPO) {
                TestBinaryStream t = (TestBinaryStream) aPO;
                super.resolveInputReturn(t.getData().getStream());
                return false;
            }
  }
  private static class BlobHandler extends SetupInputData implements ApplicationRowHandler {
            BlobHandler() throws IOException {
                super();
            }
            public Object getResult() {
                return null;
            }
            public void clear() {
            }
            public boolean processRow(PersistentObject aPO) {
                TestBlob b = (TestBlob) aPO;
                try {
                    super.resolveInputReturn(b.getMessage().getBlob().getBinaryStream());
                }
                catch (SQLException ex) {
                    fail("SQL Exception thrown for getBlob()");
                }
                return false;
            }
  }

  private static class TestObject implements Serializable {

        private String data1;
        private int data2;

        public TestObject() {
            data1 = "hello";
            data2 = 6734;
        }

        public boolean equals(Object otherObj) {
            TestObject other = (TestObject) otherObj;
            if (other.data1.equals(this.data1) && other.data2 == this.data2)
                return true;
            return false;
        }
        public String toString() {
            return "data1 = "+data1+"; data2 = "+data2;
        }

  }


  } // DomainTEST




