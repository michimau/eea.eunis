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
import org.vmguys.appgen.*;
import java.io.*;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
import javax.naming.*;
import java.beans.*;
import javax.naming.directory.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.vmguys.reflect.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.ErrorHandler;
import java.util.*;
import org.apache.log4j.Category;
import net.sf.jrf.column.*;
import net.sf.jrf.column.columnspecs.*;
import java.text.*;

/** Code generator for generating embedded <code>PersistentObject</code>s and
* join table columns, sub-classing simple table-mapped <code>PersistentObjects</code>
* and <code>AbstractDomain</code>.
*/
public class EmbeddedGenerator extends Generator {

	static Category LOG = Category.getInstance(EmbeddedGenerator.class.getName());
	static {
		// Set so Main can correctly run.
		generatorClassName = EmbeddedGenerator.class.getName();
	}
	
	/** Output directory for generated <code>PersistentObject</code>. **/
	protected String sourceOutputDbObj;
	
	/** Output directory for generated <code>AbstractDomain</code>. **/
	protected String sourceOutputDomain;

	/** Import package of base <code>PersistentObject</code>. **/
	protected String baseImportDbObj;

	/** Import package of base <code>AbstractDomain</code>. **/
	protected String baseImportDomain;
	
	/** Package name of <code>AbstractDomain</code>. **/
	protected String packageNameDomain;

	/** Package name of <code>PersistentObject</code>. **/
	protected String packageNameDbObj;

	private static final String POKEY_EMBEDDED_DECLARATIONS = "embeddedDeclarations";
	private static final String POKEY_EMBEDDED_ACCESSORS = "embeddedAccessors";
	private static final String POKEY_TOSTRING = "tostring";
	private static final String POKEY_ADDITIONAL = "additional";
	
	private SourceBuffer poBuffer;

	private void initPersistentObjectBuffer() {
		poBuffer = new SourceBuffer(persistentObjectTemplate);
		poBuffer.setOutputDirectory(this.sourceOutputDbObj);
		poBuffer.addPermanentKeyAndValue("packageNameDbObj",this.packageNameDbObj);
		poBuffer.addPermanentKeyAndValue("baseImportDbObj",this.baseImportDbObj+".*");
		poBuffer.addAppendableKey(POKEY_EMBEDDED_DECLARATIONS);
		poBuffer.addAppendableKey(POKEY_EMBEDDED_ACCESSORS);
		poBuffer.addAppendableKey(POKEY_TOSTRING);
		poBuffer.addAppendableKey(POKEY_ADDITIONAL);
	}
	/*
	classNameObj			CDATA	#REQUIRED
	 	baseClassNameObj		CDATA	#REQUIRED
		description			CDATA	#REQUIRED
		classNameDomain		CDATA	#IMPLIED
		objInterfaces			CDATA	#IMPLIED
		domainInterfaces		CDATA	#IMPLIED
	 	baseClassNameDomain		CDATA	#IMPLIED
	*/
	static private final String persistentObjectTemplate =
		"package $packageNameDbObj$;"+
		"\n"+
		"import $baseImportDbObj$;\n"+
		"import java.util.*;\n"+
		"import net.sf.jrf.domain.*;\n"+
		"import net.sf.jrf.rowhandlers.*;\n"+
		"\n"+
		"/** \n"+
		"* $description$\n"+
		"*/\n"+
		"public class $classNameObj$ extends $baseClassNameObj$ $objInterfaces$ {\n"+
		"$"+POKEY_EMBEDDED_DECLARATIONS+"$\n"+
		"	/** Default constructor **/\n"+
		"	public $classNameObj$() {\n"+
		"		super();\n"+
		"	}\n"+
		"\n"+
		"	/** Returns master record value and all embedded values. **\n"+
		"	 * @return master record and all embedded values.\n"+
		"	 */\n"+
		"	public String toString() {\n"+
		"		StringBuffer result = new StringBuffer();\n"+
		"		result.append(super.toString()+\"\\n\");\n"+
		"		Iterator iter;\n"+
		"$"+POKEY_TOSTRING+"$\n"+
		"		return result.toString();\n"+
		"	}\n"+
		"\n"+
		"$"+POKEY_EMBEDDED_ACCESSORS+"$\n"+
		"$"+POKEY_ADDITIONAL+"$\n"+
		"}\n";

	//////////////////////////////////////////////////////////////////////////////////
	
	
	/* Variables:
	*	classNameDomain:  		Name of composite domain.
	*	classNameDomainBase:	Name of base domain.
	* (!)classNameObject:  		Name of composite persistent object	
	*    domainDeclarations:		List of embedded domains variable declarations.
	*    domainInstantiations:	List of embedded domains instantiations.
	*    embeddedAdds:			List of addEmbeddedPersistentObjectHandler() calls.
	*	joins				List of join declarations.
	*	handlers				List of handler implementations
	*						(embeddedHandlerTemplateWriteDetailAfterRow)
	*						
	*/
	private SourceBuffer domainBuffer;
	private static final String DOMKEY_DOMAIN_DECLARATIONS = "domainDeclarations";
	private static final String DOMKEY_DOMAIN_INSTANTIATIONS = "domainInstantiations";
	private static final String DOMKEY_EMBEDDED_ADDS = "embeddedAdds";
	private static final String DOMKEY_JOINS = "joins";
	private static final String DOMKEY_HANDLERIMPL = "handlerImpls";
	private static final String DOMKEY_JOINGETTERSETTER = "joinGetterSetter";
	private static final String DOMKEY_ADDITIONAL = "additional";
	// Called at construct time.
	private void initDomainBuffer() {
		domainBuffer = new SourceBuffer(domainTemplate);
		domainBuffer.setOutputDirectory(this.sourceOutputDomain);
		domainBuffer.addPermanentKeyAndValue("packageNameDomain",this.packageNameDomain);
		domainBuffer.addPermanentKeyAndValue("baseImportDbObj",this.baseImportDbObj+".*");
		domainBuffer.addPermanentKeyAndValue("domainbaseImport",this.baseImportDomain+".*");
		domainBuffer.addPermanentKeyAndValue("compositebaseImport",this.packageNameDbObj+".*");
		domainBuffer.addAppendableKey(DOMKEY_DOMAIN_DECLARATIONS);
		domainBuffer.addAppendableKey(DOMKEY_EMBEDDED_ADDS);
		domainBuffer.addAppendableKey(DOMKEY_DOMAIN_INSTANTIATIONS);
		domainBuffer.addAppendableKey(DOMKEY_HANDLERIMPL);
		domainBuffer.addAppendableKey(DOMKEY_JOINS);
		domainBuffer.addAppendableKey(DOMKEY_JOINGETTERSETTER);
		domainBuffer.addAppendableKey(DOMKEY_ADDITIONAL);
	}

	/*
	classNameObj			CDATA	#REQUIRED
	 	baseClassNameObj		CDATA	#REQUIRED
		description			CDATA	#REQUIRED
		cached				(true|false) "false"
		cacheSize				CDATA	#IMPLIED
		classNameDomain		CDATA	#IMPLIED
		objInterfaces			CDATA	#IMPLIED
		domainInterfaces		CDATA	#IMPLIED
	 	baseClassNameDomain		CDATA	#IMPLIED
	*/
	static private final String domainTemplate = 
		"package $packageNameDomain$;"+
		"\n"+
		"import $baseImportDbObj$;\n"+
		"import $domainbaseImport$;\n"+
		"import $compositebaseImport$;\n"+
		"import java.io.Serializable;\n"+
		"import java.util.*;\n"+
		"import net.sf.jrf.domain.*;\n"+
		"import net.sf.jrf.rowhandlers.*;\n"+
		"import net.sf.jrf.sql.*;\n"+
		"import net.sf.jrf.join.JoinTable;\n"+
		"import net.sf.jrf.join.OuterJoinTable;\n"+
		"import net.sf.jrf.join.joincolumns.*;\n"+
		"import net.sf.jrf.column.GetterSetter;\n"+
		"\n"+
		"public class $classNameDomain$ extends $baseClassNameDomain$ $domainInterfaces$ {\n"+
		"$"+DOMKEY_DOMAIN_DECLARATIONS+"$\n"+
		"	/** Default constructor **/\n"+
		"	public $classNameDomain$() {\n"+
		"		super();\n"+
		"	}\n"+
		"\n"+
		"	/** Constructs domain using given <code>Properties</code> object.\n"+
		"	* @param properties domain-specific properties. \n"+
		"	*/\n"+
		"	public $classNameDomain$(Properties properties) {\n"+
		"		super(properties);\n"+
		"	}\n"+
		"\n"+
		"	/** Returns a new object \n"+
		"	 * @return new instance of handled composite object\n"+
		"	 */\n"+
		"	public PersistentObject newPersistentObject()\n"+
		"	{\n"+
		" 		return new $classNameObj$();\n"+
		"	}\n"+	
		"\n"+
		"	protected PersistentObject createParentPersistentObject() {\n"+
		"		return super.newPersistentObject();\n"+
		"	}\n"+
		"\n"+
		"	protected String getParentEncodedPrimaryKey(PersistentObject aPO) {\n"+
		"		return super.encodePrimaryKey(aPO);\n"+
		"	}\n"+
		"\n"+
		"	protected void setup() {\n"+
		"		super.setup();\n"+
		"		PersistentObjectCache.setMaxCacheSize(this.getClass(),$lruCacheSize$);\n"+
		"		PersistentObjectCache.setCacheAll(this.getClass(),$cacheAll$);\n"+
		"$"+DOMKEY_DOMAIN_INSTANTIATIONS+"$\n"+
		"$"+DOMKEY_EMBEDDED_ADDS+"$\n"+
		"$"+DOMKEY_JOINS+"$\n"+
		"	}\n"+
		"\n"+
		"$"+DOMKEY_HANDLERIMPL+"$\n"+
		"$"+DOMKEY_JOINGETTERSETTER+"$\n"+
		"$"+DOMKEY_ADDITIONAL+"$\n"+
		"\n"+
		"}\n";

	private SourceBuffer writeHandlerBuffer;

	private static final String HWKEY_SETPARAMS = "setParams";
	private static final String HWKEY_POPSETTERS = "popSetters";
	private static final String HWKEY_ARGSETTERS = "argSetters";

	private void initWriteHandlerBuffer() {
		writeHandlerBuffer = new SourceBuffer(embeddedHandlerTemplateWriteDetailRecords);
		writeHandlerBuffer.addAppendableKey(HWKEY_SETPARAMS);
		writeHandlerBuffer.addAppendableKey(HWKEY_POPSETTERS);
		writeHandlerBuffer.addAppendableKey(HWKEY_ARGSETTERS);
	}

	/* Variables:
	*	handerClassName:			Class name of the handler.
	*	aggregateRowHandler:		Class name of the row handler.
	*	handlerDomainVariableName	Name of the variable. 
	*	setParams					List of template resolution of 
	*							setSpecsTemplate (see below).		
	*	whereClause				Where clause of the search.
	* 	orderBy					Order by for the search.
	*	parentClassName			Name of the parent class (generally maps
	*							to classNameObjectBase (see above))	
	*	childClassName				Name of the child class
	*	popSetters				List of setters of values from parent to 
	*							child values. (see popSetterTemplate)
	*	childDataName				Name of accessor for the child embedded object.
	*	constructObjects			Filling out of template for constructObjects()
	*							(see constructObjectsTemplate2 and 
	*							 constructObjectsTemplate1)	
	*/
	private static final String embeddedHandlerTemplateWriteDetailRecords = 
		"	private class $handlerClassName$ extends EmbeddedPersistentObjectHandlerWrite {\n"+
		"		ArrayList args = new ArrayList();\n"+
		"		ArrayList specs = new ArrayList();\n"+
		"		private String whereClause = \"$whereClause$\";\n"+
		"		$aggregateRowHandler$ rowHandler =  new $aggregateRowHandler$($rowHandlerArgs$);\n"+
		"		private String preparedKeyFind;\n"+
		"		private String preparedKeyDelete;\n"+
		"		$handlerClassName$(){\n"+
		"			super.domain = $handlerDomainVariableName$;\n"+
		"			preparedKeyFind = super.domain.createPreparedStatementKey(\"findDet\");\n"+
		"			preparedKeyDelete = super.domain.createPreparedStatementKey(\"delDet\");\n"+
		"$"+HWKEY_SETPARAMS+"$\n"+
		"			for (int i = 0; i < specs.size(); i++) {\n"+
		"				args.add(new Object());\n"+
		"			}\n"+
		"			domain.addPreparedFindStatement(preparedKeyFind,domain.getTableName(),whereClause,\"$orderBy$\",specs);\n"+
		"			domain.addAdhocPreparedStatement(preparedKeyDelete,\"Delete from \"+domain.getTableName()+\" WHERE \"+\n"+
		"							whereClause,specs);\n"+
		"		}\n"+
		"\n"+
		"\n"+
		"		public void populateEmbeddedObjectKeyValues(PersistentObject parentPO, PersistentObject embeddedPO) {\n"+
		"			$parentClassName$ parentRec = ($parentClassName$) parentPO;\n"+
		"			$childClassName$ childRec = ($childClassName$) embeddedPO;\n"+
		"$"+HWKEY_POPSETTERS+"$\n"+
		"		}\n"+
		"\n"+
		"		public Iterator getObjectIterator(PersistentObject parentPO) {\n"+
		"			$parentClassName$ parentRec = ($parentClassName$) parentPO;\n"+
		"			return parentRec.get$fieldName$()$iteratorGet$;\n"+
		"		}\n"+
		"\n"+
		"		public void  constructObjects(PersistentObject parentPO, JRFResultSet jrfResultset) { \n"+
		"			$parentClassName$ parentRec = prepareArgs(parentPO);\n"+
		"			rowHandler.clear();\n"+
		"			domain.findByPreparedStatement(preparedKeyFind,rowHandler,args);\n"+
		"			parentRec.set$fieldName$(($aggregateReturnClassName$) rowHandler.getResult());\n"+
		"		}\n"+	
		"\n"+
		"		public void deleteDetailRecords(PersistentObject parentPO){\n"+
		"			$parentClassName$ parentRec = prepareArgs(parentPO);\n"+
		"			domain.executeAdhocPreparedStatement(preparedKeyDelete,args);\n"+
		"		}\n"+
		"\n"+
		"		private $parentClassName$ prepareArgs(PersistentObject parentPO) { \n"+
		"			$parentClassName$ parentRec = ($parentClassName$) parentPO;\n"+
		"$"+HWKEY_ARGSETTERS+"$\n"+
		"			return parentRec;\n"+
		"		}\n"+	
		"		\n"+
		"		public String getBeanAttribute() {\n"+
		"			return \"$attributeName$\";\n"+ 
		"		}\n"+
		"	}\n";

	private SourceBuffer readHandlerBuffer;

	private static final String HRKEY_SETTERS = "joinObjSetters";
	private void initReadHandlerBuffer() {
		readHandlerBuffer = new SourceBuffer(embeddedHandlerTemplateJoinRead);
		readHandlerBuffer.addAppendableKey(HRKEY_SETTERS);
	}

	private static final String embeddedHandlerTemplateJoinRead  = 
		"	private class $handlerClassName$ extends EmbeddedPersistentObjectHandlerReadOnly {\n"+
		"		$handlerClassName$() {\n"+
		"		}\n"+
		"\n"+
		"		public void  constructObjects(PersistentObject parentPO, JRFResultSet jrfResultset) { \n"+
		"			$parentClassName$ parentRec = ($parentClassName$) parentPO;\n"+
		"			try {\n"+
		"				$classNameObj$ obj = new $classNameObj$();\n"+
		"$"+HRKEY_SETTERS+"$\n"+		// see template just below
		"				parentRec.set$fieldName$(obj);\n"+
		"			}\n"+
    		"			catch (SQLException e) {\n"+
          "				  throw new DatabaseException(e);\n"+
	     "			}\n"+
		"		}\n"+		
		"	}\n";

	private static final String readJoinSetterTemplate = 
		"		obj.set$fieldName$(jrfResultset.$resultSetGetter$($columnName$))\n";

	/* This template is used for popSetters, using parentRec and childRec variables declared
	*	in the embedded template.
	* 	Variables:
	* 	childFieldName:	Name of the field in child that needs to get populated by the master.
	*	parentFieldGetter:	Name of the get/is method that obtains the field in the master record.
	* 
	*/
	private static final String popSetterTemplate = 
		"			childRec.set$childFieldName$(parentRec.$parentFieldGetter$());\n";

	/* Sets column specification for template.
	* Variables:
	*		columnSpec:		 class name of the column specification	for the query.
	*/
	private static final String setParamsTemplate = 
		"		specs.add(new $columnSpec$());\n";

	private static final String argSetterTemplateObject = 
		"			args.set($num$,parentRec.$parentFieldGetter$());\n";

	private static final String argSetterTemplatePrimitive = 
		"			args.set($num$,new $wrapperType$(parentRec.$parentFieldGetter$()));\n";

	// Defaults is not overridden by a sub-class.
	//private String compositeMasterMetaDataClassName = "net.sf.jrf.codegen.CompositeMasterMetaData";
	//private String embeddedObjectMetaDataClassName = "net.sf.jrf.codegen.EmbeddedObjectMetaData";
	//private String joinFieldMetaDataClassName = "net.sf.jrf.codegen.JoinFieldMetaData";
	
	private String compositeMasterMetaDataClassName;
	private String embeddedObjectMetaDataClassName;
	private String joinFieldMetaDataClassName;

	private List getCompositeList(Element root) 
						throws SAXException,IntrospectionException,
						java.lang.reflect.InvocationTargetException,ParseException,
						java.lang.IllegalAccessException,NoSuchMethodException {
		///////////////////////////////////////////////////////////
		// Hierarchy
		// CompositeObject --
		//				EmbeddedInfo --
		//							JoinFields --
		//				JoinTable
		//						 	JoinColumn
		//							JoinTable
		//				Methods
		///////////////////////////////////////////////////////////
		SourceGenXMLEntityMetaData masterMeta = new SourceGenXMLEntityMetaData(
							compositeMasterMetaDataClassName,
							"CompositeObject");
		SourceGenXMLEntityMetaData embeddedMeta = new SourceGenXMLEntityMetaData(
							embeddedObjectMetaDataClassName,
							"EmbeddedInfo");
		SourceGenXMLEntityMetaData joinFieldsMeta = new SourceGenXMLEntityMetaData(
							joinFieldMetaDataClassName,
							"JoinFields");
		SourceGenXMLEntityMetaData joinTableMeta = new SourceGenXMLEntityMetaData(
							"org.vmguys.appgen.jrf.JoinTableXMLEntity",
							"JoinTable");
		SourceGenXMLEntityMetaData joinColumnMeta = new SourceGenXMLEntityMetaData(
							"org.vmguys.appgen.jrf.JoinColumnXMLEntity",
							"JoinColumn");
		SourceGenXMLEntityMetaData domainMethodMeta = new SourceGenXMLEntityMetaData(
							"org.vmguys.appgen.jrf.MethodsXMLEntity",
							"DomainMethods");
		SourceGenXMLEntityMetaData poMethodMeta = new SourceGenXMLEntityMetaData(
							"org.vmguys.appgen.jrf.MethodsXMLEntity",
							"PersistentObjectMethods");
		// Set up hierarchy.
		joinTableMeta.addChild(joinColumnMeta);
		joinTableMeta.addChild(joinTableMeta);
		embeddedMeta.addChild(joinFieldsMeta);
		masterMeta.addChild(joinTableMeta);
		masterMeta.addChild(embeddedMeta);
		masterMeta.addChild(domainMethodMeta);
		masterMeta.addChild(poMethodMeta);
		return SourceGenXMLEntityMetaData.createEntityTreeFromXML(root,masterMeta);
	}

	/** Initializes XML document and reads the properites file, calling all set methods
	 * specified in the file.
	 * @param prop properties file path
	 * @param xml xml file paths
	 */
	public EmbeddedGenerator(String prop,ArrayList xml) 
		throws IOException, SecurityException, CodeGenException,FileNotFoundException, 
						SAXException, ParserConfigurationException, IntrospectionException,
						java.lang.reflect.InvocationTargetException,ParseException,
						java.lang.IllegalAccessException,NoSuchMethodException {
		super(prop,xml);
		checkParameters(prop);
		init();	// Init any sub-class stuff.
		initPersistentObjectBuffer();
		initDomainBuffer();
		initWriteHandlerBuffer();
		initReadHandlerBuffer();
		//////////////////////////////////////////////////////////////////////////////////
		// Combine all XML files (some resusable for multiple application projects) into a single list.
		//////////////////////////////////////////////////////////////////////////////////
		List compositeList = getCompositeList(super.roots[0]);
		for (int j = 1; j < super.roots.length; j++) {
			compositeList.addAll( getCompositeList(super.roots[j]) );
		}
		Iterator compIter = compositeList.iterator();
		// For each composite object, generate a domain and a persistent object file.
		while (compIter.hasNext()) {
			CompositeObjectXMLEntity comp = (CompositeObjectXMLEntity) compIter.next();
			if (!generateEntity(comp.getModuleList()) )
				continue;
			reset();
			poBuffer.reset();
			domainBuffer.reset();
			// Allow a sub-class to do something with it.
			processCompositeEntity(comp);
			poBuffer.setTransientKeys(comp.getTransientKeys());		
			domainBuffer.setTransientKeys(comp.getTransientKeys());		
			// For each embedded object within the composite
			Iterator embeddedIter = comp.getEmbeddedInfo().iterator();
			while (embeddedIter.hasNext()) {
				EmbeddedInfoXMLEntity embedded = (EmbeddedInfoXMLEntity) embeddedIter.next();
				if (embedded.isJoinType()) {
					processEmbeddedJoinObject(comp,embedded);
				}
				else {
					processEmbeddedQueryObject(comp,embedded);
				}
				poBuffer.append(POKEY_TOSTRING,embedded.getToString("result","iter"));
			}
			// Process any join fields.
		 	Iterator joinTableIter = comp.getJoinTable().iterator();
			String classNameObj = (String) comp.getTransientKeys().get(CompositeObjectXMLEntity.CLASSNAME_OBJ);
			int count = 0;
			while (joinTableIter.hasNext()) {
				JoinTableXMLEntity je = (JoinTableXMLEntity) joinTableIter.next();
				processJoinTable(classNameObj,null,je,count++,0);
			}
			// Add in any sub-class code -- base class is blank.
			poBuffer.append(POKEY_ADDITIONAL,getAdditionalPersistentObjectCode(comp));
			domainBuffer.append(DOMKEY_ADDITIONAL,getAdditionalDomainCode(comp));
			// Add in any methods -- currently list should only have one item -- iterate anyway in case this changes.
			Iterator poMethodIter = comp.getPersistentObjectMethods().iterator();
			while (poMethodIter.hasNext()) {
				MethodsXMLEntity m = (MethodsXMLEntity) poMethodIter.next();
				poBuffer.append(POKEY_ADDITIONAL,m.getContents());
			}
			Iterator domainMethodIter = comp.getDomainMethods().iterator();
			while (domainMethodIter.hasNext()) {
				MethodsXMLEntity m = (MethodsXMLEntity) domainMethodIter.next();
				domainBuffer.append(DOMKEY_ADDITIONAL,m.getContents());
			}
			// Generate the files.
			poBuffer.flushToFile(classNameObj);
			domainBuffer.flushToFile( (String) comp.getTransientKeys().get(CompositeObjectXMLEntity.CLASSNAME_DOMAIN) );

		} // End for each composite object.
	}

	private void processEmbeddedJoinObject(CompositeObjectXMLEntity comp, EmbeddedInfoXMLEntity embedded) 
			throws CodeGenException {
		readHandlerBuffer.reset();
		readHandlerBuffer.setTransientKeys(embedded.getTransientKeys());
		Iterator joinIter = embedded.getJoinFields().iterator();
		domainBuffer.append(DOMKEY_EMBEDDED_ADDS,embedded.getEmbeddedAdd());
		// For each join field that makes up the join object.	
		while (joinIter.hasNext()) {
			JoinFieldXMLEntity join = (JoinFieldXMLEntity) joinIter.next();
			join.validateByJoin();
			readHandlerBuffer.addTransientKeysAndValues(join.getTransientKeys());
			readHandlerBuffer.append(HRKEY_SETTERS,
						CodeGenUtil.generateFromTemplate(
					 		CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
				  			readJoinSetterTemplate,readHandlerBuffer.getTransientKeys()));
		}	
		domainBuffer.append(DOMKEY_HANDLERIMPL,readHandlerBuffer.buildSource());
	}

	private void processEmbeddedQueryObject(CompositeObjectXMLEntity comp, EmbeddedInfoXMLEntity embedded) 
					throws CodeGenException{
			embedded.getTransientKeys().put("parentClassName",(String) comp.getTransientKeys().get(
						CompositeObjectXMLEntity.CLASSNAME_OBJ) );
			// Append to domain declarations, domain instantiations and handler "adds":
			domainBuffer.append(DOMKEY_DOMAIN_DECLARATIONS,embedded.getDomainDeclaration());
			domainBuffer.append(DOMKEY_DOMAIN_INSTANTIATIONS,embedded.getDomainInstantiations());
			domainBuffer.append(DOMKEY_EMBEDDED_ADDS,embedded.getEmbeddedAdd());
			// Append PO object declare and getter/setter.
			poBuffer.append(POKEY_EMBEDDED_DECLARATIONS,embedded.getObjectDeclaration());
			embedded.appendGetterSetter(poBuffer.getAppendableBuffer(POKEY_EMBEDDED_ACCESSORS));
			// Set up base handler buffer stuff.
			writeHandlerBuffer.reset();
			writeHandlerBuffer.setTransientKeys(embedded.getTransientKeys());
			Iterator joinIter = embedded.getJoinFields().iterator();
			int c = 0;
			// For each join field in the embedded object.	
			while (joinIter.hasNext()) {
				JoinFieldXMLEntity join = (JoinFieldXMLEntity) joinIter.next();
				writeHandlerBuffer.addTransientKeyAndValue("num",""+c+"");
				writeHandlerBuffer.addTransientKeysAndValues(join.getTransientKeys());
				writeHandlerBuffer.append(HWKEY_SETPARAMS,
					CodeGenUtil.generateFromTemplate(
				 		CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
				  			setParamsTemplate,writeHandlerBuffer.getTransientKeys()));
				writeHandlerBuffer.append(HWKEY_POPSETTERS,
					CodeGenUtil.generateFromTemplate(
				 		CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
				  			popSetterTemplate,writeHandlerBuffer.getTransientKeys()));
				if (writeHandlerBuffer.getTransientKeys().containsKey("wrapperType")) {
					writeHandlerBuffer.append(HWKEY_ARGSETTERS,
						CodeGenUtil.generateFromTemplate(
					 		CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
				  			argSetterTemplatePrimitive,writeHandlerBuffer.getTransientKeys()));

				}
				else {
					writeHandlerBuffer.append(HWKEY_ARGSETTERS,
						CodeGenUtil.generateFromTemplate(
				 			CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
				  			argSetterTemplateObject,writeHandlerBuffer.getTransientKeys()));

				}
				writeHandlerBuffer.getTransientKeys().remove("wrapperType");
				c++;
			}
			domainBuffer.append(DOMKEY_HANDLERIMPL,writeHandlerBuffer.buildSource());
	}

	/** Recursive handle join declarations.
	*/
	private void processJoinTable(String classNameObj,String prevJoinTable,JoinTableXMLEntity je,int count, int recurseLevel) 
				throws CodeGenException {
		// Create the join table
		Iterator tableIter = je.getJoinTable().iterator();
		String curJoinTable = "joinTable"+(count)+"_"+recurseLevel;
		domainBuffer.append(DOMKEY_JOINS,je.getJoinTableDeclare(curJoinTable));
		if (prevJoinTable != null)
			domainBuffer.append(DOMKEY_JOINS,"	  "+prevJoinTable+".addJoinTable("+curJoinTable+");\n");
		int i = 0;
		while (tableIter.hasNext()) {
			JoinTableXMLEntity en = (JoinTableXMLEntity) tableIter.next();
			processJoinTable(classNameObj,curJoinTable,en,i+count,recurseLevel+1);
			i++;
		}
		Iterator columnIter = je.getJoinColumn().iterator();
		while (columnIter.hasNext()) {
			JoinColumnXMLEntity jc = (JoinColumnXMLEntity) columnIter.next();
			poBuffer.append(POKEY_TOSTRING,jc.getToString("result"));
			poBuffer.append(POKEY_EMBEDDED_DECLARATIONS,jc.getObjectDeclaration());
			jc.appendGetterSetter(poBuffer.getAppendableBuffer(POKEY_EMBEDDED_ACCESSORS));
			domainBuffer.append(DOMKEY_JOINS,"	"+curJoinTable+".addJoinColumn("
				+jc.getJoinColumnDeclare()+");\n");
			domainBuffer.append(DOMKEY_JOINGETTERSETTER,
					jc.getGetterSetterImpl(classNameObj));	
		}
		if (recurseLevel == 0)
			domainBuffer.append(DOMKEY_JOINS,"	  addJoinTable("+curJoinTable+");\n");
	}

	/** Initializes any sub-classe data.  This version does nothing.
	*/
	protected void init() {
	}

	/** Allows a sub-class to add additional code for embedded object <code>PersistentObject</code>.
	 * @param current current <code>CompositeObjectXMLEntity</code>.
	* @return any additional code to place at the end of generated <code>PersisentObject</code>.
	*/
	protected String getAdditionalPersistentObjectCode(CompositeObjectXMLEntity current) {
		return "";
	}

	/** Allows a sub-class to add additional code for embedded object <code>AbstractDomain</code>.
	 * @param current current <code>CompositeObjectXMLEntity</code>.
	* @return any additional code to place at the end of generated <code>AbstractDomain</code>.
	*/
	protected String getAdditionalDomainCode(CompositeObjectXMLEntity current) {
		return "";
	}

	/** Allows a sub-class to process a <code>CompositeObjectXMLEntity</code>.  
	 *  Base class method does nothing.
	 * @param current current <code>CompositeObjectXMLEntity</code>.
	 * @throws CodeGenException if the method generates additional code and encounters an error generating the code.
	 * @throws IOException if the method generates additional code and encounters an error creating a file.
	 */
	protected void processCompositeEntity(CompositeObjectXMLEntity current) throws CodeGenException, IOException {
	}


	/** Validate args and set defaults.
	*/
	private void checkParameters(String prop) {
		if (sourceOutputDbObj == null) 
			throw new IllegalArgumentException(prop+" needs to specify SourceOutputDbObj.");
		if (sourceOutputDomain == null) 
			throw new IllegalArgumentException(prop+" needs to specify SourceOutputDomain.");
		if (baseImportDbObj == null) 
			throw new IllegalArgumentException(prop+" needs to specify BaseImportDbObj.");
		if (baseImportDomain == null) 
			throw new IllegalArgumentException(prop+" needs to specify BaseImportDomain.");
		if (packageNameDomain == null) 
			throw new IllegalArgumentException(prop+" needs to specify PackageNameDomain.");
		if (packageNameDbObj == null) 
			throw new IllegalArgumentException(prop+" needs to specify PackageNameDbObj.");
		if (compositeMasterMetaDataClassName == null)
			compositeMasterMetaDataClassName = "org.vmguys.appgen.jrf.CompositeObjectXMLEntity";
		if (embeddedObjectMetaDataClassName == null)
			embeddedObjectMetaDataClassName = "org.vmguys.appgen.jrf.EmbeddedInfoXMLEntity";
		if (joinFieldMetaDataClassName == null)
			joinFieldMetaDataClassName = "org.vmguys.appgen.jrf.JoinFieldXMLEntity";
	}

	/** Sets the sub-class instance of <code>CompositeMasterMetaData</code> to use.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param compositeMasterMetaDataClassName subclass name instance of <code>CompositeMasterMetaData</code>.
	 */
	public void setCompositeMasterMetaDataClassName(String compositeMasterMetaDataClassName) {
		this.compositeMasterMetaDataClassName = compositeMasterMetaDataClassName;
	}

	/** Sets the sub-class instance of <code>EmbeddedObjectMetaData</code> to use.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param embeddedObjectMetaDataClassName subclass name instance of <code>EmbeddedObjectMetaData</code>.
	 */
	public void setEmbeddedObjectMetaDataClassName(String embeddedObjectMetaDataClassName) {
		this.embeddedObjectMetaDataClassName = embeddedObjectMetaDataClassName;
	}

	/** Sets the sub-class instance of <code>JoinFieldMetaData</code> to use.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param joinFieldMetaDataClassName subclass name instance of <code>JoinFieldMetaData</code>.
	 */
	public void setJoinFieldMetaDataClassName(String joinFieldMetaDataClassName) {
		this.joinFieldMetaDataClassName = joinFieldMetaDataClassName;
	}

	/** Sets the output directory for the <code>PersistentObject</code>.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param sourceOutputDbObj Output directory name for generated <code>PersistentObject</code>.
	 */
	public void setSourceOutputDbObj(String sourceOutputDbObj) {
		this.sourceOutputDbObj = sourceOutputDbObj;
	}

	/** Sets the output directory for the <code>AbstractDomain</code>.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param sourceOutputDomain Output directory name for generated <code>AbstractDomain</code>.
	 */
	public void setSourceOutputDomain(String sourceOutputDomain) {
		this.sourceOutputDomain = sourceOutputDomain;
	}

	/** Sets the import package for the base, direct table-to-bean
	 * <code>PersistentObject</code>.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param baseImportDbObj Import package for the base <code>PersistentObject</code>.
	 */
	public void setBaseImportDbObj(String baseImportDbObj) {
		this.baseImportDbObj = baseImportDbObj;
	}

	/** Sets the import package for the base, direct table-to-bean
	 * <code>AbstractDomain</code>.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param baseImportDomain Import package for the base <code>AbstractDomain</code>.
	 */
	public void setBaseImportDomain(String baseImportDomain) {
		this.baseImportDomain = baseImportDomain;
	}

	/** Sets the package name for the <code>AbstractDomain</code>.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param packageNameDomain package name for the generated <code>AbstractDomain</code>.
	 */
	public void setPackageNameDomain(String packageNameDomain) {
		this.packageNameDomain = packageNameDomain;
	}
	
	/** Sets the package name for the <code>PersistentObject</code>.
	 * <em>This method is normally evoked programatically through reflection rather
	 * then evoked by program code.</em>
	 * @param packageNameDbObj package name for the generated <code>PersistentObject</code>.
	 */
	public void setPackageNameDbObj(String packageNameDbObj) {
		this.packageNameDbObj = packageNameDbObj;
	}
}
