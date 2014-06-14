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
 * Contributor: James Evans (jevans@vmguys.com)
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
package net.sf.jrf.rowhandlers;

import java.util.*;
import net.sf.jrf.ApplicationRowHandler;
import net.sf.jrf.domain.*;
import net.sf.jrf.domain.PersistentObject;

/**
 * An implementation of <code>ApplicationRowHandler</code> that
 * handles primary key record retrievals.  The base version of this class
 * is not very useful.  Sub-classes should override this class to resolve
 * multiple rows fetched for a single primary key in <code>processRow()</code>.
 */
public class ApplicationRowHandlerPrimaryKey implements ApplicationRowHandler
{

    /** Result of query * */
    protected PersistentObject result = null;

    /** Constructs a handler. */
    public ApplicationRowHandlerPrimaryKey() { }

    /**
     * Processes a row of data from a database query and
     * returns <code>true</code> if next row, if any, should be fetched by the framework.
     * This base version is not particularly useful.
     *
     * @param aPO  Description of the Parameter
     * @return     <code>true</code> if framework should fetch the next row.
     */
    public boolean processRow(PersistentObject aPO)
    {
        aPO.forceCurrentPersistentState();
        result = aPO;
        return true;
    }

    /**
     * Returns resulting object.
     *
     * @return   result <code>PersistentObject</code> from a database query.
     */
    public Object getResult()
    {
        return result;
    }

    /** Description of the Method */
    public void clear()
    {
        result = null;
    }
}
