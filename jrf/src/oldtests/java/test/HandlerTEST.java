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
import java.util.Calendar;
import org.apache.log4j.Category;


/**
 */
public class HandlerTEST
    extends TestCase
  {

  private GroupPersonsDomain 		   i_groupPersonsDomain = null;
  private PersonsDomain 		   i_personsDomain = null;
  private GroupTypesDomain			   i_groupTypesDomain = null;

  private static final Category LOG = Category.getInstance(HandlerTEST.class.getName());

  static {
    JRFProperties.getProperties().setProperty("useAutoSetupNewColumnMethodology","NO");
  }

  public HandlerTEST(String testName)
  {
    super(testName);
  }


  public void tearDown() {
    System.out.println(getName()+" test is complete.");
  }

  private class MasterHandler extends DomainHandler {
    public MasterHandler() {
        super(GroupTypesDomain.class.getName(),GroupPersonsDomain.class.getName());
    }
  }

  public void setUp() {
    boolean ignoreErrors = true;
    i_groupPersonsDomain = new GroupPersonsDomain();
    i_personsDomain = new PersonsDomain();
    i_groupTypesDomain = new GroupTypesDomain();
    i_groupTypesDomain.dropTable(ignoreErrors);
    i_personsDomain.dropTable(ignoreErrors);
        try {
        i_personsDomain.createTable();
        i_groupTypesDomain.createTable();
        CompositeTEST.groupDataCreate(i_groupPersonsDomain);
    }
    catch (Exception e) {
        LOG.fatal("Unable to run tests",e);
        System.out.println("Setup failed.  Test aborted.");
            System.exit(1);
        }
 }

 public void test000() throws Exception {
    MasterHandler handler = new MasterHandler();

    List l = handler.getAllAsList();
    this.assertEquals(4,l.size());

    GroupTypes g = (GroupTypes) l.get(0);
    GroupPersons gp = (GroupPersons) handler.findByKey(l.get(0));
    this.assertNotNull(gp);
    this.assertEquals(g.getGroupName(),gp.getGroupName());
    try {
        CompositeTEST.validateGroupRec(gp);
    }
    catch (Exception ex) {
        this.fail(ex.getMessage());
    }
 }
}
