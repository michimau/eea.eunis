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
package net.sf.jrf;

import java.sql.Date;
import java.sql.Time;

import java.sql.Timestamp;

/**
 *  This interface should be implemented whenever a class wants easy access
 *  to the value of these variables.
 */
public interface JRFConstants
{

    /* ===============  Static Final Variables  =============== */
    /**
     * This is a special timestamp that, when detected, is replaced with the
     * current date/time function in the sql.  This value must be unique
     * enough that no one else would accidentally use it.
     */

    /** Constant denoting current time. */
    public final static Timestamp CURRENT_TIMESTAMP = new Timestamp(-7);
    /** Description of the Field */
    public final static java.sql.Time CURRENT_TIME = new Time(-7);

    /** Constants denoting current date. */
    public final static Date CURRENT_DATE = new Date(-7);

    // ColumnSpec options
    /** Description of the Field */
    public final static int SEQUENCED_PRIMARY_KEY = 1;
    /** Description of the Field */
    public final static int NATURAL_PRIMARY_KEY = 2;
    /** Description of the Field */
    public final static int OPTIMISTIC_LOCK = 3;
    /** Description of the Field */
    public final static int REQUIRED = 4;
    /** Description of the Field */
    public final static int UNIQUE = 5;
    /** Description of the Field */
    public final static int SUBTYPE_IDENTIFIER = 6;

    // ColumnSpec default options
    /** Description of the Field */
    public final static Object DEFAULT_TO_NULL = null;
    /** Description of the Field */
    public final static String DEFAULT_TO_EMPTY_STRING = "";
    /** Description of the Field */
    public final static Integer DEFAULT_TO_ZERO = new Integer(0);
    /** Description of the Field */
    public final static Integer DEFAULT_TO_ONE = new Integer(1);
    /** Description of the Field */
    public final static Timestamp DEFAULT_TO_NOW = CURRENT_TIMESTAMP;
    /** Description of the Field */
    public final static Date DEFAULT_TO_TODAY = CURRENT_DATE;
    /** Description of the Field */
    public final static Boolean DEFAULT_TO_TRUE = Boolean.TRUE;
    /** Description of the Field */
    public final static Boolean DEFAULT_TO_FALSE = Boolean.FALSE;

    // Use these in arguements to buildNameValuePair()
    /** Description of the Field */
    public final static String EQUALS = "=";
    /** Description of the Field */
    public final static String NOT_EQUALS = "<>";

    /**
     *  This option should be used as an argument to the AbstractDomain
     *  constructor when we don't want the postFind() method to be executed.
     */
    public final static int NO_POST_FIND = 6;

}// JRFConstants
