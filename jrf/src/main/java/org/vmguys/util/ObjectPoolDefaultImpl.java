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

/** A very simple implementation of an object pool.
*/
public class ObjectPoolDefaultImpl implements ObjectPool  {

    /** Max dormant time defaults to 3 minutes.
    */
    protected long maxDormantTime = 1000L * 3L * 60L;

    /** Maximum size, default to 1000. **/
    protected int maxSize = 100;

    /** Class name of pool */
    protected String className;

    /** Hash table pool **/
    protected Hashtable pool;

    /** Available list **/
    protected ArrayList available;

    /** Listener list **/
    protected ArrayList listeners;

    /** Default constructor.
    */
    public ObjectPoolDefaultImpl() {
        pool = new Hashtable();
        available = new ArrayList();
        listeners = new ArrayList();
    }

    /** Constructs instance using class name.
    */
    public ObjectPoolDefaultImpl(String className) {
        this();
        setClassName(className);
    }

    /** Returns available count.
    * @return available count.
    */
    public int getAvailableSize() {
        synchronized (available) {
            return available.size();
        }
    }

    /** Returns pool count.
    * @return poole count.
    */
    public int getPoolSize() {
        synchronized (pool) {
            return pool.size();
        }
    }

    /** Set the class name of the pool.
    * @param className
    */
    public void setClassName(String className) {
        this.className = className;
    }

    /** Sets maxiumum dormant time for a pooled object after which
    * it can be removed by <code>adjustPool()</code>.
    * @param maxDormantSeconds max dormant time in seconds.
    */
    public void setMaxDormantTime(int maxDormantSeconds) {
        this.maxDormantTime = (long) maxDormantSeconds * 1000L;
    }

    /** Fetches an object from the pool
    * @return object of class type specified in <code>setClassName()</code>.
    * @see #setClassName(String)
    */
    public Object getObject()  {
        Object result = null;
        synchronized (available) {
            if (available.size() > 0) {
                result = available.remove(0);
                pool.put(result,new Object());  // Mark in use.
            }
        }
        if (result == null) {
            if (pool.size() == maxSize) {
                throw new RuntimeException("Pool has reached maximum size of "+maxSize+" object.");
            }
            result = createObject();
            Iterator listenerIter = listeners.iterator();
            while (listenerIter.hasNext()) {
                ObjectPoolListener ol = (ObjectPoolListener) listenerIter.next();
                ol.objectCreated(result);
            }
            pool.put(result,new Object());
        }
        return result;

    }

    /** Sets maximum pool size.
    * @param max maximum pool value.
    */
    public void setMaximumSize(int maxSize) {
        this.maxSize = maxSize;
    }

    /** Returns an object to the pool.
    * @param obj object to return obtained through a call to <code>getObject()</code>
    * @see #getObject()
    */
    public void returnObject(Object obj) {
        Object back = pool.get(obj);
        if (back != null) { // Got object.
            synchronized (available) {
                available.add(obj);
                pool.put(obj,new Date());// Mark free.
            }
        }
    }

    /** Adjusts the size of the pool based on non-usage or dormant time.
    * This is an unsophisticated pool-trimming approach that will certainly not
    * work in environments with huge bursts of activity followed by quiescent periods.
    * More sophisticated sub-class implementations are certainly encouraged.
    * @see #setMaxDormantTime(int)
    */
    public void adjustPool() {
        Iterator iter = pool.values().iterator();
        long now = System.currentTimeMillis();
        while (iter.hasNext()) {
            Object obj = iter.next();
            if (obj instanceof Date) {
                Date d = (Date) obj;
                if (now - d.getTime() > maxDormantTime) {
                    iter.remove();
                    Iterator listenerIter = listeners.iterator();
                    while (listenerIter.hasNext()) {
                        ObjectPoolListener ol = (ObjectPoolListener) listenerIter.next();
                        ol.objectRemoved(obj);
                    }
                }
            }
        }
    }

    /** Allows a sub-class to allocate an object.
    * This method uses default constructor.
    * @return new instance of object.
    */
    protected Object createObject() {
        return  org.vmguys.reflect.ReflectionHelper.createObject(className);
    }


    /** @see org.vmguys.util.ObjectPool#addListener(ObjectPoolListener) **/
    public void addListener(ObjectPoolListener listener) throws UnsupportedOperationException {
        listeners.add(listener);
    }

    /** @see org.vmguys.util.ObjectPool#removeListener(ObjectPoolListener) **/
    public void removeListener(ObjectPoolListener listener) throws UnsupportedOperationException {
        int idx = listeners.indexOf(listener);
        if (idx != -1)
            listeners.remove(idx);
    }
}








