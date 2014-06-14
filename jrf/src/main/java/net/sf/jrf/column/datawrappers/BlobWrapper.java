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

import java.io.InputStream;
import java.sql.Blob;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import net.sf.jrf.*;
import net.sf.jrf.column.*;
import net.sf.jrf.join.*;
import net.sf.jrf.sql.*;

/**
 * A wrapper class for BLOB objects.  Since <code>Blob</code>s cannot
 * be directly instantiated by an application user, a wrapper class is
 * required in order to  comply with the column specification paradigm,
 * which is a that a specific object type is associated with a specific column.
 * This class supports a concept of an "input type".  In other words,
 * in insert contexts, the input type may be binary stream (user calls
 * <code>setInput(InputStream)</code>) or an array of bytes
 * (user calls <code>setInput(byte[])).  On rare occasions, when
 * a <code>Blob</code> object exists in another table, <code>setInput(Blob)</code>
 * may be called for a data insert.  The class contains an internal method
 * to call the appropriated JDBC <code>PreparedStatement</code> method dependent
 * on the type.
 * <p>
 * For data fetches, user may call <code>getBlob</code> to manipulate data as required
 * by an application.
 *
 * @see   net.sf.jrf.column.columnspecs.BlobColumnSpec
 */
public class BlobWrapper extends InputWrapper
{

    private final static int INPUTTYPE_BLOB = 1;
    private final static int INPUTTYPE_BINARYSTREAM = 2;
    private final static int INPUTTYPE_BYTES = 3;
    private int inputType;

    /**
     * Constructs a default BlobWrapper object with
     * the default input type of Blob.  Input object is initialized
     * to <code>null</code>.
     */
    public BlobWrapper()
    {
        inputType = INPUTTYPE_BLOB;
    }

    /**
     * Constructor for use by ClobColumnSpec *
     *
     * @param b                 Description of the Parameter
     * @exception SQLException  Description of the Exception
     */
    public BlobWrapper(Blob b)
        throws SQLException
    {
        setInput(b);
    }

    /**
     * Returns underlying <code>Blob</code> or <code>null</code>
     * if none exists.
     *
     * @return   wrapped <code>Blob</code>.
     */
    public Blob getBlob()
    {
        if (this.inputType != INPUTTYPE_BLOB)
        {
            throw new IllegalStateException("Underlying object is no a blob.");
        }
        return (Blob) super.data;
    }

    /**
     * Sets the input data and underlying <code>Blob</code> object.
     *
     * @param blob           <code>Blob</code> object to use for next database save operation.
     * @throws SQLException  if thrown by <code>Blob.length()</code>.
     */
    public void setInput(Blob blob)
        throws SQLException
    {
        this.inputType = INPUTTYPE_BLOB;
        super.setInput(blob, (int) blob.length());
    }

    /**
     * Sets the input data to an <code>InputStream</code>..
     *
     * @param stream         <code>InputStream</code> to use for next database save operation.
     * @param storageLength  length to store.
     */
    public void setInput(InputStream stream, int storageLength)
    {
        this.inputType = INPUTTYPE_BINARYSTREAM;
        super.setInput(stream, storageLength);
    }

    /**
     * Sets the input data to an <code>byte</code> array. Length is assumed to be
     * the length of the array.
     *
     * @param b  <code>byte</code> array to use for next database save operation.
     */
    public void setInput(byte b[])
    {
        this.inputType = INPUTTYPE_BYTES;
        super.setInput(b, b.length);
    }

    /**
     * Stores data based on current input type, calling the appropriate
     * underlying JDBC <code>setPreparedStatement</code> method.
     *
     * @param stmt           prepared statement wrapper
     * containing the <code>Blob</code> column.
     * @param pos            index of column in SQL statement.
     * @param sqlType        data type from <code>java.sql.Type</code>.
     * @throws SQLException  if error occurs setting data for prepared statement.
     */
    public void storeData(JRFPreparedStatement stmt, int pos, int sqlType)
        throws SQLException
    {
        switch (this.inputType)
        {
            case INPUTTYPE_BLOB:
                stmt.setBlob(super.data, pos);
                break;
            case INPUTTYPE_BINARYSTREAM:
                stmt.setBinaryStream(super.data, pos, super.storageLength, sqlType);
                break;
            case INPUTTYPE_BYTES:
                stmt.setBytes(super.data, pos, sqlType);
                break;
        }
    }

}
