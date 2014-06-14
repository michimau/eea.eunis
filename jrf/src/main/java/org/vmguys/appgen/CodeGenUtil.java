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
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
package org.vmguys.appgen;
import java.util.*;
import java.io.*;
import java.lang.reflect.*;

/** A utility class with static methods to help
* with code generation.
*/
public class CodeGenUtil {

	/** Source file type of Java.
	*/
	public static final int SOURCETYPE_JAVA = 0;

	/** Source file type of XML. 
	*/
	public static final int SOURCETYPE_XML = 1;

	/** Source file type of UNIXSCRIPT. 
	*/
	public static final int SOURCETYPE_UNIXSCRIPT = 2;

	/** Source file type of SQL 
	*/
	public static final int SOURCETYPE_SQL = 3;

	/** Source file type of Windows Batch 
	*/
	public static final int SOURCETYPE_BAT = 4;

	/** Source file type of C
	*/
	public static final int SOURCETYPE_C = 5;

	/** Source file type of properties.
	*/
	public static final int SOURCETYPE_PROPERTIES = 6;

	/** A javadoc version tag including $Revision and $Date
	*/
	public static final String JAVADOC_VERSION_TAG = "* @version $Revision: 1.3 $ $Date: 2002/10/23 19:52:04 $";

	/** Default tag for begin token ("$"), when using template parsing.
	* @see #generateFromTemplate(String,char,String,HashMap)
	*/
	public static final String TEMPLATE_TAG_BEGIN = "$";

	/** Default tag for end token ("$", when using template parsing.
	* @see #generateFromTemplate(String,char,String,HashMap)
	*/
	public static final char TEMPLATE_TAG_END = '$';

	private static String getExtension(int sourceType) {
		switch (sourceType) {
			case SOURCETYPE_JAVA:
				return ".java";
			case SOURCETYPE_UNIXSCRIPT:
				return ".sh";
			case SOURCETYPE_XML:
				return ".xml";
			case SOURCETYPE_SQL:
				return ".sql";
			case SOURCETYPE_C:
				return ".c";
			case SOURCETYPE_BAT:
				return ".bat";
			case SOURCETYPE_PROPERTIES:
				return ".properties";
			default:
				return "";
		}
	}

	/** Useful template for getter **/
	private static final String getterTemplate = 
		"	/** Gets $vdesc$\n"+
		"	* @return $vdesc$\n"+
		"	* $see$\n"+
		"	*/\n"+
		"	public $cname$ $prefix$$postFix$() {\n"+
		"		return $vname$;\n"+
		"	}\n"+
		"\n";

	/** Useful template for setter **/
	private static final String setterTemplate = 
		"	/** Sets $vdesc$\n"+
		"	* @param $vname$\n"+
		"	* $see$\n"+
		"	*/\n"+
		"	public void set$postFix$($cname$ $vname$) {\n"+
		"$additional$\n"+
		"		this.$vname$ = $vname$;\n"+
		"	}\n"+
		"\n";

	private static Hashtable primitives = null;
	private static Hashtable primitiveWrappers = null;
	private static Hashtable userClasses = null;
	private static final String packageToken = "package";
	static {

		primitives = new Hashtable();
		primitives.put("int",new ClassHandle(int.class,new int[0]) ) ;
		primitives.put("byte",new ClassHandle(byte.class,new byte[0] ) );
		primitives.put("char",new ClassHandle(char.class,new char[0] ) );
		primitives.put("float",new ClassHandle(float.class,new float[0]) );
		primitives.put("double",new ClassHandle(double.class,new double[0]) );
		primitives.put("short",new ClassHandle(short.class,new short[0]) );
		primitives.put("long",new ClassHandle(long.class,new long[0]) );
		primitives.put("boolean",new ClassHandle(boolean.class,new boolean[0]) );
		primitives.put("void",new ClassHandle(void.class,null) ) ;

		primitiveWrappers = new Hashtable();
		primitiveWrappers.put("java.lang.Integer",new PrimitiveClassHandle(int.class,java.lang.Integer.class,new Integer[0]) ) ;
		primitiveWrappers.put("java.lang.Byte",new PrimitiveClassHandle(byte.class,java.lang.Byte.class,new Byte[0] ) );
		primitiveWrappers.put("java.lang.Character",new PrimitiveClassHandle(char.class,
														java.lang.Character.class,new Character[0] ) );
		primitiveWrappers.put("java.lang.Long",new PrimitiveClassHandle(long.class,java.lang.Long.class,new Long[0]) );
		primitiveWrappers.put("java.lang.Double",new PrimitiveClassHandle(double.class,java.lang.Double.class,new Double[0]) );
		primitiveWrappers.put("java.lang.Float",new PrimitiveClassHandle(float.class,java.lang.Float.class,new Float[0]) );
		primitiveWrappers.put("java.lang.Short",new PrimitiveClassHandle(short.class,java.lang.Short.class,new Long[0]) );
		primitiveWrappers.put("java.lang.Boolean",new PrimitiveClassHandle(boolean.class,java.lang.Boolean.class,new Boolean[0]) );
		primitiveWrappers.put("java.lang.Void",new PrimitiveClassHandle(void.class,java.lang.Void.class,null) ) ;

		userClasses = new Hashtable();

	}

	/** Reads a file into a <code>StringBuffer</code>.
	 * @param fileName
	 * @param StringBuffer buffer to place file
	 * @throws IOException if IO error occurs.
	 * @throws FileNotFoundException if file is not found.
	 */
	public static void readFile(String fileName,StringBuffer buffer) 
			throws IOException, FileNotFoundException {
		// Read in the source file to a StringBuffer.
		FileReader fr = new FileReader(fileName);
		buffer.setLength(0);
		int c;
		while ((c = fr.read()) != -1) {
			buffer.append((char) c);
		}	
		fr.close();
	}

	/** Skips comments in a java source file stored in a string buffer
	 *  and returns the new offset pointing to the first non-comment characeter. 
	 * @param buffer <code>StringBuffer</code> that contains the source.
	 * @param offset starting offset. If <code>buffer.charAt(offset)</code> is not '/',
	 *			  method will do nothing and simple return offset parameter.
	 * @param skipForward if <code>true</code>, skip forward; <code>false</code> skip back. 
	 * @return offset pointing to the first character past the java comment.
	 * @throws IllegalArgumentException if offset is out of bounds or multi-line
	 *			comment end is not found.
	 */
	public static int skipJavaComment(StringBuffer buf, int offset, boolean skipForward) {
		if (offset < 0 || offset >= buf.length())
			throw new IllegalArgumentException("Offset argument is invalid.");
		int end;
		int inc;
		if (skipForward) {
			inc = 1;
			end = buf.length();
		}
		else {
			inc = -1;
			end = 0;
		}
		if (buf.charAt(offset) != '/')
			return offset;
		int newOffset = offset + inc;
		if (newOffset == end)		// Last or first char in buffer.
			return offset;
		if (skipForward && buf.charAt(newOffset) == '/') { // Single line comment.	Forward only.
			newOffset++;
			while (newOffset < buf.length() && buf.charAt(newOffset) != '\n') 
				newOffset++;
			if (buf.charAt(newOffset) == '\n')
				newOffset++;
		}
		else if (buf.charAt(newOffset) == '*') { // Multi-line comment. Handle backward or forward.
			newOffset+=inc;
			boolean foundEnd = false;
			while (newOffset != end) {
				if (buf.charAt(newOffset) == '*') {
					newOffset+=inc;
					if (newOffset == end)
						break;
					if (buf.charAt(newOffset) == '/') {
						foundEnd = true;
						newOffset+=inc;
						break;
					}
				}
				else
					newOffset+=inc;
			} 
			if (!foundEnd) {
				int showStart,showEnd;
				if (skipForward) {
					showStart = offset;
					showEnd = offset + 35;
					if (showEnd >= end) 
						showEnd = end - 1;
				}
				else  {
					showStart = offset - 35;
					showEnd = offset;
					if (showStart < 0) 
						showStart = 0;	
				}
				throw new IllegalArgumentException("End of multi-line comment starting at offset "+
						offset+" not found. String starting at this location is "+buf.substring(showStart,showEnd));
			}
		}
		else { // Not a comment. Point to starting offset.
			newOffset = offset;
		}		
		return newOffset;
	}
	
	/** Replaces existing file with contents of buffer.
	 * @param fileName name of file.
	 * @param buffer replacement contents.
	 * @throws IOException if file IO error occurs.
	 */
	public static void replaceFileContents(String fileName, StringBuffer buffer) throws IOException {
		// Delete old file.
		File oldFile = new File(fileName);
		if (!oldFile.delete()) {
			throw new IOException("Unable to delete "+fileName);
		}
		File newFile = new File(fileName);
		newFile.createNewFile();
		FileWriter w = new FileWriter(newFile);
		// Write out new file.	
		for (int i = 0; i < buffer.length(); i++) {	
			w.write(buffer.charAt(i));
		}
		w.close();
	}


	/** Returns the offset of the first non-commented out, non-white space character 
	 * in a Java source file provided in the buffer.
	 * @param buf buffer that should contain a Java source file.
	 * @param start starting buffer to start looking.
	 * @return index of the first non-commented character.
	 * @throws IllegalArgumentException if no non-commented out characters existing in <code>buf</code>.
	 */
	public static int findFirstNonCommentedOutCharacter(StringBuffer buf,int start) {
		int offset = start;
		boolean inQuotes = false;
		while (offset < buf.length()) {
			do {
				offset = skipJavaComment(buf,offset,true);

			} while (offset < buf.length() && buf.charAt(offset) == '/');	// Handle a succession of comments.
			if (offset == buf.length())
				break;
 			if (java.lang.Character.isWhitespace(buf.charAt(offset)) ) {
				offset++;
				continue;				
			}
			return offset;
		}	
		if (offset == buf.length())
			return offset;
		throw new IllegalArgumentException("No non-commented out character exists.");
	}

	/** Returns the offset in supplied buffer that is a Java source file where 
	 * import statements can successfully be placed without generating a compile error.
	 * @param buf buffer that should contain a Java source file.
	 * @return index where import declarations can be placed.
	 */
	public static int findImportInsertPoint(StringBuffer buf) {
		int first = findFirstNonCommentedOutCharacter(buf,0);
		// Starts with package?
		for (int i = 0; i < packageToken.length(); i++,first++) {
			if (packageToken.charAt(i) != buf.charAt(first))
				return first;
		}		
		// Got package
		first++;
		while (first < buf.length() && buf.charAt(first) != ';')
			first++;
		return findFirstNonCommentedOutCharacter(buf,first+1);	// Skip semi-colon.
	}

	private static boolean adjustInQuotes(boolean inQuotes, char c) {
		if (c == '"') {
			return inQuotes ? false:true;	
		}
		return inQuotes;
	}

	/** Returns an array of bytes denoting which offsets in supplied 
	 * buffer that contains a Java (or C) file are commented out.
	 * @param buffer a <code>StringBuffer</code> that contatins a Java or C source file.
	 * @return a <code>byte</code> buffer with all offsets equal to "1" denoting a commented out offset.
	 */
	public static byte [] getCommentedOutOffsets(StringBuffer buf) {
		byte [] commentedOutOffsets = new byte[buf.length()];
		java.util.Arrays.fill(commentedOutOffsets,(byte) 0);
		int endOffset = 0;
		int beginOffset = 0;
		boolean inQuotes = false;
		while (beginOffset < buf.length()) {
			if (!inQuotes && buf.charAt(beginOffset) == '/') {
				endOffset = CodeGenUtil.skipJavaComment(buf,beginOffset,true);
				if (endOffset == buf.length())
					break;
				if (beginOffset != endOffset) {
					java.util.Arrays.fill(commentedOutOffsets,beginOffset,endOffset-1,(byte) 1);
					beginOffset = endOffset;
				}
				else {
					beginOffset++;
				}
			}
			else {
				inQuotes = adjustInQuotes(inQuotes,buf.charAt(beginOffset));
				beginOffset++;
			}
		}
		return commentedOutOffsets;
	}

	/** Returns the array or raw class instance for the supplied raw type.
	 * @param primType primitive type such as 'int','float', etc.
	 * @param getArray if <code>true</code>, return array instance of this class.
	 * @return the desired class instance or <code>null</code> if not found.
	 */
	public static Class getPrimitiveClass(String primType,boolean getArray) {
		return ClassHandle.findClass(primitives,primType,getArray);
	}

	/** Returns primitive class handle based on wrapper class namee.
	* @param className name of wrapper class.
	*/
	public static PrimitiveClassHandle getPrimitiveClassHandle(String className) {
		return (PrimitiveClassHandle) primitiveWrappers.get(className);
	}
	

	/** Returns the array or raw class instance for the supplied primitive wrapper type.
	 * @param primType primitive wrapper type such as 'Integer','Float', etc.
	 * @param getArray if <code>true</code>, return array instance of this class.
	 * @return the desired class instance or <code>null</code> if not found.
	 */
	public static Class getPrimitiveWrapperClass(String primType,boolean getArray) {
		return ClassHandle.findClass(primitiveWrappers,primType,getArray);
	}

	/** Appends to the supplied buffer a get method.  Method will examine class name. If
	* "boolean" or "java.lang.Boolean" is the class name, "is" instead of "get" will be
	* implemented.  Name of method will be constructed by capitilized the variable name.
	* For example, if <code>vname</code> is dataType, get method will be <code>getDataType()</code>.
	* @param desc variable description.
	* @param vname variable name.
	* @param c class of the variable. 
	* @param buf <code>StringBuffer</code> to append to.
	*/
	public static void appendGetter(String desc, String vname, Class c, String see, StringBuffer buf) throws CodeGenException {
		appendGetter(desc,vname,handleClassDeclaration(c),see,buf);
	}

	/** Appends to the supplied buffer a get method.  Method will examine class name. If
	* "boolean" or "java.lang.Boolean" is the class name, "is" instead of "get" will be
	* implemented.  Name of method will be constructed by capitilized the variable name.
	* For example, if <code>vname</code> is dataType, get method will be <code>getDataType()</code>.
	* @param desc variable description.
	* @param vname variable name.
	* @param cname class name. 
	* @param see optionanal "@see" info with or without the "@see"
	* @param buf <code>StringBuffer</code> to append to.
	*/
	public static void appendGetter(String desc, String vname, String cname, String see, StringBuffer buf) 
				throws CodeGenException {
			appendGetter(desc,null,vname,cname,see,buf);
	}

	/** Appends to the supplied buffer a get method.  Method will examine class name. If
	* "boolean" or "java.lang.Boolean" is the class name, "is" instead of "get" will be
	* implemented.  Name of method will be constructed by capitilized the variable name.
	* For example, if <code>vname</code> is dataType, get method will be <code>getDataType()</code>.
	* @param desc variable description.
	* @param postfix get postfix (e.g. getStuff() -- postfix = Stuff)
	* @param vname variable name.
	* @param cname class name. 
	* @param see optionanal "@see" info with or without the "@see"
	* @param buf <code>StringBuffer</code> to append to.
	*/
	public static void appendGetter(String desc,String postfix,String vname, String cname, String see, StringBuffer buf) throws CodeGenException {
		HashMap h = new HashMap();
		initGetterOrSetter(h,desc,postfix,vname,cname,see,null);
		int idx = -1;
		if ((idx = cname.indexOf("boolean")) != -1 || (idx = cname.indexOf("Boolean")) != -1) {
			h.put("prefix","is");
		}
		else
			h.put("prefix","get");
		buf.append( generateFromTemplate(TEMPLATE_TAG_BEGIN, TEMPLATE_TAG_END, getterTemplate, h) );
	}

	/** Appends to the supplied buffer a set method.  Method will examine class name. 
	* Name of method will be constructed by capitilized the variable name.
	* For example, if <code>vname</code> is dataType, set method will be <code>setDataType()</code>.
	* @param desc variable description.
	* @param vname variable name.
	* @param cname class of the variable. 
	* @param see optionanal "@see" info with or without the "@see"
	* @param additional any additional code to be placed <em>before</em> the variable setting.
	* @param buf <code>StringBuffer</code> to append to.
	*/
	public static void appendSetter(String desc, String vname, Class c, String see, String additional,
					StringBuffer buf) throws CodeGenException {
		appendSetter(desc,vname,handleClassDeclaration(c),see,additional,buf);
	}

	/** Appends to the supplied buffer a set method.  Method will examine class name. 
	* Name of method will be constructed by capitilized the variable name.
	* For example, if <code>vname</code> is dataType, set method will be <code>setDataType()</code>.
	* @param desc variable description.
	* @param vname variable name.
	* @param cname class of the variable. 
	* @param additional any additional code to be placed <em>before</em> the variable setting.
	* @param buf <code>StringBuffer</code> to append to.
	*/
	public static void appendSetter(String desc, String vname, String cname, String see, String additional,
						StringBuffer buf) throws CodeGenException {
			appendSetter(desc,null,vname,cname,see,additional,buf);
	}

	/** Appends to the supplied buffer a set method.  Method will examine class name. 
	* Name of method will be constructed by capitilized the variable name.
	* For example, if <code>vname</code> is dataType, set method will be <code>setDataType()</code>.
	* @param desc variable description.
	* @param postfix set postfix (e.g. setStuff() -- postfix = Stuff)
	* @param vname variable name.
	* @param cname class of the variable. 
	* @param additional any additional code to be placed <em>before</em> the variable setting.
	* @param buf <code>StringBuffer</code> to append to.
	*/
	public static void appendSetter(String desc, String postFix, String vname, String cname, String see, String additional,
						StringBuffer buf) throws CodeGenException {
		HashMap h = new HashMap();
		initGetterOrSetter(h,desc,postFix,vname,cname,see,additional);
		buf.append( generateFromTemplate(TEMPLATE_TAG_BEGIN, TEMPLATE_TAG_END, setterTemplate, h) );
	}


	private static void initGetterOrSetter(HashMap h, String desc, String postFix, String vname, String cname,String see,String additional) {

		if (see == null) 
			h.put("see","");
		else if (see.startsWith("@see"))
			h.put("see",see);
		else
			h.put("see","@see "+see);
		if (additional == null)
			h.put("additional","");
		else
			h.put("additional",additional);
		h.put("vdesc",desc);
		if (postFix == null)
			h.put("postFix", java.lang.Character.toUpperCase(vname.charAt(0))+vname.substring(1) );
		else
			h.put("postFix",postFix);
		h.put("vname",vname);
		h.put("cname",cname);
	}

	private static String handleClassDeclaration(Class c) {
		if (c.isPrimitive()) {
			String cname = c.getName();
			int idx = cname.indexOf(".class");
			if (idx == -1) {
				return cname;
			}
			return  cname.substring(0,idx);
		}
		return getClassDeclarationValue(c);

	}

	/** Generate a code generated file header.
	*  @param outstream print stream
	*  @param name name of generated code
	*  @param copyright copyright notice
	*  @param isJava if <code>true</code>, Java header will be generated, otherwise XML is assumed.
	*  @throws IOException is something goes awry in writing to stream.
	*  @see #SOURCETYPE_JAVA
	*  @see #SOURCETYPE_XML
	*  @see #SOURCETYPE_UNIXSCRIPT
	*  @see #SOURCETYPE_BAT
	*/
	public static void generateCodeGenHeader(PrintWriter outstream, String name, String copyright, int fileType) throws IOException {
		Date now = new Date();
		String lineBegin,lineEnd;
		switch (fileType) {
			case SOURCETYPE_JAVA:
				lineBegin = "//";
				lineEnd = "//";
				break;
			case SOURCETYPE_XML:
				lineBegin = "<!--";
				lineEnd = "-->";
				break;
			case SOURCETYPE_SQL:
			case SOURCETYPE_C:
				lineBegin = "/*";
				lineEnd = "*/";
				break;
			case SOURCETYPE_BAT:
				lineBegin = "REM ";
				lineEnd = "";
				break;
			case SOURCETYPE_PROPERTIES:
			default:
				lineBegin = "#";
				lineEnd = "#";
				break;
		}
		outstream.println(lineBegin+"======================================================"+lineEnd);
		outstream.println(lineBegin+copyright+lineEnd);
		outstream.println(lineBegin+"======================================================"+lineEnd);
		outstream.println(lineBegin+"THIS FILE WAS AUTOMATICALLY GENERATED. DO NOT EDIT!"+lineEnd);
		outstream.println(lineBegin+name+lineEnd);
		outstream.println(lineBegin+"Generated: "+now+" "+lineEnd);
		outstream.println(lineBegin+"======================================================"+lineEnd);
	}	


	/** Generates code from a given template by replacing uniquely designated tokens embedded in the template
	* with values from a hash table.  This versions uses the default tokens.
	* @param codeTemplate code template string.
	* @param keyMap hash table to look up keys to replace tokens.
	* @return generated code with template tags replaced with the appropriate values.
	* @throws CodeGenException when template is invalid or a token key is not found.  
	* @see #generateFromTemplate(String,char,String,HashMap)
	* @see #TEMPLATE_TAG_BEGIN
	* @see #TEMPLATE_TAG_END
	*/
	public static String generateFromTemplate(String codeTemplate, HashMap keyMap) 
		throws CodeGenException {
			return generateFromTemplate(TEMPLATE_TAG_BEGIN,TEMPLATE_TAG_END,codeTemplate,keyMap);
	}


	/** Generates code from a given template by replacing uniquely designated tokens embedded in the template
	* with values from a hash table.  For example, assume a template uses "|TOK" to designate the token
	* begin tag and "|" to designate the end token tag. A part of the template might be:
	* <p>
	* <pre>
	* 		public class |TOKClassName|DataSource extends AnotherClass {
	* </pre>
	* If  "ClassName" maps to "SpecialMap" in the hash table, code becomes:
	* <p>
	* <pre>
	*		public class SpecialMapDataSource extends AnotherClass {
	* </pre>
	* @param tagBegin tag string designating the beginning of a token. (e.g. "|TOK")
	* @param tagEnd tag character designating the end of a token. (e.g. "|").
	* @param codeTemplate code template string.
	* @param keyMap hash table to look up keys to replace tokens.
	* @return generated code with template tags replaced with the appropriate values.
	* @throws CodeGenException when template is invalid or a token key is not found.  
	*/
	public static String generateFromTemplate(String tagBegin, char tagEnd, String codeTemplate, HashMap keyMap) 
		throws CodeGenException {
			StringBuffer result = new StringBuffer();
			StringBuffer key = new StringBuffer();
			String token;
			int start = 0;
			int tagStart;
			int len = codeTemplate.length();
			while (start < len && ((tagStart = codeTemplate.indexOf(tagBegin,start))) != -1) {
				// Append code up to tag.
				result.append(codeTemplate.substring(start,tagStart));
				key.setLength(0);
				start = tagStart;		
				start += tagBegin.length();
				while (start < len && codeTemplate.charAt(start) != tagEnd) {
					key.append(codeTemplate.charAt(start++));
				}
				if (start == len) {
					throw new CodeGenException(
								"Invalid template token at offset "+tagStart+" has no end token.",
									codeTemplate,tagStart);	
				}			
				if ((token = (String) keyMap.get(key.toString())) == null) {
					throw new CodeGenException(
								"Key not found for key ["+key.toString()+"] in template at offset "+tagStart+".",
									codeTemplate,tagStart);	
					
				} 
				result.append(token);
				// start points to tagend. skip over it.
				start++;
			}
			if (start < len)
				result.append(codeTemplate.substring(start));
			return result.toString();
	}

	/** Turns a package name into a path name.
	* @param pkge package
	* @return a file path for the package.
	*/
	public static String packageNameToPathName(Package pkge) {
		return packageNameToPathName(pkge.getName());
	}

	/** Turns a package name into a path name.
	* @param packageName a fully qualified package name
	* @return a file path for the package.
	*/
	public static String packageNameToPathName(String packageName) {
		return packageName.replace('.',File.separatorChar);
	}


	/** Creates a java file based on a supplied package, base directory and
	* optional sub-directory.  For example, given with a base directory of 
	* "/home/joe/myproject/src", a package named "com.acompany.dbobjects", 
	* a sub-directory called "generated",and a file called "EmployeeFactory",
	* the resulting file would be: <p>
	* <pre>
	* /home/joe/myproject/src/com/acompany/dbobjects/generated/EmployeeFactory.java 
	</pre>
	* @param baseDirectory a base directory <code>File</code> instance.
	* @param pkg package instance.
	* @param subDirName optional subdirectory name (may be <code>null</code>).
	* @param className className for java file to create.
	* @return a <code>PrintWriter</code> instance for the created java file.	
	* @throws IOException if there is a problem creating the file.
	* @throws FileNotFoundException 
	*/
	public static PrintWriter createJavaFile(File baseDirectory, Package pkg, String subdirName, String className) throws
			IOException, FileNotFoundException {
		String dirName;
		if (subdirName != null) {
			dirName = packageNameToPathName(pkg)+File.separatorChar+subdirName;
		}
		else {
			dirName = packageNameToPathName(pkg);
		}
		File outputDirectoryFile = new File(baseDirectory,dirName);
		if (outputDirectoryFile.exists()) {
			if (!outputDirectoryFile.isDirectory()) {
				throw new IOException(outputDirectoryFile.getAbsolutePath()+
							"already exists and is not a directory.");

			}
		}
		else {
			if (!outputDirectoryFile.mkdirs()) {
				if (!outputDirectoryFile.canWrite()) {
					throw new IOException("Do not have permissions to write to or create directory "+
					outputDirectoryFile.getAbsolutePath());
				}
				throw new IOException(outputDirectoryFile.getAbsolutePath()+
							": unable to create.");
			}
		}
		return  createJavaFile(outputDirectoryFile,className);
	}

	/** Returns the correct code to use to correctly 
	* provide a cast value or method parameter declaration for generated code.  
	* This method correctly handles array types.
	* @param className class name normally returned from <code>Class.getName()</code>.
	* @return a value suitable for casting in generated code. Parentheses <i>not</i> provided.
	* @see #getActualClassName(String)
	*/
	public static String getClassDeclarationValue(String className) {
		if (className.startsWith("["))
			return getActualClassName(className)+" []";
		return className;	
	}


	/** Returns the correct code to use to correctly 
	* provide a cast value or method parameter declaration for generated code.  
	* This method correctly handles array types.
	* @param cls class instance.
	* @return a value suitable for casting in generated code. Parentheses <i>not</i> provided.
	* @see #getClassDeclarationValue(String)
	*/
	public static String getClassDeclarationValue(Class cls) {
		return getClassDeclarationValue(cls.getName());
	}

	/** Returns the actual underlying class name, correctly
	* handling array types.  For example, if "[LMyClass" is
	* passed to this method, "MyClass" will be returned.  If,
	* "[B" is passed, "byte" will be returned.
	* @param cls class instance.
	* @return class name, correctly handling class Name;
	*/
	public static String getActualClassName(Class cls) {
		return getActualClassName(cls.getName());
	}

	/** Returns the actual underlying class name, correctly
	* handling array types.  For example, if "[LMyClass" is
	* passed to this method, "MyClass" will be returned.  If,
	* "[B" is passed, "byte" will be returned.
	* @param className class name normally returned from <code>Class.getName()</code>.
	* @return class name, correctly handling class Name;
	*/
	public static String getActualClassName(String className) {

		if (!className.startsWith("[") || className.length() == 1)
			return className;
		if (className.startsWith("[L")) {
			int j = className.indexOf(';');
			return className.substring(2,j);
		}
		if (className.charAt(1) == 'B') {
			return "byte";
		}
		if (className.charAt(1) == 'C') {
			return "char";
		} 
		if (className.charAt(1) == 'D') {
			return "double";
		}	
		if (className.charAt(1) == 'F') {
			return "float";
		}
		if (className.charAt(1) == 'I') {
			return "int";
		}
		if (className.charAt(1) == 'J') {
			return "long";
		}
		if (className.charAt(1) == 'S') {
			return "short";
		}	
		if (className.charAt(1) == 'Z') {
			return "boolean";
		}	
		return className;
	}

	/** Creates a new java file given an output directory and a class name
	* @param outputDirectory source output directory File instance.
	* @param className name of class to generate.
	* @return a <code>PrintWriter</code> to use for writing source.
	*/
	static public PrintWriter createJavaFile(File outputDirectory, String className) throws FileNotFoundException {
		return createFile(outputDirectory,className,SOURCETYPE_JAVA);
	}

	/** Creates a new file given an output directory and a file name
	* @param outputDirectory source output directory.
	* @param name name of file.
	* @return a <code>PrintWriter</code> to use for writing source.
	*/
	static public PrintWriter createFile(File outputDirectory, String fileName) throws FileNotFoundException {
		return createFile(outputDirectory,fileName,9999);	// Set invalid type = "" (no extension).
	}

	/** Creates a new file given an output directory and a file name
	* @param outputDirectory source output directory.
	* @param name name of file.
	* @param sourceType one of the source type constants.
	* @return a <code>PrintWriter</code> to use for writing source.
	* @see #SOURCETYPE_JAVA
	* @see #SOURCETYPE_XML
	* @see #SOURCETYPE_UNIXSCRIPT
	* @see #SOURCETYPE_SQL
	* @see #SOURCETYPE_BAT
	* @see #SOURCETYPE_C
	*/
	static public PrintWriter createFile(File outputDirectory, String fileName,int sourceType) throws FileNotFoundException {
		return new PrintWriter(new FileOutputStream(outputDirectory.getAbsolutePath()+"/"+fileName+
				getExtension(sourceType)));
	}

	/** Creates a new file given an output directory and a file name
	* @param outputDirectory source output directory name.
	* @param name name of file.
	* @param sourceType one of the source type constants.
	* @return a <code>PrintWriter</code> to use for writing source.
	* @see #SOURCETYPE_JAVA
	* @see #SOURCETYPE_XML
	* @see #SOURCETYPE_UNIXSCRIPT
	* @see #SOURCETYPE_SQL
	* @see #SOURCETYPE_BAT
	* @see #SOURCETYPE_C
	*/
	static public PrintWriter createFile(String outputDirectory, String fileName,int sourceType) 
		throws FileNotFoundException {
		return createFile(new File(outputDirectory),fileName,sourceType);
	}

	/** Creates a new java file given an output directory and a class name
	* @param outputDirectory source output directory.
	* @param className name of class to generate.
	* @return a <code>PrintWriter</code> to use for writing source.
	*/
	static public PrintWriter createJavaFile(String outputDirectory, String className) throws FileNotFoundException {
		return createJavaFile(new File(outputDirectory),className);
	}
}
