/*
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *
 *  http://www.mozilla.org/MPL/
 *
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations under
 *  the License.
 *
 *  The Original Code is jRelationalFramework.
 *
 *  The Initial Developer of the Original Code is is.com.
 *  Portions created by is.com are Copyright (C) 2000 is.com.
 *  All Rights Reserved.
 *
 *  Contributor(s): Jonathan Carlson (joncrlsn@users.sf.net)
 *  Contributor(s): James Evans (jevans@vmguys.com)
 *  Contributor(s): ____________________________________
 *
 *  Alternatively, the contents of this file may be used under the terms of
 *  the GNU General Public License (the "GPL") or the GNU Lesser General
 *  Public license (the "LGPL"), in which case the provisions of the GPL or
 *  LGPL are applicable instead of those above.  If you wish to allow use of
 *  your version of this file only under the terms of either the GPL or LGPL
 *  and not to allow others to use your version of this file under the MPL,
 *  indicate your decision by deleting the provisions above and replace them
 *  with the notice and other provisions required by either the GPL or LGPL
 *  License.  If you do not delete the provisions above, a recipient may use
 *  your version of this file under either the MPL or GPL or LGPL License.
 *
 */
package net.sf.jrf.util;

import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 *  A simple bean class to capture the pertinent information for creating a
 *  foreign key relationship in the database.
 *
 */
public class ForeignKey {

    private String constraintName;
    private String localTableName;
    private String referencedTableName;
    private List localTableColumns;
    private List referencedTableColumns;
    private String additionalInfo;


    /**
     *  Default constructor
     */
    public ForeignKey() { }


    /**
     *  Constructs an instance with all parmeters.
     *
     *@param  constraintName          name of the foreign key constraint, if
     *      applicable.
     *@param  localTableName          name of the local table.
     *@param  referencedTableName     name of the referenced table.
     *@param  localTableColumns       list of <code>String</code> objects for
     *      the local column names.
     *@param  referencedTableColumns  list of <code>String</code> objects for
     *      the referenced column names.
     *@param  additionalInfo          additional information to use in
     *      constructing the foreign key.
     */
    public ForeignKey(String constraintName, String localTableName, String referencedTableName,
            List localTableColumns, List referencedTableColumns,
            String additionalInfo) {
        setConstraintName(constraintName);
        setLocalTableName(localTableName);
        setReferencedTableName(referencedTableName);
        setLocalTableColumns(localTableColumns);
        setReferencedTableColumns(referencedTableColumns);
        setAdditionalInfo(additionalInfo);
    }


    /**
     *  Returns <code>true</code> if all parameters except for the constraint
     *  name and additional create information are equal. (e.g. local table name,
     *  referenced table name, local columns and referenced columns)
     *
     *@param  o  <code>ForeignKey</code> instance to compare.
     *@return    <code>true</code> if all parameters except for the constraint
     *      name and additional information are equal.
     */
    public boolean equals(Object o) {
        ForeignKey other = (ForeignKey) o;
        if (this.localTableName.equals(other.localTableName) &&
                this.referencedTableName.equals(other.referencedTableName) &&
                this.localTableColumns.equals(other.localTableColumns) &&
                this.referencedTableColumns.equals(other.referencedTableColumns)) {
            return true;
        }
        return false;
    }


    /**
     *  Sets additional information for a foreign key constraint. (e.g.
     *  "INITIALLY DEFERRED" on postgreSQL).
     *
     *@param  additionalInfo  additional information to use in constructing the
     *      foreign key.
     */
    public void setAdditionalInfo(String additionalInfo) {
        this.additionalInfo = additionalInfo;
    }


    /**
     *  Gets additional information for a foreign key constraint. (e.g.
     *  "INITIALLY DEFERRED" on postgreSQL).
     *
     *@return    additional information to use in constructing the foreign key.
     */
    public String getAdditionalInfo() {
        return this.additionalInfo;
    }


    /**
     *  Constructs an instance with all parameters, but with column parameters
     *  given as comma-separated names as <code>String</code> values.
     *
     *@param  constraintName          name of the foreign key constraint, if
     *      applicable.
     *@param  localTableName          name of the local table.
     *@param  referencedTableName     name of the referenced table.
     *@param  localTableColumns       comma-separated list of local column
     *      names.
     *@param  referencedTableColumns  comma-separated list of referenced column
     *      names.
     *@param  additionalInfo          additional information to use in
     *      constructing the foreign key.
     */
    public ForeignKey(String constraintName, String localTableName, String referencedTableName,
            String localTableColumns, String referencedTableColumns,
            String additionalInfo) {
        setConstraintName(constraintName);
        setLocalTableName(localTableName);
        setReferencedTableName(referencedTableName);
        setLocalTableColumns(localTableColumns);
        setReferencedTableColumns(referencedTableColumns);
        setAdditionalInfo(additionalInfo);
    }


    /**
     *  Returns all components.
     *
     *@return    all components.
     */
    public String toString() {
        return "FK constraint Name: " + constraintName + ". \n" +
                "Local table: " + localTableName + ". \n" +
                "Referenced table: " + referencedTableName + ". \n" +
                "Local column name(s): " + listToString(localTableColumns) + ". \n" +
                "Referenced column name(s): " + listToString(referencedTableColumns);
    }


    /**
     *  Returns an HTML-formatted 'toString().
     *
     *@return    all components in HTML format.
     */
    public String toHTMLString() {
        return "<strong>FK constraint Name: " + constraintName + "</strong></br>\n" +
                "Local table: " + localTableName + "</br>" +
                "Referenced table: " + referencedTableName + "</br>" +
                "Local column name(s): " + listToString(localTableColumns) + "</br>" +
                "Referenced column name(s): " + listToString(referencedTableColumns);
    }


    /**
     *  Sets constraint name.
     *
     *@param  constraintName
     */
    public void setConstraintName(String constraintName) {
        this.constraintName = constraintName;
    }


    /**
     *  Gets constraint name.
     *
     *@return    constraint name
     */
    public String getConstraintName() {
        return this.constraintName;
    }


    /**
     *  Sets local table name.
     *
     *@param  localTableName
     */
    public void setLocalTableName(String localTableName) {
        this.localTableName = localTableName;
    }


    /**
     *  Gets local table name.
     *
     *@return    local table name
     */
    public String getLocalTableName() {
        return this.localTableName;
    }


    /**
     *  Sets referenced table name.
     *
     *@param  referencedTableName
     */
    public void setReferencedTableName(String referencedTableName) {
        this.referencedTableName = referencedTableName;
    }


    /**
     *  Gets referenced table name.
     *
     *@return    referenced table name
     */
    public String getReferencedTableName() {
        return this.referencedTableName;
    }


    /**
     *  Sets local table columns.
     *
     *@param  localTableColumns  list of <code>String</code> objects for the
     *      local column names.
     */
    public void setLocalTableColumns(List localTableColumns) {
        this.localTableColumns = localTableColumns;
    }


    /**
     *  Sets local table columns.
     *
     *@param  localTableColumns  comma-separated list of local column names.
     */
    public void setLocalTableColumns(String localTableColumns) {
        this.localTableColumns = stringToList(localTableColumns);
    }


    /**
     *  Gets local table columns.
     *
     *@return    local table columns
     */
    public List getLocalTableColumns() {
        return this.localTableColumns;
    }


    /**
     *  Sets referenced table columns.
     *
     *@param  referencedTableColumns  list of <code>String</code> objects for
     *      the referenced column names.
     */
    public void setReferencedTableColumns(List referencedTableColumns) {
        this.referencedTableColumns = referencedTableColumns;
    }


    /**
     *  Sets referenced table columns.
     *
     *@param  referencedTableColumns  comma-separated list of referenced column
     *      names.
     */
    public void setReferencedTableColumns(String referencedTableColumns) {
        this.referencedTableColumns = stringToList(referencedTableColumns);
    }


    /**
     *  Gets referenced table columns.
     *
     *@return    referenced table columns
     */
    public List getReferencedTableColumns() {
        return this.referencedTableColumns;
    }


    /**
     *  Description of the Method
     *
     *@param  list  Description of the Parameter
     *@return       Description of the Return Value
     */
    private List stringToList(String list) {
        ArrayList result = new ArrayList();
        StringTokenizer tokenizer = new StringTokenizer(list, ",");
        while (tokenizer.hasMoreTokens()) {
            result.add(tokenizer.nextToken());
        }
        return result;
    }


    /**
     *  Description of the Method
     *
     *@param  list  Description of the Parameter
     *@return       Description of the Return Value
     */
    private String listToString(List list) {
        Iterator iter = list.iterator();
        StringBuffer result = new StringBuffer();
        int i = 0;
        while (iter.hasNext()) {
            String n = (String) iter.next();
            if (++i > 1) {
                result.append(",");
            }
            result.append(n);
        }
        return result.toString();
    }
}
