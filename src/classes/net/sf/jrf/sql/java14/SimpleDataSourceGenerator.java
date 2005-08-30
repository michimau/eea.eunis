/*
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
package net.sf.jrf.sql.java14;

import net.sf.jrf.sql.LocalDataSourceGenerator;

import java.sql.*;
import java.util.HashSet;
import java.util.Properties;
import javax.sql.DataSource;

import net.sf.jrf.*;
import net.sf.jrf.exceptions.ConfigurationException;
import org.apache.log4j.Category;

/**
 * Implementation for default data source of <code>SimpleDataSource</code>
 *
 * @see   net.sf.jrf.sql.java14.SimpleDataSource
 */
public class SimpleDataSourceGenerator implements LocalDataSourceGenerator {
  private final static Category LOG = Category.getInstance(SimpleDataSourceGenerator.class.getName());

  /**Constructor for the SimpleDataSourceGenerator object */
  public SimpleDataSourceGenerator() {
  }

  /**
   * @param dbtype                      Description of the Parameter
   * @param p                           Description of the Parameter
   * @return                            Description of the Return Value
   * @exception ConfigurationException  Description of the Exception
   * @see                               net.sf.jrf.sql.LocalDataSourceGenerator#findLocalDataSource(String,Properties) *
   */
  public DataSource findLocalDataSource(String dbtype, Properties p)
          throws ConfigurationException {
    SimpleDataSource d = new SimpleDataSource();
    d.setDriverClassName(
            JRFProperties.resolveRequiredStringProperty(p, dbtype + ".driver",
                    "driver specification class is mandatory."));
    d.setURL(
            JRFProperties.resolveRequiredStringProperty(p, dbtype + ".url",
                    "URL for database is mandatory."));
    d.setUser(JRFProperties.resolveRequiredStringProperty(p, dbtype +
            ".user", "User name is mandatory"));
    d.setPassword(JRFProperties.resolveStringProperty(p, dbtype + ".password", ""));
    d.setTestSql(JRFProperties.resolveStringProperty(p, dbtype + ".testsql", null));

    d.setPoolMin(JRFProperties.resolveIntProperty(p, dbtype + ".minpoolsize", 1));
    d.setPoolMax(JRFProperties.resolveIntProperty(p, dbtype + ".maxpoolsize", 10));
    LOG.debug(d.toString());
    return d;
  }
}
