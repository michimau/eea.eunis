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
package net.sf.jrf.join;

import net.sf.jrf.DatabasePolicy;

/**
 *  This class can be used in place of the JoinTable class since it is a
 *  subclass.  Use it whenever you want an outer join instead of an inner
 *  join.
 */
public class OuterJoinTable
        extends JoinTable {

  /* ===============  Constructors  =============== */
  /**
   *Constructor for the OuterJoinTable object
   *
   * @param tableName        Description of the Parameter
   * @param mainColumnNames  Description of the Parameter
   * @param joinColumnNames  Description of the Parameter
   */
  public OuterJoinTable(
          String tableName,
          String mainColumnNames,
          String joinColumnNames) {
    super(tableName,
            mainColumnNames,
            joinColumnNames);
  }


  /**
   * Return something like "JOIN" or "LEFT OUTER JOIN", etc...
   * Subclasses should override.
   *
   * @return   a value of type 'String'
   */
  protected String ansiJoinCommand() {
    return "LEFT OUTER JOIN";
  }


  /**
   * This method overrides the superclass method.  It returns a name/value
   * pair that can be used in a where clause for a non-standard join.
   *
   * Return value example: <code>T1.id = T2.id(+)</code> (Oracle)
   *
   * @param mainColumnName  a value of type 'String'
   * @param joinColumnName  a value of type 'String'
   * @param dbPolicy        a value of type 'DatabasePolicy'
   * @return                a value of type 'String'
   */
  protected String buildWhereJoin(String mainColumnName,
                                  String joinColumnName,
                                  DatabasePolicy dbPolicy) {
    return dbPolicy.outerWhereJoin(mainColumnName,
            joinColumnName);
  }

}// OuterJoinTable

