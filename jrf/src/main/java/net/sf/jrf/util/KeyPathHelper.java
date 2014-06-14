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
 * Contributor: Tim Dawson (tdawson@is.com)
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
package net.sf.jrf.util;


import java.lang.reflect.*;

import java.util.StringTokenizer;

/**
 *  This class executes recursive getter methods (no parameters) using
 *  reflection.
 *
 *  i.e.  If you have an Employee instance that has a Manager instance, you
 *  could get the name of the employees manager with this key path string:
 *  "getManager.getName"
 */
public class KeyPathHelper
{

    /**
     * Recursively execute methods on the result of the previous method.
     *
     * @param obj                   a value of type 'Object' - i.e. an Employee instance
     * @param keyPath               a value of type 'String' - i.e. "getManager.getName"
     * @return                      a value of type 'Object' - i.e. returns the managers name
     * @exception KeyPathException  Description of the Exception
     */
    public static Object getValueForKeyPath(Object obj, String keyPath)
        throws KeyPathException
    {

        // Use reflection to call the appropriate method name

        // Create the parameter list array (empty)
        Class[] emptyParms = new Class[]
            {};

        // Create the args object (empty)
        Object args[] = new Object[]
            {};

        // Create the result object
        Object result = null;
        String methodName = null;
        Method getMethod = null;
        Class valueClass = null;

        // Tokenize the keypath
        StringTokenizer st = new StringTokenizer(keyPath, ".");

        try
        {
            // Grab
            result = obj;
            while (st.hasMoreTokens())
            {
                methodName = st.nextToken();
                valueClass = result.getClass();
                getMethod = valueClass.getMethod(methodName, emptyParms);
                result = getMethod.invoke(result, args);
            }
        }
        catch (Exception e)
        {
            throw new KeyPathException(e);
        }
        return result;
    }// getValueForKeyPath(anObject,aString)


    public static class KeyPathException
         extends Exception
    {
        private Exception i_originalException = null;

        /**
         *Constructor for the KeyPathException object
         *
         * @param e  Description of the Parameter
         */
        public KeyPathException(Exception e)
        {
            super();
            i_originalException = e;
        }

        public Exception getOriginalException()
        {
            return i_originalException;
        }

        public String toString()
        {
            return super.toString()
                + " [\n"
                + i_originalException.toString()
                + "]";
        }
    }// KeyPathException

}// KeyPathHelper


