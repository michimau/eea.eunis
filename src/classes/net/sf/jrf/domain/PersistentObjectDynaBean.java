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
package net.sf.jrf.domain;

/** Interface with a single method to obtain <code>PersistentObjectDynaClass</code> instance.  This interface is
 * provided to allow a <code>DynaBean</code> implementation to store a <code>PersistentObjectDynaClass</code>
 * instance in contexts where is it is not possible to directly store <code>PersistentObjectDynaClass</code>
 * as the real underlying <code>DynaClass</code>.  Implementations of this interface <em>MUST</em> also implement
 * <code>DynaBean</code>.
 */
public interface PersistentObjectDynaBean {

  /** Returns <code>PersistentObjectDynaClass</code> instance of the bean.
   * In many implementations where the underlying <code>DynaClass</code> is a <code>PersistentObjectDynaClass</code>,
   * the return will simply be:
   * <pre>
   * return (PersistentObjectDynaClass) getDynaClass();
   * </pre>
   * @return <code>PersistentObjectDynaClass</code> instance of the bean.
   */
  public PersistentObjectDynaClass getPersistentObjectDynaClass();

}
