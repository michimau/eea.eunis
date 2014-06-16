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
/*
////////////////////////////////////////////////////////////
*/
package org.vmguys.reflect;
import java.util.*;
import java.lang.reflect.*;
import java.io.*;
import java.beans.*;

/** A simple management class over <code>BeanInfo</code> that allows searching of
* a particular property description.  This class is not sophisticated enough to handle
* overloaded methods.
* This is a moribund class.  Most of the functionality of this class is duplicated and
* enhanced in <code>org.apache.commons.beanutils.BeanUtils.java</code> and
* <code>org.apache.commons.beanutils.PropertyUtils.java</code>.
*/
public class BeanSearchUtil  {


            private BeanInfo beanInfo = null;
        private PropertyDescriptor [] properties = null;
        /** Constructs an instance with given class.
        * @param cls <code>Class</code> instance.
        */
        public BeanSearchUtil(Class cls) throws IntrospectionException {
            beanInfo = Introspector.getBeanInfo(cls);
            properties = beanInfo.getPropertyDescriptors();
        }

        /** Returns property descriptors.
        * @return property descriptors.
        */
        public PropertyDescriptor [] getPropertyDescriptors() {
            return properties;
        }

        /** Returns property descriptor for given name.
        * @param name name of property.
        * @param caseInsensitiveSearch if <code>true</code>, do a case-insenstive search
        *                        for name.
        * @return property descriptor or <code>null</code> if not found.
        **/
        public PropertyDescriptor getPropertyDescriptor(String name,boolean caseInsensitiveSearch) {
            for (int i = 0; i < properties.length; i++) {
                boolean test;
                if (caseInsensitiveSearch)
                    test = name.equalsIgnoreCase(properties[i].getName());
                else
                    test = name.equals(properties[i].getName());
                if (test)
                    return properties[i];
            }
            return null;
        }

        /** Processes entire properties list, evokes setter values on the bean, and optionally removes
         * <code>Properties</code> keys  that are found.
         * @param properties object to analyze.
         * @param obj bean to call setters.
         * @param removeFoundKeys if <code>true</code>, keys that are found will be removed from the
         * <code>Properties</code> instance.
         * @throws IllegalArgumentException if error occurs calling set method.
         */ 
        public void processProperties(Properties p,Object obj,boolean removeFoundKeys) {
            processProperties(p,obj,removeFoundKeys,null);
        }


        /** Processes entire properties list, evokes setter values on the bean, and optionally removes
         * <code>Properties</code> keys  that are found.
         * @param properties object to analyze.
         * @param prefix optional prefix value; the method name will be assumed data passed the prefix and
         * separator.  For example, "com.stuff.x.RunWork". If "com.stuff.x." is the prefix, "RunWork" will
         * be called.  All properties that do not start with the prefix will be ignored.
         * @param obj bean to call setters.
         * @param removeFoundKeys if <code>true</code>, keys that are found will be removed from the
         * <code>Properties</code> instance.
         * @throws IllegalArgumentException if error occurs calling set method.
         */ 
        public void processProperties(Properties p,Object obj,boolean removeFoundKeys,String prefix) {
            StringBuffer notFound = new StringBuffer();
            Enumeration e = p.propertyNames();
            while (e.hasMoreElements()) {
                String key = (String) e.nextElement();
                if (prefix != null) {
                    if (key.startsWith(prefix)) {
                        key = key.substring(prefix.length());
                    }
                    else { // Ignore
                        key = null;
                    }                   
                }
                if (key != null) {
                    if (evokeWriteMethod(obj,key,p.getProperty(key)) && removeFoundKeys) {
                        p.remove(key);
                    }
                }
            }
        }
        
        /** Evokes write method for given name.
         * @param obj <code>Object</code> that contains method.
         * @param methodName method name to invoke
         * @param valueToSet value to set in bean.
         * @return <code>true</code> if method was found.
         * @throws IllegalArgumentException if error occurs calling set method.
         */
        public boolean evokeWriteMethod(Object obj, String methodName, String valueToSet) {
            Method m = getWriteMethod(methodName,true);
            boolean found = (m != null ? true:false);
            if (found) {
                try {
                    ReflectionHelper.invokeSetProperty(obj,m,valueToSet);
                }
                catch (Exception ex) {
                    throw new IllegalArgumentException("Unable to call "+m.getName()+": "+ex.getClass().getName()+": "+
                        ex.getMessage());
                }   
            }
            return found;
        }

        /** Returns set method name.
        * @param name name of property.
        * @param caseInsensitiveSearch if <code>true</code>, do a case-insenstive search
        *                        for name.
        * @return set method  or <code>null</code> if not found.
        */
        public Method getWriteMethod(String name, boolean caseInsensitiveSearch) {
            if (name.startsWith("set") && name.length() > 3)
                name = name.substring(3);
            PropertyDescriptor p = getPropertyDescriptor(name,caseInsensitiveSearch);
            return (p == null ? null:p.getWriteMethod());
        }

        /** Returns get method name.
        * @param name name of property.
        * @param caseInsensitiveSearch if <code>true</code>, do a case-insenstive search
        *                        for name.
        * @return get method  or <code>null</code> if not found.
        */
        public Method getReadMethod(String name, boolean caseInsensitiveSearch) {
            if (name.length() > 3) {
                if (name.startsWith("get"))
                    name = name.substring(3);
                else if (name.startsWith("is")) {
                    name = name.substring(2);
                }   
            }
            PropertyDescriptor p = getPropertyDescriptor(name,caseInsensitiveSearch);
            return (p == null ? null:p.getReadMethod());
        }


        /** Returns names of all properties and some minimal information.
        * @return names of all properties and some minimal information.
        */
        public String toString() {
            StringBuffer buf = new StringBuffer();
            for (int i = 0; i < properties.length; i++) {
                buf.append("\nName: "+properties[i].getName()); 
            }
            return buf.toString();
        }

}
