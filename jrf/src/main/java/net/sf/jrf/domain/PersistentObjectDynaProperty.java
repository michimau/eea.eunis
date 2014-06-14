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
import net.sf.jrf.column.ColumnSpec;
import net.sf.jrf.column.GetterSetter;
import org.apache.commons.beanutils.DynaProperty;
import net.sf.jrf.exceptions.InvalidValueException;
import java.util.List;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.lang.reflect.Method;
import org.apache.log4j.Category;

/** Extension of <code>DynaProperty</code> that contains the <code>PersistentObject</code>
* properties with the sub-set of properties from <code>ColumnSpec</code>, most of which
* are applicable in pure Java space. 
*/
public class PersistentObjectDynaProperty extends DynaProperty {

  final static Category LOG = Category.getInstance(PersistentObjectDynaProperty.class.getName());

  /** Primary key flag.**/
  protected boolean primaryKey = false;

  /** Write once flag.
  */
  protected boolean writeOnce = false;
  
  /** database column flag.
  */ 
  protected boolean dbColumn = false;

  /** Required flag
  */
  protected boolean required = false;

  /** Optimistic lock flag
  */
  protected boolean optimisticLock = false;

  /** Maximum value.
  */
  protected Comparable maxValue = null;	

  /** Mininum value.
  */
  protected Comparable minValue = null;	

  /** List of valid values.
  */
  protected List listOfValues = null;	
 
  /** <code>GetterSetter</code> implementation.
  */
  protected GetterSetter getterSetterImpl = null;

  /** Default value.
  */
  protected Object defaultValue = null;

  /** Max size, if applicable
  */
  protected int maxSize = -1;

  /** Read method name to use with reflection for all non-database fields and
   * <code>GetterSetter</code> implementations that do not implement <code>Serializable</code>.
   */
  protected String readMethodName;

  /** Write method names for 
   * <code>GetterSetter</code> implementations that do not implement <code>Serializable</code>.
   */
  protected String writeMethodName;

  /** Wrapper class for primitives to use for validation. **/
  private Class primitiveWrapperClass = null;

  private boolean indexed = false;
  private boolean mapped = false;

  /** Constructs instance and property name and class.
  * @param name property name.
  * @param cls value object <code>Class</code>.
  * @param readMethodName name of the read <code>Method</code>
  * @param writeMethodName name of the write <code>Method</code>
  */
  public PersistentObjectDynaProperty(String name,Class cls,String readMethodName,String writeMethodName) {
       super(name,cls);
       this.readMethodName = readMethodName;
       this.writeMethodName = writeMethodName;
       if (cls.isPrimitive()) {
            if (cls.equals(Boolean.TYPE))
		   primitiveWrapperClass = Boolean.class;
	    else if (cls.equals(Byte.TYPE))
		   primitiveWrapperClass = Byte.class;
	    else if (cls.equals(Character.TYPE))
		   primitiveWrapperClass = Character.class;
	    else if (cls.equals(Double.TYPE))
		   primitiveWrapperClass = Double.class;
	    else if (cls.equals(Float.TYPE))
		   primitiveWrapperClass = Float.class;
	    else if (cls.equals(Integer.TYPE))
		   primitiveWrapperClass = Integer.class;
	    else if (cls.equals(Long.TYPE))
		   primitiveWrapperClass = Long.class;
	    else if (cls.equals(Short.TYPE))
		   primitiveWrapperClass = Short.class;

      }
      else if (java.util.List.class.isAssignableFrom(cls) || cls.isArray()) {
		indexed = true;
      }
      else if (java.util.Map.class.isAssignableFrom(cls)) {
	        mapped = true;
      }
  }


  /** Returns string representation of the properties.
   * @return string representation of the properties.
   */ 
  public String toString() {
     StringBuffer buf = new StringBuffer();
     buf.append("name=["+getName()+"]\n");
     buf.append("Value Class=["+getType()+"]\n");
     if (primitiveWrapperClass != null)
        buf.append("Primitive wrapper Class=["+primitiveWrapperClass+"]\n");
     buf.append("Default Value=["+getDefaultValue()+"]\n");
     buf.append("Max size=["+maxSize+"]\n");
     buf.append("Max Value=["+maxValue+"]\n");
     buf.append("Min Value=["+minValue+"]\n");
     buf.append("Required=["+required+"]\n");
     buf.append("DbColumn=["+dbColumn+"]\n");
     buf.append("ReadMethodName=["+readMethodName+"]\n");
     buf.append("WriteMethodName=["+writeMethodName+"]\n");
     buf.append("List of Values=["+listOfValues+"]\n");
     buf.append("GetterSetter=["+getterSetterImpl+"]\n");
     buf.append("Optimistic Lock=["+optimisticLock+"]\n");
     buf.append("Write Once=["+writeOnce+"]\n");
     buf.append("Primary Key Status=["+primaryKey+"]");
     return buf.toString();
  }

   /** Returns <code>PersistentObjectDynaProperty</code> if parameter is an instance
   * of <code>PersistentObjectDynaProperty</code> or <code>null</code> if not.
   * @param p <code>DynaProperty</code> to test.
   * @return <code>PersistentObjectDynaProperty</code> if parameter is an instance
   * of <code>PersistentObjectDynaProperty</code> or <code>null</code> if not.
   */
   public static PersistentObjectDynaProperty getPOProperty(DynaProperty p) {
	try {
		return (PersistentObjectDynaProperty) p;
	}
	catch (ClassCastException ce) {

		return null;
	}
  } 
	
  /** Returns the value in the <code>PersistentObject</code>.
  * @param obj <code>PersistentObject</code> from which to get the object value.
  * @return the value in the <code>PersistentObject</code>.
  */
  public Object get(PersistentObject obj) {
	Object result = null;
	if (getterSetterImpl == null) {
		try {
			Method m = obj.getClass().getMethod(readMethodName,new Class [] {});
			result = m.invoke(obj,new Object [] {});		
			if (result == null)
				result = defaultValue;
		}
		catch (Exception ex) {
			String error = "Unable to evoke "+readMethodName+"() for "+obj.getClass();
			LOG.error(error,ex);
			throw new IllegalArgumentException(error);
		}	
	}
	else {
		result = getterSetterImpl.get(obj,defaultValue);
	}
	return result;
  } 

  /** Sets the object in the <code>PersistentObject</code>.
  * @param obj <code>PersistentObject</code> from which to get the object value.
  * @param value value to set.
  */
  public void set(PersistentObject obj, Object value) {
	if (getterSetterImpl == null) {
		if (writeMethodName == null)
			return; // OK.
		try {
			Method m = obj.getClass().getMethod(writeMethodName,new Class [] {type} );
			m.invoke(obj,new Object [] {value});		
		}
		catch (Exception ex) {
			String error = "Unable to evoke "+writeMethodName+"("+type.getName()+") for "+obj.getClass();
			LOG.error(error,ex);
			throw new IllegalArgumentException(error);
		}	
	}
	else {
		getterSetterImpl.set(obj,value);
	}
   }


   /** Validates the column value againsts either a list of values, a specified
   * minimum or maximum value.   
   * sub-classes.
   * @param obj <code>Object</code> instance to check.
   * @throws InvalidValueException if validation fails.
   * @see net.sf.jrf.exceptions.InvalidValueException
   */
  public void validate(Object obj) throws InvalidValueException {
	if (obj == null) {
		if (required) 
			throw new InvalidValueException(getName(),InvalidValueException.TYPE_REQUIRED);
	}
	else {
		if (!isAssignableFrom(obj) ) {
			throw new InvalidValueException(getType().getName(),InvalidValueException.TYPE_INVALID_VALUE_TYPE);
		}
		if (this.maxSize > 0) {
			if (obj instanceof java.lang.String) {
				String s = (String) obj;
				if (s.length() > this.maxSize)
					throw new InvalidValueException(this.maxSize,obj);
			}
			// TODO -- other types - or changes to ColumnSpec.
		}
		if (maxValue != null && maxValue.compareTo(obj) < 0)
        	    	throw new InvalidValueException(InvalidValueException.TYPE_GREATER_THAN_MAXIMUM,maxValue,obj);
        	else if (minValue != null && minValue.compareTo(obj) > 0)
                	throw new InvalidValueException(InvalidValueException.TYPE_LESS_THAN_MINIMUM,minValue,obj);
           	else if (listOfValues != null && !listOfValues.contains(obj) )
                	throw new InvalidValueException(listOfValues,obj);
	}
    }

   // Check for primitives if necessary.
   private boolean isAssignableFrom(Object obj) {
	if (primitiveWrapperClass != null && primitiveWrapperClass.equals(obj.getClass())  ) {
		return true;
	}
	if (this.getType().isAssignableFrom(obj.getClass()) ) 
		return true;
	return false;
   }

  /** Returns <code>true</code> if property is indexed (array or list)
   * @return <code>true</code> if property is indexed (array or list)
   */
  public boolean isIndexed() {
	return this.indexed;
  }

  /** Returns <code>true</code> if property is mapped.
   * @return <code>true</code> if property is mapped.
   */
  public boolean isMapped() {
	return this.mapped;
  }

  /** Sets primary key status.
   * @param primaryKey primary key status of the attribute.
   */
  public void setPrimaryKey(boolean primaryKey) {
    	this.primaryKey = primaryKey;
	this.writeOnce = true;
  }

  /** Returns true if attribute is a primary key.
  * @return true if attribute is a primary key.
  */
  public boolean isPrimaryKey() {
	return this.primaryKey;
  }
  
  /** Sets optimistic lock status.
   * @param optimisticLock optimistic lock status of the attribute.
   */
  public void setOptimisticLock(boolean optimisticLock) {
    	this.optimisticLock = optimisticLock;
  }

  /** Gets optimistic lock status.
   * @return optimistic lock status of the attribute.
   */
  public boolean isOptimisticLock() {
    	return this.optimisticLock;
  }

  /** Sets required status.
   * @param required required status of the attribute.
   */
  public void setRequired(boolean required) {
    	this.required = required;
  }

  /** Gets required status.
   * @return required status of the attribute.
   */
  public boolean isRequired() {
    	return this.required;
  }

   /** Returns <code>true</code> if this attribute is written to database only once upon
   * row creation.
   * @return "write once" status of the attrbute.
   */
   public boolean isWriteOnce() {
        return this.writeOnce;
   }

    /** Sets the "write once" status of the attribute.
    * @param writeOnce write once status.
    * @see #isWriteOnce()
    */
    public void setWriteOnce(boolean writeOnce) {
        this.writeOnce = writeOnce;
    }


  /** Sets db column status.
   * @param dbColumn if <code>true</code> attribute is a database column.
   */
  public void setDbColumn(boolean dbColumn) {
    	this.dbColumn = dbColumn;
  }

  /** Gets db column status.
   * @return db column status of the attribute.
   */
  public boolean isDbColumn() {
    	return this.dbColumn;
  }

  /** Sets maximum size of the attribute.
   * @param maxSize maximum size of the attribute.
   */
  public void setMaxSize(int maxSize) {
    	this.maxSize = maxSize;
  }

  /** Gets maximum size of the attribute.
   * @return maximum size of the attribute.
   */
  public int getMaxSize() {
    	return this.maxSize;
  }

  /** Sets default value.
   * @param value default value.
   */
  public void setDefaultValue(Object defaultValue) {
    	this.defaultValue = defaultValue;
  }

  /** Gets default value.
   * @return default value.
   */
  public Object getDefaultValue() {
	if (defaultValue != null)
    		return this.defaultValue;
	Class cls = getType();
	if (primitiveWrapperClass != null) {
            if (cls.equals(Boolean.TYPE))
		   return new Boolean(false);
	    else if (cls.equals(Byte.TYPE))
		   return new Byte((byte) 0);
	    else if (cls.equals(Character.TYPE))
		   return new Character((char) 0);
	    else if (cls.equals(Double.TYPE))
		   return new Double((double) 0);
	    else if (cls.equals(Float.TYPE))
		   return new Float((float) 0);
	    else if (cls.equals(Integer.TYPE))
		   return new Integer((int) 0);
	    else if (cls.equals(Long.TYPE))
		   return new Long((long) 0);
	    else if (cls.equals(Short.TYPE))
		   return new Short((short) 0);
	    else
		   return null;
	}
	else 
		return null;
  }

  /** Returns the implementation of <code>GetterSetter</code>.
   * @return attribute specification's <code>GetterSetter</code> implementation.
   * @see net.sf.jrf.column.GetterSetter
   */
  public GetterSetter getGetterSetter() {
    return getterSetterImpl;
  }

  /** Sets the implementation of <code>GetterSetter</code>.
   * @param getterSetterImpl <code>GetterSetter</code> implementation.
   * @see net.sf.jrf.column.GetterSetter
   */
  public void setGetterSetter(GetterSetter getterSetterImpl) {
     if (getterSetterImpl != null && getterSetterImpl instanceof java.io.Serializable) {
     	this.readMethodName = null; // Dereference this; not needed.
        this.writeMethodName = null; // Ditto.
        this.getterSetterImpl = getterSetterImpl;
     }
  }

  /** Gets the read method name.
   * @return read method name.
  */
  public String getReadMethodName() {
      return this.readMethodName;
  }

  /** Gets the read method name.
   * @return read method name.
  */
  public String getWriteMethodName() {
      return this.writeMethodName;
  }

   /** Sets the maximum allowable value.
    * @param maxValue implementation of <code>Comparable</code>.
    */
   public void setMaxValue(Comparable maxValue) {
        this.maxValue = maxValue;
   }

   /** Sets the minimum allowable value.
    * @param minValue implementation of <code>Comparable</code>.
    */
   public void setMinValue(Comparable minValue) {
        this.minValue = minValue;
   }

   /** Gets the minimum allowable value.
    * @return mininum value.
    */
   public Comparable getMinValue() {
        return this.minValue;
   }

   /** Gets the maximum allowable value.
    * @return maximum value.
    */
   public Comparable getMaxValue() {
        return this.maxValue;
   }

   /** Sets the acceptable list of values for the attribute.
    * @param listOfValue acceptable list of values.
    */
   public void setListOfValues(List listOfValues) {
        this.listOfValues = listOfValues;
   }

   /** Gets the acceptable list of values for the attribute.
    * @return acceptable list of values.
    */
   public List getListOfValues() {
        return this.listOfValues;
   }

}
