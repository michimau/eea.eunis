/*
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.mozilla.org/MPL
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
package test;

import net.sf.jrf.domain.PersistentObject;

import java.sql.Timestamp;

/**
 * This is a persistent object with a sequenced primary key. This is tested by
 * the DomainTest class.
 *
 * @author    jacarlso
 * @created   July 31, 2001
 */
public class Person
         extends PersistentObject
{

    private Long                   i_personId = null;
    private String                 i_name = null;
    private Short                  i_age = null;
    private Boolean                i_wealthy = Boolean.FALSE;
    private Timestamp              i_lastUpdated = null;
    private String                 i_subtypeCode = null;


    /**
     * Sets the PersonId attribute of the Person object
     *
     * @param v  The new PersonId value
     */
    public void setPersonId(Long v)
    {
        i_personId = v;
    }

    /** Returns primary key
    */
    public String toString() {
        return this.getClass().getName()+": [PK(personID) = "+i_personId+"]";
    }

    /**
     * Sets the Name attribute of the Person object
     *
     * @param v  The new Name value
     */
    public void setName(String v)
    {
        i_name = v;
        this.markModifiedPersistentState();
    }


    /**
     * Sets the Age attribute of the Person object
     *
     * @param v  The new Age value
     */
    public void setAge(Short v)
    {
        i_age = v;
        this.markModifiedPersistentState();
    }


    /**
     * Sets the Wealthy attribute of the Person object
     *
     * @param v  The new Wealthy value
     */
    public void setWealthy(Boolean v)
    {
        i_wealthy = v;
        this.markModifiedPersistentState();
    }


    /**
     * Sets the Wealthy attribute of the Person object
     *
     * @param v  The new Wealthy value
     */
    public void setWealthy(boolean v)
    {
        i_wealthy = new Boolean(v);
        this.markModifiedPersistentState();
    }


    /**
     * Sets the LastUpdated attribute of the Person object
     *
     * @param v  The new LastUpdated value
     */
    public void setLastUpdated(Timestamp v)
    {
        i_lastUpdated = v;
    }


    /**
     * Gets the PersonId attribute of the Person object
     *
     * @return   The value of PersonId
     */
    public Long getPersonId()
    {
        return i_personId;
    }


    /**
     * Gets the Name attribute of the Person object
     *
     * @return   The value of Name
     */
    public String getName()
    {
        return i_name;
    }

//Subtype is not necessary yet since we can only access via the subtype domain
//class.
//  public String getSubtypeCode()
//    {
//    return i_subtypeCode;
//    }
//  public void setSubtypeCode(String v)
//    {
//    i_subtypeCode = v;
//    this.markModifiedPersistentState();
//    }

    /**
     * Gets the Age attribute of the Person object
     *
     * @return   The value of Age
     */
    public Short getAge()
    {
        return i_age;
    }


    /**
     * Gets the Wealthy attribute of the Person object
     *
     * @return   The value of Wealthy
     */
    public boolean isWealthy()
    {
        return i_wealthy.booleanValue();
    }


    /**
     * Gets the LastUpdated attribute of the Person object
     *
     * @return   The value of LastUpdated
     */
    public Timestamp getLastUpdated()
    {
        return i_lastUpdated;
    }

}// Person




