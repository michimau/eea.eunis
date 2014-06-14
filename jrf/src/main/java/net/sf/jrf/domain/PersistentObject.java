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
package net.sf.jrf.domain;

import java.io.Serializable;

/**
 * This abstract superclass is meant to denote a Java object whose attributes
 * can be fetched from an SQL database.  Dependent upon the type of object,
 * attributes may be stored in an SQL database as well.  Subclasses may be:
 * <ul>
 * <li> A Java version of an SQL table with one-to-one correspondence between
 *	   fields in the object and columns in the table.
 * <li> A Java version of an SQL table with all the required database columns,
 *	   but additional Java fields necessary for an application.
 * <li> A Java version of an SQL view.
 * <li> A Java version of a base SQL table with
 *	   field attributes that map to column attributes from an SQL join construct.
 * <li> A Java version of base SQL table with aggregate <code>PersistentObject</code>s.
 * </ul>
 */
public abstract class PersistentObject
     implements Serializable
{

    private PersistentState i_persistentState = PersistentState.NEW;

    /**
     * Gets the persistentState attribute of the PersistentObject object
     *
     * @return   The persistentState value
     */
    public PersistentState getPersistentState()
    {
        return i_persistentState;
    }

    /**
     * Sets the persistentState attribute of the PersistentObject object
     *
     * @param state  The new persistentState value
     */
    public void setPersistentState(PersistentState state)
    {
        i_persistentState = state;
    }

    /**
     * When true, this object is not in the database yet.  This method name is
     * somewhat cumbersome, however it is consistent, makes sense when you
     * think about it, and it won't conflict with business methods like
     * 'isNew()' or something similar would.
     *
     * @return   a value of type 'boolean'
     */
    public boolean hasNewPersistentState()
    {
        return i_persistentState.isNewPersistentState();
    }


    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public boolean hasDeletedPersistentState()
    {
        return i_persistentState.isDeletedPersistentState();
    }

    /**
     * When true, this objects attributes do not match the database values.
     * This method name is somewhat cumbersome, however it is consistent,
     * makes sense when you think about it, and it won't conflict with
     * business methods like 'isModified()' or something similar would.
     *
     * @return   a value of type 'boolean'
     */
    public boolean hasModifiedPersistentState()
    {
        return i_persistentState.isModifiedPersistentState();
    }

    /**
     * When true, this object's attributes match the database values.  This
     * method name is somewhat cumbersome, however it is consistent, makes
     * sense when you think about it, and it won't conflict with business
     * methods like 'isCurrent()' or something similar would.
     *
     * @return   a value of type 'boolean'
     */
    public boolean hasCurrentPersistentState()
    {
        return i_persistentState.isCurrentPersistentState();
    }

    /**
     * When true, this object has already been saved to the database once while
     * ReturnSavedObject on the domain was set to true.  In this case, the
     * returned instance should replace the instance that was an argument to
     * save() to avoid saving old information to the database (columns can
     * change during the insert or update via triggers, optimistic locks,
     * timestamps, etc...).
     *
     * @return   a value of type 'boolean'
     */
    public boolean hasDeadPersistentState()
    {
        return i_persistentState.isDeadPersistentState();
    }

    /**
     * Returns an encoded key for this object.  The default version
     * throws <code>UnsupportedOperationException</code>.  This method
     * should return the same value that <code>AbstractDomain.
     * encodePrimaryKey</code> would return.  The usefulness
     * of implementing this method is to allow an application to
     * obtain the encoded key in contexts where instantiating an
     *<code>AbstractDomain</code> implementation is not practical.
     * (For example, consider a <code>PersistentObject</code> instance
     * stored in a Web session context; applications can simply
     * obtain the key without having to worry about the existence of
     * an <code>AbstractDomain</code>).
     * <p>
     * Implementations of this method are best left to code generators.
     *
     * @return                                encoded key for the object.
     * @throws UnsupportedOperationException  if method is not implemented.
     * @see                                   net.sf.jrf.domain.AbstractDomain#encodePrimaryKey(PersistentObject)
     */
    public String getEncodedKey()
        throws UnsupportedOperationException
    {
        throw new UnsupportedOperationException("getEncodedKey() not supported for " + this);
    }

    /* ==========  These methods may cause a state change  ========== */


    /** Description of the Method */
    public void markNewPersistentState()
    {
        i_persistentState.markNewPersistentState(this);
    }

    /** State change will only occur if state is "Current" */
    public void markModifiedPersistentState()
    {
        i_persistentState.markModifiedPersistentState(this);
    }

    /** Description of the Method */
    public void markCurrentPersistentState()
    {
        i_persistentState.markCurrentPersistentState(this);
    }

    /** Description of the Method */
    public void markDeadPersistentState()
    {
        i_persistentState.markDeadPersistentState(this);
    }

    /** Description of the Method */
    public void markDeletedPersistentState()
    {
        i_persistentState.markDeletedPersistentState(this);
    }

    /* ==========  These methods force a state change  ========== */

    /** Description of the Method */
    public void forceNewPersistentState()
    {
        if (!(i_persistentState instanceof NewPersistentState))
        {
            i_persistentState = PersistentState.NEW;
        }
    }

    /** Description of the Method */
    public void forceModifiedPersistentState()
    {
        if (!(i_persistentState instanceof ModifiedPersistentState))
        {
            i_persistentState = PersistentState.MODIFIED;
        }
    }

    /** Description of the Method */
    public void forceCurrentPersistentState()
    {
        if (!(i_persistentState instanceof CurrentPersistentState))
        {
            i_persistentState = PersistentState.CURRENT;
        }
    }

    /** Description of the Method */
    public void forceDeadPersistentState()
    {
        if (!(i_persistentState instanceof DeadPersistentState))
        {
            i_persistentState = PersistentState.DEAD;
        }
    }

    /** Description of the Method */
    public void forceDeletedPersistentState()
    {
        if (!(i_persistentState instanceof DeletedPersistentState))
        {
            i_persistentState = PersistentState.DELETED;
        }
    }

}// PersistentObject


