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


/**
 *  This is a persistent object with a natural primary key.  This is tested
 *  using by the DomainTest class.
 */
public class Part
    extends PersistentObject
  {

  /* =====  Part table columns ===== */

  private String   i_code             = null;
  private String   i_name             = null;
  private String   i_description      = null;
  private Integer  i_manufacturerId   = null;
  private String   i_manufacturerCode = null;
  private Integer  i_version          = null;

  /** This is a joined column */
  private String   i_manufacturerName = null;

  public String getCode()
    {
    return i_code;
    }
  public void setCode(String v)
    {
    i_code = v;
    this.markModifiedPersistentState();
    }

  public String getName()
    {
    return i_name;
    }
  public void setName(String v)
    {
    i_name = v;
    this.markModifiedPersistentState();
    }

  public String getDescription()
    {
    return i_description;
    }
  public void setDescription(String v)
    {
    i_description = v;
    this.markModifiedPersistentState();
    }

  public Integer getManufacturerId()
    {
    return i_manufacturerId;
    }
  public void setManufacturerId(Integer v)
    {
    i_manufacturerId = v;
    this.markModifiedPersistentState();
    }

  public String getManufacturerCode()
    {
    return i_manufacturerCode;
    }
  public void setManufacturerCode(String v)
    {
    i_manufacturerCode = v;
    this.markModifiedPersistentState();
    }

  public Integer getVersion()
    {
    return i_version;
    }
  public void setVersion(Integer v)
    {
    i_version = v;
    this.markModifiedPersistentState();
    }

  public String getManufacturerName()
    {
    return i_manufacturerName;
    }
  public void setManufacturerName(String v)
    {
    i_manufacturerName = v;
    // This is a joined column, so we should *not* mark modified.
    // this.markModifiedPersistentState();
    }

  } // Part







