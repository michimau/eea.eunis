/*
*
* The contents of this file are subject to the Mozilla Public License
* Version 1.1 (the "License"); you may not use this file except in
 compliance with the License. You may obtain a copy of the License at
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
* Contributor: 		James Evans (jevans@vmguys.com)
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
package net.sf.jrf.domain;

import java.util.*;

import net.sf.jrf.*;
import net.sf.jrf.sql.*;

/**
 * An implementation of <code>EmbeddedPersistentObjectHandler</code> where
 * sub-classes need only implement <code>constructObjects</code>.
 */
public abstract class EmbeddedPersistentObjectHandlerReadOnly implements EmbeddedPersistentObjectHandler
{

    /**
     * This default version returns <code>CONSTRUCT_AFTER_EACH_ROW</code>.
     *
     * @return   context in which <code>AbstractDomain</code> will call <code>constructObjects()</code>.
     * @see      #constructObjects(PersistentObject,JRFResultSet)
     * @see      #CONSTRUCT_CONTEXT_AFTER_EACH_ROW
     */
    public int getConstructObjectContext()
    {
        return CONSTRUCT_CONTEXT_AFTER_EACH_ROW;
    }


    /**
     * Constructs the embedded object or objects based on the
     * information from the parent <code>PersistentObject</code>
     * and any other fields from the <code>JRFResultSet</code>
     * generated from a <code>find(PersistentObject)</code> of
     * the parent object's <code>AbstractDomain</code>.
     *
     * @param parentPO         <code>PersistentObject</code> instance just
     *			fetched a call to the parent's
     *		     <code>AbstractDomain.find(PersistentObject)</code> method.
     * @param parentResultset  Description of the Parameter
     * @see                    net.sf.jrf.domain.AbstractDomain#find(Object)
     */
    public abstract void constructObjects(PersistentObject parentPO, JRFResultSet parentResultset);

    /**
     * Constructs the embedded object or objects based on the
     * information from the parent <code>PersistentObject</code>
     * and any other fields from the <code>JRFResultSet</code>
     * generated from a <code>find(PersistentObject)</code> of
     * the parent object's <code>AbstractDomain</code>.
     *
     * @param parentPO  <code>PersistentObject</code> instance just
     *			fetched a call to the parent's
     *		     <code>AbstractDomain.find(PersistentObject)</code> method.
     * @see             net.sf.jrf.domain.AbstractDomain#find(Object)
     */
    public void constructObjects(PersistentObject parentPO)
    {
    }

    /**
     * This is a no-op method in a read only context.
     *
     * @param parentPO    Description of the Parameter
     * @param embeddedPO  Description of the Parameter
     */
    public void populateEmbeddedObjectKeyValues(PersistentObject parentPO, PersistentObject embeddedPO)
    {
    }

    /**
     * Returns <code>null</code> since this method is not called for read-only instances by the framework.
     *
     * @return   <code>null</code>
     */
    public AbstractDomain getDomain()
    {
        return null;
    }

    /**
     * Returns <code>null</code> since this method is not called for read-only instances by the framework.
     *
     * @param parentPO  Description of the Parameter
     * @return          <code>null</code>
     */
    public Iterator getObjectIterator(PersistentObject parentPO)
    {
        return null;
    }

    /**
     * Returns <code>false</code>.
     *
     * @return   <code>false</code>.
     */
    public boolean isDependentDetailRecord()
    {
        return false;
    }

    /**
     * Not applicable here; does nothing.
     *
     * @param parentPO  <code>PersistentObject</code> instance of the parent.
     */
    public void deleteDetailRecords(PersistentObject parentPO)
    {
    }


    /**
     * Returns <code>true</code>.
     *
     * @return   <code>true</code>.
     */
    public boolean isReadOnly()
    {
        return true;
    }

}
