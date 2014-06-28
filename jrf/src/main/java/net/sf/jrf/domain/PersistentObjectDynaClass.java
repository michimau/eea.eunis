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
package net.sf.jrf.domain;
import org.apache.commons.beanutils.BasicDynaClass;
import org.apache.commons.beanutils.DynaBean;
import org.apache.commons.beanutils.DynaProperty;
import org.apache.log4j.Category;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import net.sf.jrf.exceptions.ConfigurationException;
import net.sf.jrf.column.ColumnSpec;
import net.sf.jrf.column.columnspecs.CompoundPrimaryKeyColumnSpec;
import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;

/** Extension of <code>BasicDynaClass</code> that contains
* the class name of the <code>PersistentObject</code> that may be
* used to generate new instances.  This class also contains static conversion methods to
* convert between <code>PersistentObject</code> and <code>DynaBean</code> instances and a
* factory method to generate an instance through the information provided in an <code>AbstractDomain</code>.
*/
public class PersistentObjectDynaClass extends BasicDynaClass {

        private Class poClass = null;
    final static Category LOG = Category.getInstance(PersistentObjectDynaClass.class.getName());


    /** Constructs an instance
    * @param name name of the object.
    * @param beanClass name of the <code>PersistentObjectDynaBean</code> class to be used.
    * @param poClass <code>PersistentObject</code> class type.
    * @param properties array of <code>DynaProperty</code>s.
    */
    public PersistentObjectDynaClass(String name,Class beanClass,Class poClass,List properties) {
        super(name,beanClass, (DynaProperty []) (properties.toArray(new DynaProperty[properties.size()]) ));
        this.poClass = poClass;
    }

    /** Overrides base class version to allow no-args constructors.
    * @param dynaBeanClass <code>Class</code> instance to examine.
    */
        protected void setDynaBeanClass(Class dynaBeanClass) {
            // Validate the argument type specified
            if (dynaBeanClass.isInterface())
                    throw new IllegalArgumentException
                           ("Class " + dynaBeanClass.getName() +
                          " is an interface, not a class");
            if (!DynaBean.class.isAssignableFrom(dynaBeanClass))
                       throw new IllegalArgumentException
                           ("Class " + dynaBeanClass.getName() +
                           " does not implement DynaBean");
            if (!PersistentObjectDynaBean.class.isAssignableFrom(dynaBeanClass))
                       throw new IllegalArgumentException
                           ("Class " + dynaBeanClass.getName() +
                           " does not implement PersistentObjectDynaBean");

         // Try DynaClass arg first, followed by no-arg constructor.
        for (int i = 0; super.constructor == null && i < 2; i++) {
            Class [] constructorParams =
                (i == 0 ? new Class [] {this.getClass()} : new Class []{} );
                try {
                    super.constructor = dynaBeanClass.getConstructor(constructorParams);
                super.constructorValues = (i == 0 ? new Object[] {this}: new Object[] {});

                }
            catch (NoSuchMethodException e) {
            }
        }
        if (super.constructor == null)
                    throw new IllegalArgumentException
                    ("Class " + dynaBeanClass.getName() +
                    " does not have an appropriate constructor");
            super.dynaBeanClass = dynaBeanClass;
    }

    /** Constructs a new <code>PersistentObject</code>.
    * @return newly constructed <code>PersistentObject</code>.
    */
    public PersistentObject newPersistentObject()  {
        PersistentObject result = null;
        try {
            result = (PersistentObject) poClass.newInstance();
        }
        catch (Exception ex) {
            String error = "Unexpected instantiation exception for "+poClass;
            LOG.error(error,ex);
            throw new RuntimeException(error);
        }
        return result;
    }

    /** Returns information on each property of the <code>PersistentObject</code> class.
    * @return information on each property of the <code>PersistentObject</code> class.
    */
    public String toString() {
        StringBuffer buf = new StringBuffer();
        DynaProperty[] props = getDynaProperties();
        for (int i = 0; i < props.length; i++) {
            buf.append("Property "+(i+1)+" of "+props.length+":\n");
            buf.append(props[i].toString());
            buf.append("\n===================\n");
        }
        return buf.toString();
    }

    /** Updates bean from a given <code>PersistentObject</code>.
    * @param aPO <code>PersistentObject</code> to read.
    * @param poBean <code>PersistentObjectDynaBean</code> instance to update.
    */
    public static void persistentObjectToBean(PersistentObject aPO, PersistentObjectDynaBean poBean) {
        DynaBean bean = (DynaBean) poBean;
        DynaProperty[] props = poBean.getPersistentObjectDynaClass().getDynaProperties();
        for (int i = 0; i < props.length; i++) {
            PersistentObjectDynaProperty cp;
            if ( (cp = PersistentObjectDynaProperty.getPOProperty(props[i])) != null) {
                Object value = cp.get(aPO);
                bean.set(cp.getName(),value);
            }
        }
    }

    /** Initializes a bean to the default settings of the <code>PersistentObject</code>.
    * Any default values specified will be populated in the bean.
    * @param poBean <code>PersistentObjectDynaBean</code> instance.
    */
    public static void resetBean(PersistentObjectDynaBean poBean) {
        DynaProperty[] props = poBean.getPersistentObjectDynaClass().getDynaProperties();
        DynaBean bean = (DynaBean) poBean;
        for (int i = 0; i < props.length; i++) {
            PersistentObjectDynaProperty cp;
            if ((cp = PersistentObjectDynaProperty.getPOProperty(props[i])) != null) {
                if (cp.getName().equals("persistentState"))
                    bean.set(cp.getName(),new NewPersistentState());
                else if (cp.isDbColumn() && cp.getDefaultValue() != null)
                    bean.set(cp.getName(),cp.getDefaultValue());
            }
        }
    }


    /** Transfers the properties from the bean to a new <code>PersistentObject</code>.  This
    * method may be used for "stateful" and "stateless" contexts.  Stateful contexts maintain
    * a copy of the <code>PersistentObject</code> for reference after properties of the bean has been updated,
    * usually through a user interface. On the other hand, stateless contexts do not maintain a copy of the
    * <code>PersistentObject</code> and rely on setting the <code>PersistentState</code> in the bean itself.
    * In fact, this method  determines stateless status by examining the <code>PersistentState</code> in the bean.
    * If the value is non-null, <code>PersistentState</code> of bean will be transferred to the
    * <code>PersistentObject</code>.
    * Otherwise the state of the <code>PersistentObject</code> will be <code>NewPersistentState</code>.
    * <p>
        * Indexed and mapped properties will not be copied.  This functionality may be implemented
    * in the future.
    * @param poBean <code>DynaBean</code> instance to process that must return
    * a <code>PersistentObjectDynaClass</code> instance from a call to <code>getDynaClass()</code>.
    * @return a generated <code>PersistentObject</code> from the bean.
    * @see #beanToPersistentObject(PersistentObjectDynaBean,PersistentObject)
    */
    public static PersistentObject beanToPersistentObject(PersistentObjectDynaBean poBean) {
        PersistentObjectDynaClass c = poBean.getPersistentObjectDynaClass();
        PersistentObject aPO = c.newPersistentObject();
        DynaBean bean = (DynaBean) poBean;
        // If state is null, force to new:
        if (bean.get("persistentState") == null)
            bean.set("persistentState",new NewPersistentState());
        beanToPersistentObject(c,bean,aPO,false);
        return aPO;
    }

    /** Transfers the properties from the bean to a "stateful" <code>PersistentObject</code>.
    * @param bean <code>DynaBean</code> instance to process.
    * @param aPO <code>PersistentObject</code> argument representing the state of the object
    * before manipulation of a bean.
    */
    public static void beanToPersistentObject(PersistentObjectDynaBean bean,PersistentObject aPO) {
        PersistentObjectDynaClass c = bean.getPersistentObjectDynaClass();
        beanToPersistentObject(c,(DynaBean) bean,aPO,true);
    }

    /** Transfers the properties from the bean to the <code>PersistentObject</code> in a
    * "stateful" or "stateless" manner.
    * @param bean <code>DynaBean</code> instance to process.
    * @param aPO <code>PersistentObject</code> to update.
    * @param stateful if <code>true</code>, <code>PersistentObject</code> argument represents
    * the state of the object before manipulation of a bean.
    */
    private static void beanToPersistentObject(PersistentObjectDynaClass c,
                DynaBean bean,PersistentObject aPO,boolean stateful) {
        DynaProperty[] props = c.getDynaProperties();
        PersistentState state = (stateful ? aPO.getPersistentState():
                            (PersistentState) bean.get("persistentState"));
        int count = 0;
        // Respect deleted state, if necessary.
        if (state.isDeletedPersistentState()) {
            if (!stateful)
                aPO.forceDeletedPersistentState();
            return;
        }
        for (int i = 0; i < props.length; i++) {
            PersistentObjectDynaProperty cp;
            if ((cp = PersistentObjectDynaProperty.getPOProperty(props[i])) != null
                        && !cp.getName().equals("persistentState") &&
                            !cp.isIndexed() && !cp.isMapped()) {
                Object beanValue = bean.get(cp.getName());
                if (!stateful) {
                    if (LOG.isDebugEnabled()) {
                        LOG.debug("Stateless copy for po: "+aPO+
                            ": setting bean value for "+cp.getName()+" to ["+
                            beanValue+"]");
                    }
                    cp.set(aPO,beanValue);
                }
                else {  // Stateful update -- check current values.
                    boolean changed = true;
                    // Do not touch primary key, "write once"
                    // or optimistic lock values for existing
                    // records.
                    if (state.isCurrentPersistentState() &&
                            (cp.isWriteOnce() || cp.isOptimisticLock()) ) {
                        changed = false;
                    }
                    else {
                        Object poValue = cp.get(aPO);
                        if (LOG.isDebugEnabled()) {
                            LOG.debug("Stateful copy for po: "+aPO+
                                ": setting bean value for "+cp.getName()+" to "+
                                beanValue+" if not equal to "+poValue);
                        }
                        if (poValue != null && !poValue.equals(beanValue))
                            changed = true;
                        else if (beanValue != null && !beanValue.equals(poValue))
                            changed = true;
                        else
                            changed = false;
                    }
                    if (changed) {
                        count++;
                        cp.set(aPO,beanValue);
                    }
                }
            }
        }
        // Set State accordingly.
        if (stateful) {
            if (state.isNewPersistentState())
                aPO.forceNewPersistentState();
            else if (state.isCurrentPersistentState()) {
                if (count > 0)
                    aPO.forceModifiedPersistentState();
                else
                    aPO.forceCurrentPersistentState();
            }
        }
        else { // Stateless.
            if (state.isNewPersistentState()) {
                aPO.forceNewPersistentState();
            }
            else if (state.isCurrentPersistentState()) {
                aPO.forceModifiedPersistentState();
            }
        }
        if (LOG.isDebugEnabled())
            LOG.debug("copy bean to PO is complete: object is now: "+aPO);
    }

     /** Factory method to create a <code>PersistentObjectDynaClass</code> based on bean properties
      * of the <code>PersistentObject</code> managed by the <code>AbstractDomain</code> instance parameter.
      * If the object is a composite, <code>Map</code> and <code>List</code> properties will
      * be included.
      * @param domain <code>AbstractDomain</code> instance to inspect.
      * @param beanClass class name of the implementer of <code>DynaBean</code>
      *  returned <code>PersistentObjectDynaClass</code>'s <code>PersistentObjectDynaProperty</code> list.
      * @return <code>PersistentObjectDynaClass</code> based on internal column specifications.
      */
      static public PersistentObjectDynaClass createPersistentObjectDynaClass(AbstractDomain domain, Class beanClass) {
            BeanInfo beanInfo;
        PersistentObject obj = domain.newPersistentObject();
        // Introspect the Persistent Object.
            try {
                beanInfo = Introspector.getBeanInfo(obj.getClass());
            }
            catch (IntrospectionException ex) {
                throw new ConfigurationException(ex, "Unexpected introspection exception on " + obj.getClass());
            }
            PropertyDescriptor[] properties = beanInfo.getPropertyDescriptors();
        HashMap propertyMap = new HashMap();
            for (int i = 0; i < properties.length; i++) {
                if (properties[i].getReadMethod() != null) {
            Class returnType = properties[i].getReadMethod().getReturnType();
            /** NO - include them
             (Ignore Maps and Lists from composites)
            if (java.util.Map.class.isAssignableFrom(returnType) ||
                java.util.List.class.isAssignableFrom(returnType))
                continue;
            **/
            String writeMethodName = properties[i].getWriteMethod() == null ? null:
                properties[i].getWriteMethod().getName();

            propertyMap.put(properties[i].getName(),new PersistentObjectDynaProperty(properties[i].getName(),
                        returnType,properties[i].getReadMethod().getName(),writeMethodName) );
        }
        }
        // Reconcile bean properties with the column specifications.
            Iterator columnSpecs = domain.getColumnSpecs().iterator();
            while (columnSpecs.hasNext()) {
                 ColumnSpec c = (ColumnSpec) columnSpecs.next();
                 if (c instanceof CompoundPrimaryKeyColumnSpec) {
                    CompoundPrimaryKeyColumnSpec cp = (CompoundPrimaryKeyColumnSpec) c;
                    Iterator iter = cp.getColumnSpecs().iterator();
                    while (iter.hasNext()) {
                              PersistentObjectDynaProperty p = updatePropertyMap((ColumnSpec) iter.next(),propertyMap);
                  // Force dyna property for primary key to true.  Value for compound keys does not
                  // have this value set automatically.
                  p.setPrimaryKey(true);
                        }
         }
         else {
                      updatePropertyMap(c,propertyMap);
         }
             }
         List list = new ArrayList(propertyMap.values());
             return new PersistentObjectDynaClass(domain.getPropertyName(),beanClass,obj.getClass(),list);
     }

     private static PersistentObjectDynaProperty updatePropertyMap(ColumnSpec c, Map propertyMap) {
       PersistentObjectDynaProperty p = (PersistentObjectDynaProperty) propertyMap.get(c.getPropertyName());
       if (p == null) {
        throw new ConfigurationException("Property not set correctly for column "+c.getColumnName()+". "+
            "Property is "+c.getPropertyName()+". Property map:\n"+propertyMap);
       }
       c.updatePersistentObjectDynaProperty(p);
       return p;
     }

}
