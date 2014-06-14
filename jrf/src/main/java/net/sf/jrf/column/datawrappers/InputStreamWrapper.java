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
package net.sf.jrf.column.datawrappers;

import java.io.IOException;
import java.io.InputStream;
import net.sf.jrf.column.*;

import org.apache.log4j.Category;
/**
 * A simple wrapper class over an input stream that may act
 * a the column class for <code>BinaryStreamColumnSpec</code>.
 *
 * @see   net.sf.jrf.column.columnspecs.BinaryStreamColumnSpec
 */
public class InputStreamWrapper extends InputWrapper
{

    final static Category LOG = Category.getInstance(InputStreamWrapper.class.getName());

    /**
     * Constructs a wrapper. <code>SetInput()</code>
     * must be called.
     *
     * @see   #setInput(Object,int)
     */
    public InputStreamWrapper()
    {
        super();
    }

    /**
     * Constructs a wrapper setting  both input stream
     * and full length of data.
     *
     * @param stream         input stream
     * @param storageLength  length of all underlying data, which may not necessarily
     *			 be the same value as the one returned from the <code>InputStream.available()</code>
     *			 method.
     */
    public InputStreamWrapper(InputStream stream, int storageLength)
    {
        setInput(stream, storageLength);
    }

    /**
     *Constructor for the InputStreamWrapper object
     *
     * @param stream  Description of the Parameter
     */
    public InputStreamWrapper(InputStream stream)
    {
        super.data = stream;
        try
        {
            super.storageLength = stream.available();//
        }
        catch (IOException io)
        {
            LOG.error("Error constructing InputStream wrapper", io);
        }
        if (LOG.isDebugEnabled())
        {
            LOG.debug(this.hashCode() + ": Constructed InputStream data of " + super.storageLength + " bytes from JDBC call.");
        }
    }

    /**
     * Returns the underlying input stream.
     *
     * @return   underlying input stream.
     */
    public InputStream getStream()
    {
        if (LOG.isDebugEnabled())
        {
            LOG.debug("getStream() called: " + this.toString());
        }
        return (InputStream) super.data;
    }

    /**
     * Sets both input stream and full length of data.
     *
     * @param stream         input stream
     * @param storageLength  length of all underlying data, which may not necessarily
     *			 be the same value as the one returned from the <code>InputStream.available()</code>
     *			 method.
     */
    public void setInput(InputStream stream, int storageLength)
    {
        super.setInput(stream, storageLength);
        if (LOG.isDebugEnabled())
        {
            LOG.debug("setInput() called: " + this.toString());
        }
    }

    /**
     * Returns current status of object.
     *
     * @return   formatted status of object.
     */
    public String toString()
    {
        if (super.data == null)
        {
            return "No data stored.";
        }
        InputStream i = (InputStream) super.data;
        StringBuffer result = new StringBuffer();
        result.append(this.hashCode() + ": ");
        try
        {
            result.append("available() returns " + i.available());
        }
        catch (IOException io)
        {
            result.append("Error on available() call: " + io.getMessage());
        }
        result.append(" storageLength value set to " + super.storageLength);
        return result.toString();
    }
}
