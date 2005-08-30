/*
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *
 *  http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations under
 *  the License.
 *
 *  The Original Code is jRelationalFramework.
 *
 *  The Initial Developer of the Original Code is is.com.
 *  Portions created by is.com are Copyright (C) 2000 is.com.
 *  All Rights Reserved.
 *
 *  Contributor: 		James Evans (jevans@vmguys.com)
 *  Contributor(s): ____________________________________
 *
 *  Alternatively, the contents of this file may be used under the terms of
 *  the GNU General Public License (the "GPL") or the GNU Lesser General
 *  Public license (the "LGPL"), in which case the provisions of the GPL or
 *  LGPL are applicable instead of those above.  If you wish to allow use of
 *  your version of this file only under the terms of either the GPL or LGPL
 *  and not to allow others to use your version of this file under the MPL,
 *  indicate your decision by deleting the provisions above and replace them
 *  with the notice and other provisions required by either the GPL or LGPL
 *  License.  If you do not delete the provisions above, a recipient may use
 *  your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.domain;

import net.sf.jrf.rowhandlers.*;

import java.util.*;

import org.apache.commons.collections.LRUMap;
import org.apache.log4j.Category;

/**
 *  Class of static methods to maintain caches for <code>PersistentObject</code>
 *  s. The static methods in this class are primarily for use in <code>AbstractDomain</code>
 *  . <p>
 *
 *  If multiple caches exist among several related composite objects, the only
 *  truly simple way to ensure that modifications are handled correctly among
 *  the caches is to clear a related cache. This is a simplistic approach that
 *  may later be supplanted with a more sophisticated approach, but for now
 *  removing a related, usually read-only, cache is all that is supported.
 *
 */
public class PersistentObjectCache {

  /**
   *  Cache type of none.
   *
   *@see    #getCacheType(Class)
   */
  public final static int CACHE_TYPE_NONE = 0;

  /**
   *  Cache type of all records cached.
   *
   *@see    #getCacheType(Class)
   */
  public final static int CACHE_TYPE_ALL = 1;

  /**
   *  Cache type of LRU (least-recently-used) cache.
   *
   *@see    #getCacheType(Class)
   */
  public final static int CACHE_TYPE_LRU = 2;

  // Log4j static.
  final static Category LOG = Category.getInstance(PersistentObjectCache.class.getName());

  /////////////////////////////////////////////////////////////
  // Hash table is thread safe.
  // Key = class of domain; value = ClassCache (see below)
  /////////////////////////////////////////////////////////////
  private static Hashtable s_cache = null;

  static {
    s_cache = new Hashtable();
  }


  /**
   *  Description of the Class
   *
   *@author     jevans
   *@created    June 13, 2002
   */
  static class SearchResult {
    private String encodedKey = null;
    private Object recordKey = null;
    private PersistentObject result = null;
    private boolean cacheable = false;
    private boolean argIsPersistentObject = true;


    /**
     *  Constructor for the SearchResult object
     *
     *@param  recordKey              Description of the Parameter
     *@param  argIsPersistentObject  Description of the Parameter
     */
    public SearchResult(Object recordKey, boolean argIsPersistentObject) {
      this.recordKey = recordKey;
      this.argIsPersistentObject = argIsPersistentObject;
    }


    /**
     *  Gets the encodedKey attribute of the SearchResult object
     *
     *@return    The encodedKey value
     */
    public String getEncodedKey() {
      return this.encodedKey;
    }


    /**
     *  Gets the cacheable attribute of the SearchResult object
     *
     *@return    The cacheable value
     */
    public boolean isCacheable() {
      return cacheable;
    }


    /**
     *  Gets the result attribute of the SearchResult object
     *
     *@return    The result value
     */
    public PersistentObject getResult() {
      return result;
    }


    /**
     *  Sets the result attribute of the SearchResult object
     *
     *@param  result  The new result value
     */
    public void setResult(PersistentObject result) {
      this.result = result;
    }
  }


  // Hash table value for each cache.
  /**
   *  Description of the Class
   *
   *@author     jevans
   *@created    June 13, 2002
   */
  private static class ClassCache {
    int type = CACHE_TYPE_NONE;
    int maxSize = 0;
    boolean findAllCalled = false;
    Map map = null;
    // Cache
    List relatedCaches;
    String className;
    // List of caches related to this cache.


    /**
     *  Constructor for the ClassCache object
     */
    ClassCache(String className) {
      this.className = className;
      relatedCaches = new ArrayList();
    }

    public boolean equals(Object o) {
      ClassCache c = (ClassCache) o;
      return this.className.equals(c.className);
    }

    // Clear out cache

    /**
     *  Description of the Method
     */
    void clear() {
      switch (type) {
        case CACHE_TYPE_NONE:
          break;
        case CACHE_TYPE_ALL:
          map.clear();
          map = null;
          findAllCalled = false;
          break;
        case CACHE_TYPE_LRU:
          map.clear();
          break;
      }
      // Possible infinite loop based on bad configuration.
      // No error handling for now.
      clearRelatedCache();
    }


    /**
     *  Description of the Method
     */
    void clearRelatedCache() {
      Iterator iter = relatedCaches.iterator();
      while (iter.hasNext()) {
        ClassCache c = (ClassCache) iter.next();
        c.clear();
      }
    }


    /**
     *  Sets the toNone attribute of the ClassCache object
     */
    void setToNone() {
      clear();
      map = null;
      maxSize = 0;
      type = CACHE_TYPE_NONE;
    }


    /**
     *  Description of the Method
     *
     *@return    Description of the Return Value
     */
    public String toString() {
      return "\n" + className +
              "\nType = " + type + " (0=none; 1=all; 2= lru)" +
              "\nmaxSize = " + maxSize +
              "\nfindAllCalled = " + findAllCalled +
              "\nmap = " + map;
    }
  }


  // Static methods only.
  /**
   *  Constructor for the PersistentObjectCache object
   */
  private PersistentObjectCache() {
  }


  /**
   *  Adds a related cache to a given cache.  Any changes to the base
   *  class cache will result the the clearing of the relation class
   *  cache.
   *
   *@param  baseClass      class name of cache that needs to store the
   *      relation.
   *@param  relationClass  class name of related cache.
   */
  public static void addRelatedCache(Class baseClass, Class relationClass) {
    ClassCache baseCache = findOrCreateCache(baseClass);
    ClassCache relationCache = findOrCreateCache(relationClass);
    synchronized (baseCache) {
      if (!baseCache.relatedCaches.contains(relationCache))
        baseCache.relatedCaches.add(relationCache);
    }
  }


  /**
   *  Returns the cache type of this domain class, irrespective of the current
   *  instance.
   *
   *@param  domainClass  Description of the Parameter
   *@return              the cache type for the domain class application wide.
   *@see                 #CACHE_TYPE_NONE
   *@see                 #CACHE_TYPE_LRU
   *@see                 #CACHE_TYPE_ALL
   */
  public static int getCacheType(Class domainClass) {
    return findOrCreateCache(domainClass).type;
  }


  /**
   *  Sets whether all records should be cached. A <code>false</code>
   *  parameter will not generate any action. If you want to turn caching off,
   *  use <code>removeCache()</code>
   *
   *@param  domainClass  class instance of the domain.
   *@param  value        if <code>true</code> all records will be cached..
   *@see                 #setMaxCacheSize(Class,int)
   *@see                 #removeCache(Class)
   */
  public static void setCacheAll(Class domainClass, boolean value) {
    ClassCache cache = findOrCreateCache(domainClass);
    synchronized (cache) {
      switch (cache.type) {
        case CACHE_TYPE_ALL:
          if (value) {
            value = false;
            // Already cache all.
          }
          break;
        case CACHE_TYPE_LRU:
          if (value) {
            cache.clear();
          }
          break;
        default:
          break;
      }
      if (value) {
        cache.type = CACHE_TYPE_ALL;
        cache.map = new HashMap();
      }
    }
  }


  /**
   *  Clears the cache entirely. Cache type does not change.
   *
   *@param  domainClass  class instance of the domain.
   */
  public static void clearCache(Class domainClass) {
    ClassCache cache = findOrCreateCache(domainClass);
    synchronized (cache) {
      cache.clear();
    }
  }


  /**
   *  Clears the cache entirely <em>and</em> sets the cache type to <code>CACHE_TYPE_NONE</code>
   *  .
   *
   *@param  domainClass  class instance of the domain.
   */
  public static void removeCache(Class domainClass) {
    ClassCache cache = findOrCreateCache(domainClass);
    synchronized (cache) {
      cache.setToNone();
    }
  }


  /**
   *  Returns an indication of whether the domain class is cached.
   *
   *@param  domainClass  class instance of the domain.
   *@return              <code>true</code> if all records should be cached or
   *      are cached.
   */
  public static boolean isCacheAll(Class domainClass) {
    return findOrCreateCache(domainClass).type == CACHE_TYPE_ALL;
  }


  /**
   *  Sets the maximum size of the cache. A size of zero denotes no cache.
   *  This method may be used to increase the size of an existing cache. If
   *  'cacheAll' is set, calling this method will clear the cache and change
   *  the type to <code>CACHE_TYPE_LRU</code>.
   *
   *@param  domainClass  class instance of the domain.
   *@param  size         size of the cache.
   */
  public static void setMaxCacheSize(Class domainClass, int size) {
    if (size <= 0) {
      return;
    }
    ClassCache cache = findOrCreateCache(domainClass);
    synchronized (cache) {
      if (cache.type == CACHE_TYPE_ALL) {
        cache.clear();
      }
      cache.maxSize = size;
      if (cache.type == CACHE_TYPE_LRU) {
        LRUMap m = (LRUMap) cache.map;
        m.setMaximumSize(size);
      } else {
        cache.map = new LRUMap(size);
        cache.type = CACHE_TYPE_LRU;
      }
    }
  }


  /**
   *  Gets the maximum size of the cache. A zero value may mean either that
   *  the type is <code>CACHE_TYPE_ALL</code> or <code>CACHE_TYPE_NONE</code>.
   *
   *@param  domainClass  class instance of the domain.
   *@return              size of the cache.
   *@see                 #getCacheType(Class)
   */
  public static int getMaxCacheSize(Class domainClass) {
    return findOrCreateCache(domainClass).maxSize;
  }


  /**
   *  Returns the current cache size.
   *
   *@param  domainClass  class instance of the domain.
   *@return              current cache size.
   */
  public static int getCacheSize(Class domainClass) {
    ClassCache cache = findOrCreateCache(domainClass);
    return cache.map == null ? 0 : cache.map.size();
  }


  // Package-scope method used in AbstractDomain only to
  // Find a given cache and/or create one if it doesn't exist.
  /**
   *  Description of the Method
   *
   *@param  domainClass  Description of the Parameter
   *@return              Description of the Return Value
   */
  static ClassCache findOrCreateCache(Class domainClass) {
    ClassCache cache = (ClassCache) s_cache.get(domainClass);
    if (cache == null) {
      cache = new ClassCache(domainClass.getName());
      s_cache.put(domainClass, cache);
    }
    return cache;
  }


  /**
   *  Description of the Method
   *
   *@param  domain         Description of the Parameter
   *@param  changedObject  Description of the Parameter
   */
  static void updateCache(AbstractDomain domain, PersistentObject changedObject) {
    ClassCache cache = findOrCreateCache(domain.getClass());
    if (cache.type != CACHE_TYPE_NONE) {
      updateCache(cache, domain.encodePrimaryKey(changedObject), changedObject);
      // Check parent's cache.
      cache = findOrCreateCache(domain.getClass().getSuperclass());
      if (cache.type != CACHE_TYPE_NONE) {
        PersistentObject parentObject = domain.createAndPopulateParentPersistentObject(changedObject);
        updateCache(cache, domain.getParentEncodedPrimaryKey(parentObject), parentObject);
      }
    }
  }


  /**
   *  Description of the Method
   *
   *@param  domainClass  Description of the Parameter
   *@param  key          Description of the Parameter
   *@param  aPO          Description of the Parameter
   */
  static void updateCache(Class domainClass, String key, PersistentObject aPO) {
    updateCache(findOrCreateCache(domainClass), key, aPO);
  }


  /**
   *  Description of the Method
   *
   *@param  cache  Description of the Parameter
   *@param  key    Description of the Parameter
   *@param  aPO    Description of the Parameter
   */
  static void updateCache(ClassCache cache, String key, PersistentObject aPO) {
    synchronized (cache) {
      if (cache.map != null) {
        if (LOG.isDebugEnabled()) {
          LOG.debug(aPO.getClass().getName() + ": updating cache with state "
                  + aPO.getPersistentState() + ": " + aPO);
        }
        if (aPO.hasDeletedPersistentState()) {
          cache.map.remove(key);
        } else {
          cache.map.put(key, aPO);
        }
        cache.clearRelatedCache();
      }
    }
  }


  // find() saves encoded key for possible update to cache.
  /**
   *  Description of the Method
   *
   *@param  domain        Description of the Parameter
   *@param  searchResult  Description of the Parameter
   */
  static void find(AbstractDomain domain, SearchResult searchResult) {
    ClassCache cache = initializeCache(domain);
    if (cache.type != CACHE_TYPE_NONE) {
      searchResult.cacheable = true;
      if (searchResult.argIsPersistentObject) {
        PersistentObject aPO = (PersistentObject) searchResult.recordKey;
        searchResult.encodedKey = domain.encodePrimaryKey(aPO);
      } else {
        searchResult.encodedKey = (searchResult.recordKey == null ? "null" : searchResult.recordKey.toString());
      }
      searchResult.setResult((PersistentObject) cache.map.get(searchResult.encodedKey));
    }
  }


  /**
   *  Description of the Method
   *
   *@param  domain  Description of the Parameter
   *@return         Description of the Return Value
   */
  static List findAll(AbstractDomain domain) {
    ClassCache cache = initializeCache(domain);
    return cache.type == CACHE_TYPE_ALL ? new ArrayList(cache.map.values()) : null;
  }


  // Run findAll() if required on cache.
  /**
   *  Description of the Method
   *
   *@param  domain  Description of the Parameter
   *@return         Description of the Return Value
   */
  private static ClassCache initializeCache(AbstractDomain domain) {
    ClassCache cache = findOrCreateCache(domain.getClass());
    synchronized (cache) {
      if (cache.type != CACHE_TYPE_NONE) {
        if (cache.type == CACHE_TYPE_ALL && !cache.findAllCalled) {
          ApplicationRowHandlerHashMap h = new ApplicationRowHandlerHashMap(domain);
          domain.findAll(h);
          cache.map = (Map) h.getResult();
          cache.findAllCalled = true;
        }
      }
    }
    return cache;
  }


  /**
   *  Returns <code>true</code> if <code>PersistentObjects</code> maintained
   *  by <code>domainClass</code> instance are cached.
   *
   *@param  domainClass  class instance of the domain.
   *@return              <code>true</code> if <code>PersistentObjects</code>
   *      maintained by <code>domainClass</code> instance are cached.
   */
  public static boolean isClassCached(Class domainClass) {
    ClassCache cache = findOrCreateCache(domainClass);
    return cache.type == CACHE_TYPE_NONE ? false : true;
  }
}

////////////////////////////////////////////////////////////////////////////

/*
 *  Original thread-specifc code from AbstractStaticDomain.
 *  private static ThreadLocal s_cache = null;
 *  s_cache = new ThreadLocal()
 *  {
 *  / This would be specific just to the thread.
 *  / We need the entire application.
 *  protected Object initialValue() {
 *  return new HashMap();
 *  }
 *  };
 */
