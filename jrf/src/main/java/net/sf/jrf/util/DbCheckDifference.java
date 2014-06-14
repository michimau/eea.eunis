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
 * Contributor: ______________________________
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
package net.sf.jrf.util;
import net.sf.jrf.sql.*;
import java.io.*;
import java.util.*;


/** Difference information <code>List</code> element class generated by a call to
* <code>DbCheck.getDifferences()</code>.
* @see net.sf.jrf.util.DbCheck#getDifferences(DbCheck,DbCheck)
*/
public class DbCheckDifference 
{


	private String fromInstanceDescription; // DbCheck 'compare from' instance description.
	
	private String toInstanceDescription; // DbCheck 'compare to' instance description.

	private String tableName; 	// Table name

	private String columnName;

	private String attributeDescription;

	private Object fromAttribute;

	private Object toAttribute;

	private int type;

	/** Difference type constant for missing table **/
	public static final int DIFFTYPE_MISSING_TABLE = 0;

	/** Difference type constant for missing column **/
	public static final int DIFFTYPE_MISSING_COLUMN = 1;

	/** Difference type constant for attribute difference. **/
	public static final int DIFFTYPE_ATTRIBUTE_DIFFERENT = 2;

	// Package scope constructors only.
	DbCheckDifference(int type,String fromInstanceDescription,String toInstanceDescription,String tableName) {
		this.type = type;
		this.fromInstanceDescription = fromInstanceDescription;
		this.toInstanceDescription = toInstanceDescription;
		this.tableName = tableName;	
	}

	DbCheckDifference(String fromInstanceDescription,String toInstanceDescription,String tableName) {
		this(DIFFTYPE_MISSING_TABLE,fromInstanceDescription,toInstanceDescription,tableName);
	}

	DbCheckDifference(String fromInstanceDescription,String toInstanceDescription,String tableName,String columnName) {
		this(DIFFTYPE_MISSING_COLUMN,fromInstanceDescription,toInstanceDescription,tableName);
		this.columnName = columnName;
	}

	DbCheckDifference(String fromInstanceDescription,String toInstanceDescription,
					String tableName,String columnName,String attributeDescription,
					Object fromAttribute, Object toAttribute) {
		this(DIFFTYPE_ATTRIBUTE_DIFFERENT,
			fromInstanceDescription,toInstanceDescription,tableName);
		this.columnName = columnName;
		this.attributeDescription = attributeDescription;
		this.fromAttribute = fromAttribute;
		this.toAttribute = toAttribute;
	}


	/** Returns description of difference.
	 * @return description of difference.
	 */
	public String toString() {
		String result = null;
		switch (type) {
			case DIFFTYPE_MISSING_TABLE:
				result =  "Table \""+tableName+"\" exists in \""+fromInstanceDescription+
							"\" but not in \""+
							toInstanceDescription+"\"";
				break;
			case DIFFTYPE_MISSING_COLUMN:
				result =  "Column \""+columnName+"\" of table \""+tableName+"\" exists in \""+
						fromInstanceDescription+"\" but not in \""+
							toInstanceDescription+"\"";
				break;
			case DIFFTYPE_ATTRIBUTE_DIFFERENT:
				result =  "Column \""+columnName+"\" of table \""+tableName+"\": attribute for "+
						attributeDescription+" is "+fromAttribute+" in \""+
						fromInstanceDescription+"\" and "+toAttribute+" in \""+
						toInstanceDescription+"\"";
				break;
		}
		return result;
	}

	/** Returns difference type.
	 * @return difference type constant.
	 * @see #DIFFTYPE_MISSING_TABLE
	 * @see #DIFFTYPE_MISSING_COLUMN
	 * @see #DIFFTYPE_ATTRIBUTE_DIFFERENT
	 */
	public int getType() {
		return this.type;
	}

	/** Returns the "from" instance description of <code>DbCheck</code>.
	 * For difference types of missing tables and columns, table or column 
	 * will exist in the "from" instance, but not in the "to" instance.
	 * @return "from" instance description.
	 * @see net.sf.jrf.util.DbCheck#getInstanceDescription()
	 */
	public String getFromInstanceDescription() {
		return this.fromInstanceDescription;	
	}

	/** Returns the "to" instance description of <code>DbCheck</code>.
	 * For difference types of missing tables and columns, table or column 
	 * will exist in the "from" instance, but not in the "to" instance.
	 * @return "to" instance description.
	 * @see net.sf.jrf.util.DbCheck#getInstanceDescription()
	 */
	public String getToInstanceDescription() {
		return this.toInstanceDescription;	
	}
	/** Returns the table name of the difference.
	* @return the table name of the difference.
	*/
	public String getTableName() {
		return this.tableName;
	}

	/** Returns the column name of the difference or <code>null</code>
	* if difference type is <code>DIFFTYPE_MISSING_TABLE</code>.
	* @return the column name of the difference or <code>null</code>
	* if difference type is <code>DIFFTYPE_MISSING_TABLE</code>.
	*/
	public String getColumnName() {
		return this.columnName;
	}

	/** Returns attribute description or <code>null</code> if 
	 * type is not <code>DIFFTYPE_ATTRIBUTE_DIFFERENT</code>.
	 * @return attribute description or <code>null</code> if 
	 * type is not <code>DIFFTYPE_ATTRIBUTE_DIFFERENT</code>.
	 * @see #DIFFTYPE_ATTRIBUTE_DIFFERENT
	 */
	public String getAttributeDescription() {
		return this.attributeDescription;
	}

	/** Returns "from" attribute or <code>null</code> if 
	 * type is not <code>DIFFTYPE_ATTRIBUTE_DIFFERENT</code>.
	 * @return "from" attribute  or <code>null</code> if 
	 * type is not <code>DIFFTYPE_ATTRIBUTE_DIFFERENT</code>.
	 * @see #DIFFTYPE_ATTRIBUTE_DIFFERENT
	 */
	public Object getFromAttribute() {
		return this.fromAttribute;
	}

	/** Returns "to" attribute or <code>null</code> if 
	 * type is not <code>DIFFTYPE_ATTRIBUTE_DIFFERENT</code>.
	 * @return "to" attribute  or <code>null</code> if 
	 * type is not <code>DIFFTYPE_ATTRIBUTE_DIFFERENT</code>.
	 * @see #DIFFTYPE_ATTRIBUTE_DIFFERENT
	 */
	public Object getToAttribute() {
		return this.toAttribute;
	}
}

