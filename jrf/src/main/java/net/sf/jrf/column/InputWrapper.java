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
package net.sf.jrf.column;

/**
 * A simple wrapper class over an input data that wraps the underlying data
 * and length.
 */
public abstract class InputWrapper
{
    protected Object data = null;
    protected int storageLength = 0;

    /**
     * Constructs a wrapper.
     *
     * @see   #setInput(Object,int)
     */
    public InputWrapper() { }

    /**
     * Constructs a wrapper setting  both input stream
     * and full length of data.
     *
     * @param data           input data
     * @param storageLength  length of all underlying data, which may not necessarily
     *			 be the same value as the one returned from the <code>InputStream.available()</code>
     *			 method.
     */
    public InputWrapper(Object data, int storageLength)
    {
        setInput(data, storageLength);
    }

    /**
     * Returns underlying storage length.
     *
     * @return   underlying storage length.
     */
    public int getLength()
    {
        return this.storageLength;
    }

    /**
     * Returns the underlying data object.
     *
     * @return   underlying data object.
     */
    protected Object getData()
    {
        return this.data;
    }

    /**
     * Sets both object and full storage length of data.
     *
     * @param storageLength  length of all underlying data, which may not necessarily
     *			 be the same value as the one returned from the <code>InputStream.available()</code>
     *			 method.
     * @param data           The new input value
     */
    public void setInput(Object data, int storageLength)
    {
        this.data = data;
        this.storageLength = storageLength;
    }

}
