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
 * Contributor: _____________________________________
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

import java.sql.SQLException;

import java.util.HashMap;
import java.util.Stack;

import org.apache.log4j.Category;

/**
 * Before anything else happens, do this:<br />
 * <tt>JDBCHelperPool.createPool(</tt><br />
 * <tt>    "XYZ_DB",                    // Name of the pool</tt><br />
 * <tt>    JDBCHelperFactory.create(),  // or however you create a JDBCHelper</tt><br />
 * <tt>    5);                          // number of objects in the pool.</tt><P>
 *
 *  Later, when you need a JDBCHelper instance:<br />
 *  <tt>JDBCHelperPool.getPool("XYZ_DB").getJDBCHelper();</tt><br />
 *
 *  When done with the pool:<br />
 *  <tt>JDBCHelperPool.getPool("XYZ_DB").destroy();</tt><br />
 */
public class JDBCHelperPool {

  /* ============  Static Variables  ============ */
  private static HashMap s_instances = new HashMap();
  /** log4j category for debugging and errors */
  private final static Category LOG =
          Category.getInstance(JDBCHelperPool.class.getName());

  /* ============  Instance Variables  ============ */
  private Stack i_stack = null;// pool of objects.
  private String i_name = null;// name of this pool instance.
  private JDBCHelper i_example = null;// example object for cloning purposes.
  private int i_stackSize = 0;// total number of objects to create.
  private int i_maxAttempts = 5;// try n times before throwing exception.
  private long i_waitTime = 1000;// milliseconds to wait between attempts.
  private boolean i_dataLocked = false;// allow changes until an object is retrieved.
  private boolean i_destroyed = false;


  /* ============  Constructor(s)  ============ */
  /**
   * This empty constructor is private so it is not used by anything other
   * than myself.
   */
  private JDBCHelperPool() {
    super();
  }


  /**
   * This constructor must not be used by application code.  Use the
   * createPool() method instead.
   *
   * @param poolName  a value of type 'String'
   * @param example   a value of type 'JDBCHelper'
   * @param poolSize  a value of type 'int'
   * @see             #JDBCHelperPool.createPool(String,JDBCHelper,int)
   */
  private JDBCHelperPool(String poolName, JDBCHelper example, int poolSize) {
    this();
    i_stack = new Stack();
    i_example = example;
    i_stackSize = poolSize;
    i_name = poolName;
    try {
      for (int i = 0; i < poolSize; i++) {
        JDBCHelper jdbcHelper = (JDBCHelper) i_example.clone();
        jdbcHelper.markInPool();// Don't allow it to be used when in pool.
        jdbcHelper.setCommitButDontClose(true);// keep connection open
        jdbcHelper.setJDBCHelperPool(this);
        i_stack.push(jdbcHelper);
      }
    } catch (CloneNotSupportedException e) {
      // This shouldn't happen, but if it does throw RuntimeException.
      // It's never good to just "eat" an exception.
      throw new RuntimeException(e.toString());
    } catch (NullPointerException npe) {
      npe.printStackTrace();
      throw npe;
    }
  }// JDBCHelperPool(...)


  /* ============  Static Methods  ============ */

  /**
   * This method must be called before a pool with this name can be retrieved.
   *
   * @param poolName     a value of type 'String'
   * @param aJDBCHelper  a value of type 'JDBCHelper'
   * @param poolSize     a value of type 'int'
   */
  public static void createPool(String poolName,
                                JDBCHelper aJDBCHelper,
                                int poolSize) {

    if (s_instances.containsKey(poolName)) {
      throw new IllegalArgumentException(
              "JDBCHelperPool named: '" + poolName + "' already exists!");
    }
    LOG.debug(
            "JDBCHelperPool creation attempt: '" + poolName + "'."
            + " aJDBCHelper: " + aJDBCHelper);
    JDBCHelperPool pool = new JDBCHelperPool(poolName,
            aJDBCHelper,
            poolSize);
    s_instances.put(poolName, pool);
    LOG.debug("JDBCHelperPool was created: '" + poolName + "'.");
  }


  /**
   * This method must be called before a pool with this name can be retrieved.
   *
   * @param poolName     a value of type 'String'
   */
  public static void destroyPool(String poolName) {
    JDBCHelperPool pool = JDBCHelperPool.getPool(poolName);
    pool.destroy();
  }


  /**
   * Return the pool with the given name.  Null is returned if none is found.
   *
   * @param poolName  a value of type 'String'
   * @return          a value of type 'JDBCHelperPool'
   */
  public static JDBCHelperPool getPool(String poolName) {
    JDBCHelperPool pool = (JDBCHelperPool) s_instances.get(poolName);
    if (pool == null) {
      LOG.debug("JDBCHelperPool.getPool('" + poolName
              + "') found no pool with that name.");
    }
    return pool;
  }


  /**
   * Return a JDBCHelper from the pool.  This is a shortcut/convenience
   * method for JDBCHelperPool.getPool("name").getJDBCHelper();
   *
   * @param poolName          a value of type 'String'
   * @return                  a value of type 'JDBCHelper'
   * @exception SQLException  Description of the Exception
   */
  public static JDBCHelper getFrom(String poolName)
          throws SQLException {
    JDBCHelperPool pool = JDBCHelperPool.getPool(poolName);
    if (pool == null) {
      throw new SQLException(
              "No pool with this name found: '" + poolName + "'");
    }
    return pool.getJDBCHelper();
  }


  /* ============  Instance Methods  ============ */

  /**
   * Close the JDBCHelper objects and remove them from the stack.  Once this
   * method is called, this instance can never be used again.
   */
  public void destroy() {
    i_destroyed = true;
    synchronized (i_stack) {
      while (!i_stack.empty()) {
        JDBCHelper jdbcHelper = (JDBCHelper) i_stack.pop();
        jdbcHelper.setCommitButDontClose(false);
        try {
          jdbcHelper.close();
        } catch (SQLException e) {
          // This is one of the few times it is OK to "eat" the error.
          LOG.error(
                  "SQLException occured while destroying JDBCHelperPool "
                  + "'" + i_name + "'",
                  e);

        }
      }
    }
  }


  /**
   * Gets an object from the pool of available ones.  If none are available,
   * it sleeps for waitTime then tries again. It repeats that for the number
   * of times specified in i_maxAttempts.
   *
   * NOTE: Once you are done with a JDBCHelper, you MUST return it to the
   * available pool by calling the returnJDBCHelper() method.
   * /
   *
   * @return                  a value of type 'JDBCHelper'
   * @exception SQLException  if an object is not found after n attempts.
   */
  public JDBCHelper getJDBCHelper()
          throws SQLException {
    if (i_destroyed) {
      LOG.error(
              "Error, Attempt to access the destroyed JDBCHelperPool named: '"
              + i_name + "'.");
      throw new SQLException("This JDBCHelperPool has been destroyed");
    }
    LOG.debug(
            "Requesting JDBCHelper from pool named '" + i_name + "'.");
    // "lock" all pool fields once a JDBCHelper is retrieved.
    i_dataLocked = true;
    synchronized (i_stack) {
      int attempts = 0;
      while (i_stack.empty()) {
        attempts++;
        if (attempts > i_maxAttempts) {
          LOG.warn(
                  "All JDBCHelper instances are busy. "
                  + "Throwing an SQLException.");
          throw new SQLException("All JDBCHelper instances are busy");
        }
        try {
          // sleep before checking for new objects again.
          // waiting for a connection to be returned.
          i_stack.wait(i_waitTime);
        } catch (Exception e) {
          LOG.error(
                  "Exception occurred while waiting on the stack", e);
          throw new SQLException(
                  "An error occurred while waiting for a JDBCHelper to be "
                  + "returned to the pool: " + e);
        }
        // Write to the log when we wait more than one period
        // for an object.
        if (attempts > 1) {
          LOG.warn(
                  "Warning, at least " + attempts
                  + " JDBCHelperPool get attempts. "
                  + "Consider increasing the pool size.");
        }
      }// while
      JDBCHelper jdbcHelper = (JDBCHelper) i_stack.pop();
      jdbcHelper.markOutOfPool();
      if (LOG.isDebugEnabled()) {
        LOG.debug(
                jdbcHelper.toString() + " found in pool named '" + i_name + "'.");
      }
      return jdbcHelper;
    }// synchronized(i_stack)
  }


  /**
   * This method returns an object to the available pool and notifies any
   * threads that are waiting for it.
   *
   * @param aJDBCHelper  Description of the Parameter
   */
  public void returnJDBCHelper(JDBCHelper aJDBCHelper) {
    if (aJDBCHelper == null) {
      throw new IllegalArgumentException(
              "JDBCHelperPool#returnJDBCHelper(aJDBCHelper) was called with "
              + "a null argument.");
    }
    if (aJDBCHelper.isInPool()) {
      LOG.warn(
              aJDBCHelper.toString()
              + " was already returned to pool '" + i_name + "'");
      return;
    }
    synchronized (i_stack) {
      aJDBCHelper.markInPool();
      i_stack.push(aJDBCHelper);
      i_stack.notify();
    }
    LOG.debug(
            aJDBCHelper.toString() + " was returned to pool named '" + i_name + "'.");
  }


  /**
   * Returns the maximum number of attempts that will be made trying to get
   * a connection.
   *
   * @return   The maxAttempts value
   */
  public int getMaxAttempts() {
    return i_maxAttempts;
  }


  /**
   * Sets the number of attempts to try to get an object before failing.
   * This is the number of times to wait for a connection to be
   * returned..when the pool is empty.  Min = 1, Max = 10
   *
   * @param value  The new maxAttempts value
   */
  public void setMaxAttempts(int value) {
    if (value < 1) {
      i_maxAttempts = 1;
    } else if (value > 10) {
      i_maxAttempts = 10;
    } else {
      i_maxAttempts = value;
    }
  }


  /**
   * Returns the wait in milliseconds betweent attempts
   * to get a conection
   *
   * @return   The waitTime value
   */
  public long getWaitTime() {
    return i_waitTime;
  }


  /**
   * Sets the waitTime in milliseconds. Min = 0, Max = 10000
   *
   * @param value  The new waitTime value
   */
  public void setWaitTime(long value) {
    if (value < 0) {
      i_waitTime = 0;
    } else if (value > 10000) {
      i_waitTime = 10000;
    } else {
      i_waitTime = value;
    }
  }

}// JDBCHelperPool
