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
import java.util.Iterator;
import java.io.*;
import junit.framework.TestCase;
import junit.framework.Test;
import junit.framework.TestSuite;
import java.util.Calendar;
import org.apache.log4j.Category;


/**
 */
public class CompositeTEST
    extends TestCase
  {

  private GroupPersonsDomain 		   i_groupPersonsDomain = null;
  private PersonsDomain 			   i_personsDomain = null;
  private GroupTypesDomain			   i_groupTypesDomain = null;
  private Master2Domain			   i_master2Domain = null;
  private Master3Domain			   i_master3Domain = null;
  private Detail2Domain			   i_detail2Domain = null;
  private Detail3Domain			   i_detail3Domain = null;
  private DOWTestKeyDomain		   i_dowKeyDomain = null;
  private DOWTestNullDomain		   i_dowNullDomain = null;
  private LOVTestDomain			   i_lovTestDomain = null;

  private static final Category LOG = Category.getInstance(CompositeTEST.class.getName());

  static {
    JRFProperties.getProperties().setProperty("useAutoSetupNewColumnMethodology","NO");
  }

  public CompositeTEST(String testName)
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
  }

  public static Test suite() {
	TestSuite result = new TestSuite();
	for (int i = 0; i < TESTS.length; i++) {
		result.addTest(new  CompositeTEST(TESTS[i]));
	}
	return result;
  }

  static private String TESTS[] = {
	"test000",
	"test002",
	"test004",
	"test005",
	"test006",
	"test007",
	"test008",
	"test009",
	"test010",
	"test011",
	"cleanUp"
  };


  public void cleanUp() throws Exception {
        boolean ignoreErrors = true;
        i_groupTypesDomain.dropTable(ignoreErrors);
        i_personsDomain.dropTable(ignoreErrors);
        i_master2Domain.dropTable(ignoreErrors);
        i_master3Domain.dropTable(ignoreErrors);
        i_detail2Domain.dropTable(ignoreErrors);
        i_detail3Domain.dropTable(ignoreErrors);
        i_dowNullDomain.dropTable(ignoreErrors);
        i_dowKeyDomain.dropTable(ignoreErrors);
    	i_lovTestDomain.dropTable(ignoreErrors);
  }

  public void test000() throws Exception {
       cleanUp(); 
       try {
    	   String tableparams = DomainTEST.getCreateTableParams();
           i_personsDomain.createTable(null,tableparams);
           i_groupTypesDomain.createTable(null,tableparams);
           i_master2Domain.createTable(null,tableparams);
           i_master3Domain.createTable(null,tableparams);
           i_detail2Domain.createTable(null,tableparams);
           i_detail3Domain.createTable(null,tableparams);
           i_dowKeyDomain.createTable(null,tableparams);
           i_dowNullDomain.createTable(null,tableparams);
    	   i_lovTestDomain.createTable(null,tableparams);
        }
        catch (Exception e) {
            LOG.fatal("Unable to run tests",e);
            System.out.println("Setup failed.  Test aborted.");
            System.exit(1);
        }
 }

 public void test002() throws Exception {
    // Add some data.
    groupDataCreate(i_groupPersonsDomain);
 }
 private static String [] group1Names = {"Joe","Barbara","Susan"};
 private static String [] group2Names  = {"Bob","Bill","Marcia"};
 private static String [] group3Names = {"John","Karen","Cathy","Mark","Jim"};
 private static String [] group4Names = {"Eric","Allison"};

 public static void groupDataCreate(GroupPersonsDomain groupPersonsDomain) throws Exception {
    createGroup(groupPersonsDomain,"Group-1",group1Names );
    createGroup(groupPersonsDomain,"Group-2",group2Names );
    createGroup(groupPersonsDomain,"Group-3",group3Names );
    createGroup(groupPersonsDomain,"Group-4",group4Names );
 }


 public static  GroupPersons createGroup(GroupPersonsDomain domain, 
			String groupName, String [] personsInGroup) throws Exception {
    GroupPersons gp = new GroupPersons();
    
    gp.setGroupName(groupName);
    for (int i = 0; i < personsInGroup.length; i++) {
        Persons p = new Persons();
        p.setPersonName(personsInGroup[i]);
        gp.getPersons().add(p);
    }
    domain.update(gp);
    return gp;
 }


 public static void validateGroupRec(GroupPersons gp)  throws Exception {
    int i;
    for (i = 0; i < 4; i++) {
        if (gp.getGroupName().equals("Group-"+(i+1)) )
            break;
    }
    if (i == 4)
        throw new Exception("No such group: "+gp.getGroupName());
    switch (i) {
        case 0:
            nameCheck(gp,group1Names);
            break;
        case 1:
            nameCheck(gp,group2Names);
            break;
        case 2:
            nameCheck(gp,group3Names);
            break;
        case 3:
            nameCheck(gp,group4Names);
            break;

    }
 }

 public static void nameCheck(GroupPersons gp, String [] names) throws Exception {
    Iterator iter = gp.getPersons().iterator();
    int namesCovered = 0;
    if (names.length != gp.getPersons().size()) {
        throw new Exception("For "+gp+": expected "+names.length+" persons but have instead "+gp.getPersons().size());
    }
    while (iter.hasNext()) {
        Persons p = (Persons) iter.next();
        for (int i = 0; i < names.length; i++) {
            if (p.getPersonName().equals(names[i])) {
                namesCovered++;
                break;
            }
        }
    }
    if (namesCovered != names.length) {
        throw new Exception("For "+gp+" don't have all the correct names. Found "+namesCovered+" of "+names.length);
    }

 }

 public void test003() throws Exception {
    GroupPersonsDomain domain = new GroupPersonsDomain();
    List list = domain.findAll();
    this.assertEquals(4,list.size());
    Iterator iter = list.iterator();
    while (iter.hasNext()) {
        GroupPersons gp = (GroupPersons) iter.next();
        try {
            validateGroupRec(gp);
        }
        catch (Exception ex) {
            this.fail(ex.getMessage());
        }
    }
 }

 // Test full delete.
 public void test004() throws Exception {
    GroupPersonsDomain domain = new GroupPersonsDomain();
    List list = domain.findAll();
    this.assertEquals(4,list.size());
    GroupPersons gp = (GroupPersons) domain.find(list.get(0));
    this.assertNotNull(gp);
    Persons p1  = (Persons) gp.getPersons().get(0);
    GroupPersons gp2 = (GroupPersons) domain.find(list.get(1));
    Persons p2  = (Persons) gp2.getPersons().get(0);
    domain.delete(gp);
    list = domain.findAll();
    this.assertEquals(3,list.size());
    // Make sure persons 0-0 is gone.
    if (i_personsDomain.find(p1) != null)
        fail("Person "+p1+" still exists.");
    // Make sure persons 1-0 is still there.
    this.assertNotNull(i_personsDomain.find(p2));
 }

 // Test partial deletion.
 public void test005() throws Exception {
    GroupPersonsDomain domain = new GroupPersonsDomain();
    List list = domain.findAll();
    GroupPersons gp = (GroupPersons) domain.find(list.get(0));
    this.assertNotNull(gp);
    Persons p1  = (Persons) gp.getPersons().get(0);
    int oldSize = gp.getPersons().size();
    p1.markDeletedPersistentState();
    domain.update(gp);
    // Make sure master is still intact
    GroupPersons gp2 = (GroupPersons) domain.find(gp);
    this.assertNotNull(gp2);
    this.assertEquals(oldSize-1,gp2.getPersons().size());
    // Make sure person deleted is gone.
    if (i_personsDomain.find(p1) != null)
        fail("Person "+p1+" still exists.");
 }

 // Test ResultSet get methods through column indexes via a join construct.
 public void test006() throws Exception {
    Master2 m2 = new Master2();
    m2.setName("LINKNAME");
    m2.setDescription("DESC-M-2");
    m2.setANumber(10);
    i_master2Domain.save(m2);

    Master3 m3 = new Master3();
    m3.setName("LINKNAME");
    m3.setDescription("DESC-M-3");
    i_master3Domain.save(m3);

    Detail2 d2 = new Detail2();
    d2.setName("LINKNAME");
    d2.setDescription("DESC-D-2");
    i_detail2Domain.save(d2);

    Detail3 d3 = new Detail3();
    d3.setName("LINKNAME");
    d3.setDescription("DESC-D-3");
    i_detail3Domain.save(d3);

    // Run the ugly join.
    MasterTestColIdxDomain domain = new MasterTestColIdxDomain();
    MasterTestColIdx result = (MasterTestColIdx) domain.find("LINKNAME");
    this.assertNotNull(result);
    this.assertEquals("DESC-M-2",result.getDescription());
    this.assertEquals("DESC-D-2",result.getDescriptionD2());
    this.assertEquals("DESC-D-3",result.getDescriptionD3());
    this.assertEquals("DESC-M-3",result.getDescriptionM3());

 }
    // DOW KEY
 public void test007() throws Exception {
    DOWTestKey d = new DOWTestKey();
    d.setDescription("TUES??");
    d.setDOW(Calendar.TUESDAY);
    i_dowKeyDomain.save(d);

    DOWTestKey f = (DOWTestKey) i_dowKeyDomain.find(d);
    this.assertNotNull(f);
    this.assertEquals(d.getDOW(),f.getDOW());


 }
    // DOW NULL
 public void test008() throws Exception {
    DOWTestNull d = new DOWTestNull();
    d.setCode("AAA");
    d.setDOW(DayOfWeekColumnSpec.NULLDAYOFWEEK);
    i_dowNullDomain.save(d);

    DOWTestNull f = (DOWTestNull) i_dowNullDomain.find(d);
    this.assertNotNull(f);
    this.assertEquals(DayOfWeekColumnSpec.NULLDAYOFWEEK,f.getDOW());


 }

 // Assure overflow string exceptions work.
 public void test009() throws Exception {
	Master2 m = new Master2();
	m.setName("BADBAD");
	m.setDescription("THIS STRING IS MUCH LONGER THAN THE LIMIT OF 75 CHARACTERS."+
		" INSERTING IT SHOULD GENERATE AN EXCEPTION, NOT A TRUNCATION!!!");
	m.setANumber(10);
      	try {
		i_master2Domain.update(m);
		this.fail("INSERT SHOULD HAVE FAILED FOR "+m);
	}
	catch (InvalidValueException ex) {
                LOG.debug("Got invalild value exception: "+ex.getMessage());
    		this.assertEquals(InvalidValueException.TYPE_MAX_LENGTH_EXCEEDED,ex.getErrorType());
		String s = (String) ex.getErrantValue();
		this.assertEquals(m.getDescription(),s);
	}
 }

 // Assure  max/min value works. Range is 5 to 25 (see source/xml/testdb.xml)
 public void test010() throws Exception {
	Master2 m = new Master2();
	m.setName("GOODGOOD1");
	m.setDescription("Good1");
	// Put in a good value and update with valid values.
	m.setANumber(10);
	i_master2Domain.update(m);
	m.setANumber(5);
	i_master2Domain.update(m);
	m.setANumber(25);
	i_master2Domain.update(m);
      	try {
		m.setANumber(4);
		i_master2Domain.update(m);
		this.fail("MODIFY SHOULD HAVE FAILED. Value is too low: "+m);
	}
	catch (InvalidValueException ex) {
    		this.assertEquals(InvalidValueException.TYPE_LESS_THAN_MINIMUM,ex.getErrorType());
		Integer i  = (Integer) ex.getErrantValue();
		this.assertEquals(4,i.intValue());
		i  = (Integer) ex.getBoundaryValue();
		this.assertEquals(5,i.intValue());
	}
      	try {
		m.setANumber(26);
		i_master2Domain.update(m);
		this.fail("MODIFY SHOULD HAVE FAILED. Value is too high: "+m);
	}
	catch (InvalidValueException ex) {
    		this.assertEquals(InvalidValueException.TYPE_GREATER_THAN_MAXIMUM,ex.getErrorType());
		Integer i  = (Integer) ex.getErrantValue();
		this.assertEquals(26,i.intValue());
		i  = (Integer) ex.getBoundaryValue();
		this.assertEquals(25,i.intValue());
	}
  }

 public void test011() throws Exception {
	List list = i_groupPersonsDomain.getEmbeddedPropertyNames();
	this.assertEquals(1,list.size());
	String name = (String) list.get(0);
	this.assertEquals("persons",name);
    	GroupPersons gp = new GroupPersons();
        gp.setGroupName("AGROUP");
	Persons p = (Persons) i_groupPersonsDomain.newEmbeddedPersistentObject(gp,"persons");
	this.assertEquals("AGROUP",p.getGroupName());
	
 }
 // Test LOV -- Not yet supported in code generator. TODO

}
  // MORE TODO
