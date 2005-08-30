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
 * The Initial Developer of the Original Code is is.com (bought by wamnet.com).
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: James Evans jevans@vmguys.com
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

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;

import net.sf.jrf.domain.*;
import org.apache.log4j.Category;

/**
 * A class to handle notifications to domains that
 * the data source has changed.  Applications can register
 * a group of domains and this class will assure that all
 * domains registered will be updated with a new <code>DataSource</code>
 * as needed.
 * <p>
 * This class is must useful in applications where the domains
 * are instantiated at start up, but may have
 * to handle operations for the different data sources using the
 * same underlying <code>DataSourceProperties</code>.
 */
public class DataSourceChangeEventHandler {

  private Vector domainList = new Vector();

  private DataSource currentDataSource = null;
  private final static Category LOG = Category.getInstance(DataSourceChangeEventHandler.class.getName());

  /** Constructs a instance. */
  public DataSourceChangeEventHandler() {
  }

  /**
   * Register a domain to handle.
   *
   * @param domain  <code>AbstractDomain</code> instance to register.
   */
  public void registerDomain(AbstractDomain domain) {
    if (domain == null) {
      throw new IllegalArgumentException("registerDomain(AbstractDomain domain); domain cannot be null!");
    }
    domainList.addElement(domain);
  }

  /**
   * Checks for a change of <code>DataSource</code> and updates all
   * domains with new <code>DataSource</code> if required.
   *
   * @param dataSource  data source to survey.
   * @return            <code>true</code> if all enclosed domains were notified of a new data source.
   * @see               net.sf.jrf.domain.AbstractDomain#setDataSource(DataSource)
   */
  public boolean checkDataSourceChangeEvent(DataSource dataSource) {
    if (dataSource == null) {
      throw new IllegalArgumentException("DataSource argument is null.");
    }
    if (currentDataSource == null || !dataSource.equals(currentDataSource)) {
      if (LOG.isDebugEnabled()) {
        LOG.debug("New data source: " + dataSource + "; old was " + currentDataSource + ". Updating domains.");
      }
      currentDataSource = dataSource;
      for (int i = 0; i < domainList.size(); i++) {
        AbstractDomain domain = (AbstractDomain) domainList.elementAt(i);
        domain.setDataSource(dataSource);
      }
      return true;
    }
    return false;
  }

  /**
   * Returns a list of all underlying domains of this handler.
   *
   * @return   a list of all underlying domains of this handler.
   */
  public String toString() {
    StringBuffer buf = new StringBuffer();
    for (int i = 0; i < domainList.size(); i++) {
      if (i > 0) {
        buf.append(",");
      }
      buf.append(domainList.elementAt(i));
    }
    return buf.toString();
  }
}

