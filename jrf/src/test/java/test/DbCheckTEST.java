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
 * Contributor: James Evans (jevans@vmguys.com)
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
import net.sf.jrf.util.*;

/**
 */
public class DbCheckTEST
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


  private DbCheckBaseDomain		   i_dbCheckBaseDomain = null;
  private DbCheckMissingColDomain 	   i_dbCheckMissingColDomain = null;
  private DbCheckNewColDomain		   i_dbCheckNewColDomain = null;
  private DbCheckScaleChangeDomain	   i_dbCheckScaleChangeDomain = null;
  private DbCheckSizeChangeDomain	   i_dbCheckSizeChangeDomain = null;
  private DbCheckTypeChangeDomain	   i_dbCheckTypeChangeDomain = null;
  private DbCheckNullChangeDomain          i_dbCheckNullChangeDomain = null;

  private static final Category LOG = Category.getInstance(DbCheckTEST.class.getName());

  static {
    JRFProperties.getProperties().setProperty("useAutoSetupNewColumnMethodology","NO");
  }

  public DbCheckTEST(String testName)
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
    i_dbCheckBaseDomain = new DbCheckBaseDomain();
    i_dbCheckBaseDomain.dropTable(true);	// Destroy every time.
  }

  public static Test suite() {
	TestSuite result = new TestSuite();
	for (int i = 0; i < TESTS.length; i++) {
		result.addTest(new  DbCheckTEST(TESTS[i]));
	}
	return result;
  }

  static private String TESTS[] = {
	"test000",
	"test001",
	"test002",
	"test003",
	"test004",
	"test005",
	"test006",
	"test007",
	"test008",
	"test009",
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
        i_dbCheckBaseDomain.dropTable(ignoreErrors);	
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
        }
        catch (Exception e) {
            LOG.fatal("Unable to run tests",e);
            System.out.println("Setup failed.  Test aborted.");
            System.exit(1);
        }
 }

  public void test001() throws Exception {
	Properties p = DbCheck.generateProperties(JRFConnectionFactory.create(),null);
	DbCheck dc1 = new DbCheck(JRFConnectionFactory.create(),null);
	//log("FROM DB = \n"+dc1);
	DbCheck dc2 = new DbCheck(p);
	//log("FROM PROP = \n"+dc2);
	List diff = DbCheck.getDifferences(dc1,dc2);
	this.assertEquals(0,diff.size());

  }

  // Add a table.
  public void test002() throws Exception {
    	String tableparams = DomainTEST.getCreateTableParams();
	Properties p = DbCheck.generateProperties(JRFConnectionFactory.create(),null);
	DbCheck dc1 = new DbCheck(p);
    	i_lovTestDomain.createTable(null,tableparams);
	DbCheck dc2 = new DbCheck(JRFConnectionFactory.create(),null);
	List diff = DbCheck.getDifferences(dc1,dc2);
	this.assertEquals(1,diff.size());
	DbCheckDifference d = (DbCheckDifference) diff.get(0);
	log(d.toString());
	this.assertEquals(DbCheckDifference.DIFFTYPE_MISSING_TABLE,d.getType());
	this.assertEquals(i_lovTestDomain.getTableName().toUpperCase(),d.getTableName().toUpperCase());
  }


  // Remove table added in 002
  public void test003() throws Exception {
	Properties p = DbCheck.generateProperties(JRFConnectionFactory.create(),null);
	DbCheck dc1 = new DbCheck(p);
    	i_lovTestDomain.dropTable(false);
	DbCheck dc2 = new DbCheck(JRFConnectionFactory.create(),null);
	List diff = DbCheck.getDifferences(dc1,dc2);
	this.assertEquals(1,diff.size());
	DbCheckDifference d = (DbCheckDifference) diff.get(0);
	log(d.toString());
	this.assertEquals(DbCheckDifference.DIFFTYPE_MISSING_TABLE,d.getType());
	this.assertEquals(i_lovTestDomain.getTableName().toUpperCase(),d.getTableName().toUpperCase());
  }

  private DbCheck initDbCheck() throws Exception {
	return initDbCheck(false);
  }

  // Always create dbCheckBase table.
  private DbCheck initDbCheck(boolean displayOutput) throws Exception {
    	   String tableparams = DomainTEST.getCreateTableParams();
           i_dbCheckBaseDomain.createTable(null,tableparams);
	   Properties p = DbCheck.generateProperties(JRFConnectionFactory.create(),null);
	   DbCheck result = new DbCheck(p);
	   if (displayOutput)
		log(result.toString());
	   return result;
  }

  // Always drop dbCheckBase table and add another table.
  private DbCheck redoDbCheck(AbstractDomain newDomain) throws Exception {
    	   String tableparams = DomainTEST.getCreateTableParams();
    	   i_dbCheckBaseDomain.dropTable(false);	
           newDomain.createTable(null,tableparams);
	   return  new DbCheck(JRFConnectionFactory.create(),null);
  }
  
  private DbCheckDifference verify(DbCheck dc1, DbCheck dc2) throws Exception {
		return verify(dc1,dc2,1);
  }

  private DbCheckDifference verify(DbCheck dc1, DbCheck dc2,int expectedChanges) throws Exception {
	   List diff = DbCheck.getDifferences(dc1,dc2);
	   StringBuffer buf = new StringBuffer();
	   buf.append("Difference total = "+diff.size()+": \n");
	   for (int i = 0; i < diff.size(); i++) {
		buf.append("DIFF "+(i+1)+" IS "+diff.get(i)+"\n");
	   }
	   log(buf.toString());
 	   this.assertEquals(expectedChanges,diff.size());
	   return (DbCheckDifference) diff.get(0);
  }
 
  public void test004() throws Exception {
	   DbCheck dc1 = initDbCheck(true);	// First test  - show goods in the logs.
	   DbCheck dc2 = redoDbCheck(new DbCheckMissingColDomain());
	   DbCheckDifference d = verify(dc1,dc2);
	   log(d.toString());
	   this.assertEquals(DbCheckDifference.DIFFTYPE_MISSING_COLUMN,d.getType());
	   this.assertEquals("FIELD1",d.getColumnName().toUpperCase());
  }



  public void test005() throws Exception {
	   DbCheck dc1 = initDbCheck();
	   DbCheck dc2 = redoDbCheck(new DbCheckNewColDomain());
	   DbCheckDifference d = verify(dc1,dc2);
	   log(d.toString());
	   this.assertEquals(DbCheckDifference.DIFFTYPE_MISSING_COLUMN,d.getType());
	   this.assertEquals("FIELD2",d.getColumnName().toUpperCase());
  }

  
  public void test006() throws Exception {
  // TODO: fix this -- in testdb.xml 
	/*
	   DbCheck dc1 = initDbCheck();
	   DbCheck dc2 = redoDbCheck(new DbCheckScaleChangeDomain());
	   DbCheckDifference d = verify(dc1,dc2);
	   log(d.toString());
	   this.assertEquals(DbCheckDifference.DIFFTYPE_ATTRIBUTE_DIFFERENT,d.getType());
	 */
 }

  public void test007() throws Exception {
	   DbCheck dc1 = initDbCheck();
	   DbCheck dc2 = redoDbCheck(new DbCheckSizeChangeDomain());
	   DbCheckDifference d = verify(dc1,dc2);
	   log(d.toString());
	   this.assertEquals(DbCheckDifference.DIFFTYPE_ATTRIBUTE_DIFFERENT,d.getType());
 }
  public void test008() throws Exception {
	   DbCheck dc1 = initDbCheck();
	   DbCheck dc2 = redoDbCheck(new DbCheckTypeChangeDomain());
	   DbCheckDifference d = verify(dc1,dc2,2);
	   log(d.toString());
	   this.assertEquals(DbCheckDifference.DIFFTYPE_ATTRIBUTE_DIFFERENT,d.getType());
 }
  public void test009() throws Exception {
	   DbCheck dc1 = initDbCheck();
	   DbCheck dc2 = redoDbCheck(new DbCheckNullChangeDomain());
	   DbCheckDifference d = verify(dc1,dc2);
	   log(d.toString());
	   this.assertEquals(DbCheckDifference.DIFFTYPE_ATTRIBUTE_DIFFERENT,d.getType());
 }

 private void log(String msg) {
	LOG.info(this.getName()+": "+msg);
 }
}
