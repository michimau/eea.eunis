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
package net.sf.jrf.column;

import net.sf.jrf.domain.PersistentObject;

/**
 * An interface designed to remove reflection
 * from <code>AbstractColumnSpec</code>. Instead
 * of giving the names of the
 * methods for getting and setting values
 * for an object member to <code>AbstractColumnSpec</code>,
 * an implementation of this class can call the get and set methods
 * directly.
 */
public interface GetterSetter {

  /**
   * Returns <code>true</code> if <code>set</code> actually
   *  functional (e.g sets a value).
   *
   * @return   <code>true</code> if <code>set</code> is functional.
   * @see      #set(PersistentObject,Object)
   */
  public boolean setterIsFunctional();


  /**
   * Sets the value for the given object.
   *
   * @param obj    A <code>PersistentObject</code> instance.
   * @param value  Value to set for object member.
   */
  public void set(PersistentObject obj, Object value);


  /**
   * Gets the value from the object.
   *
   * @param obj    A <code>PersistentObject</code> instance.
   * @param deflt  A value to use for default if field value is null.
   * @return       object that is the appropriate field in <code>obj</code>.
   */
  public Object get(PersistentObject obj, Object deflt);
}
