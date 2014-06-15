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
package test;

import net.sf.jrf.domain.PersistentObject;

import java.sql.Timestamp;


/**
 *  This subclass of Person was created to demonstrate the use of subtype
 *  tables in jRelationalFramework.
 */
public class Employee
        extends Person
  {

  public static String SUBTYPE_CODE = "EMP";
  private String    i_departmentCode = null;
  private Long      i_managerPersonId = null;


  public Long getManagerPersonId()
    {
    return i_managerPersonId;
    }
  public void setManagerPersonId(Long v)
    {
    i_managerPersonId = v;
    this.markModifiedPersistentState();
    }

  public String getDepartmentCode()
    {
    return i_departmentCode;
    }
  public void setDepartmentCode(String v)
    {
    i_departmentCode = v;
    this.markModifiedPersistentState();
    }

  public String getSubtypeCode()
    {
    return SUBTYPE_CODE;
    }

  } // Employee







