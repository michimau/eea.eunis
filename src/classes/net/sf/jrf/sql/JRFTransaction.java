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

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;

import net.sf.jrf.*;
import net.sf.jrf.domain.*;
import net.sf.jrf.exceptions.*;
import org.apache.log4j.Category;

/** Base class for read and write transactions. */
public abstract class JRFTransaction {

  private final static Category LOG = Category.getInstance(JRFTransaction.class.getName());

  private HashMap dataSources = new HashMap();// Key is datasource hash; value = JRF connection.

  /**
   * Flag denoting whether connections should be synchronized. Default value is
   * <code>false</code>.
   */
  protected boolean shouldSynchronizeConnections = false;

  /**
   * Array of <code>JRFConnections</code> associated with the transaction. This
   * vector is only used if synchronization of connections is used.
   */
  protected Vector uniqueConnections = new Vector();

  /** Array of <code>JRFConnections</code> associated with the transaction. */
  protected Vector jrfConnections = new Vector();

  /**
   * Array of <code>AbstractDomain</code> information associated with the transaction.
   */
  protected HashMap domains = new HashMap();


  /**
   * Constructs a <code>JRFTransaction</code>, setting the should synchronize connections
   * attribute to <code>true</code>.
   *
   * @see   #setShouldSynchronizeConnections(boolean)
   */
  public JRFTransaction() {
  }

  /**
   * Constructs a <code>JRFTransaction</code>, using connection synchronization value.
   *
   * @param shouldSynchronizeConnections  connection synchronization value.
   * @see                                 #setShouldSynchronizeConnections(boolean)
   */
  public JRFTransaction(boolean shouldSynchronizeConnections) {
    this.setShouldSynchronizeConnections(shouldSynchronizeConnections);
  }

  /** Clears underlying collections of datasources and connections. */
  protected void clear() {
    jrfConnections.clear();
    //uniqueConnections.clear();
    //dataSources.clear();

  }

  /**
   * Sets whether connections from multiple <code>JRFConnection</code>
   * handles that point to the same <code>DataSource</code> should be
   * synchronized thus reducing the number of <code>Connection</code>
   * entities that must be handled to complete the transaction.
   * The default behavior of this class is always to synchronize connections.
   * Setting this value to <code>false</code>is not recommended in most cases
   * since multiple connections to the same data source
   * may have to be reconciled, particularly for database write transactions.
   * If the database enforces foreign key relationships, setting this value
   * to <code>false</code> will cause all sorts of problems (e.g.
   * errant reports of integrity violations, hangs etc.).
   * <b><i>Dedicated connections will never be synchronized.  While supported,
   * it is not recommended to mix non-dedicated  <code>JRFConnection<code>
   * domains with dedicated <code>JRFConnection<code> domains
   * in a single transaction. </i></b>.
   *
   * @param shouldSynchronizeConnections  if <code>true</code> connections will
   * be synchronized in <code>AbstractDomain</code>
   */
  public void setShouldSynchronizeConnections(boolean shouldSynchronizeConnections) {
    throw new RuntimeException("Not yet supported.");
    //this.shouldSynchronizeConnections = shouldSynchronizeConnections;
  }

  /**
   * Returns the current value of whether connections should be synchronized.
   *
   * @return   connection synchronization value.
   * @see      #setShouldSynchronizeConnections(boolean)
   */
  public boolean getShouldSynchronizeConnections() {
    return this.shouldSynchronizeConnections;
  }

  /**
   * Begins a transaction.  If the domain list has not been eliminated,
   * it will be re-surveyed to reconcile <code>JRFConnections</code> and
   * set transaction state flags.
   */
  public void beginTransaction() {
    try {
      clear();
      Iterator iter = domains.values().iterator();
      while (iter.hasNext()) {
        AbstractDomain domain = (AbstractDomain) iter.next();
        domain.setInTransactionState(true);
        // TODO:
        addDomainConnection(domain);
      }
      if (LOG.isDebugEnabled()) {
        LOG.debug(this + ".beginTransaction() complete:\n" + showAll());
      }
    } catch (Exception ex) {
      throw new DatabaseException(ex, "beginTrsnsaction() exception generated " + this);
    }
  }

  /**
   * Returns the underlying domains, connection and data source information
   * on this transaction.
   *
   * @return   transaction domain, connection and data source information.
   */
  public String toString() {
    return
            "Domains count: " + domains.size() + "\n" +
            "JRF Connections: " + jrfConnections.size() + "\n";
    /*
    "DataSources: "+dataSources.size()+"\n";
    */
  }

  /**
   * Description of the Method
   *
   * @return   Description of the Return Value
   */
  protected String showAll() {
    StringBuffer buf = new StringBuffer();
    Iterator iter = domains.values().iterator();
    int i = 0;
    while (iter.hasNext()) {
      i++;
      AbstractDomain domain = (AbstractDomain) iter.next();
      buf.append("Domain " + i + " of " + domains.size() + ": " + domain.getTableName() + " -");
      buf.append("JRFConn = " + domain.getJRFConnection().getName() + "\n");
    }
    i = 0;
    iter = jrfConnections.iterator();
    while (iter.hasNext()) {
      i++;
      JRFConnection conn = (JRFConnection) iter.next();
      buf.append("JRF Connection " + i + " of " + jrfConnections.size() + ": " + conn.getName() + "\n");
    }
    return buf.toString();
  }

  /**
   * Returns the total number of individual connections for
   * this transaction.
   *
   * @return   the total number of individual connections for this transaction.
   */
  public int getJDBCConnectionCount() {
    return jrfConnections.size();
  }

  /** Ends a transaction. */
  public abstract void endTransaction();

  /** Aborts a transaction. */
  public abstract void abortTransaction();

  private void addDomainConnection(AbstractDomain domain)
          throws SQLException {
    JRFConnection conn = domain.getJRFConnection();
    if (!jrfConnections.contains(conn)) {
      jrfConnections.addElement(conn);
    }
  }

  /** Clears the domain list. */
  public void clearDomains() {
    domains.clear();
  }

  /**
   * Adds an <code>AbstractDomain</code> to transaction domain list and any of the
   * embedded domains.  If the
   * domain is already on the list, this method will do nothing.
   * This method will call <code>getEmbeddedPersistentObjectDomains()</code> to
   * fetch any embedded domains.
   *
   * @param domain  domain to add.
   * @see           #endTransaction()
   */
  public void addDomain(AbstractDomain domain) {
    Integer hash = new Integer(domain.hashCode());
    if (!domains.containsKey(hash)) {
      Iterator iter = domain.getEmbeddedPersistentObjectHandlersIterator();
      while (iter.hasNext()) {
        EmbeddedPersistentObjectHandler handler = (EmbeddedPersistentObjectHandler) iter.next();
        AbstractDomain eDomain = handler.getDomain();
        if (eDomain != null) {
          this.addDomain(eDomain);
        }
      }
      domains.put(hash, domain);
    }
  }

  /** Description of the Method */
  protected void closeConnections() {
    int total = jrfConnections.size();
    for (int i = 0; i < total; i++) {
      JRFConnection c = (JRFConnection) jrfConnections.elementAt(i);
      c.closeOrReleaseResources();
    }
  }

  /** Clears transaction state flags in domains. */
  protected void clearTransactionStateFlags() {
    Iterator iter = domains.values().iterator();
    while (iter.hasNext()) {
      AbstractDomain domain = (AbstractDomain) iter.next();
      domain.setInTransactionState(false);
    }
  }
}

/* TODO: --
        // If not synchronizing, done.
        if (!this.shouldSynchronizeConnections) {
            return;
        }
        Integer hashCode = new Integer(conn.dataSource.hashCode());
        JRFConnection listConn = null;
        if ((listConn = (JRFConnection) dataSources.get(hashCode)) == null) {
            if (LOG.isDebugEnabled()) {
                LOG.debug("addDomainConnection("+domain+"): new datasource with connection "+conn);
            }
            // Force this guy to open up a connection.
            conn.assureDatabaseConnection();	// Force a connection init.
            dataSources.put(hashCode,conn);
            uniqueConnections.addElement(conn);
        }
        else {
            // Already got this data source.
            if (conn.isDedicatedConnection()) {
                uniqueConnections.addElement(conn);
            }
            else {
                if (LOG.isDebugEnabled()) {
                    LOG.debug("addDomainConnection("+domain+"): found data source. Synchronizing connection "+conn);
                }
                conn.synchronizeConnection(listConn); // Force conn == listConn
            }
        }
        */
