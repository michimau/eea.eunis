/* ====================================================================
 * The VM Systems, Inc. Software License, Version 1.0
 *
 * Copyright (c) 2002 VM Systems, Inc.  All rights reserved.
 *
 * THIS SOFTWARE IS PROVIDED PURSUANT TO THE TERMS OF THIS LICENSE.
 * ANY USE, REPRODUCTION, OR DISTRIBUTION OF THE SOFTWARE OR ANY PART
 * THEREOF CONSTITUTES ACCEPTANCE OF THE TERMS AND CONDITIONS HEREOF.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by
 *        VM Systems, Inc. (http://www.vmguys.com/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "VM Systems" must not be used to endorse or promote products
 *    derived from this software without prior written permission. For written
 *    permission, please contact info@vmguys.com.
 *
 * 5. VM Systems, Inc. and any other person or entity that creates or
 *    contributes to the creation of any modifications to the original
 *    software specifically disclaims any liability to any person or
 *    entity for claims brought based on infringement of intellectual
 *    property rights or otherwise. No assurances are provided that the
 *    software does not infringe on the property rights of others.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE TITLE
 * AND NON-INFRINGEMENT ARE DISCLAIMED. IN NO EVENT SHALL VM SYSTEMS, INC.,
 * ITS SHAREHOLDERS, DIRECTORS OR EMPLOYEES BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE. EACH RECIPIENT OR USER IS SOLELY RESPONSIBLE
 * FOR DETERMINING THE APPROPRIATENESS OF USING AND DISTRIBUTING THE SOFTWARE
 * AND ASSUMES ALL RISKS ASSOCIATED WITH ITS EXERCISE OF RIGHTS HEREUNDER,
 * INCLUDING BUT NOT LIMITED TO THE RISKS (INCLUDING COSTS) OF ERRORS,
 * COMPLIANCE WITH APPLICABLE LAWS OR INTERRUPTION OF OPERATIONS.
* ====================================================================
*/
package org.vmguys.util;
import java.util.*;
import org.vmguys.reflect.*;
import org.apache.log4j.Category;

/** A factory for creating and accessing pools by class name.
*
*/
public class ObjectPoolFactory {

    private static Category LOG = Category.getInstance(ObjectPoolFactory.class.getName());

    private static Properties properties;

    private static final String POOLIMPLKEY = "poolImplementationClassName";
    // Thread safe list of pools.
    private static Hashtable listOfPools = null;

    private static ArrayList globalListeners = null;
    static {
        listOfPools = new Hashtable();
        properties = new Properties();
        globalListeners = new ArrayList();
        String poolProp = null;
        // This may get overwritten below;
        properties.put(POOLIMPLKEY,"org.vmguys.util.ObjectPoolDefaultImpl");
        try {
            poolProp = System.getProperty("objectpoolproperties");
            if (poolProp == null)
                poolProp = "objectpool";
            ResourceBundle bundle = ResourceBundle.getBundle(poolProp);
            Enumeration enumer = bundle.getKeys();
                while ( enumer.hasMoreElements() ) {
                        String key = (String) enumer.nextElement();
                    properties.put(key,bundle.getString(key));
            }
        }
        catch (MissingResourceException m) {
            LOG.warn(poolProp+".properties not found. Default settings used.");
        }
        catch (Exception ex) {
            LOG.error("Error processing properties for "+poolProp,ex);
        }
    }

    /** Trims all pools.  This method will usually be called from a timer thread of some sort.
    */
    static public void adjustPools() {
        Iterator iter = listOfPools.values().iterator();
        while (iter.hasNext()) {
            ObjectPool pool = (ObjectPool) iter.next();
            pool.adjustPool();
        }
    }

    private ObjectPoolFactory(){
    }

    /** Adds a global listener to be added to any object pool created in this class, irrespective of class name.
    * @param listener listener to call when an object is first created on the pool.
    * @see org.vmguys.util.ObjectPool#addListener(ObjectPoolListener)
    */
    static public void addListener(ObjectPoolListener listener) {
        if (!globalListeners.contains(listener))
            globalListeners.add(listener);
    }

    /** Adds a listener to the pool.
    * @param className class name of the object.
    * @param listener listener to call when an object is first created on the pool.
    * @throws UnsupportedOperationException if listeners are supported on the pool implementation.
    * @see org.vmguys.util.ObjectPool#removeListener(ObjectPoolListener)
    */
    static public void addListener(String className, ObjectPoolListener listener)
                throws UnsupportedOperationException {
        getPool(className).addListener(listener);
    }


    /** Removes a listener from the pool.
    * @param className class name of the object.
    * @param listener listener to call when an object is first created on the pool.
    * @throws UnsupportedOperationException if listeners are supported on the pool implementation.
    * @see org.vmguys.util.ObjectPool#removeListener(ObjectPoolListener)
    */
    static public void removeListener(String className, ObjectPoolListener listener)
                throws UnsupportedOperationException {
        getPool(className).removeListener(listener);
    }

    static private ObjectPool getPool(String className) {
        ObjectPool objMgr = (ObjectPool) listOfPools.get(className);
        if (objMgr == null) {
            try {
                objMgr = (ObjectPool) org.vmguys.reflect.ReflectionHelper.createObject(
                    properties.getProperty(POOLIMPLKEY));
                objMgr.setClassName(className);
                synchronized (globalListeners) {
                    Iterator iter = globalListeners.iterator();
                    while (iter.hasNext()) {
                        objMgr.addListener( (ObjectPoolListener) iter.next() );
                    }
                }
                // Call any additional setters.
                if (properties.size() > 1) {
                    BeanSearchUtil bs = new BeanSearchUtil(objMgr.getClass());
                    bs.processProperties(properties,objMgr,false,className);
                }
                listOfPools.put(className,objMgr);
            }
            catch (Exception ex) {
                String errorMessage =
                    "Unexpected error creating object pool using implementation "
                        +properties.getProperty(POOLIMPLKEY);
                LOG.error(errorMessage,ex);
                throw new RuntimeException(errorMessage+". "
                        +ex.getClass().getName()+": "+ex.getMessage());

            }
        }
        return objMgr;
    }

    /** Returns requested object.
    * @param className class name of the object.
    */
    static public Object getObject(String className) {
        return getPool(className).getObject();
    }

    /** Releases the object fetched in <code>getInstance()</code>
    * @param obj Object instance to return to the pool.
    */
    static public void returnObject(Object obj) {
        ObjectPool objMgr = (ObjectPool) listOfPools.get(obj.getClass().getName());
        if (objMgr == null) {
            LOG.error("No pool for "+obj.getClass().getName());
        }
        else
            objMgr.returnObject(obj);
    }

}
