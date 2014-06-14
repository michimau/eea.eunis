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
 * Contributor: Jonathan Carlson (jcarlson@is.com)
 * Contributor: ____________________________________
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
package net.sf.jrf.codegen;

import java.beans.*;
import java.io.*;
import java.lang.reflect.*;
import java.text.*;
import java.util.*;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.util.ReflectionHelper;
import org.vmguys.appgen.*;

/**
 * A very simple code generator designed to build getters and setters implementations
 * of <code>GetterSetter</code> for a given <code>PersistentObject</code>.
 */
public class GetterSetterBuilder
{

    private final static String PARAM_CLASSNAME = "className";
    private final static String PARAM_SETTERFUNCTIONAL = "isSetterFunctional";
    private final static String PARAM_FIELDNAME = "fieldName";
    private final static String PARAM_FIELDCLASSNAME = "fieldClassName";
    private final static String PARAM_VALUE = "value";
    private final static String PARAM_DECLARINGCLASSNAME = "declaringClassName";

    private File outputDirectoryFile;
    private File baseDir;

    private final static String mainClassTemplate =
        "	private static class $fieldName$GetterSetterImpl implements GetterSetter {\n" +
        "	\n" +
        "		public boolean setterIsFunctional() {\n" +
        "			return $isSetterFunctional$;\n" +
        "		}\n" +
        "	\n";

    private final static String getterExists =
        "		public Object get(PersistentObject obj, Object deflt) {\n" +
        "			$declaringClassName$ x = ( $declaringClassName$ ) obj;\n" +
        "			Object result = x.get$fieldName$();\n" +
        "			return result == null ? deflt:result;\n" +
        "		}\n" +
        "	}\n";

    private final static String getterNoExist =
        "		public Object get(PersistentObject obj, Object deflt) {\n" +
        "			return null;\n" +
        "		}\n" +
        "	}\n";

    private final static String setterExists =
        "		public void set(PersistentObject obj, Object value) {\n" +
        "			$declaringClassName$ x = ( $declaringClassName$ ) obj;\n" +
        "			x.set$fieldName$(( $fieldClassName$ ) value);\n" +
        "		}\n";

    private final static String setterNoExist =
        "		public Object set(PersistentObject obj, Object value) {\n" +
        "		}\n";

    private final static String searchTemplate =
        "		if (key.equals(\"$value$\")) \n" +
        "			return new $value$GetterSetterImpl();";

    private final static String masterTemplate =
        "/** Automatically generated factory class to return\n" +
        "* <code>GetterSetter</code> implementations for the \n" +
        "* <code>PersistentObject</code> subclass $className$.\n" +
        "* @see net.sf.jrf.codegen.GetterSetterBuilder\n" +
        "*/\n" +
        "public class GetterSetterFactory$className$ { \n" +
        "	\n" +
        "	private GetterSetterFactory$className$(){ \n" +
        "	}\n" +
        "	\n" +
        "	/** Returns the <code>GetterSetter</code> implementation for a \n" +
        "	 * field in object <code>$className$</code>. \n" +
        "	 * @param getterOrSetterName either the get or set method name \n" +
        "	 * for the field.\n" +
        "	 * @return <code>GetterSetter</code> implementation for the field.\n" +
        "	 */\n" +
        "	static public GetterSetter getImpl(String getterOrSetterName) {\n" +
        "		if (getterOrSetterName == null || getterOrSetterName.length() < 4 ||\n" +
        "			(!getterOrSetterName.startsWith(\"get\") && \n" +
        "				!getterOrSetterName.startsWith(\"set\") && \n" +
        "				!getterOrSetterName.startsWith(\"is\")) ) \n" +
        "		throw new IllegalArgumentException(\ngetterOrSetterName+" +
        "			\": Value must start with get,set or is and must be least four characters\");\n" +
        "		String key = getterOrSetterName.substring(3);\n" +
        "\n";

    private final static String endGet =
        "		else {\n" +
        "			return null;\n" +
        "		}\n" +
        "	}\n\n";

    private final static String CL = "-classlist";
    private final static String SD = "-sourcedir";
    private final static String PK = "-packagename";
    private final static String DOTJAVA = ".java";

    GetterSetterBuilder(String args[])
        throws IOException, ClassNotFoundException
    {
        if (args.length < 3)
        {
            usage();
        }
        try
        {
            setOutputDirectory(args[0]);
            System.out.println("Output directory is " + args[0]);
        }
        catch (IOException io)
        {
            System.err.println(io.getMessage());
            usage();
        }
        String packageName = null;
        String sourceDir = null;
        for (int i = 1; i < args.length; i++)
        {
            if (args[i].equals(CL))
            {
                if (args.length != 3)
                {
                    System.err.println(showArgs(args) + "Three arguments required for list of classes.");
                    usage();
                }
                else if (i != 1)
                {
                    System.err.println(showArgs(args) + CL + " needs to be first argument.");
                    usage();
                }
                processList(args[i + 1]);
                return;
            }
            else if (args[i].equals(SD))
            {
                if (sourceDir != null)
                {
                    System.err.println(showArgs(args) + SD + " already specified.");
                }
                sourceDir = getArg(SD, args, ++i);
            }
            else if (args[i].equals(PK))
            {
                if (packageName != null)
                {
                    System.err.println(showArgs(args) + PK + " already specified.");
                }
                packageName = getArg(PK, args, ++i);
            }
        }
        if (packageName == null || sourceDir == null)
        {
            System.err.println(showArgs(args) + "Missing " + PK + " or " + SD + ".");
            usage();
        }
        processDir(sourceDir, packageName);
    }


    void setOutputDirectory(String outputDirectory)
        throws IOException
    {
        this.baseDir = new File(outputDirectory);
        if (!baseDir.isDirectory())
        {
            throw new IOException(baseDir.getAbsolutePath() + " is not a directory.");
        }
    }

    /**
     * Process the given class.
     *
     * @param poCls                       Description of the Parameter
     * @exception IntrospectionException  Description of the Exception
     * @exception IOException             Description of the Exception
     * @exception CodeGenException        Description of the Exception
     */
    void processClass(Class poCls)
        throws
        IntrospectionException, IOException, CodeGenException
    {

        StringBuffer impls = new StringBuffer();// Impls for each get/setter.
        BeanInfo beanInfo = Introspector.getBeanInfo(poCls);
        PropertyDescriptor[] properties = beanInfo.getPropertyDescriptors();
        String className = ReflectionHelper.getAbbreviatedClassName(poCls);
        HashMap map = new HashMap();
        map.put(PARAM_CLASSNAME, className);
        Vector names = new Vector();
        HashSet importList = new HashSet();

        for (int i = 0; i < properties.length; i++)
        {
            Method setter = properties[i].getWriteMethod();
            Method getter = properties[i].getReadMethod();
            String name = null;
            if (setter != null)
            {
                name = setter.getName().substring(3);
                map.put(PARAM_DECLARINGCLASSNAME, setter.getDeclaringClass().getName());
                map.put(PARAM_SETTERFUNCTIONAL, "true");
            }
            else if (getter == null)
            {
                continue;
            }
            else
            {
                name = getter.getName().substring(3);
                map.put(PARAM_SETTERFUNCTIONAL, "false");
                map.put(PARAM_DECLARINGCLASSNAME, getter.getDeclaringClass().getName());
            }
            if (name.equals("EncodedKey") || name.equals("PersistentState") || name.equals("Class") || name.equals("SubtypeCode")
                || properties[i].getPropertyType().isPrimitive())
            {
                continue;
            }
            map.put(PARAM_FIELDNAME, name);
            map.put(PARAM_FIELDCLASSNAME,
                CodeGenUtil.getClassDeclarationValue(properties[i].getPropertyType()));
            importList.add(properties[i].getPropertyType().getName());
            names.addElement(map.get(PARAM_FIELDNAME));
            impls.append(
                CodeGenUtil.generateFromTemplate(CodeGenUtil.TEMPLATE_TAG_BEGIN,
                CodeGenUtil.TEMPLATE_TAG_END,
                mainClassTemplate, map));
            if (setter == null)
            {
                impls.append(setterNoExist);
            }
            else
            {
                impls.append(
                    CodeGenUtil.generateFromTemplate(CodeGenUtil.TEMPLATE_TAG_BEGIN,
                    CodeGenUtil.TEMPLATE_TAG_END,
                    setterExists, map));
            }
            if (getter == null)
            {
                impls.append(getterNoExist);
            }
            else
            {
                impls.append(CodeGenUtil.generateFromTemplate(CodeGenUtil.TEMPLATE_TAG_BEGIN,
                    CodeGenUtil.TEMPLATE_TAG_END,
                    getterExists, map));
            }
        }
        PrintWriter outstream = CodeGenUtil.createJavaFile(baseDir, poCls.getPackage(),
            "generated", "GetterSetterFactory" + className);
        // Headers --
        outstream.println("package " + poCls.getPackage().getName() + ".generated;");
        outstream.println("import " + poCls.getName() + ";");
        Iterator iter = importList.iterator();
        while (iter.hasNext())
        {
            String value = (String) iter.next();
            if (value.indexOf(".") != -1)
            {
                outstream.println("import " + value + ";");
            }
        }
        outstream.println("import net.sf.jrf.column.GetterSetter;");
        outstream.println("import net.sf.jrf.domain.PersistentObject;");
        outstream.println("import org.apache.log4j.Category;");
        // Main class definition.
        outstream.println(
            CodeGenUtil.generateFromTemplate(CodeGenUtil.TEMPLATE_TAG_BEGIN,
            CodeGenUtil.TEMPLATE_TAG_END,
            masterTemplate, map));
        // Set up to search for each field.
        for (int i = 0; i < names.size(); i++)
        {
            String name = (String) names.elementAt(i);
            map.put(PARAM_VALUE, name);
            outstream.println(
                CodeGenUtil.generateFromTemplate(CodeGenUtil.TEMPLATE_TAG_BEGIN,
                CodeGenUtil.TEMPLATE_TAG_END,
                searchTemplate, map));

        }
        outstream.println(endGet);
        // Pop in the implementations for each field.
        outstream.println(impls.toString());
        outstream.println("}");
        outstream.close();
        System.out.println("Generated source for class " + poCls.getName());
    }

    private void usage()
    {
        System.out.println("java GetterSetterBuilder outputdirectory [options]");
        System.out.println("-classlist        list  'list' is a comma-seperated list of class names");
        System.out.println("                  that must be found in the class path.");
        System.out.println("-sourcedir dir    'name' is a directory of java source files that must ");
        System.out.println("                  already be compiled and in the class path.");
        System.out.println("                  'Class.forName()' will be applied to every source file");
        System.out.println("                  in the directory. GetterSetter implementations will");
        System.out.println("                  built for each successful instantiation of a ");
        System.out.println("                  PersistentObject subclass.");
        System.out.println("-packagename name For sourcedir, name of package for files in the ");
        System.out.println("                  directory.");
        System.out.println("outputdirectory   directory where generated source will be placed.");
        System.exit(1);
    }

    String showArgs(String args[])
    {
        StringBuffer buf = new StringBuffer();
        buf.append("ARGS: ");
        for (int i = 0; i < args.length; i++)
        {
            if (i > 0)
            {
                buf.append(" ");
            }
            buf.append(args[i]);
        }
        buf.append("\n");
        return buf.toString();
    }

    String getArg(String token, String args[], int i)
    {
        if (i == args.length)
        {
            System.err.println("Missing argument for " + token);
            usage();
        }
        return args[i];
    }

    void processList(String list)
    {
        StringTokenizer st = new StringTokenizer(list, ",");
        while (st.hasMoreTokens())
        {
            String cName = st.nextToken();
            try
            {
                Class c = java.lang.Class.forName(cName);
                processClass(c);
            }
            catch (Exception ex)
            {
                System.err.println("Reflection exception for class " + cName);
            }
        }
    }

    void processDir(String directory, String packageName)
        throws IOException, ClassNotFoundException
    {
        File inFile = new File(directory);
        if (!inFile.isDirectory())
        {
            throw new IOException(inFile.getAbsolutePath() + " is not a directory.");
        }
        File[] fileList = inFile.listFiles(new JavaFileFilter());
        Class poC;
        poC = java.lang.Class.forName("net.sf.jrf.domain.PersistentObject");
        for (int i = 0; i < fileList.length; i++)
        {
            int idx = fileList[i].getAbsolutePath().lastIndexOf(DOTJAVA);
            String name = fileList[i].getAbsolutePath().substring(0, idx);
            name = name.replace(File.separatorChar, '.');
            idx = name.lastIndexOf(".");
            if (idx != -1)
            {
                name = name.substring(idx);
            }
            String fullName = packageName + name;
            Class c;
            try
            {
                c = java.lang.Class.forName(fullName);
            }
            catch (Exception ex)
            {
                System.err.println("Skipping " + fullName + ": " + ex.getClass().getName() + ": " + ex.getMessage());
                continue;
            }
            try
            {
                if (poC.isAssignableFrom(c))
                {
                    processClass(c);
                }
            }
            catch (Exception ex)
            {
                System.err.println("Failure on " + fullName + ": " + ex.getMessage());
            }
        }
    }

    /**
     * Generates source files for <code>GetterSetter</code> implementations.  This generator was created
     *  primarily to allow existing applications to remove reflection from the JRF framework processing
     *  in <code>AbstractDomain</code> without any coding intervention. A factory class is generated
     *  that will provide a single public method to return <code>GetterSetter</code> implementations
     *  using the "get" method as a key.
     *  The constructor of <code>AbstractDomain</code> will attempt to locate this factory class by
     *  using the following methodology:
     *  <pre>
     *   Class poClass = newPersistentObject().getClass();
     *	// just need class name, not full path.
     *   String abbreviatedClassName = ReflectionHelper.getAbbreviatedClassName(poClass);
     *	String factoryName = poClass.getPackage().getName()+".generated.GetterSetterFactory"+abbreviatedName;
     *	Class c = java.lang.Class.forName(factoryName);
     *  </pre>
     *  For example, if there is a <code>PersistentObject</code> called <code>com.acom.myapp.Customer</code>,
     *  the resulting factory class will be called <code>com.acom.myapp.generated.GetterSetterFactoryCustomer</code>;
     *  a package called <code>com.acom.myapp.generated</code> will be created.
     *  <p>
     *   When <code>AbstractDomain.addColumnSpec()</code> or <code>AbstractDomain.addJoinTable()</code> is called,
     *	the implementation of <code>GetterSetter</code> will be located by:
     *  <pre>
     *
     *    Object getterSetterImplArgs[] = new Object[1];
     *   getterSetterImplArgs[0] = (setter != null ? setter:getter);
     *   try {
     *	    return (GetterSetter) getterSetterImplFactory.invoke(null,getterSetterImplArgs);
     *   }
     *   catch (Exception ex) {
     *  		LOG.warn("AbstractDomain.addColumnSPec(): error loading getter setter",ex);
     *		return null;
     *   }
     *  </pre>
     *  <p>
     *  <code>AbstractDomain</code>'s constructor and this class then are obviously integrally tied.
     *  <p>
     *  You may specify either a list of comma-separated class names or source directory where all
     *  ".java" files that extend <code>PersistentObject</code> will be handled.  For both cases,
     *  the <code>PersistentObject</code> classes must be compiled and in the system class path.
     *  <p>
     *  Enter <code>java GetterSetterBuilder</code> to obtain full usage information.
     *
     * @param args  Description of the Parameter
     */
    public static void main(String args[])
    {
        String cName = null;
        try
        {
            GetterSetterBuilder g = new GetterSetterBuilder(args);
        }
        catch (Exception ex)
        {
            System.err.println("Failed generation of impl factory for " + cName + ": " + ex.getMessage());
            ex.printStackTrace();
        }

    }

    private class JavaFileFilter implements FileFilter
    {

        public boolean accept(File f)
        {
            return f.getAbsolutePath().endsWith(DOTJAVA) ? true : false;
        }
    }
}
