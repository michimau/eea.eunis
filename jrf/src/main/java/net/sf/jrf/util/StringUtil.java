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
 * Contributor: Jonathan Carlson (joncrlsn@users.sf.net)
 * Contributor: Craig Laurent (clauren@wamnet.com, craigLaurent@yahoo.com)
 * Contributor: Tim Dawson (tdawson@wamnet.com)
 * Contributor: James Evans (jevans@vmguys.com)
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
package net.sf.jrf.util;

import java.util.*;
import org.apache.log4j.Category;

/** String utility static method class. */
public class StringUtil
{

    final static Category LOG = Category.getInstance(StringUtil.class.getName());
    /** The delimiter characters - single quote. */
    public final static String SINGLE_QUOTE = "'";

    /** The delimiter characters - double quote. */
    public final static String DOUBLE_QUOTE = "\"";


    private StringUtil() { }

    /**
     * Formats a String for use as a String in a DB query
     *   where a single quote is the delimiter.
     *
     * @param p_val  the String to format
     * @return       String with quotes escaped, and enclosing.
     * @see          #delimitString
     */
    public static String delimitSingleQuote(String p_val)
    {
        return delimitString(p_val, SINGLE_QUOTE);
    }


    /**
     * Formats a String for use as a String in a DB query
     *   where a double quote is the delimiter.
     *
     * @param p_val  the String to format
     * @return       String with quotes escaped, and enclosing.
     * @see          #delimitString
     */
    public static String delimitDoubleQuote(String p_val)
    {
        return delimitString(p_val, DOUBLE_QUOTE);
    }


    /* Formats a String for use as a String in a DB query
    *   where the delimiter is as provided.
    *
    * @param p_val the String to format
    * @param p_delimiter the delimiter for formatting
    * @return String with quotes escaped, and enclosing.
    */
    /**
     * Description of the Method
     *
     * @param p_val        Description of the Parameter
     * @param p_delimiter  Description of the Parameter
     * @return             Description of the Return Value
     */
    public static String delimitString(String p_val, String p_delimiter)
    {
        String result = null;

        // replace occurrances of the delimiter with "double delimiters"
        // to "escape" the delimiter character within the string.
        result = replace(p_val,
            p_delimiter,
            (p_delimiter + p_delimiter));

        // pre-pend and post-pend the delimiter
        result = p_delimiter + result + p_delimiter;
        return result;
    }


    /**
     * This method should really be in a StringUtil class.
     * Replace occurrences of oldString with newString within the content text.
     *
     * @param content    The text String that will be acted upon (strings
     *                replaced).
     * @param oldString  The string that will be replaced.
     * @param newString  The string that will replace oldString.
     * @return           returns the content string with the replaced values, as a
     *         String, or original content if bad parms.
     */
    public static String replace(String content,
        String oldString,
        String newString)
    {
        // if any parms null or too small, no point in doing anything...return
        // content
        if ((content == null) ||
            (oldString == null) ||
            (oldString.length() < 1) ||
            (newString == null))
        {
            return content;
        }
        // if content too small to contain oldString, no point in doing
        // anything...return content
        if (content.length() < oldString.length())
        {
            return content;
        }
        // Perform String replacement
        String newContent = content;
        int foundIndex = content.indexOf(oldString);

        // Recurse through the string, replacing ALL occurrences recurse rather
        // than loop to allow a replace that includes itself (eg "'" with "''" -
        // SQL escaping)
        if (foundIndex != -1)
        {
            try
            {
                newContent = content.substring(0, foundIndex)
                    + newString
                    + replace(
                    content.substring(foundIndex + oldString.length(),
                    content.length()),
                    oldString,
                    newString);
            }
            catch (StringIndexOutOfBoundsException e)
            {
                LOG.error(
                    "Exception occured in StringUtil.replace()... Ignoring.", e);
            }
        }
        return newContent;
    }// replace(...)

    /**
     * For a given List, this method creates a comma-separated string list and
     * surrounds it with parenthesis.  It is suitable for use in any SQL clauses
     * where that formatting is required.<br>
     * e.g. WHERE IN (foo,bar,blah)
     * e.g. VALUES (tom,dick,harry)<br>
     *
     * This calls the String.valueOf() method on each List element to produce the values.
     *
     * @param objects  a value of type 'List'
     * @return         a value of type 'String'
     */
    public static String toSQLList(List objects)
    {
        if (objects == null || objects.size() < 1)
        {
            return "()";
        }

        // Create a comma delimited, paren enclosed string of all the objects in
        // the List.  All concrete implementations of List will inherit from
        // AbstractCollection where the #toString() method does this formatting
        // but uses [] instead of (), so we have to replace it. Elements are
        // converted to strings as by String.valueOf(Object).  So if Your list
        // contains:
        //
        // 1234
        // 5678
        // 9012
        //
        // ... the resulting String will be:
        // (1234, 5678, 9012)

        return objects.toString().replace('[', '(').replace(']', ')');
    }

}
