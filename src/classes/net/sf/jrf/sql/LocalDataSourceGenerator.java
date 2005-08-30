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
package net.sf.jrf.sql;

import java.util.Properties;
import javax.sql.DataSource;

import net.sf.jrf.exceptions.ConfigurationException;

/**
 * An interface that handles the generation of
 * data sources locally without the use of JNDI.
 */
public interface LocalDataSourceGenerator {

  /**
   * Finds data source based on type and list of properties locally
   * without the use of JNDI.
   *
   * @param p                        <code>Properties instance to use.  Implementations
   * may insist that all properties exist in this instance or
   * fall back to <code>JRFProperties</code> for all required
   * properties.
   * <p>
   * Implementations may differ on what is a required property, but
   * generally the following will should be mandatory:
   * <ul>
   * <li> "driver" (e.g. if dbType = "mysql", "mysql.driver")
   * <li> "url" (e.g. if dbType = "mysql", "mysql.url")
   * <li> "user" (e.g. if dbType = "mysql", "mysql.user")
   * <li> "password" (e.g. if dbType = "mysql", "mysql.password")
   * </ul>
   * @param dbtype                   Description of the Parameter
   * @return                         <code>DataSource</code> instance associated with
   * supplied parameters.
   * @throws ConfigurationException  if data source cannot be created.
   */
  public DataSource findLocalDataSource(String dbtype, Properties p)
          throws ConfigurationException;

}
