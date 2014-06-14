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
 * Contributor: CJ Hurst (cjhurst@is.com)
 * Contributor: Tim Dawson (tdawson@is.com)
 * Contributor: ______________________________
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


import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

/**
 *  This class defines a set of static methods which allow get sublists,
 *  convert to & from arrays, sort, and concatenate lists.
 */
public class ListUtil
{

    /**
     *  Return a string that contains all the list components as strings
     *  separated by the specified separator.
     *
     * @param vec        the list to convert to a separated string
     * @param separator  the string separator between elements
     * @return           a concatenated string of the list elements
     */
    public static String join(List vec, String separator)
    {
        StringBuffer buf = new StringBuffer();

        if (separator == null)
        {
            separator = "";
        }

        Iterator e = vec.iterator();
        while (e.hasNext())
        {
            buf.append(e.next().toString());

            // if there are more, include the separator
            if (e.hasNext())
            {
                buf.append(separator);
            }
        }

        return buf.toString();
    }


    /**
     * Create a list from an array of objects.
     *
     * @param array  the array of objects to convert to a list
     * @return       a list of objects
     */
    public static List listFromArray(Object[] array)
    {
        List elements = new ArrayList();

        if (array != null)
        {
            int length = array.length;

            if (length > 0)
            {
                for (int i = 0; i < length; i++)
                {
                    elements.add(array[i]);
                }
            }
        }

        return elements;
    }


    /**
     * Create an array of strings from a list of strings.
     *
     * @param list  the list to convert into an array of strings
     * @return      an array of strings
     */
    public static String[] stringArrayFromList(List list)
    {
        String array[] = null;

        if ((list != null) && (list.size() > 0))
        {
            int size = list.size();
            array = new String[size];

            for (int i = 0; i < size; i++)
            {
                array[i] = list.get(i).toString();
            }
        }

        return array;
    }


    /**
     * Sort List argument - natural order
     *
     * @param aList  Description of the Parameter
     * @return       Description of the Return Value
     */
    public static List sort(List aList)
    {
        List results = null;

        if (aList != null)
        {
            results = new ArrayList();
            Object[] array = aList.toArray();
            Arrays.sort(array);
            List list = Arrays.asList(array);
            ListIterator listIterator = list.listIterator();
            while (listIterator.hasNext())
            {
                results.add(listIterator.next());
            }
        }

        return results;
    }


    /**
     * Iterate through the list and return the first object whose KeyPath is
     * equal to the "equals" argument.  Return null if none exist.
     *
     * @param v                                   a value of type 'List'
     * @param keyPath                             a value of type 'String'
     * @param equals                              a value of type 'Object'
     * @return                                    a value of type 'List'
     * @exception KeyPathHelper.KeyPathException  Description of the Exception
     * @see                                       net.sf.jrf.util.KeyPathHelper
     */
    public static Object find(List v,
        String keyPath,
        Object equals)
        throws KeyPathHelper.KeyPathException
    {
        Object returnValue = null;
        List found = ListUtil.select(v, keyPath, equals);
        if (found.size() > 0)
        {
            returnValue = found.get(0);
        }
        return returnValue;
    }


    /**
     * Iterate through the list looking for objects whose KeyPath is equal
     * to the equals argument.  Return the matching objects in a list.  If
     * none are found, an empty list is returned.  This is similar to the
     * Smalltalk select: statement.
     *
     * @param v                                   a value of type 'List'
     * @param keyPath                             a value of type 'String'
     * @param equals                              a value of type 'Object'
     * @return                                    a value of type 'List'
     * @exception KeyPathHelper.KeyPathException  Description of the Exception
     * @see                                       net.sf.jrf.util.KeyPathHelper
     */
    public static List select(List v,
        String keyPath,
        Object equals)
        throws KeyPathHelper.KeyPathException
    {
        List returnValue = new ArrayList();
        Iterator iterator = v.iterator();
        while (iterator.hasNext())
        {
            Object o = iterator.next();
            if (o != null)
            {
                Object value = null;
                value = KeyPathHelper.getValueForKeyPath(o, keyPath);
                if (value != null &&
                    value.equals(equals))
                {
                    returnValue.add(o);
                }
            }
        }
        return returnValue;
    }

}// ListUtil

