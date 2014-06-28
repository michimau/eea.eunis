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
* Contributor:      James Evans (jevans@vmguys.com)
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
 * that may act as a base for writable instances.
 */
public abstract class EmbeddedPersistentObjectHandlerWrite implements EmbeddedPersistentObjectHandler
{
    /** Variable provided allow sub-classes to override * */
    protected int constructType = CONSTRUCT_CONTEXT_AFTER_EACH_ROW;
    protected AbstractDomain domain = null;

    /** Constructs object. */
    public EmbeddedPersistentObjectHandlerWrite() { }


    /**
     * Construct object using given domain.
     *
     * @param domain  <code>AbstractDomain</code> instance to use.
     */
    public EmbeddedPersistentObjectHandlerWrite(AbstractDomain domain)
    {
        this.domain = domain;
    }

    /**
     * This default version returns <code>CONSTRUCT_AFTER_EACH_ROW</code>.
     *
     * @return   context in which <code>AbstractDomain</code> will call <code>constructObjects()</code>.
     * @see      #constructObjects(PersistentObject,JRFResultSet)
     * @see      #CONSTRUCT_CONTEXT_AFTER_EACH_ROW
     */
    public int getConstructObjectContext()
    {
        return constructType;
    }

    /**
     * Provides a no-op method in the base class.
     *
     * @param parentPO  Description of the Parameter
     */
    public void constructObjects(PersistentObject parentPO)
    {
    }

    /**
     * Provides a no-op method in the base class.
     *
     * @param parentPO         Description of the Parameter
     * @param parentResultSet  Description of the Parameter
     */
    public void constructObjects(PersistentObject parentPO, JRFResultSet parentResultSet)
    {
    }

    /**
     * Provides a no-op method in the base class.
     *
     * @param parentPO    Description of the Parameter
     * @param embeddedPO  Description of the Parameter
     */
    public void populateEmbeddedObjectKeyValues(PersistentObject parentPO, PersistentObject embeddedPO)
    {
    }

    /**
     * Returns domain *
     *
     * @return   The domain value
     */
    public AbstractDomain getDomain()
    {
        return domain;
    }

    /**
     * No-op here; sub-classes need to implement.
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
    public boolean isDependentDetailRecord()
    {
        return true;
    }

    /**
     * Returns <code>true</code>.
     *
     * @return   <code>true</code>.
     */
    public boolean isReadOnly()
    {
        return false;
    }
}
