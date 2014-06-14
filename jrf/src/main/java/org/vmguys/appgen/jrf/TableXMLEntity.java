/* ====================================================================
 * The VM Systems, Inc. Software License, Version 1.0
 *
 * Copyright (c) 2002 VM Systems, Inc.  All rights reserved.
 *
 * THIS SOFTWARE IS PROVIDED PURSUANT TO THE TERMS OF THIS LICENSE.
 * ANY USE, REPRODUCTION, OR DISTRIBUTION OF THE SOFTWARE OR ANY PART
 * THEREOF CONSTITUTES ACCEPTANCE OF THE TERMS AND CONDITIONS HEREOF.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by 
 *        VM Systems, Inc. (http://www.vmguys.com/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "VM Systems" must not be used to endorse or promote products 
 *    derived from this software without prior written permission. For written
 *    permission, please contact info@vmguys.com.
 *
 * 5. VM Systems, Inc. and any other person or entity that creates or
 *    contributes to the creation of any modifications to the original
 *    software specifically disclaims any liability to any person or
 *    entity for claims brought based on infringement of intellectual
 *    property rights or otherwise. No assurances are provided that the
 *    software does not infringe on the property rights of others.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE TITLE
 * AND NON-INFRINGEMENT ARE DISCLAIMED. IN NO EVENT SHALL VM SYSTEMS, INC.,
 * ITS SHAREHOLDERS, DIRECTORS OR EMPLOYEES BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE. EACH RECIPIENT OR USER IS SOLELY RESPONSIBLE
 * FOR DETERMINING THE APPROPRIATENESS OF USING AND DISTRIBUTING THE SOFTWARE
 * AND ASSUMES ALL RISKS ASSOCIATED WITH ITS EXERCISE OF RIGHTS HEREUNDER,
 * INCLUDING BUT NOT LIMITED TO THE RISKS (INCLUDING COSTS) OF ERRORS,
 * COMPLIANCE WITH APPLICABLE LAWS OR INTERRUPTION OF OPERATIONS.
* ====================================================================
*/
////////////////////////////////////////////////////////////
package org.vmguys.appgen.jrf;
import java.util.*;
import org.vmguys.appgen.*;
import net.sf.jrf.util.*;

/** Table XML entity.
* XML element "Table
<pre>
!ATTLIST Table 	catalogName		CDATA	#IMPLIED
				schemaName		CDATA	#IMPLIED
				tableName			CDATA	#REQUIRED
				interfaces		CDATA	#IMPLIED
				objectName		CDATA	#IMPLIED
				tableType			CDATA	#IMPLIED
				description		CDATA	#IMPLIED
				cacheAll			(true|false) "false"
				lruCacheSize		CDATA	"0"
				pkToString		(true|false) "false"
				generateGUI		(true|false) "false"
</pre>
*/
public class TableXMLEntity extends SourceGenXMLEntity  {

	/** Token for object description **/
	static public final String DESCRIPTION = "description";

	/** Token for composite class name of the <code>PersistentObject</code>. **/
	static public final String CLASSNAME_OBJ = "classNameObj";

	/** Token for composite lass name of the <code>AbstractDomain</code>. **/
	static public final String CLASSNAME_DOMAIN = "classNameDomain";

	/** Public static to decide how to make object names **/
	static public boolean initCapNameOnly = false;

	static public String interfaceBase = null;
	boolean skipGenerate;
	boolean generateGUI;
	boolean cacheAll;
	private HashSet dbObjInterfaces = new HashSet();
	private HashSet domainInterfaces = new HashSet();

	private List columns = new ArrayList();
	private List foreignKeys = new ArrayList();

	private HashSet moduleList;

	/*** Default constructor
	*/
	public TableXMLEntity() {
	}
	public String toString() {
		return super.transientKeys.toString();
	}

	public void resolveImpliedKeys() {
		String util;
		moduleList = Generator.parseTokenList((String) super.transientKeys.get("moduleList"));
		processInterfaces(transientKeys,dbObjInterfaces,"interfaces",interfaceBase);
		processInterfaces(transientKeys,domainInterfaces,"domainInterfaces",interfaceBase);
		// Set domainExtension value -- always.
		util = "AbstractDomain";
		super.transientKeys.put("domainExtension",util);
		util = (String) super.transientKeys.get("objectName");
		if (util == null) {
			if (initCapNameOnly) {
				util = (String) super.transientKeys.get("tableName");
				super.transientKeys.put("classNameObj",java.lang.Character.toUpperCase(util.charAt(0))
					+util.substring(1));
			}
			else 
				super.transientKeys.put("classNameObj",JRFGeneratorUtil.databaseNameToFieldName(
					(String) super.transientKeys.get("tableName")));
		}
		else {
			super.transientKeys.put("classNameObj",util);
		}
		super.transientKeys.put("classNameDomain",(String) super.transientKeys.get("classNameObj")+"Domain");

	}

	public HashSet getModuleList() {
		return moduleList;
	}

	static void processInterfaces(HashMap transientKeys,HashSet interfaces, String key,String interfaceBase) {
		String util;
		if ( (util = (String) transientKeys.get(key)) != null ) {
			StringTokenizer st = new StringTokenizer(util,",");
			StringBuffer buf  = new StringBuffer();
			int c = 0;
			while (st.hasMoreTokens()) {
				String i = st.nextToken();
				if (++c > 1)
					buf.append(",");
				String result;
				if (interfaceBase != null && i.indexOf(".") == -1)
					result = interfaceBase+"."+i;
				else
					result = i;
				buf.append(result);
				interfaces.add(result);
			}
			transientKeys.put(key," implements "+buf.toString());
		}
		else 
			transientKeys.put(key,"");
	}

	public boolean implementsDbObjInterface(String interfaceName) {
		return dbObjInterfaces.contains(interfaceName);
	}

	public boolean implementsDomainInterface(String interfaceName) {
		return domainInterfaces.contains(interfaceName);
	}

	public String getDomainClassName() {
		return (String) super.transientKeys.get("classNameDomain");
	}
	public String getPersistentObjectClassName() {
		return (String) super.transientKeys.get("classNameObj");
	}
	public void setDescription(String description) {
		super.transientKeys.put("description",description);
	}

	public String getForeignKeyDescriptions() {
		StringBuffer buf = new StringBuffer();
		Iterator iter;
		iter = columns.iterator();
		int count = -1;
		String color;
		int i = 0;
		while (iter.hasNext()) {
			ColumnXMLEntity col = (ColumnXMLEntity) iter.next();
			String s = (String) col.getTransientKeys().get("importedFromTable");
			if (count % 2 == 0)
				color = "blue";
			else
				color =  "red";	
			if (s != null) {
				count++;
				color = (count % 2) == 0 ? "blue":"green";
				buf.append("<font color='"+color+"'>");
				buf.append(GenerateDatabase.createFKFromImport(i,null,s,this.getTableName(),
						(String) col.getTransientKeys().get("importedFromColumn"),
						(String) col.getTransientKeys().get("name")).toHTMLString()+"</br>");
				buf.append("</font>");
				i++;
			}
		}
		iter = foreignKeys.iterator();
		while (iter.hasNext()) {
			ForeignKeyXMLEntity fk = (ForeignKeyXMLEntity) iter.next();
			count++;
			color = (count % 2) == 0 ? "blue":"green";
			buf.append("<font color='"+color+"'>");
			buf.append(new ForeignKey(
						(String) fk.getTransientKeys().get("constraintName"),
						this.getTableName(),
						(String) fk.getTransientKeys().get("foreignTable"),
						(String) fk.getTransientKeys().get("localColumns"),
						(String) fk.getTransientKeys().get("foreignColumns"),
						null).toHTMLString()+"</br>");
			buf.append("</font>");
		}
		return buf.toString();
	}	

	public String getDescription() {
		return (String) super.transientKeys.get("description");
	}


	public String getTableName() {
		return (String) super.transientKeys.get("tableName");
	}

	public void setCacheAll(boolean value) {
		cacheAll = value;
	}
	public boolean hasColumn(ColumnXMLEntity c) {
		return columns.contains(c);		
	}

	public List getColumn() {
		return columns;
	}

	public void setColumn(List columns) {
		this.columns = columns;
	}

	public List getForeignKeyConstraint() {
		return foreignKeys;
	}
	
	public void setSkipGenerate(boolean skipGenerate) {
		this.skipGenerate = skipGenerate;
	}
	public boolean isGenerateGUI() {
		return this.generateGUI;
	}

	public void setGenerateGUI(boolean generateGUI) {
		this.generateGUI = generateGUI;
	}

	public void setForeignKeyConstraint(List foreignKeys) {
		this.foreignKeys = foreignKeys;
	}
}
