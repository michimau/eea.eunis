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
 * Portions created by VM Systems are Copyright (C) 2000 VM Systems, Inc.
 * All Rights Reserved.
 *
 * Contributor: James Evans (jevans@vmguys.com - VM Systems, Inc.)
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
package net.sf.jrf.dbpolicies;

import java.lang.reflect.Method;

import java.sql.*;
import java.util.List;

import net.sf.jrf.*;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.exceptions.*;

import net.sf.jrf.sql.*;
import net.sf.jrf.util.*;

import org.apache.log4j.Category;

/**
 *  DB2 support for internal sequences.
 */
public class DB2DatabasePolicyIntSeq extends DB2DatabasePolicyBase {
  private final static Category LOG = Category.getInstance(DB2DatabasePolicyIntSeq.class.getName());

  /**
   * Returns <code>SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT</code>.
   *
   * @return   <code>SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT</code>.
   * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT
   */
  public int getSequenceSupportType() {
    return DatabasePolicy.SEQUENCE_SUPPORT_AUTOINCREMENT_IMPLICIT;
  }

  /**
   * Returns <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
   *
   * @return   <code>SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY</code>.
   * @see      net.sf.jrf.DatabasePolicy#SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY
   */
  public int getSequenceFetchAfterInsertSupportType() {
    return net.sf.jrf.DatabasePolicy.SEQUENCE_FETCHAFTERINSERTSUPPORT_SQLQUERY;
  }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  // SEQUENCE_SUPPORT_EXTERNAL - required methods -- not supported here.
  //////////////////////////////////////////////////////////////////
  /**
   * @see                 net.sf.jrf.DatabasePolicy#sequenceSQL(String,String)
   */
  public String sequenceSQL(String sequenceName, String tableName) {
    return null;
  }

  /**
   * @see                     net.sf.jrf.DatabasePolicy#createSequence(AbstractDomain,StatementExecuter)
   * Not supported here.
   */
  public void createSequence(AbstractDomain domain, StatementExecuter stmtExecuter)
          throws SQLException {
  }

  /**
   * @see                       #createSequence(AbstractDomain,String,StatementExecuter)
   * Not supported for DB2
   */
  public void createSequence(AbstractDomain domain, String sequenceParameters, StatementExecuter stmtExecuter)
          throws SQLException {
  }

  /**
   * @see                       net.sf.jrf.DatabasePolicy#getCreateSequenceSQL(String,String)
   * Not supported under DB2.
   */
  public String getCreateSequenceSQL(String sequenceName, String sequenceParameters) {
    return null;
  }

  /**
   * @see                 net.sf.jrf.DatabasePolicy#sequenceNextValSQL(String,String) *
   */
  public String sequenceNextValSQL(String sequenceName, String tableName) {
    return "";
  }
  //////////////////////////////////////////////////////////////////
  // SEQUENCE_SUPPORT_AUTOINCREMENT_.. - supported here.
  //////////////////////////////////////////////////////////////////

  /**
   *  Hypersonic uses auto-increment for assigning arbitrary primary key ids.
   *
   * @return   a value of type 'String'
   */
  public String autoIncrementIdentifier() {
    return "IDENTITY";
  }

  /**
   * @see                 net.sf.jrf.DatabasePolicy#getFindLastInsertedSequenceSql(String,String) *
   */
  public String getFindLastInsertedSequenceSql(String sequenceName, String tableName) {
    return "SELECT IDENTITY_VAL_LOCAL()";
  }

  /** Not supported under DB2 (see <code>getFindLastInsertedSequenceSql()</code>).
   * @see               net.sf.jrf.DatabasePolicy#findAutoIncrementIdByMethodInvoke(String,String,Statement) *
   */
  public Long findAutoIncrementIdByMethodInvoke(String tableName, String columnName, Statement stmt) {
    return null;
  }

}
