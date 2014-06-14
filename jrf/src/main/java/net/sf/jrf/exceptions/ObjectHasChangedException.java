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
package net.sf.jrf.exceptions;

/**
 *  This exception is thrown during the save of an object when that
 *  object has been changed by someone else since it was last retrieved.
 *  <p>
 *  The original modified object is also stored.  This is done for 
 *  so that composite (master-detail) objects contexts can always figure out 
 *  the offending object; if the modify attempt was tried on a deleted key,
 *  <code>getChangedObject</code> would of course return <code>null</code>.
 */
public class ObjectHasChangedException
     extends DomainException
{

    /** This is the object with the other person's or process's changes */
    private Object i_changedObject = null;

    /** This is the object with that the modify attempt was made.*/
    private Object i_modifyAttemptObject = null;

    /** Constructs an instance with changed object only.
    * @param changedObject changed object from database. 
    */
    public ObjectHasChangedException(Object changedObject) {
        super("");
        i_changedObject = changedObject;
    }

    /** Constructs an instance with changed object and modify attempt object.
    * @param changedObject changed object from database. 
    * @param modifyAttemptObject modify attempt object.
    */
    public ObjectHasChangedException(Object changedObject,Object modifyAttemptObject) {
        super("");
        i_changedObject = changedObject;
        i_modifyAttemptObject = modifyAttemptObject;
    }

    /**
     * Get the changes that were made to the object by someone (something) else
     * since we last retrieved it.
     * @return  object retrieved from the database with changes. 
     */
    public Object getChangedObject()
    {
        return i_changedObject;
    }

    /**
     * Get the object that the save attempt was made on.
     * @return  object of the modify attempt.
     */
    public Object getModifyAttemptObject() {
        return i_modifyAttemptObject;
    }

}// ObjectHasChangedException
