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
package org.vmguys.appgen; 
import org.vmguys.xml.*;
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

/** Abstract base class for generating source code from
 * a properties file with setter values and an XML file of 
 * source.
*/
public abstract class Generator {

	static protected Category LOG = Category.getInstance(Generator.class.getName());

	/** Document root elements **/
	protected Element [] roots;

	/** Actual generator class set by sub-classes. */
	protected static String generatorClassName;


	private HashSet xmlFileList;
	
	/** Properties instance.
	 */
	protected Properties properties;

	/** Modules to generate
	*/
	protected HashSet modulesToGenerate = new HashSet();

	/** Parses a comma-separated list of tokens and returns a <code>HashSet</code> of
	 *  these tokens.
	 * @param tokenList comma-separated list of tokens.
	 * @return <code>HashSet</code> of the tokens in the list.
	 */
	public static HashSet parseTokenList(String tokenList) {
		HashSet h = new HashSet();
		if (tokenList != null) {
			StringTokenizer st = new StringTokenizer(tokenList,",");
			while (st.hasMoreTokens()) {
				h.add(st.nextToken());
			}
		}
		return h;
	}

	/** Sets list of modules to use.
	* @param tokenList list of modules for entity generation.
	*/
	public void setModulesToGenerate(String tokenList) {
		modulesToGenerate = parseTokenList(tokenList);
	}

	/** Sets list of xml files to use.  This is only useful if multiple
	* xml files are required.  If only one file is to be used, specify it
	* on the command line.
	* @param tokenList list of xmlFiles. 
	*/
	public void setXMLFiles(String tokenList) {
		xmlFileList = parseTokenList(tokenList);
	}

	/** Returns an array of <code>Element</code> roots from an list of XML files.
	* @param xmlFiles list of XML files.
	* @return array of <code>Element</code> roots.
	*/ 
	static public Element [] parseXML(List xmlFiles)
			throws IOException, SecurityException, IntrospectionException,
						SAXException, ParserConfigurationException {
		Element result [] = new Element[ xmlFiles.size() ];
		Iterator iter = xmlFiles.iterator();
		int i = 0;
		while ( iter.hasNext() ) {
			XMLReadHandler rx = new XMLReadHandler();
			Document doc = rx.getDocument( (String) iter.next() );
			result[i++] = doc.getDocumentElement();
		}
		return result;	
	}

	static public void validateXMLList(List xml) {
		if (xml.size() == 0)
			throw new IllegalArgumentException("No xml files have been specified. Either specify one "+
				"on the command line and/or place a comma-separated list of XML file paths "+
				"in the properties file under 'XMLFiles='");	
	}

	/** Protected default constructor for use in classes where XML parsing may already
	 * be done.
	 */
	protected Generator() {
	}

	/** Initializes XML document and reads the properites file, calling all set methods
	 * specified in the file.
	 * @param prop properties file path
	 * @param xml xml file paths
	 */
	protected Generator(String prop, List xml) 
		throws IOException, SecurityException, CodeGenException,FileNotFoundException, 
						SAXException, ParserConfigurationException, IntrospectionException,
						java.lang.reflect.InvocationTargetException,ParseException,
						java.lang.IllegalAccessException {
		// Open up properties instance.
		properties = loadProperties(prop);
		processProperties(properties,this);
		if (xmlFileList != null)
			xml.addAll(xmlFileList);
		validateXMLList(xml);
		displayXML(xml);
		roots = parseXML(xml);
		//System.out.println("Modules generated: "+modulesToGenerate);
	}

	static private Properties loadProperties(String prop) throws FileNotFoundException,IOException {
		Properties p = new Properties();
		p.load(new FileInputStream(prop));	
		System.out.println("Loading properties from "+prop);
		return p;
	}

	/** Processes properties and calls setter methods specified in <code>Properties</code> instance
	 * on the <code>Object</code>.
	 * @param prop <code>Properties</code> file name.
	 * @param obj <code>Object</code> to process.
	 */
	static public void processProperties(String prop,Object obj) throws IOException,FileNotFoundException,
				SecurityException,IntrospectionException,
					java.lang.reflect.InvocationTargetException,ParseException,
					java.lang.IllegalAccessException {
		processProperties(loadProperties(prop),obj);
	}
	
	/** Processes properties and calls setter methods specified in <code>Properties</code> instance
	 * on the <code>Object</code>.
	 * @param prop <code>Properties</code> instance.
	 * @param obj <code>Object</code> to process.
	 */
	static public void processProperties(Properties p,Object obj) throws 
				SecurityException,IntrospectionException,
					java.lang.reflect.InvocationTargetException,ParseException,
					java.lang.IllegalAccessException {
		BeanSearchUtil beanSearch = new BeanSearchUtil(obj.getClass());
		beanSearch.processProperties(p,obj,true);
	}

	static public void displayXML(List xml) {
		Iterator iter = xml.iterator();
		while (iter.hasNext()) {
			System.out.println("XML file: "+iter.next());
		}
	}

	/** Allows a sub-class to reset any state variables in preparation for a new generation of a file set.
	* This version does nothing.
	*/
	protected void reset() {
	}

	/** Returns <code>true</code> if entity should be generated based on information supplied
	 * by the entity and the modules that must be generated.  If no modules have been
	 * specified for generation, the entity will be generated always. If  no 
	 * modules have been specified for the entity, the entity will be generated always as well.
	 * @param modulesToGenerate list of modules to generate.
	 * @param entityModuleList list of modules for the entity.
	 * @return <code>true</code> if entity should be generated based on information supplied
	 * by the entity and the modules that must be generated.
	*/
	public static boolean generateEntity(HashSet modulesToGenerate, HashSet entityModuleList) {
		// No modules specified for code generation means generate everything.
		// No modules specified for the entity means generate the entity.
		if (modulesToGenerate.size() == 0 || entityModuleList.size() == 0)
			return true;
		Iterator iter = entityModuleList.iterator();	// Return true on first match.
		while (iter.hasNext()) {
			if (modulesToGenerate.contains(iter.next()))
				return true;
		}
		return false;
	}

	/** Returns <code>true</code> if either module name is <code>null</code>/blank or
	 *  module name is on <code>entityModuleList</code>.
	 * @param entityModuleList list of modules for the entity.
	 * @return <code>true</code> if entity should be generated.
	*/
	public boolean generateEntity(HashSet entityModuleList) {
		return generateEntity(modulesToGenerate,entityModuleList);
	}


	/** Runs the generator with the properties file and an optional xml file.
	 * @param args args[0] = properties file; args[1] = xml file (optional). Alternatively you can specify 
	 * only the properties file and specify the XML files to process in the properties file.
	 * @see #setXMLFiles(String)
	 */
	public static void main(String args[]) {
		LOG = Category.getInstance(generatorClassName);
		if (args.length < 1) {
			System.out.println("Usage: "+generatorClassName+" propertiesFile [xmlFile]");
			System.exit(1); 
		}
		try {
			List a = new ArrayList(); 
			System.out.println(generatorClassName);
			if (args.length > 1) 
				a.add(args[1]);
			ReflectionHelper.createObject(generatorClassName,new Object [] { args[0], a } );
			System.out.println("Execution successful");
		}
		catch (Exception ex) {
			System.err.println("Execution failed. See logs");
			LOG.fatal("Fatal exception occured.",ex);
			System.exit(-1);
		}
	}

}
