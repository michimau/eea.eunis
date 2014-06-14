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
import net.sf.jrf.column.columnspecs.*;
import net.sf.jrf.column.*;
import org.vmguys.appgen.*;

/** Table XML entity.
* XML element "Column"
<pre>
				objectName		CDATA	#IMPLIED
				jrfImpl			CDATA	#IMPLIED
				position		CDATA	#IMPLIED
				type			CDATA	#IMPLIED
				nullable		(true|false) "false"
				unique			(true|false) "false"
				seqName			CDATA	#IMPLIED
				size				CDATA	"0"
				digits			CDATA	"0"
				precision			CDATA	#IMPLIED
				scale			CDATA	"0"	
				dbType			CDATA	#IMPLIED
				versionColumn		(true|false) "false"
				description		CDATA	#IMPLIED
				isPrimaryKey		(true|false) "false"
				isSeq			(true|false) "false"
				optimisticLock		(true|false) "false"
				imported		(true|false) "false"
				importedFromTable	CDATA	#IMPLIED
				importedFromColumn	CDATA	#IMPLIED
				descKey			(true|false) "false"
				descLookupKey		CDATA	#IMPLIED	
				descLookupGetterName CDATA	#IMPLIED	
				fkseq			CDATA 	#IMPLIED
				default			CDATA	#IMPLIED
				setDefaultInDb		CDATA	#IMPLIED
				minValue			CDATA	#IMPLIED
				maxValue			CDATA	#IMPLIED
				usePrimitives   (true|false) "true"
</pre>
*/
public class ColumnXMLEntity extends SourceGenXMLEntity  {

	boolean primaryKey;
	boolean sequence;
	boolean optimisticLock;
	boolean nullable;
	boolean unique;
	boolean usePrimitives;
	String defaultBeanValue = null;
	String jrfColumnClassName;	
	String fieldName;
	static public int T_NUMERIC = 0;
	static public int T_TEXT = 1;
	static public int T_DOW = 2;
	static public int T_DATE = 3;
	static public int T_OTHER = 4;
	String getterSetter;
	int type = T_OTHER;
	String descriptionColor = "blue";
	String descriptionSize = "3";

	static String defaultPKColor;
	static String defaultColor;

	static public Properties dbTypeToJrfImplMap;

	// To update this list, create a properties file called
	// dbtype2jrfimpl.properties and specify translations as
	// char=StringColumnSpec
	// and so forth.
	static {
		dbTypeToJrfImplMap = new Properties();
		dbTypeToJrfImplMap.put("char","net.sf.jrf.column.columnspecs.StringColumnSpec");
		dbTypeToJrfImplMap.put("int","net.sf.jrf.column.columnspecs.LongColumnSpec");
		dbTypeToJrfImplMap.put("long","net.sf.jrf.column.columnspecs.LongColumnSpec");
		dbTypeToJrfImplMap.put("short","net.sf.jrf.column.columnspecs.ShortColumnSpec");
		dbTypeToJrfImplMap.put("double","net.sf.jrf.column.columnspecs.DoubleColumnSpec");
		dbTypeToJrfImplMap.put("boolean","net.sf.jrf.column.columnspecs.BooleanColumnSpec");
		dbTypeToJrfImplMap.put("date","net.sf.jrf.column.columnspecs.DateColumnSpec");
		dbTypeToJrfImplMap.put("datetime","net.sf.jrf.column.columnspecs.DateColumnSpec");
		// Let user override or add more.
		net.sf.jrf.util.PropertiesHelper.updatePropertiesForBundle("dbtype2jrfimpl",dbTypeToJrfImplMap);
	}
	
	/** Public static to decide how to make object names **/
	static public boolean initCapNameOnly = false;

	/*** Default constructor
	*/
	public ColumnXMLEntity() {
	}

	public int getType() {
		return this.type;
	}

	/** Returns true if columns names match.
	*/
	public boolean equals(Object o) {
		ColumnXMLEntity c = (ColumnXMLEntity) o;
		return c.getColumnName().equals(this.getColumnName());
	}

	public void resolveImpliedKeys() {
		String util = (String) super.transientKeys.get("jrfImpl");
		if (util == null) {
			util = (String) super.transientKeys.get("dbType");
			if (util == null)
				throw new IllegalArgumentException(this+": neither jrfImpl or dbType is specified.");
			String t = (String) dbTypeToJrfImplMap.getProperty(util);
			if (t == null) {
				throw new IllegalArgumentException(this+": no JRF column impl translation found for "+
							util);
			}
			util = t;
		}
		// fill out if required.
		if (util.indexOf(".") == -1) {
			util = "net.sf.jrf.column.columnspecs."+util;
		}
		super.transientKeys.put("jrfImpl",util);
		try {
			ColumnSpec spec = (ColumnSpec) Class.forName(util).newInstance();
			if (spec instanceof DayOfWeekColumnSpec) 
				type = T_DOW;
			else if (spec instanceof TextColumnSpec) 
				type = T_TEXT;
			else if (spec instanceof NumericColumnSpec)
				type = T_NUMERIC;
			else if (spec instanceof DateColumnSpec)
				type = T_DATE;
			else
				type = T_OTHER;
			jrfColumnClassName = spec.getColumnClass().getName();
		}
		catch (Exception ne) {
			throw new IllegalArgumentException(this+": No such class: "+util);
		}
		if (nullable && type != T_DOW) {
			// If is nullable -- CANNOT be a primitive -- override default.
			usePrimitives = false;
		}
		util = (String) super.transientKeys.get("objectName");
		if (util == null) {
			if (initCapNameOnly) {
				util = (String) super.transientKeys.get("name");
				super.transientKeys.put("objectName",java.lang.Character.toUpperCase(util.charAt(0))
							+util.substring(1));
			}
			else
				super.transientKeys.put("objectName",JRFGeneratorUtil.databaseNameToFieldName(
					(String) super.transientKeys.get("name")));
			util = (String) super.transientKeys.get("objectName");
		}
		super.transientKeys.put("propertyName",generatePropertyName(util) );
		getterSetter = super.transientKeys.get("objectName")+"GetterSetter";
		fieldName = "f_"+((String) super.transientKeys.get("objectName"));
		util = (String) transientKeys.get("maxValue");
		if (util == null) {
			super.transientKeys.put("maxValue","null");
		}
		util = (String) super.transientKeys.get("minValue");
		if (util == null) {
			super.transientKeys.put("minValue","null");
		}
		util = (String) super.transientKeys.get("default");
		if (util == null || type == T_DOW) {
			super.transientKeys.put("default","null");
		}
		if (type == T_DOW) {
			if (util == null) {
			      defaultBeanValue = 
						"net.sf.jrf.column.columnspecs.DayOfWeekColumnSpec.NULLDAYOFWEEK";
			}      
			else {
			      defaultBeanValue  = util;
			}
		}
		if (util != null) {
			if (!util.startsWith("new")) {
				super.transientKeys.put("default",JRFGeneratorUtil.getLiteralValueCode(
						jrfColumnClassName,util));
				
			}
		}
		
		util = (String) super.transientKeys.get("size");
		if (util == null) {
			super.transientKeys.put("size","255");
		}
		super.transientKeys.put("listOfValues","null");
		super.transientKeys.put("listOfValuesAdd","");
		setDescriptionColor(primaryKey ? defaultPKColor:defaultColor);	
		util = (String) super.transientKeys.get("writeOnce");
		if (util.equals("true") && !primaryKey) {
			super.transientKeys.put("writeOnceAdd","	colVar.setWriteOnce(true);");
		}
		else {
			super.transientKeys.put("writeOnceAdd","");
		}
	}

	public static String generatePropertyName(String name) {
		int i = 0;
		for ( ; i < name.length(); i++) {
			if (Character.isLowerCase(name.charAt(i)) )
				break;
		}
		if (i == name.length())
			return name;
		return Character.toLowerCase(name.charAt(0))+name.substring(1);
	}

	public void setDescriptionColor(String color) {
		this.descriptionColor = color;
	}
	public void setDescriptionColorAndSize(String color,String size) {
		this.descriptionColor = color;
		this.descriptionSize = size;
	}

        public String getPropertyName() {
		return (String) super.transientKeys.get("propertyName");
	}

	public String getEncodedKeyCode() {
		if (type == T_DATE) {
			return "("+fieldName+" == null ? \"null\":new java.sql.Timestamp("+fieldName+".getTime()).toString())";
		}
		if (usePrimitives) {
			return JRFGeneratorUtil.getPrimitiveWrapperCode(jrfColumnClassName,fieldName)+".toString()";
		}
		return fieldName+".toString()";
	}

	public boolean isTextColumn() {
		return type == T_TEXT ? true:false;
	}
	public String getSequenceName() {
		return (String) super.transientKeys.get("seqName");
	}


	public String getFieldDeclaration() {
		return getFieldDeclaration(usePrimitives,jrfColumnClassName,fieldName,defaultBeanValue);
	}	

	public String getToStringInfo() {
		return  "		\""+fieldName+" = \"+"+fieldName+"+\"\\n\"+\n";
	}

	public String getObjectName() {
		return (String) super.transientKeys.get("objectName");

	}
	public String getFieldDeclarationType() {
		return getClassDeclaration(jrfColumnClassName,usePrimitives);
	}

	public String getFieldName() {
		return fieldName;	
	}

	public String getColumnName() {
		return (String) super.transientKeys.get("name");
	}

	static public String getFieldDeclaration(boolean usePrimitives, String jrfColumnClassName, String fieldName,String defaultBeanValue) {
		String cName = getClassDeclaration(jrfColumnClassName,usePrimitives);
		if (defaultBeanValue != null)
			return "	private "+cName+" "+fieldName+" = "+defaultBeanValue+";\n";
		return "	private "+cName+" "+fieldName+";\n";
	}	

	private static String getClassDeclaration(String jrfColumnClassName, boolean usePrimitives) {
		String result = CodeGenUtil.getClassDeclarationValue(jrfColumnClassName);
		if (usePrimitives) {	// Translate things like java.util.Long to long, if required.
			return JRFGeneratorUtil.translateWrapper(result);
		}
		return result;
	}

	public String getRawDescription() {
		return (String) super.transientKeys.get("description");
	}
	
	public String getDescription() {
		String d = (String) super.transientKeys.get("description");
		if (d == null)
			d = getColumnName();
		if (nullable && type == T_NUMERIC) 
			d = d + ". This numeric attribute has an underlying nullable database column.";
		return "<font size='"+descriptionSize+"' color='"+descriptionColor+"'>"+d+"</font>";
	}

	public void appendGetterSetter(StringBuffer buf,String additional) throws CodeGenException {
		String cName = getClassDeclaration(jrfColumnClassName,usePrimitives);
		String objName = (String) super.transientKeys.get("objectName");
		String description = getDescription();
		String localAdditional;
		if (isPrimaryKey()) 
			localAdditional = "		markNewPersistentState();\n";
		else
			localAdditional = "		markModifiedPersistentState();\n";
		if (additional != null)
			localAdditional = localAdditional + additional;
		CodeGenUtil.appendSetter(description,objName,fieldName,cName,null,localAdditional,buf);
		CodeGenUtil.appendGetter(description,objName,fieldName,cName,null,buf);

	}

	public String getGetterSetterImpl(String dbObjClassName) throws CodeGenException {
		return  JRFGeneratorUtil.getGetterSetterImplCode(
					getterSetter,
					dbObjClassName,
					(String) super.transientKeys.get("objectName"),
					jrfColumnClassName,
					usePrimitives);
	} 


	private static final String specCreateTemplateBase = 
			"		{\n"+
			"		$jrfImpl$ colVar;\n"+
			"		colVar= new $jrfImpl$(\"$name$\",$colOption$,new $getterSetter$(),\n"+
			"					$default$);\n"+
			"		colVar.setMaxValue($maxValue$);\n"+
			"		colVar.setMinValue($minValue$);\n"+
			"		$listOfValuesAdd$\n"+
			"		$writeOnceAdd$\n"+
			"		colVar.setListOfValues($listOfValues$);\n"+
			"		colVar.setPropertyName(\"$propertyName$\");\n"+
			"$text$\n"+
			"$numeric$\n"+
			"		$entity$.addColumnSpec(colVar);\n"+
			"		}\n";
	

	public String getColumnSpecDeclare(String entity, boolean respectCompoundKey) throws CodeGenException {
		super.transientKeys.put("numeric","");
		super.transientKeys.put("text","");
		if (type == T_NUMERIC) {
			String scale = (String) super.transientKeys.get("scale");
			if (!scale.equals("0")) {
				super.transientKeys.put("numeric",
				"		colVar.setPrecision("+super.transientKeys.get("precision")+");\n"+
				"		colVar.setScale("+super.transientKeys.get("scale")+");\n");
			}
		}
		else if (type == T_TEXT) {
			super.transientKeys.put("text",
			"		colVar.setMaxLength("+super.transientKeys.get("size")+");\n");
		}
		super.transientKeys.put("colOption",getColumnOption(respectCompoundKey));
		super.transientKeys.put("getterSetter",getterSetter);
		super.transientKeys.put("entity",entity);
		return CodeGenUtil.generateFromTemplate(
				 			CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
				  			specCreateTemplateBase,super.transientKeys);
	}
	
	private  String getColumnOption(boolean respectCompoundKey) {
		if (sequence)	
			return "new SequencedPrimaryKeyColumnOption()";
		if (primaryKey) {
			if (respectCompoundKey)
				return "new RequiredColumnOption()";
			return  "new NaturalPrimaryKeyColumnOption()";
		}
		if (optimisticLock) 
			return "new OptimisticLockColumnOption()";
		if (nullable)
			return "new NullableColumnOption()";
		return unique ? "new UniqueColumnOption()":"new RequiredColumnOption()";
	}

	public String getColumnClassName() {
		return this.jrfColumnClassName;
	}

	public String getColumnImplClassName() {
		return (String) super.transientKeys.get("jrfImpl");
	}

	public boolean isPrimaryKey() {
		return primaryKey;
	}
	public void setIsPrimaryKey(boolean value) {
		this.primaryKey = value;
	}	
	
	public void setUnique(boolean value) {
		this.unique = unique;
	}	

	public boolean isNullable() {
		return this.nullable;
	}

	public void setNullable(boolean value) {
		this.nullable = value;
	}	

	public void setOptimisticLock(boolean value) {
		this.optimisticLock = value;
	}	
	public void setIsSeq(boolean value) {
		this.sequence = value;
	}	

	public boolean getUsePrimitives() {
		return this.usePrimitives;
	}

	public void setUsePrimitives(boolean usePrimitives) {
		this.usePrimitives = usePrimitives;
	}


	/** Sets LOV.
	*/
	public void setListOfValues(List listOfValues) {
		if (listOfValues.size() > 0) {
			StringBuffer buf = new StringBuffer();
			buf.append("		java.util.ArrayList lov = new ArrayList();\n");
			Iterator iter =  listOfValues.iterator();
			while (iter.hasNext()) {
				ListOfValuesXMLEntity e = (ListOfValuesXMLEntity) iter.next();
				String value = e.getValue();
				if (!e.getValue().startsWith("new")) {
					if (type == T_TEXT)  
						value = "\""+e.getValue()+"\"";
					else if (type == T_NUMERIC) {
						if (jrfColumnClassName.equals("java.lang.Long"))
							value = "new Long("+e.getValue()+")";
						else if (jrfColumnClassName.equals("java.lang.Short"))
							value = "new Short("+e.getValue()+")";
						else if (jrfColumnClassName.equals("java.lang.Integer"))
							value = "new Integer("+e.getValue()+")";
						else if (jrfColumnClassName.equals("java.lang.Double"))
							value = "new Double("+e.getValue()+")";
						else if (jrfColumnClassName.equals("java.lang.Float"))
							value = "new Float("+e.getValue()+")";
						else
							throw new IllegalArgumentException(this+
				": Unsupported list of value number type (long,short,double,float and integer supported)");
					}	
					else 
						throw new IllegalArgumentException(this+
							": Unsupported list of value literal; use 'new X..");
				}
				buf.append("		lov.add("+value+");\n");
			}
			super.transientKeys.put("listOfValues","lov");
			super.transientKeys.put("listOfValuesAdd",buf.toString());
		}
		
	}

}
