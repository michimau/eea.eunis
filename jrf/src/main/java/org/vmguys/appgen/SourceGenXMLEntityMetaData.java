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
package org.vmguys.appgen;
import org.vmguys.xml.XMLReadHandler;
import org.vmguys.reflect.ReflectionHelper;
import java.util.List;
import java.lang.NoSuchMethodException;
import java.lang.IllegalAccessException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Iterator;
import org.w3c.dom.*;
import org.xml.sax.SAXException;
import java.lang.reflect.InvocationTargetException; 
import java.beans.IntrospectionException;
import java.text.ParseException;
import org.apache.log4j.Category;

/** A bean class that captures source generated metadata
* and potential children.
* @see org.vmguys.appgen.SourceGenXMLEntity
*/
public class SourceGenXMLEntityMetaData {
	private String entityBeanClassName;
	private String xmlElementTagName = null;
	private String parentAccessorName = null; // Null at parent; only children have them.
	static Category LOG = Category.getInstance(SourceGenXMLEntityMetaData.class.getName());

	private ArrayList childEntities = new ArrayList();
	/** Constructs entity. <code>setEntityBeanClassName</code>
	 * must be called.
	 */
	public SourceGenXMLEntityMetaData() {
	}

	/** Constructs entity with bean class name. -- parent constructor.
	 * @param xmlElementTagName XML element tag name
	 * @param entityBeanClassName
	 */
	public SourceGenXMLEntityMetaData(String entityBeanClassName,String xmlElementTagName) {
		this.entityBeanClassName = entityBeanClassName;
		this.xmlElementTagName = xmlElementTagName;
	}

	/** Sets the entity bean class name.
	 * @param entityBeanClassName
	 */
	public void setEntityBeanClassName(String entityBeanClassName) {
		this.entityBeanClassName = entityBeanClassName;
	}
	
	/** Sets the XML entity tag.
	 * @param xmlElementTagName XML element tag name
	 */
	public void setXmlElementTag(String xmlElementTagName) {
		this.xmlElementTagName = xmlElementTagName;
	}

	/** Sets the accessor name.
	 * @param accessorName bean accessor name.
	 */
	public void setParentAccessorName(String parentAccessorName) {
		this.parentAccessorName = parentAccessorName;
	}

	/** Adds a nested child entity.
	 * @param entity nested child entity.
	 */
	public void addChild(SourceGenXMLEntityMetaData entity) {
		childEntities.add(entity);
	}

	/** Returns entity bean class name
	 * @return entity bean class name.
	 */
	public String getEntityBeanClassName() {
		return this.entityBeanClassName;
	}

	/** Returns a list of children, each of which is of type
	 * <code>SourceGenXMLEntity</code>.
	 * @return list of <code>SourceGenXMLEntity</code> instances for each child.
	 */
	public List getChildren() {
		return this.childEntities;
	}

	private void setListEntity(SourceGenXMLEntity parentEntity, 
							SourceGenXMLEntityMetaData childInfo, List item) 
			throws NoSuchMethodException, InvocationTargetException, IllegalAccessException{
		if (childInfo.parentAccessorName == null) {
			childInfo.parentAccessorName = "set"+childInfo.xmlElementTagName;
		}
		//System.out.println("Looking for "+parentEntity.getClass().getName()+"::"+childInfo.parentAccessorName+"(List)");
		Method parentAccessorMethod = 
			parentEntity.getClass().getMethod(childInfo.parentAccessorName,new Class[] {java.util.List.class});
		//System.out.println("Invoking "+parentEntity.getClass().getName()+"::"+childInfo.parentAccessorName+"()");
		parentAccessorMethod.invoke(parentEntity, new Object[] {item});
	}

	/** Traverses entire tree starting at a given parent and returns a <code>List</code> 
	 * of <code>SourceGenXMLEntity</code> slbling records who may in turn have
	 * <code>SourceGenXMLEntity</code> child lists. 
	 * @param parentElement parent <code>Element</code>.
	 * @param entity SourceGenXMLEntity for the parent.
	 * @return a <code>List</code> of sibling </code>Element</code>s under the tag
	 * <code>SourceEntityMetaData.xmlElementTagName</code>.
	 */
	public static List createEntityTreeFromXML(Element baseElement,SourceGenXMLEntityMetaData entity) 
			throws IntrospectionException, ParseException,
				InvocationTargetException, NoSuchMethodException, IllegalAccessException, SAXException {
		ArrayList result = new ArrayList();
		for (Node child = baseElement.getFirstChild(); 
				child != null; child = child.getNextSibling()) {
			if (child instanceof Element) {
				Element object = (Element) child;
				if ( object.getTagName().equals(entity.xmlElementTagName) ) {
					SourceGenXMLEntity  sg = (SourceGenXMLEntity)
						ReflectionHelper.createObject(entity.getEntityBeanClassName());
					// Is this just attribute entity?
					if (object.hasAttributes()) {
						XMLReadHandler.elementToObject(object,sg);
						// Build keys to map.
						NamedNodeMap attMap = object.getAttributes();
						int size = attMap.getLength();
						for (int i = 0; i < size; i++) {
							Node n = attMap.item(i);
							sg.getTransientKeys().put(n.getNodeName(),n.getNodeValue());
						}
						sg.resolveImpliedKeys();	// Allow entity to handle #IMPLIED values and so forth.
					}
					else { // No attributes at all; just get content.
						Node fc = object.getFirstChild();
						if (fc != null && fc.getNodeType() == Node.TEXT_NODE) {
							Text t = (Text) fc;
							LOG.debug(object.getTagName()+" is a pure text node of "+
									t.getLength()+" char(s). Data is ["+t.getData()+"]");
							sg.setContents(t.getData());
						}
					}
					Iterator entityChildren = entity.getChildren().iterator();
					while (entityChildren.hasNext()) {
						SourceGenXMLEntityMetaData childMetaData = 
						   (SourceGenXMLEntityMetaData) entityChildren.next();
							List childList = createEntityTreeFromXML(object,childMetaData);
						entity.setListEntity(sg,childMetaData,childList);
					}
					result.add(sg);
				}
			}
		}
		return result;
	}

}
