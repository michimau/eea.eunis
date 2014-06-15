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
 * Contributor(s): James Evans (jevans@vmguys.com)
 * Contributor(s): ____________________________________
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
import java.io.*;
import junit.framework.TestCase;
import junit.framework.Test;
import junit.framework.TestSuite;

import org.apache.log4j.Category;


/**
 *  This tests the Domain framework using an Oracle database.
 */
public class CacheTEST
    extends TestCase
  {

  private NamesDomain     		   i_nameDomain = null;
  private PlacesDomain     		   i_placeDomain = null;
  private MasterDomain     		   i_masterDomain = null;
  private DetailDomain     		   i_detailDomain = null;
  private static final Category LOG = Category.getInstance(CacheTEST.class.getName());

  static {
	JRFProperties.getProperties().setProperty("useAutoSetupNewColumnMethodology","NO");
  }	

  public CacheTEST(String testName)
  {
    super(testName);
  }


  public void tearDown() {
	System.out.println(getName()+" test is complete.");
  }

  public static Test suite() {
	TestSuite result = new TestSuite();
	for (int i = 0; i < TESTS.length; i++) {
		result.addTest(new  CacheTEST(TESTS[i]));
	}
	return result;
  }

  static private String TESTS[] = {
	"test000",
	"test001",
	"test002",
	//"test003",
	"test004",
	"test005",
	//"test006",
	"test007",
	"test008",
	"cleanUp"
  };


  public void cleanUp() throws Exception {
        boolean ignoreErrors = true;
   	i_nameDomain.dropTable(ignoreErrors);
   	i_placeDomain.dropTable(ignoreErrors);
   	i_masterDomain.dropTable(ignoreErrors);
   	i_detailDomain.dropTable(ignoreErrors);
  }

  public void setUp()
  {
	i_nameDomain = new NamesDomain();
	i_placeDomain = new PlacesDomain();
	i_masterDomain = new MasterDomain();
	i_detailDomain = new DetailDomain();
	if (!getName().equals("cleanUp"))  {
    		try {
    		   String tableparams = DomainTEST.getCreateTableParams();
		   cleanUp();
	    	   i_nameDomain.createTable(null,tableparams);
		   i_placeDomain.createTable(null,tableparams);
    		   i_masterDomain.createTable(null,tableparams);
		   i_detailDomain.createTable(null,tableparams);
		   for (int i = 0; i < names.length; i++) {
			Names n = new Names();
			n.setName(names[i]);
			n.setDescription("A Description");
			i_nameDomain.update(n);
		   }
		   for (int i = 0; i < places.length; i++) {
			Places p = new Places();
			p.setName(places[i]);
			p.setDescription("A Description");
			i_placeDomain.update(p);
		   }
	        }
     		catch (Exception e) {
			LOG.fatal("Unable to run tests",e);
	  	        System.out.println("Setup failed.  Test aborted.");
       		        System.exit(1);
                }
	}
  }

  public void test000() throws Exception {
	MasterCompositeDomain domain = new MasterCompositeDomain();
		
 }

 static private final String names[] = {"Phillip","Joe","Barbara","Susan","Bob","Bill","Marcia","Karen"};
 static private final String places[] = {"NY","NJ","KY","AZ","AR","NZ","PO","NH"};

 public void test001() throws Exception {
		// We have created 8 name records in setup()
		PersistentObjectCache.setCacheAll(i_nameDomain.getClass(),false);
		PersistentObjectCache.setMaxCacheSize(i_nameDomain.getClass(),6);
		this.assertEquals(PersistentObjectCache.getCacheType(i_nameDomain.getClass()),
					PersistentObjectCache.CACHE_TYPE_LRU);
		this.assertEquals(6,PersistentObjectCache.getMaxCacheSize(i_nameDomain.getClass()));
		List list = i_nameDomain.findAll();
		this.assertEquals(8,list.size());
		// Find all does not touch cache; should be zero.
		this.assertEquals(0,PersistentObjectCache.getCacheSize(i_nameDomain.getClass()) );
		int i = 0;
		while (i < 6) {
			// Each fetch should increment the cache.
			i_nameDomain.find(list.get(i));
			i++;
			this.assertEquals(i,PersistentObjectCache.getCacheSize(i_nameDomain.getClass()) );
		}
		// Add one more and cache should remain at 6
		i_nameDomain.find(list.get(i));
		this.assertEquals(6,PersistentObjectCache.getCacheSize(i_nameDomain.getClass()) );
		i_nameDomain.delete((PersistentObject) list.get(0));
		this.assertEquals(6,PersistentObjectCache.getCacheSize(i_nameDomain.getClass()) );
		i_nameDomain.delete((PersistentObject) list.get(1));
		// Make sure listener is working - now should be 5
		this.assertEquals(5,PersistentObjectCache.getCacheSize(i_nameDomain.getClass()) );
			
		
 }

 public void test002() throws Exception {
		PersistentObjectCache.setCacheAll(i_placeDomain.getClass(),true);
		this.assertEquals(PersistentObjectCache.getCacheType(i_placeDomain.getClass()),
					PersistentObjectCache.CACHE_TYPE_ALL);
		// In this case, findall() DOES touch cache; cache size should be equal to list size.
		List list = i_placeDomain.findAll();
		this.assertEquals(list.size(),PersistentObjectCache.getCacheSize(i_placeDomain.getClass()));
		i_placeDomain.find(list.get(0));
		this.assertEquals(list.size(),PersistentObjectCache.getCacheSize(i_placeDomain.getClass()) );
		
 }
 /** NO LONGER APPLICABLE
 public void test003() throws Exception {
	// Error case 1 -- set detail to cacheable
	Detail d = new Detail();
	d.setName("JOE");
	d.setDescription("XXXX");
	PersistentObjectCache.setCacheAll(i_detailDomain.getClass(),true);
	assertEquals(true,PersistentObjectCache.isCacheAll(i_detailDomain.getClass()));
	i_detailDomain.update(d);
	assertEquals(true,PersistentObjectCache.isClassCached(i_detailDomain.getClass()));

	try {
		MasterCompositeDomain domain = new MasterCompositeDomain();
		fail("ConfigurationException should have been thrown.");
	}
	catch (ConfigurationException ex) {

	}
 }
 **/
 public void test004() throws Exception {
	// Error case 2 -- set master to cacheable
	Master m = new Master();
	m.setName("JOE");
	m.setDescription("XXXX");
	PersistentObjectCache.setMaxCacheSize(i_masterDomain.getClass(),6);
	i_masterDomain.update(m);
 }

  public void test005() throws Exception {
	// try cache all after setting the size. Should work.
	PersistentObjectCache.setMaxCacheSize(i_masterDomain.getClass(),8);
	this.assertEquals(8,PersistentObjectCache.getMaxCacheSize(i_masterDomain.getClass()));
	PersistentObjectCache.setCacheAll(i_masterDomain.getClass(),true);
 }
	/** NO LONGER APPLICABLE
  public void test006() throws Exception {
	// Error case 4 -- try cache size after setting all.
	PersistentObjectCache.setCacheAll(i_detailDomain.getClass(),true);
	this.assertEquals(true,PersistentObjectCache.isCacheAll(i_detailDomain.getClass()));
	try {
		PersistentObjectCache.setMaxCacheSize(i_detailDomain.getClass(),8);
		fail("IllegalStateException should have been thrown.");
	}
	catch (IllegalStateException ex) {

	}
	finally {
		PersistentObjectCache.removeCache(i_detailDomain.getClass());
		this.assertEquals(PersistentObjectCache.getCacheType(i_detailDomain.getClass()),
					PersistentObjectCache.CACHE_TYPE_NONE);
	}
 }
 **/

  // Use a private class since method to test is protected. 
  private class BeanTester extends MasterCompositeDomain {
		public void testBeanCopy() throws Exception {
			MasterComposite master = (MasterComposite) this.newPersistentObject();
			master.setName("TEST1");
			master.setDescription("DESC-1");
			Master m = (Master) this.createAndPopulateParentPersistentObject(master);
			assertEquals(master.getName(),"TEST1");
			assertEquals(master.getDescription(),"DESC-1");
			assertEquals(master.getName(),m.getName());
			assertEquals(master.getDescription(),m.getDescription());
		}

  }

  public void test007() throws Exception {
	// Test straight bean-to-bean method using private class above.
	BeanTester b = new BeanTester();
	b.testBeanCopy();	
  }

  public void test008() throws Exception {
	// Update master and assure that master cache is updated.	
	MasterCompositeDomain domain = new MasterCompositeDomain();
	PersistentObjectCache.setMaxCacheSize(domain.getClass(),3);
	int sizeOfSuperCache = PersistentObjectCache.getCacheSize(i_masterDomain.getClass());
	List list = i_masterDomain.findAll();
	// Should be no change.
	this.assertEquals(sizeOfSuperCache,PersistentObjectCache.getCacheSize(i_masterDomain.getClass()) );
	
	// Add a new record using composite record.
	MasterComposite m = new MasterComposite();
	m.setName("JOENUM2");
	m.setDescription("YYYYY");
	domain.update(m);
	// Assure composite cache has 1 record.
	this.assertEquals(1,PersistentObjectCache.getCacheSize(domain.getClass()) );
	// Base master should have one more record.
	this.assertEquals(sizeOfSuperCache+1,PersistentObjectCache.getCacheSize(i_masterDomain.getClass()) );
	// Make sure the bean to bean copy worked.
	m = (MasterComposite) domain.find("JOENUM2");
	this.assertNotNull(m);
	Master master = (Master) i_masterDomain.find("JOENUM2");
	this.assertNotNull(master);
	this.assertEquals(m.getName(),master.getName());
	this.assertEquals(m.getDescription(),master.getDescription());

  }
}

