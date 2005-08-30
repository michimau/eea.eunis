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
 * This is the state for brand new PersistentObject objects that are not in
 * the database yet.
 */
public class NewPersistentState
        implements PersistentState, Serializable {

  final static long serialVersionUID = 8930712935237190682L;

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markModifiedPersistentState(PersistentObject aPO) {
    // Stay new since we're not in the database yet.
  }

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markNewPersistentState(PersistentObject aPO) {
    // Nothing to do.  We're already "new".
  }

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markCurrentPersistentState(PersistentObject aPO) {
    // We match the database now.
    aPO.setPersistentState(PersistentState.CURRENT);
  }

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markDeadPersistentState(PersistentObject aPO) {
    // This instance is not to used for saving again.
    aPO.setPersistentState(PersistentState.DEAD);
  }

  /**
   * Description of the Method
   *
   * @param aPO  Description of the Parameter
   */
  public void markDeletedPersistentState(PersistentObject aPO) {
    aPO.setPersistentState(PersistentState.DELETED);
  }

  /**
   * Gets the modifiedPersistentState attribute of the NewPersistentState object
   *
   * @return   The modifiedPersistentState value
   */
  public boolean isModifiedPersistentState() {
    return false;
  }

  /**
   * Gets the newPersistentState attribute of the NewPersistentState object
   *
   * @return   The newPersistentState value
   */
  public boolean isNewPersistentState() {
    return true;
  }

  /**
   * Gets the currentPersistentState attribute of the NewPersistentState object
   *
   * @return   The currentPersistentState value
   */
  public boolean isCurrentPersistentState() {
    return false;
  }

  /**
   * Gets the deadPersistentState attribute of the NewPersistentState object
   *
   * @return   The deadPersistentState value
   */
  public boolean isDeadPersistentState() {
    return false;
  }

  /**
   * Gets the deletedPersistentState attribute of the NewPersistentState object
   *
   * @return   The deletedPersistentState value
   */
  public boolean isDeletedPersistentState() {
    return false;
  }

  /**
   * Description of the Method
   *
   * @param anObject  Description of the Parameter
   * @return          Description of the Return Value
   */
  public boolean equals(Object anObject) {
    return (anObject instanceof NewPersistentState);
  }

  /**
   * Description of the Method
   *
   * @return   Description of the Return Value
   */
  public String toString() {
    return "NEW";
  }
}// NewPersistentState
