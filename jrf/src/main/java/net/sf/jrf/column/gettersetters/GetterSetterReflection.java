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
 * Contributor: James Evans (jevans@vmguys.com)
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
package net.sf.jrf.column.gettersetters;

import java.lang.reflect.*;
import java.util.*;
import net.sf.jrf.column.GetterSetter;
import net.sf.jrf.column.GetterSetter;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.exceptions.ConfigurationException;
import org.apache.log4j.Category;

/**
 * A  default implementation of <code>GetterSetter</code> that uses reflection, but
 * optimizes the operations by creating the required reflection objects
 * on instantiation.
 */
public class GetterSetterReflection implements GetterSetter
{

    private Object[] getterArgs = new Object[0];
    private Method[] i_getter = null;
    private Object[] setterArgs = new Object[1];
    private Method i_setter = null;
    private String className;
    private boolean i_setterIsFunctional = false;
    private boolean i_getterIsFunctional = false;

    final static Category LOG = Category.getInstance(GetterSetterReflection.class.getName());

    /**
     * Constructs a reflection-based <code>GetterSetter</code>. <code>Method</code>
     * instances are captured on start up an used for get and sets.
     *
     * @param colClass                column class.
     * @param getter                  get method name.
     * @param setter                  set method name.
     * @param mustHaveGetterOrSetter  if <code>true</code> getter or setter must be provided.
     */
    public GetterSetterReflection(Class colClass, String getter, String setter, boolean mustHaveGetterOrSetter)
    {
        this.className = colClass.getName();
        Method[] methodList = colClass.getMethods();
        this.i_getterIsFunctional = (getter != null && getter.length() > 0 ? true : false);
        this.i_setterIsFunctional = (setter != null && setter.length() > 0 ? true : false);
        if (mustHaveGetterOrSetter && !i_getterIsFunctional && !i_setterIsFunctional)
        {
            throw new ConfigurationException(className + ": no getter or setter specified.");
        }
        String firstGetter = getter;
        String remainingGetters = "";
        if (getter != null)
        {
            int idx = getter.indexOf(".");
            if (idx != -1)
            {
                firstGetter = getter.substring(0, idx);
                remainingGetters = getter.substring(idx + 1);
            }
        }
        for (int i = 0; i < methodList.length; i++)
        {
            if (i_setterIsFunctional && methodList[i].getName().equals(setter))
            {
                Class[] args = methodList[i].getParameterTypes();
                if (args.length == 1)
                {
                    if (i_setter != null && !args[0].isPrimitive())
                    {
                        throw new ConfigurationException(className + "::" + i_setter.getName() +
                            " is overloaded with different setter parameter types of non-primitives.");
                    }
                    else
                    {
                        i_setter = methodList[i];
                    }
                }
            }
            if (i_getterIsFunctional && methodList[i].getName().equals(firstGetter))
            {
                Class[] args = methodList[i].getParameterTypes();
                if (args.length == 0)
                {
                    i_getter = getGetters(methodList[i], remainingGetters);
                }
            }
        }
        if (i_getterIsFunctional && i_getter == null)
        {
            throw new ConfigurationException(className + "::" + firstGetter +
                "() was not found. Methods with a super class of " +
                colClass.getSuperclass().getName() + " are " + showAllMethods(methodList));
        }
        if (i_setterIsFunctional && i_setter == null)
        {
            throw new ConfigurationException(className + "::" + setter +
                "() was not found. Methods with of super class of " +
                colClass.getSuperclass().getName() + " are " + showAllMethods(methodList));
        }
    }

    /**
     * Returns <code>true</code> if <code>set</code> is actually
     * functional (e.g sets a value).
     *
     * @return   <code>true</code> if <code>set</code> is functional.
     * @see      #set(PersistentObject,Object)
     */
    public boolean setterIsFunctional()
    {
        return this.i_setterIsFunctional;
    }

    private String showAllMethods(Method methodList[])
    {
        StringBuffer result = new StringBuffer();
        for (int i = 0; i < methodList.length; i++)
        {
            if (i > 0)
            {
                result.append(",");
            }
            result.append(methodList[i].getName());
        }
        return result.toString();
    }

    /**
     * Mimicking KeyPathHelper, traverse the chain of gets one time only.
     *
     * @param first             Description of the Parameter
     * @param remainingGetters  Description of the Parameter
     * @return                  The getters value
     */
    private Method[] getGetters(Method first, String remainingGetters)
    {
        Vector getMethods = new Vector();
        getMethods.addElement(first);
        Class valueClass = null;
        Class args[] = new Class[0];
        StringTokenizer st = new StringTokenizer(remainingGetters, ".");
        Method prevMethod = first;
        Class methodClass = null;
        String currentMethodName = null;
        try
        {
            while (st.hasMoreTokens())
            {
                currentMethodName = st.nextToken();
                methodClass = prevMethod.getReturnType();
                if (methodClass.getName().equals("void"))
                {
                    throw new ConfigurationException("Specified get method " + prevMethod.getName() +
                        " has a void return type.");
                }
                prevMethod = methodClass.getMethod(currentMethodName, args);
                getMethods.addElement(prevMethod);
            }
        }
        catch (NoSuchMethodException ne)
        {
            throw new ConfigurationException("No such get method: " + methodClass.getName() + "::" +
                currentMethodName);
        }
        return (Method[]) getMethods.toArray(new Method[getMethods.size()]);
    }

    /**
     * Description of the Method
     *
     * @return   Description of the Return Value
     */
    public String toString()
    {
        StringBuffer b = new StringBuffer();
        b.append("ClassName = " + className + "\n");
        if (i_setter == null)
        {
            b.append("Setter is null.");
        }
        else
        {
            b.append("Setter is " + i_setter.getName());
        }
        if (i_getter == null)
        {
            b.append(" Getter is null.");
        }
        else
        {
            b.append(" Getters: ");
            for (int i = 0; i < i_getter.length; i++)
            {
                if (i > 0)
                {
                    b.append(".");
                }
                b.append(i_getter[i].getName());
            }

        }
        return b.toString();
    }

    /**
     * Sets the value for the given object.
     *
     * @param aPO     A <code>PersistentObject</code> instance.
     * @param aValue  Value to set for object member.
     */
    public void set(PersistentObject aPO, Object aValue)
    {
        if (this.i_setterIsFunctional)
        {
            setterArgs[0] = aValue;
            try
            {
                i_setter.invoke(aPO, setterArgs);
                //LOG.debug(this.toString()+" setting value "+aValue);
            }
            catch (Exception ex)
            {
                handleException(ex, i_setter.getName());
            }
        }
    }

    /**
     * Gets the value from the object.
     *
     * @param aPO    A <code>PersistentObject</code> instance.
     * @param deflt  A value to use for default if field value is null.
     * @return       object that is the appropriate field in <code>obj</code>.
     */
    public Object get(PersistentObject aPO, Object deflt)
    {
        if (this.i_getterIsFunctional)
        {
            int i = 0;
            try
            {
                Object result = aPO;
                for (i = 0; i < i_getter.length; i++)
                {
                    result = i_getter[i].invoke(result, getterArgs);
                    //LOG.debug(this.toString()+" getting value "+result);
                }
                if (result == null)
                {
                    return deflt;
                }
                return result;
            }
            catch (Exception ex)
            {
                handleException(ex, i_getter[i].getName());
            }
        }
        return null;
    }

    private void handleException(Exception ex, String methodName)
    {
        if (ex instanceof IllegalAccessException)
        {
            throw new RuntimeException("Unable to access underlying method " + className + "::" + methodName +
                "(): " + ex.getMessage());
        }
        throw new RuntimeException("Unable to invoke " + className + "::" + methodName + "(); " + ex.getClass().getName() + " " +
            ex.getMessage());
    }

}
