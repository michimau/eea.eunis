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
package net.sf.jrf.domain;

import java.util.ArrayList;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import net.sf.jrf.*;
import net.sf.jrf.rowhandlers.*;
import org.apache.log4j.Category;

/**
 *  This abstract superclass caches the PersistentObjects for it's
 *  subclasses.
 *
 *  Subclasses of this abstract class should represent relatively small
 *  lookup tables that rarely or never change.  i.e. a Gender table with two
 *  rows.  One row for male, and one for female.  The resulting
 *  PersistentObjects are cached so that calls to find() or findAll() return
 *  the cached instances instead.
 *
 *  The cache uses a ThreadLocal instance so this should be able to be used in a
 *  multi-threaded environment where the threads are pooled.  If the threads
 *  are not pooled then using this superclass may not benefit the
 *  performance of the application much.
 *
 *  In a single-threaded environment this will work fine too.
 * <p>
 *
 * @deprecated   Use AbstractDomain with <code>setCacheAll(Class,true)</code>.
 * @see          net.sf.jrf.domain.PersistentObjectCache#setCacheAll(Class,boolean)
 */
public abstract class AbstractStaticDomain
        extends AbstractDomain {

  private static Category LOG = Category.getInstance(AbstractStaticDomain.class.getName());
  /** This is a ThreadLocal so it can be used in an EJB environment. */
  private static ThreadLocal s_cache = null;// static


  /** Default constructor */
  public AbstractStaticDomain() {
    super();
    addListener();

  }

  /**
   * Single option constructor.
   *
   * @param option  domain option.
   */
  public AbstractStaticDomain(int option) {
    super(option);
    addListener();
  }

  /**
   * <code>Properties</code> constructor.
   *
   * @param prop  domain properties.
   */
  public AbstractStaticDomain(Properties prop) {
    super(prop);
    addListener();
  }

  /**
   * This is a static initializer that is executed when this class is loaded
   * by the JVM.  I'm commenting it because I haven't seen this feature used
   * all that much.
   */
  static {
    s_cache =
            new ThreadLocal() {
              protected Object initialValue() {
                return new HashMap();
              }
            };
  }

  // AbstractDomain


  private void addListener() {
    addUpdateListener(new StaticUpdateListener());
  }

  /**
   * Gets the size of the cache of all records.
   *
   * @return   size of the cache.
   */
  public int getCacheSize() {
    Map m = getInstanceCache();
    return m.size();
  }

  /**
   * Does nothing. Since all records are cached, this method is
   * irrelevant.
   *
   * @param size  size of the cache; value is ignored.
   */
  public void setCacheSize(int size) {
  }

  /** Resets the cache by forcing a re-read of the database. */
  public void resetCache() {
    refresh((Map) s_cache.get());
  }

  private Map refresh(Map classMap) {
    ApplicationRowHandlerHashMap h = new ApplicationRowHandlerHashMap(this);
    super.findAll(h);
    Map instanceCache = (HashMap) h.getResult();
    classMap.put(this.getClass(), instanceCache);
    return instanceCache;
  }

  /**
   * Return a Map is unique to this thread and subclass.  If not populated,
   * the map will be populated with the results of findAll() before being
   * returned to the caller.
   *
   * @return   a value of type 'Map'
   */
  private Map getInstanceCache() {
    Map classMap = (Map) s_cache.get();
    Map instanceCache = (Map) classMap.get(this.getClass());
    if (instanceCache == null) {
      instanceCache = refresh(classMap);
    }
    return instanceCache;
  }

  // Force use of regular find method
  private PersistentObject dbFind(PersistentObject aPO) {
    return super.find(aPO);
  }

  /**
   * This is a method override that gets its objects from the cache.
   *
   * @param pkOrPO  a value of type 'Object'
   * @return        a value of type 'PersistentObject'
   */
  public PersistentObject find(Object pkOrPO) {
    String key = null;
    if (pkOrPO instanceof PersistentObject) {
      PersistentObject aPO = (PersistentObject) pkOrPO;
      key = this.encodePrimaryKey(aPO);
    } else {
      key = (pkOrPO == null ? "null" : pkOrPO.toString());
    }
    return (PersistentObject) this.getInstanceCache().get(key);
  }// find(pkOrPO)


  /**
   * Return all of the instances that are in the cache.
   *
   * @return             a value of type 'List'
   */
  public List findAll() {
    return new ArrayList(this.getInstanceCache().values());
  }

  private class StaticUpdateListener implements UpdateListener {
    public void objectUpdated(PersistentObject aPO) {
      String key = encodePrimaryKey(aPO);
      if (LOG.isDebugEnabled()) {
        LOG.debug("Updating " + key + ": " + aPO.getPersistentState() + ": " + aPO);
      }
      // If join table domain, have to refetch.
      if (isJoinTableDomain()) {
        PersistentObject db = dbFind(aPO);
        // Race condition -- someone has deleted record.
        if (db == null) {
          aPO.markDeletedPersistentState();
        } else {
          aPO = db;
        }
      }
      Map m = getInstanceCache();
      // Hash map is not synchronized.
      synchronized (m) {
        if (aPO.hasDeletedPersistentState()) {
          m.remove(key);
        } else {
          m.put(key, aPO);
        }
      }
    }
  }

}// AbstractStaticDomain




