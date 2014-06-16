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
/*
///////////////////////////////////////////////////////////////////
**/

package org.vmguys.xml;
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
import org.vmguys.reflect.*;

/** XML Read handling class.
*/
public class XMLReadHandler implements ErrorHandler {

    DocumentBuilder parser;
    private static Category LOG = Category.getInstance(XMLReadHandler.class.getName());
    private Object xmlObject = null;

    /** Default constructor **/
    public XMLReadHandler()
        throws IOException, SAXException, ParserConfigurationException {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setValidating(true);
        parser = factory.newDocumentBuilder();
        parser.setErrorHandler(this);
        LOG.debug("XML handler created succuessfully.");
    }

    /** Parses file and returns <code>Document</code> instance.
    * @param xmlFile xml file to parse.
    */
    public Document getDocument(String xmlFile) throws SAXException,IOException  {
        this.xmlObject = xmlFile;
        return parser.parse(xmlFile);
    }

    /** Parses XML in stream and returns <code>Document</code> instance.
    * @param xmlStream xml stream to parse.
    */
    public Document getDocument(InputStream xmlStream) throws SAXException,IOException {
        this.xmlObject = xmlStream;
        return parser.parse(xmlStream);
    }

    /** Invoked automatically when a non-fatal XML parsing error is encountered.
     *  Logs a detailed message (including line and column number) on logger.
     *  @param ex A <code>SAXParseException</code> thrown during parsing.
     */
    public void error(SAXParseException ex) throws SAXException
    {
        LOG.error(formatError(ex),ex);
        throw ex;
    }

    /** Reads attribute and returns either the value or <code>null</code>
      * if the attribute was not found (e.g it was implied).
      * @param element <code>Element</code> object.
      * @param attribute attribute to find.
      * @return attribute value or <code>null</code> if not found.
      */
    public static String getAttribute(Element element,String attribute) {
        String result = element.getAttribute(attribute);
        return result.length() == 0 ? null:result;
    }

    /** Invoked automatically when a fatal XML parsing error is encounterd.
     *  Logs a detailed message (including line and column number) on logger.
     *  Rethrows the exception ex.
     *  @param ex A <code>SAXParseException</code> thrown during parsing.
     *  @throws SAXParseException rethrows the same fatal exception ex.
     */
    public void fatalError(SAXParseException ex) throws SAXException
    {
        LOG.fatal(formatError(ex),ex);
        throw ex;
    }

    /** Invoked automatically when a non-fatal XML parsing error is encounterd.
     *  Logs a detailed message (including line and column number) on logger.
     *  @param ex A <code>SAXParseException</code> thrown during parsing.
     */
    public void warning(SAXParseException ex)
    {
        LOG.warn(formatError(ex),ex);
    }

    // FIXME.  Need to report whether error is in DTD or XML.
    private String formatError(SAXParseException ex) {
        return "XML parsing error on line "+ex.getLineNumber()+" of "+xmlObject+". "+
                    "Column number is "+ex.getColumnNumber();
    }


    /** Runs the <code>Introspector</code> on the parameter object and attempts
     * to find all set methods in the class under the assumption that the class
     * field is the same as the XML attribute name.  Properties name will be
     * expected as starting with uppercase and XML attributes will be expected
     * as lower case, so conversion will be done:
     * <pre>
     *      void setType(String name) {
     *      .
     *      .
     *
     *          type CDATA #REQUIRED
     * </pre>
     * In the above case, 'Type' as returned from <code>PropertyDescriptor.getName()</code>
     * will be converted so that Element.getAttribute('type') will be tried.
     * If call fails, no error will result; object should include default settings.
     @param element <code>Element</code> to search for data.
     @param object <code>Object</code> with an attribute settings.
     */
    static public void elementToObject(Element element, Object obj)
                    throws SAXException, IntrospectionException,
                        java.lang.reflect.InvocationTargetException,
                        java.lang.IllegalAccessException,java.text.ParseException
          {

        BeanInfo beanInfo = Introspector.getBeanInfo(obj.getClass());
        PropertyDescriptor [] properties = beanInfo.getPropertyDescriptors();

        for (int i = 0; i < properties.length; i++) {
            Method writeMethod = properties[i].getWriteMethod();
            if (writeMethod != null) {
                String propName = properties[i].getName();
                String name = java.lang.Character.toLowerCase(propName.charAt(0))+
                            propName.substring(1);
                String value = element.getAttribute(name);
                if (value.length() > 0) {
                    LOG.debug("Calling "+obj.getClass().getName()+"::"+writeMethod.getName()+"(\""+value+"\")");
                    ReflectionHelper.invokeSetProperty(obj,writeMethod,value);
                }
                else {
                    LOG.debug("No element found for "+obj.getClass().getName()+"::set"+propName+"("+value+") in XML file");
                }
            }
        }
    }

}

