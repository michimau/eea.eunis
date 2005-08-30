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
 * Contributor: Jonathan Carlson (jcarlson@wamnet.com)
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


/**
 * This is an interface for the state of a PersistentObject object.  I'm
 * sorry for the long names for some of these methods.  They have to be
 * different enough that they won't conflict with other method names.
 */
public interface PersistentState {

  /** Description of the Field */
  public final static PersistentState MODIFIED = new ModifiedPersistentState();
  /** Description of the Field */
  public final static PersistentState NEW = new NewPersistentState();
  /** Description of the Field */
  public final static PersistentState CURRENT = new CurrentPersistentState();
  /** Description of the Field */
  public final static PersistentState DEAD = new DeadPersistentState();
  /** Description of the Field */
  public final static PersistentState DELETED = new DeletedPersistentState();

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markModifiedPersistentState(PersistentObject aPO);

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markNewPersistentState(PersistentObject aPO);

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markCurrentPersistentState(PersistentObject aPO);

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markDeadPersistentState(PersistentObject aPO);

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markDeletedPersistentState(PersistentObject aPO);

  /**
   * Gets the modifiedPersistentState attribute of the PersistentState object
   *
   * @return   The modifiedPersistentState value
   */
  public boolean isModifiedPersistentState();

  /**
   * Gets the newPersistentState attribute of the PersistentState object
   *
   * @return   The newPersistentState value
   */
  public boolean isNewPersistentState();

  /**
   * Gets the currentPersistentState attribute of the PersistentState object
   *
   * @return   The currentPersistentState value
   */
  public boolean isCurrentPersistentState();

  /**
   * Gets the deadPersistentState attribute of the PersistentState object
   *
   * @return   The deadPersistentState value
   */
  public boolean isDeadPersistentState();

  /**
   * Gets the deletedPersistentState attribute of the PersistentState object
   *
   * @return   The deletedPersistentState value
   */
  public boolean isDeletedPersistentState();

}// PersistentState
