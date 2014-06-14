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
import java.sql.*;
import org.apache.log4j.Category;

/** A utility to compare two database instances.  A typical use of this class
* is to generate a <code>Properties</code> instance via <code>generateProperties()</code>
* as part of a build process and store this <code>Properties</code> instance in a jar or war file.  
* Included in the start up code of an application 
* (for example, in the init() method of a servlet for J2EE contexts)
* would be instantiation of two instances of this class: one via a database connection (using constructor
* <code>DbCheck(JRFConnection,String)</code>) and one via a properties instance obtained from the 
* application jar or war (using constructor <code>DbCheck(Properties)</code>).  The two instances could then
* be compared through a call to <code>getDifferences(DbCheck,DbCheck)</code>).  In most application 
* scenarios, any differences should result in aborting the application.
*/
public class DbCheck 
{

	private static int GENTYPE_PROPERTIES = 0;
	private static int GENTYPE_DB = 1;
	private String instanceDescription;
  	private static final Category LOG = Category.getInstance(DbCheck.class.getName());

	// Save a subset of return columns from
	// DatabaseMetaData.getColumns()
	/***
	**/
	private static class ColAttributeMeta {
		String description;
		boolean isInt;
		int offset;
		boolean isDataType = false;
		ColAttributeMeta(String description, int offset,boolean isInt) {
			this.description = description;
			this.offset = offset;
			if (offset == 5)
				this.isDataType = true;
			this.isInt = isInt;
		}
			
		public String toString() {
			return "\t(Attribute type: "+description+"(offset="+offset+"))";
		}
	}
/*
    From DatabaseMetaData.getColumns() javadoc:

    Each column description has the following columns:

       1. TABLE_CAT String => table catalog (may be null)
       2. TABLE_SCHEM String => table schema (may be null)
       3. TABLE_NAME String => table name
       4. COLUMN_NAME String => column name
       5. DATA_TYPE short => SQL type from java.sql.Types
       6. TYPE_NAME String => Data source dependent type name, for a UDT the type name is fully qualified
       7. COLUMN_SIZE int => column size. For char or date types this is the maximum number of characters, 
	  for numeric or decimal types this is precision.
       8. BUFFER_LENGTH is not used.
       9. DECIMAL_DIGITS int => the number of fractional digits
      10. NUM_PREC_RADIX int => Radix (typically either 10 or 2)
      11. NULLABLE int => is NULL allowed?
          * columnNoNulls - might not allow NULL values
          * columnNullable - definitely allows NULL values
          * columnNullableUnknown - nullability unknown
      12. REMARKS String => comment describing column (may be null)
      13. COLUMN_DEF String => default value (may be null)
      14. SQL_DATA_TYPE int => unused
      15. SQL_DATETIME_SUB int => unused
      16. CHAR_OCTET_LENGTH int => for char types the maximum number of bytes in the column
      17. ORDINAL_POSITION int => index of column in table (starting at 1)
      18. IS_NULLABLE String => "NO" means column definitely does not allow NULL values; 
	  "YES" means the column might allow NULL values. An empty string means nobody knows. 

*/
	static HashMap attributeInfo;
	static {
		attributeInfo = new HashMap();
		attributeInfo.put("dataType",new ColAttributeMeta("java.sql.Types",5,true));
		attributeInfo.put("columnSize",new ColAttributeMeta("Column size",7,true));
		attributeInfo.put("decimalDigits",new ColAttributeMeta("Decimal Digits",9,true));
		attributeInfo.put("nullable",new ColAttributeMeta("Nullable",18,false));
	}

	private static class ColAttribute {
		Object value;
		ColAttributeMeta info;
		String key;
		ColAttribute(String key, Object value, ColAttributeMeta info) {
			this.key = key;
			this.value = value;
			this.info = info;
		}	
		public boolean equals(Object obj) {
			ColAttribute other = (ColAttribute) obj;
			return this.info.offset == other.info.offset;
		}
		static ColAttribute createFromProperty(String key,String property) 
				throws IllegalArgumentException {
			ColAttributeMeta ci = (ColAttributeMeta) attributeInfo.get(key);
			if (ci == null)
				throw new IllegalArgumentException("Key "+key+" in properties file is invalid");
			Object value = null;
			if (ci.isInt) {
				try {
					value = new Integer(java.lang.Integer.parseInt(property));
				}
				catch (NumberFormatException ne) {
					throw new IllegalArgumentException("Value "+property+" for key "
						+key+" is not a number.");
				}	
			}
			else
				value = property;
			return new ColAttribute(key,value,ci);
		}
		public String toString() {
			if (info.isDataType) {
				Integer i = (Integer) value;
				return "Value = "+xlateType(i.intValue())+" "+info;
			}
			else
				return "Value = "+value+" "+info;
		}
	}

	private static class ColumnInfo {
		String columnName; // duplicate of key.
		List columnData = new ArrayList();	
		public ColumnInfo(String columnName) {
			this.columnName = columnName;
		}	
		public ColumnInfo(String columnName, List columnData) {
			this.columnName = columnName;
			this.columnData = columnData;
		}
		static HashMap createFromResultSet(ResultSet rs) throws SQLException {
			HashMap result = new HashMap();
			while (rs.next()) {
				String columnName = rs.getString(4);
				ArrayList columnAttr = new ArrayList();
				Iterator i = attributeInfo.keySet().iterator();
				while (i.hasNext()) {
					String key = (String) i.next();
					ColAttributeMeta ci = (ColAttributeMeta) attributeInfo.get(key);
					Object value;
					if (ci.isInt)
						value = new Integer(rs.getInt(ci.offset));
					else {
						value =  rs.getString(ci.offset);
						if (value == null)
							value = "null";
					}
					columnAttr.add(new ColAttribute(key,value,ci));
				}
				result.put(columnName,new ColumnInfo(columnName,columnAttr));
			}
			return result;
		}
		public String toString() {
			return "Column Name: "+columnName+"\n("+columnData+")\n";
		}
	}

	private static class TableInfo {
		private String tableName;	// Duplicate of key.
		private HashMap columns = new HashMap();
		TableInfo(String tableName) {
			this.tableName = tableName;
		}		
		TableInfo(String tableName,HashMap columns) {
			this.tableName = tableName;
			this.columns = columns;
		}		
		static HashMap createFromDatabase(JRFConnection conn,String schema) throws SQLException {
			DatabaseMetaData m = conn.getDatabaseMetaData();
			HashMap result = new HashMap();
			ResultSet rs = m.getTables(null,null,"%",new String[] {"TABLE"});
			while (rs.next()) {
				String tableName = rs.getString(3);
				ResultSet rsc = m.getColumns(null,null,tableName,"%");
				HashMap columns = ColumnInfo.createFromResultSet(rsc);
				result.put(tableName,new TableInfo(tableName,columns));	
			}		
        		return result; 
		}	
		public String toString() {
			return tableName+"\n"+columns;
		}
	}

	private HashMap result = new HashMap();

	private int genType;

	/** Returns the instance description indicating source of database information.
	 * @return the instance description indicating source of database information.
	 */
	public String getInstanceDescription() {
		return this.instanceDescription;
	}

	/** Creates a database check instance from parsing a <code>Properties</code>.
	  * <code>Properties</code> instance should have been created by
	  * <code>generateProperties</code> 
	  * @param props <code>Properties</code> instance previously generated from
	  * 	<code>generateProperties</code>.
	  * @see #generateProperties(JRFConnection,String)
	  * @throws IllegalArgumentException if <code>Properties</code> instance is not valid.
	  */
	public DbCheck(Properties props) throws IllegalArgumentException {
		this.genType = GENTYPE_PROPERTIES;
		this.instanceDescription = "Generated from properties instance";
		Enumeration e = props.propertyNames();
		while (e.hasMoreElements()) {
			String key = (String) e.nextElement();
			String value = (String) props.get(key);
			String tokens [] = parseKey(key);
			TableInfo ti = (TableInfo) result.get(tokens[0]);
			if (ti == null) {
				ti = new TableInfo(tokens[0]);
				result.put(tokens[0],ti);
			}
			ColumnInfo ci = (ColumnInfo) ti.columns.get(tokens[1]);
			if (ci == null) {
				ci = new ColumnInfo(tokens[1]);	
				ti.columns.put(tokens[1],ci);
			}
			// Find the attribute.
			ColAttribute ca = ColAttribute.createFromProperty(tokens[2],value);
			if (ci.columnData.contains(ca)) {
				throw new IllegalArgumentException(ca+" appears more than once for table/column "+
							ti.tableName+"/"+ci.columnName);
			}		
			ci.columnData.add(ca);
		}
	}
	private String [] parseKey(String key) {
		String [] result = new String[3];
		StringTokenizer t = new StringTokenizer(key,".");
		int i = 0;
		while (t.hasMoreTokens()) {
			result[i++] = t.nextToken();
		}
		if (i != 3)
			throw new IllegalArgumentException("Key should be in three parts separated by a '.': "+key);
		return result;
	}

	/** Creates an instance from the database connection.
	 * @param conn connection to a database.
	 * @param schema schema to use or <code>null</code> if not applicable.
	 */
	public DbCheck(JRFConnection conn,String schema) throws SQLException {
		result =  TableInfo.createFromDatabase(conn,schema);
		this.genType = GENTYPE_DB;
		if (schema == null)
			this.instanceDescription = "Generated from JDBC metadata calls under no schema";
		else
			this.instanceDescription = "Generated from JDBC metadata calls under schema "+schema;
 
	}
	
	/** Returns complete information obtained from either a <code>Properties</code> instance or
	 * database instance.
	 * @return complete information obtained from instantiation of the object.
	 */
	public String toString() {
		StringBuffer buf = new StringBuffer();
		Iterator iter = result.values().iterator();
		buf.append(instanceDescription+"\n");
		while (iter.hasNext()) {
			buf.append("TABLE: "+iter.next()+"\n");
		}
		return buf.toString();
	}

	/** Returns a list of differences between two instances.
	 * @param dbCheck1 instance one of <code>DbCheck</code>.
	 * @param dbCheck2 instance two of <code>DbCheck</code>.
	 * @return <code>List</code> of <code>DbCheckDifference</code> instances.
	 */
	public static List getDifferences(DbCheck dbcheck1, DbCheck dbcheck2) {
		ArrayList result = new ArrayList();
		Iterator iter = dbcheck1.result.values().iterator();
		// clone 2
		HashMap notFoundTables = (HashMap) dbcheck2.result.clone();
		while (iter.hasNext()) {
			TableInfo ti_1 = (TableInfo) iter.next();
			/////////////////////////////////////////////////////////
			// Attempt to find this table in dbcheck2
			/////////////////////////////////////////////////////////
			TableInfo ti_2 = (TableInfo) dbcheck2.result.get(ti_1.tableName);
			if (ti_2 == null) { // Table exists in 1 but not in 2
				result.add(new DbCheckDifference(dbcheck1.instanceDescription,
								dbcheck2.instanceDescription,ti_1.tableName));
			}
			else {
				// remove from notFoundTables.
				notFoundTables.remove(ti_2.tableName);
				// Column survey time.
				HashMap notFoundColumns = (HashMap) ti_2.columns.clone();
				Iterator colIter = ti_1.columns.values().iterator();
				while (colIter.hasNext()) {
					ColumnInfo ci_1 = (ColumnInfo) colIter.next();
					// Find in 2
					ColumnInfo ci_2 = (ColumnInfo) ti_2.columns.get(ci_1.columnName);
					if (ci_2 == null) {
						// Column exists in 1 but not in 2.
						result.add(new DbCheckDifference(dbcheck1.instanceDescription,
							dbcheck2.instanceDescription,ti_1.tableName,ci_1.columnName));

					}
					else {
						// Remove from notFoundColumns
						notFoundColumns.remove(ci_1.columnName);
						// Check all attributes.
						if (ci_1.columnData.size() != ci_2.columnData.size()) 
							throw new IllegalArgumentException(
								"Table "+ti_1.tableName+", column "+
								ci_1.columnName+": Instance "+
								dbcheck1.instanceDescription+" has "+
								ci_1.columnData.size()+" attributes and "+
								dbcheck2.instanceDescription+" has "+
								ci_2.columnData.size()+" attributes. One of "+
								"the instances may have be created with an older"+
								" version of this class.");
						for (int i = 0; i < ci_1.columnData.size(); i++) {
							ColAttribute ca1 = (ColAttribute) ci_1.columnData.get(i); 
							// Find matching attribute based on offset.
							int o = ci_2.columnData.indexOf(ca1);
							if (o == -1) {
								throw new IllegalArgumentException(
								"Table "+ti_1.tableName+", column "+
								ci_1.columnName+": Instance "+
								dbcheck1.instanceDescription+
								" attribute "+ca1+" was not found in"+
								" instance "+
								dbcheck2.instanceDescription+". One of "+
								"the instances may have be created with an older"+
								" version of this class.");
							}
							ColAttribute ca2 = (ColAttribute) ci_2.columnData.get(o); 

							if (!ca1.value.equals(ca2.value)) {
								Object value1 = ca1.value;
								Object value2 = ca2.value;
								if (ca1.info.isDataType) {
									Integer iv = (Integer) value1;
									value1 = xlateType(iv.intValue());	
									iv = (Integer) value2;
									value2 = xlateType(iv.intValue());	
								}
								result.add(
									new DbCheckDifference(
										dbcheck1.instanceDescription,
										dbcheck2.instanceDescription,
										ti_1.tableName,
										ci_1.columnName,
										ca1.info.description,
										value1,
										value2));
							}
						}
					}
				}
				colIter = notFoundColumns.values().iterator();
				while (colIter.hasNext()) {
					// Column exists in 2 but not 1.
					ColumnInfo ci = (ColumnInfo) colIter.next();
					result.add(new DbCheckDifference(dbcheck2.instanceDescription,
						dbcheck1.instanceDescription,ti_1.tableName,ci.columnName));
				}
			}	
		}
		iter = notFoundTables.values().iterator();
		// Table exists in 2 but not 1.
		while (iter.hasNext()) {
			TableInfo ti_2 = (TableInfo) iter.next();
			result.add(new DbCheckDifference(dbcheck2.instanceDescription,
							dbcheck1.instanceDescription,
								ti_2.tableName));
		}
		return result;

	}

	/** Generates a <code>Properties</code> representation of the database that may be persisted and
	 * used to check against a database installation.
	 * @param conn connection to a database.
	 * @param schema schema to use or <code>null</code> if not applicable.
	 * @see #DbCheck(Properties)
	 */
	public static Properties generateProperties(JRFConnection conn,String schema) throws SQLException {
		DbCheck dc = new DbCheck(conn,schema);
		Properties result = new Properties();
		Iterator it = dc.result.values().iterator();
		while (it.hasNext()) {
			TableInfo ti = (TableInfo) it.next();
			Iterator ic = ti.columns.values().iterator();
			while (ic.hasNext()) {
				ColumnInfo ci = (ColumnInfo) ic.next();
				Iterator attr = ci.columnData.iterator();
				while (attr.hasNext()) {
					ColAttribute ca = (ColAttribute) attr.next();
					String value = "null";
					if (ca.value != null)
						value = ca.value.toString();	
					result.setProperty(ti.tableName+"."+ci.columnName+"."+ca.key,
									value);	
				}
			}	

		}
		return result;
	}

	/** Translates type to recognizable string.
	 * @param type  <code>java.sql.Type</code> to translate.
	 * @return string version of the type.
	 */
	public static String xlateType(int type) {

		switch (type) {
			case java.sql.Types.ARRAY:
				return "java.sql.Types.ARRAY";
			case java.sql.Types.BIGINT:
				return "java.sql.Types.BIGINT";
			case java.sql.Types.BINARY:
				return "java.sql.Types.BINARY";
			case java.sql.Types.BIT:
				return "java.sql.Types.BIT";
			case java.sql.Types.BLOB:
				return "java.sql.Types.BLOB";
			case java.sql.Types.CHAR:
				return "java.sql.Types.CHAR";
			case java.sql.Types.CLOB:
				return "java.sql.Types.CLOB";
			case java.sql.Types.DATE:
				return "java.sql.Types.DATE";
			case java.sql.Types.DECIMAL:
				return "java.sql.Types.DECIMAL";
			case java.sql.Types.DISTINCT:
				return "java.sql.Types.DISTINCT";
			case java.sql.Types.DOUBLE:
				return "java.sql.Types.DOUBLE";
			case java.sql.Types.FLOAT:
				return "java.sql.Types.FLOAT";
			case java.sql.Types.INTEGER:
				return "java.sql.Types.INTEGER";
			case java.sql.Types.JAVA_OBJECT:
				return "java.sql.Types.JAVA_OBJECT";
			case java.sql.Types.LONGVARBINARY:
				return "java.sql.Types.LONGVARBINARY";
			case java.sql.Types.LONGVARCHAR:
				return "java.sql.Types.LONGVARCHAR";
			case java.sql.Types.NULL:
				return "java.sql.Types.NULL";
			case java.sql.Types.NUMERIC:
				return "java.sql.Types.NUMERIC";
			case java.sql.Types.OTHER:
				return "java.sql.Types.OTHER";
			case java.sql.Types.REAL:
				return "java.sql.Types.REAL";
			case java.sql.Types.REF:
				return "java.sql.Types.REF";
			case java.sql.Types.SMALLINT:
				return "java.sql.Types.SMALLINT";
			case java.sql.Types.STRUCT:
				return "java.sql.Types.STRUCT";
			case java.sql.Types.TIME:
				return "java.sql.Types.TIME";
			case java.sql.Types.TIMESTAMP:
				return "java.sql.Types.TIMESTAMP";
			case java.sql.Types.TINYINT:
				return "java.sql.Types.TINYINT";
			case java.sql.Types.VARBINARY:
				return "java.sql.Types.VARBINARY";
			case java.sql.Types.VARCHAR:
				return "java.sql.Types.VARCHAR";
			default:
				return "Unknown type: "+type;
		}
	}
}
