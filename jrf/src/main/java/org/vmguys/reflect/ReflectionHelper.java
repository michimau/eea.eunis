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
/**********************************************************/
////////////////////////////////////////////////////////////
package org.vmguys.reflect;
import java.util.*;
import java.lang.reflect.*;
import java.io.*;
import java.beans.*;
import java.text.*;

/** A utility class of static reflection methods.
*
*
*/
public class ReflectionHelper  {

    /** Offset in String array returned from <code>parseClassNames() that contains the class
    * name (0)
    *  @see #parseClassNames(String,String,String)
    */
    public static final int CLASSOFFSET = 0;


    /** Offset in String array returned from <code>parseClassNames() that contains the method
    * name (1)
    *  @see #parseClassNames(String,String,String)
    */
    public static final int METHODOFFSET = 1;

    /* Used in accessor invocations by invokeGetProperty()
     */
    private static final Object[] noArgs = {};

    /** Invokes a setProperty() style accessor on <code>object</code> via reflection.
     *  Expects property to be a <code>simple property</code> which takes a single parameter which is either
     *  a <code>String</code> or one of the primitive base types.
     *
     *  <p> Cannot deal with array[] arguments or methods that take multiple parameters.
     *
     * @param object The object upon which we are going to invoke a 'set' accessor.
     * @param property The property name whose 'set' accessor is to be invoked (should begin with a lowercase letter).
     * @param value  The value to be 'set' via this method invocation.
     * @throws InvocationTargetException If the method and object do not correspond.
     * @throws IllegalAccessException If invocation via reflection is denied by policy.
     * @throws NumberFormatException If value cannot be converted to an appropriate numeric type.
     */
    static public void invokeSetProperty(Object object, String property, String value)
                 throws InvocationTargetException, IllegalAccessException, NumberFormatException,
                        ParseException, IntrospectionException
    {
        PropertyDescriptor pd = new PropertyDescriptor(property, object.getClass());
        invokeSetProperty(object, pd.getWriteMethod(), value);
    }

    /** Invokes a setProperty() style accessor on <code>object</code> via reflection.
     *  Expects method to be a <code>Method</code> which takes a single parameter which is either
     *  a <code>String</code> or one of the primitive base types.
     *
     *  <p> Cannot deal with array[] arguments or methods that take multiple parameters.
     *
     * @param object The object upon which we are going to invoke a 'set' accessor.
     * @param method The 'set' accessor to be invoked.
     * @param value  The value to be 'set' via this method invocation.
     * @throws InvocationTargetException If the method and object do not correspond.
     * @throws IllegalAccessException If invocation via reflection is denied by policy.
     * @throws NumberFormatException If value cannot be converted to an appropriate numeric type.
     */
    static public void invokeSetProperty(Object object, Method method, String value)
                 throws InvocationTargetException, IllegalAccessException, NumberFormatException,
                        ParseException
    {
        Class[] parameters = method.getParameterTypes();
        Object[] args      = new Object[1];

        if (parameters.length != 1) {
            String message = "Object accessor " + method.getName() + " takes " +
                             parameters.length + " arguments. Expected a single argument.";
            throw new IllegalAccessException(message);
        }
        String parameterType = parameters[0].getName();

        if ("java.lang.String".equals(parameterType) == true) {
            args[0] = value;
        }
         else if ("java.lang.Boolean".equals(parameterType) == true) {
            args[0] = new Boolean(value);

        } else if ("int".equals(parameterType) == true) {
            args[0] = new Integer(value);

        } else if ("boolean".equals(parameterType) == true) {
            args[0] = new Boolean(value);

        } else if ("float".equals(parameterType) == true) {
            args[0] = new Float(value);

        } else if ("double".equals(parameterType) == true) {
            args[0] = new Double(value);

        } else if ("byte".equals(parameterType) == true) {
            args[0] = new Byte(value);

        } else if ("short".equals(parameterType) == true) {
            args[0] = new Short(value);

        } else if ("java.util.Date".equals(parameterType)) {
            args[0] = DateFormat.getInstance().parse(value);

        } else {
            String message = "Parameter type on accessor " + method.getName() + " type:" +
                             parameters[0].getName() + " not yet handled.";
            throw new IllegalAccessException(message);
        }
        //logger.println("Invoking accessor: " + method.getName() + "(" +
        //                  parameters[0].getName() + " " + value + ");");
        method.invoke(object, args);
    }

    /** Invokes a getProperty() style accessor on <code>object</code> via reflection.
     *  Expects property to be a <code>simple property</code> that returns either
     *  a <code>String</code>, a primitive type, or a parsable toString() value.
     *
     *  <p> Cannot deal with array[] arguments or methods that take multiple parameters.</p>
     *
     *  @param object An object whose 'get' accessor is to be invoked.
     *  @param property A property whose 'get' accessor method to be invoked (begins with lowercase).
     *  @return A string representation of the value returned by the 'get' invocation
     *  @throws InvocationTargetException If the object and method do not correspond
     *  @throws IllegalAccessException If access via reflection is disallowed by policy
     */
    static public String invokeGetProperty(Object object, String property)
                 throws InvocationTargetException, IllegalAccessException,
                    IntrospectionException
    {
        PropertyDescriptor pd = new PropertyDescriptor(property, object.getClass());
        return invokeGetProperty(object, pd.getReadMethod());
    }

    /** Invokes a getProperty() style accessor on <code>object</code> via reflection.
     *  Expects method to be a <code>Method</code> which takes no parameters and returns either
     *  a <code>String</code> or one of the primitive base types.
     *
     *  <p> Cannot deal with array[] arguments or methods that take multiple parameters.</p>
     *
     *  @param object An object whose 'get' accessor is to be invoked.
     *  @param method The 'get' accessor method to be invoked.
     *  @return A string representation of the value returned by the 'get' invocation
     *  @throws InvocationTargetException If the object and method do not correspond
     *  @throws IllegalAccessException If access via reflection is disallowed by policy
     */
    static public String invokeGetProperty(Object object, Method method)
                 throws InvocationTargetException, IllegalAccessException
    {
        Object rval = method.invoke(object, noArgs);
        if (rval instanceof Date) {
        return new SimpleDateFormat("dd MMM yyyy").format(rval);
        } else
        return rval == null ? null : rval.toString();
    }

    /** Class to instruct <code>generateDiffCode</code> how to generate "diff" code.
    */
    public static class DiffInfo {
        String fieldName;
        String userFriendlyName;
        boolean showDiff;
        /** Constructs a difference report info data class.
        * @param fieldName field that has a get method ("getFieldName()" should exist).
        * @param userFriendlyName user friendly name to use for difference report.
        * @param showDiff if true, the value changes should be show in the difference report.
        */
        public DiffInfo(String fieldName, String userFriendlyName, boolean showDiff) {
            this.fieldName = fieldName;
            this.userFriendlyName = userFriendlyName;
            this.showDiff = showDiff;
        }
    }

    /** Generates code to "diff" two objects that contain "get" methods, returning a user-friendly text
    * describing the differences.  The text generated will be the following assuming "FNAME" is the
    * field name and "VALUE"
    */
    public static String generateDiffCode(String objectName, DiffInfo [] diffInfo) {

        StringBuffer result = new StringBuffer();
        result.append("\t/** Returns a user-friendly difference report between two "+objectName+" instances.\n");
        result.append("\t * @param oldValue original value.\n");
        result.append("\t * @param newValue new value.\n");
        result.append("\t * @return a user-friendly difference report.\n");
        result.append("\t*/\n");
        result.append("\tpublic static String diff("+objectName+" oldValue,"+objectName+" newValue) {\n");
        result.append("\t\tStringBuffer diffReport = new StringBuffer();\n");
        for (int i = 0; i < diffInfo.length; i++) {
            String getOld = "oldValue.get"+diffInfo[i].fieldName+"()";
            String getNew = "newValue.get"+diffInfo[i].fieldName+"()";
            result.append("\t\tif ("+getOld+" != "+getNew+") {\n");
            result.append("\t\t\tif ("+getOld+" == null)\n");
            if (diffInfo[i].showDiff) {
                result.append("\t\t\t\tdiffReport.append("+getNew+"+\" was set as an initial value for "
                                    +diffInfo[i].userFriendlyName+".\\n\");\n");
            }
            else {
                result.append("\t\t\t\tdiffReport.append(\"An initial value was set for "+diffInfo[i].userFriendlyName+".\\n\");\n");
            }
            result.append("\t\t\telse if ("+getNew+" == null)\n");
            if (diffInfo[i].showDiff) {
                result.append("\t\t\t\tdiffReport.append(\"Value for "
                        +diffInfo[i].userFriendlyName+" of \"+"+getOld+"+\" was deleted and set to blank.\\n\");\n");
            }
            else {
                result.append("\t\t\t\tdiffReport.append(\"Value for "+diffInfo[i].userFriendlyName+
                            " was deleted and set to blank.\n\"");
            }
            result.append("\t\t\telse\n");
            if (diffInfo[i].showDiff) {
                result.append("\t\t\t\tdiffReport.append(\"Value for "+diffInfo[i].userFriendlyName+
                            " was changed from \"+"+getOld+"+\" to \"+"+getNew+"+\".\\n\");\n");
            }
            else {
                result.append("\t\t\t\tdiffReport.append(\"Value for "+diffInfo[i].userFriendlyName+" was changed.\\n\");\n");
            }
            result.append("\t\t}\n");
        }
        result.append("\t\treturn diffReport.toString();\n");
        result.append("\t}\n");
        return result.toString();
    }



    /** Parses a list of class/methods in the format "X:doit", where "X" is the class name
    *   and doit is the method. Multiple methods can be supplied separated by a comma.
    *   @param list list of class/methods.
    *   @param propName name of the property for use in exception handling
    *   @param propFile name of the properties file for use in exception handling.
    *   @return a two element String array with the first offset holding the class name
    *       and the second offset holding the method name.
    *   @throws MissingResourceException when
    *   <ul>
    *   <li>    Syntax error in list (missing ":" separators)
    *   <li> Method under class does not exist.
    *    <li> Unable to instantiate class.
    *    </ul>
    */
    public static String [][] parseClassNames(String list, String propName, String propFile)
                        throws MissingResourceException {
        StringTokenizer tokenizer = new StringTokenizer(list,",");
        Vector classes = new Vector();
        Vector methods = new Vector();
        int i;
        String item;
        int count = 0;
        while (tokenizer.hasMoreTokens()) {
            item = tokenizer.nextToken();
            if ((i = item.indexOf(":")) == -1) {
                throw new MissingResourceException(
                    "Error in "+propFile+"; "+propName+" value is missing \":\" in token "+
                        (count+1)+" ["+list+"]",item,propName);
            }
            classes.add(item.substring(0,i));
            String methodName = item.substring(i+1);
            methods.add(methodName);
            // Validate these guys.
            try {
                Class c = java.lang.Class.forName((String) classes.elementAt(count));
                // Make sure method exists.
                try {
                    Method [] m = c.getMethods();
                    for (i = 0; i < m.length; i++) {
                        if (m[i].getName().equals(methodName))
                            break;
                    }
                    if (i == m.length)
                        throw new MissingResourceException(
                            c.getName()+" does not have any method named "+methodName+
                            " ("+propFile+"/"+propName+")",item,propName);
                }
                catch (SecurityException s) {
                    throw new MissingResourceException("Security session thrown getting methods for "+c.getName()+
                        "("+propFile+"/"+propName+")",item,propName);
                }
            }
            catch (Exception e) {
                throw new MissingResourceException(
                    "Unable to initialize specified session start class: "+e.getClass().getName()+
                        ": "+e.getMessage(),item,propName);
            }
            count++;
        }
        // For better performance throw away vectors in place of two-dimensional string arrays
        // Offset zero is class and offset one is method.
        String [][] cList = new String[count][2];
        for (i = 0; i < count; i++) {
            cList[i][0] = (String) classes.elementAt(i);
            cList[i][1] = (String) methods.elementAt(i);
        }
        return cList;
    }

    /** Returns true if supplied class and method exists in the array.
    *  @param list A two-member array of class/method names, usually created by
    *           a call to <code>parseClassNames()</code>.
    *  @param c     A <code>Class</code> object.
    *  @param m A <code>Method</code> object.
    *  @return <code>true</code> when <code>c.getName()</code> and <code>m.getName()</code>
    *        match an array pair in <code>list</code>.
    *  @see #parseClassNames(String,String,String)
    */
    public static boolean findClassMethod(String [][] list, Class c, Method m) {
        return findClassMethod(list,c.getName(),m.getName());
    }

    /** Returns true if supplied class and method exists in the array.
    *  @param list A two-member array of class/method names, usually created by
    *           a call to <code>parseClassNames()</code>.
    *  @param c     A <code>Class</code> object.
    *  @param methodName    A method name in <code>c</code>.
    *  @return <code>true</code> when <code>c.getName()</code> and <code>methodName()</code>
    *        match an array pair in <code>list</code>.
    *  @see #parseClassNames(String,String,String)
    */
    public static boolean findClassMethod(String [][] list, Class c, String methodName) {
        return findClassMethod(list,c.getName(),methodName);
    }

    /** Returns true if supplied class and method exists in the array.
    *  @param list A two-member array of class/method names, usually created by
    *           a call to <code>parseClassNames()</code>.
    *  @param className     A class name.
    *  @param methodName    A method name in <code>className</code>.
    *  @return <code>true</code> when <code>className</code> and <code>methodName()</code>
    *               match an array pair in <code>list</code>.
    *  @see #parseClassNames(String,String,String)
    */
    public static boolean findClassMethod(String [][] list, String className, String methodName) {
        if (list == null) {
            return false;
        }
        for (int i = 0; i < list.length; i++) {
            // Method name is shorter -- test it first.
            if (methodName.equals(list[i][1]) && className.equals(list[i][0]))
                return true;
        }
        return false;
    }

    /** Displays properties for a given class using introspection.
    */
    static public String displayProperties(Class cls) throws IntrospectionException {
        BeanInfo beanInfo = Introspector.getBeanInfo(cls);
            if (beanInfo == null) {
            return "No beans; getBeanInfo() returned null for "+cls.getName();
        }
        PropertyDescriptor[] properties = beanInfo.getPropertyDescriptors();
        StringBuffer result = new StringBuffer();
        for (int i = 0; i < properties.length; i++) {
            result.append("Property "+(i+1)+" of "+properties.length+":\n");
            if (properties[i].getPropertyType() != null) {
                result.append("\tProperty Class: "+properties[i].getPropertyType().getName()+"\n");
            }
            else
                result.append("\tProperty Class is NULL.\n");
            if (properties[i].getReadMethod() != null) {
                result.append("\tRead method: "+properties[i].getReadMethod().getName()+"\n");
            }
            else
                result.append("\tRead method is NULL.\n");
            if (properties[i].getWriteMethod() != null) {
                result.append("\tWrite method: "+properties[i].getWriteMethod().getName()+"\n");
            }
            else
                result.append("\tWrite method is NULL.\n");

        }
        return result.toString();
    }

    /** Returns a list of bean methods in a class.
     * @param className class name to analyze.
     * @return list of bean methods.
     */
    static public String displayProperties(String className) throws ClassNotFoundException, IntrospectionException {
        Class cls = java.lang.Class.forName(className);
        return displayProperties(cls);
    }

    /** Creates object based on the fully-qualified class name.
    * @param cName fully-qualified class name.
    * @return instantiated object.
    * @see #createObject(String,Object[])
    */
    static public Object createObject(String cName) {
            return createObject(cName,new Object[0]);
    }

    /** Creates object based on the fully-qualified class name.
    * @param cName fully-qualified class name.
    * @param args list of constructor arguments.
    * @return instantiated object.
    */
    static public Object createObject(String cName, Object args[]) {
        Class c;
        Class [] argParams = null;
        try {
            c = java.lang.Class.forName(cName);
            if (args.length == 0)
                    return c.newInstance();
            argParams = new Class[args.length];
            for (int i = 0; i < args.length; i++)
                argParams[i] = args[i].getClass();
            Constructor cons = c.getConstructor(argParams);
            return cons.newInstance(args);
        }
        catch (ClassNotFoundException e) {
            throw new RuntimeException("Unable to find class \""+cName+"\"; check CLASSPATH!.");
        }
        catch (NoSuchMethodException e) {
          StringBuffer b = new StringBuffer();
          for (int i = 0; i < args.length; i++) {
            if (i > 0)
                b.append(",");
            b.append(argParams[i].getName());
          }
              throw new RuntimeException("Unable to find constructor ["+cName+"("+b+")]");
        }
        catch (InstantiationException e) {
            throw new RuntimeException("Unable to instantiate instance of "+cName+":"+e.getMessage());
         }
        catch (IllegalAccessException e) {
            throw new RuntimeException(
                    "Unable to access the default constructor of "+cName+".");
            }
        catch (Exception e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
            throw new RuntimeException(
                "Unable to initialize a implementation of a "+cName+": "+
                e.getClass().getName()+": "+e.getMessage()+"\nStack Trace:\n"
                    +sw.toString());
        }
    }


    /** Copies data references from one bean to another for all bean methods under the same signature.
    * <code>fromObject</code> and <code>toObject</code> need not belong to the same class, although
    * this implementation is much more efficient if they do.
    * @param fromObject object to copy from.
    * @param toObject object to copy to.
    */
    public static void beanCopy(Object fromObject, Object toObject) {

        String fromClassName = fromObject.getClass().getName();
        String toClassName   =   toObject.getClass().getName();

        if (fromClassName.compareTo(toClassName) != 0) {
            altBeanCopy(fromObject, toObject);
        } else {
        BeanInfo beanInfo;
        try {
            beanInfo = Introspector.getBeanInfo(toObject.getClass()); // Get all methods.
        }
        catch (IntrospectionException ex) {
            throw new RuntimeException("Unexpected introspection exception on "+toObject.getClass()+": "+ex.getMessage());
        }
        PropertyDescriptor [] properties = beanInfo.getPropertyDescriptors();
        for (int i = 0; i < properties.length; i++) {
            Method writer = properties[i].getWriteMethod();
            Method reader = properties[i].getReadMethod();
            if (reader != null && writer != null) {
            try { // Write base object instance property from property read from the composite.
                Object obj = reader.invoke (fromObject, new Object[0]);
                writer.invoke( toObject,new Object[] { obj } );
            }
            catch (Exception ex) { // Ignore
            }
            }
        }
        }
    }

    /* Less efficient version which deals with fromObject and toObject
     * of different classes.
     */
    private static void altBeanCopy(Object fromObject, Object toObject) {
    BeanInfo fromBeanInfo;
    BeanInfo toBeanInfo;
    try {
        fromBeanInfo = Introspector.getBeanInfo(fromObject.getClass());
        toBeanInfo   = Introspector.getBeanInfo(  toObject.getClass());
    }
    catch(IntrospectionException ex) {
        throw new RuntimeException("Unexpected introspection exception on "+toObject.getClass()+": "+ex.getMessage());
    }
    PropertyDescriptor [] fromProperties = fromBeanInfo.getPropertyDescriptors();
    PropertyDescriptor []   toProperties =   toBeanInfo.getPropertyDescriptors();
    for (int i = 0; i < fromProperties.length; i++) {
        String propertyName = fromProperties[i].getName();
        for (int j = 0; j < toProperties.length; j++) {
            if (propertyName.compareTo(toProperties[j].getName()) == 0) {
            Method reader = fromProperties[i].getReadMethod();
            Method writer =   toProperties[j].getWriteMethod();
            try {
            Object obj = reader.invoke(fromObject, new Object[0]);
            writer.invoke(toObject, new Object[] { obj } );
            } catch (Exception ex) { /* ignore */ }
            break;
        }
        }
    }
    }

    /** A main method to display properties for a class.
    *   Usage: java org.vmguys.util.ShowProperties className
    * @param args arg[0] = className
    */
    static void main(String args[]) {
        if (args.length != 1) {
            System.out.println("Usage java org.vmguys.util.ShowProperties "+
                    " className");
            System.out.println("Make sure className is in CLASSPATH.");
            System.exit(0);
        }
        try {
            System.out.println(displayProperties(args[0]));
        }
        catch (Exception e) {
            System.err.println("Error: "+e.getMessage());
            e.printStackTrace();
        }
    }
}

