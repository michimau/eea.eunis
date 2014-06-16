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
import java.util.*;

/** Static methods for JRF generation.
*/
public class JRFGeneratorUtil  {


    private JRFGeneratorUtil() {
    }

    // fieldName, dbObjClassName, currentFieldDataType, primitiveType,getoris
    // primitiveWrapperType,primitiveTypeSet
    private static final String getterSetterTemplate =
        "   private class $generatedClassName$ implements GetterSetter,Serializable {\n"+
        "       public boolean setterIsFunctional() {\n"+
        "           return true;\n"+
        "       }\n"+
        "       \n"+
        "       public Object get(PersistentObject obj, Object deflt) {\n"+
        "           $dbObjClassName$ x = ($dbObjClassName$) obj;\n"+
        "           Object result = x.get$fieldName$();\n"+
        "           return result == null ? deflt:result;\n"+
        "       }\n"+
        "       \n"+
        "       public void set(PersistentObject obj, Object value) {\n"+
        "           $dbObjClassName$ x = ($dbObjClassName$) obj;\n"+
        "           x.set$fieldName$(($fieldClassName$) value);\n"+
        "       }\n"+
        "   }\n\n";

    private static final String getterSetterTemplatePrimitive =
        "   private class $generatedClassName$ implements GetterSetter,Serializable {\n"+
        "       public boolean setterIsFunctional() {\n"+
        "           return true;\n"+
        "       }\n"+
        "       \n"+
        "       public Object get(PersistentObject obj, Object deflt) {\n"+
        "           $dbObjClassName$ x = ($dbObjClassName$) obj;\n"+
        "           $primitiveType$ result = x.$getoris$$fieldName$();\n"+
        "           return new $primitiveWrapperType$(result);\n"+
        "       }\n"+
        "       \n"+
        "       public void set(PersistentObject obj, Object value) {\n"+
        "           $dbObjClassName$ x = ($dbObjClassName$) obj;\n"+
        "           $primitiveWrapperType$ w = ($primitiveWrapperType$) value;\n"+
        "           if (w == null) \n"+
        "               x.set$fieldName$($primitiveTypeSet$);\n"+
        "           else\n"+
        "               x.set$fieldName$(w.$primitiveType$Value());\n"+
        "       }\n"+
        "   }\n\n";



    /** Generates <code>GetterSetter</code> implementation.
     * @param generatedClassName name of the class to generate.
     * @param dbObjClassName class name of the <code>PersistentObject</code>.
     * @param fieldName name of the field (get/isX -- setX).
     * @param fieldClassName class name of the field.
     * @param generatePrimitives if <code>true</code> and <code>fieldClassName</code> is a primitive wrapper class,
     *      primitive getter/setters will be implemented.
     */
    static public String getGetterSetterImplCode(String generatedClassName,String dbObjClassName,String fieldName,
                                    String fieldClassName, boolean generatePrimitives) throws CodeGenException {

            HashMap map = new HashMap();
            map.put("fieldName",fieldName);
            map.put("dbObjClassName",dbObjClassName);
            map.put("generatedClassName",generatedClassName);
            PrimitiveClassHandle pch;
            String result = null;
            String fldClassName = CodeGenUtil.getClassDeclarationValue(fieldClassName);
            if (generatePrimitives) {
                pch = CodeGenUtil.getPrimitiveClassHandle(fldClassName);
                if (pch != null) {
                    // Set up for primitive generation.
                    if (pch.getWrapperClass().getName().equals("java.lang.Boolean")) {
                        map.put("primitiveTypeSet","false");
                        map.put("getoris","is");
                    }
                    else {
                        map.put("getoris","get");
                        map.put("primitiveTypeSet","("+pch.getPrimitiveClass().getName()+") 0");
                    }
                    map.put("primitiveType",pch.getPrimitiveClass().getName());
                    map.put("primitiveWrapperType",pch.getWrapperClass().getName());
                    result = CodeGenUtil.generateFromTemplate(
                         CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
                              getterSetterTemplatePrimitive,map);
                }
            }
            if (result == null) { // Default to class
                map.put("fieldClassName",fldClassName);
                result = CodeGenUtil.generateFromTemplate(
                     CodeGenUtil.TEMPLATE_TAG_BEGIN,CodeGenUtil.TEMPLATE_TAG_END,
                      getterSetterTemplate,map);
            }
            return result;
    }

    /** Converts a database column or table name to a "javaese" format.  First
    * character and all characters past a "_" are upper case. "_" is removed;
    * all other characters are lower case.
    * @param name name to convert.
    * @return converted name (example:  TABLE_NAME: TableName)
    */
    static public String databaseNameToFieldName(String name) {
        StringBuffer temp = new StringBuffer();
        temp.append(java.lang.Character.toUpperCase(name.charAt(0)));
        for (int i = 1; i < name.length(); i++) {
            char c = name.charAt(i);
            if (c == '_') {
                i++;
                if (i < name.length()) {
                    temp.append(java.lang.Character.toUpperCase(name.charAt(i)));
                }
            }
            else
                temp.append(java.lang.Character.toLowerCase(name.charAt(i)));
        }
        return temp.toString();
    }

    /** Handles reseting class name to primitives
     * @param className name of class that may be a primitive wrapper.
     * @return underlying primitive name or <code>className</code> if not a wrapper.
     */
    public static String translateWrapper(String className) {
        PrimitiveClassHandle pch = CodeGenUtil.getPrimitiveClassHandle(className);
        if (pch != null) {
            return pch.getPrimitiveClass().getName();
        }
        return className;
    }   

    /** Returns code to wrap a primitive wrapper code, if the class is a primitive
     * wrapper class.  If it is not, simply "fieldName" will be returned. For example:
     * <pre>
     *    getPrimitiveWrapperCode("java.util.Integer","modnum");
     *   // Returns:
     *    "new java.util.Integer(modnum)";
     * @param className class name of field.
     * @param fieldName field name.
     * @return either "new java.util.X(fieldName)" if class is a primitive wrapper or
     *              "fieldName" if class is not a wrapper.
      */
    public static String getPrimitiveWrapperCode(String className, String fieldName) {
        PrimitiveClassHandle pch = CodeGenUtil.getPrimitiveClassHandle(className);
        if (pch != null) {
            return "new "+pch.getWrapperClass().getName()+"("+fieldName+")";
        }
        return fieldName;

    }


    
    /** Returns code to wrap a literal value.
     * @param className class name of field.
     * @param literalValue literal value.
     * @return wrapped literal value, respecting string or numeric wrapper classes.
      */
    public static String getLiteralValueCode(String className, String literalValue) {
        if (className == null)
            throw new IllegalArgumentException("class name is NULL.");
        PrimitiveClassHandle pch = CodeGenUtil.getPrimitiveClassHandle(className);
        if (pch != null) {
            String value = literalValue;
            if (pch.getWrapperClass().getName().equals("java.lang.Short"))
                value = "(short) "+literalValue;    
            return "new "+pch.getWrapperClass().getName()+"("+value+")";
        }
        if (className.equals("java.lang.String"))
            return "\""+literalValue+"\"";
        return literalValue;

    }

}
