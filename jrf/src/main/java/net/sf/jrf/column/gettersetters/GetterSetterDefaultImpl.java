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

import net.sf.jrf.column.AbstractColumnSpec;
import net.sf.jrf.column.GetterSetter;
import net.sf.jrf.domain.PersistentObject;

/**
 * Default implementation of GetterSetter which uses
 * the original reflection methodology.
 */
public class GetterSetterDefaultImpl implements GetterSetter
{

    private Class i_colClass;
    private String i_getter;
    private String i_setter;
    private boolean i_setterIsFunctional = false;
    private boolean i_getterIsFunctional = false;

    /**
     * Constructs a reflection-based <code>GetterSetter</code>.
     *
     * @param colClass  column class.
     * @param getter    get method name.
     * @param setter    set method name.
     */
    public GetterSetterDefaultImpl(Class colClass, String getter, String setter)
    {
        this.i_setter = setter;
        this.i_getter = getter;
        this.i_colClass = colClass;
        this.i_setterIsFunctional = (i_setter != null && i_setter.length() > 0 ? true : false);
        this.i_getterIsFunctional = (i_getter != null && i_getter.length() > 0 ? true : false);
    }

    /**
     * Returns <code>true</code> if <code>set</code> is actually
     *  functional (e.g sets a value).
     *
     * @return   <code>true</code> if <code>set</code> is functional.
     * @see      #set(PersistentObject,Object)
     */
    public boolean setterIsFunctional()
    {
        return this.i_setterIsFunctional;
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
            AbstractColumnSpec.setValueTo(aValue,
                aPO,
                i_setter,
                i_colClass);
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
            return AbstractColumnSpec.getValueFrom(aPO,
                i_getter,
                deflt);
        }
        return null;
    }
}
