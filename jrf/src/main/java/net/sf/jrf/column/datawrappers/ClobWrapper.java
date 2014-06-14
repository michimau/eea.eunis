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
import java.io.Reader;
import java.sql.Clob;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import net.sf.jrf.*;
import net.sf.jrf.column.*;
import net.sf.jrf.join.*;
import net.sf.jrf.sql.*;

/**
 * A wrapper class for CLOB objects that is column class for <code>CLOBColumnSpec</code>.
 * Applications to have complete flexibility on setting the form of input for database
 * saves.  A call to any of the <code>setInputData...</code> methods overrides any
 *  previous setting.    The framework will use the most recent <code>setInput</code>
 *  call to determine which underlying JDBC <code>PreparedStatement</code> method will be
 *  used (e.g. <code>PreparedStateme.setAsciiStream()</code>).
 * <p>
 *  Which input form to use may change to fit a given application context.
 *  For example, with this simple <code>PersistentObject</code> and
 *  associated <code>AbstractDomain</code>:
 *  <p>
 *  <pre>
 *	public class MailMessage extends PersistentObject   {
 *
 *	private String   mId            = null;
 *    private CLOBWrapper message;
 *
 *	public String getId() {
 *	    return mId;
 *    }
 *  	public void setId(String mId)  {
 *		this.mId = mId;
 *	     this.markModifiedPersistentState();
 *    }
 *    public CLOBWrapper getMessage()   {
 *    	return data;
 *    }
 *	public void setMessage(CLOBWrapper message) {
 *    	this.message = message;
 *    this.markModifiedPersistentState();
 *    }
 *  }
 * <p>
 *
 *   public class MailMessageDomain extends AbstractDomain {
 *   .
 *   .
 *	protected void setup() {
 *    	this.setTableName("MAIL_MESSAGE");
 *	     StringColumnSpec s =
 *	        new StringColumnSpec(
 *     	       "MID",  // Column Name
 *	            "getCode",
 *     	       "setCode",
 *          	  DEFAULT_TO_NULL,
 *	            NATURAL_PRIMARY_KEY);
 *	    s.setMaxLength(2);
 *	    s.setVariable(false);
 *	    // Column Specs
 *	    this.addColumnSpec(s);
 *
 *    CLOBColumnSpec c = new CLOBCOlumnSpec(
 *			"MESSAGE",
 *			"getMessage",
 *			"setMessage",
 *            	DEFAULT_TO_NULL,
 *			ColumnSpec.REQUIRED);
 *
 *	c.setMaxLength(0);	// Unlimited.
 *	c.setVariable(true);
 *	c.setBlockSize(0);
 *	c.setSqlType(this.getDatabasePolicy());
 *	this.addColumnSpec(c);
 *    }
 *  </pre>
 *  <p>
 * Interaction with the table through the framework might look like:
 * <p>
 * <pre>
 *	String key = "123";
 *	MailMessage m = new MailMessage();
 *	MailMessageDomain mDomain = new MailMessageDomain();
 *	m.setId(key);
 *	CLOBWrapper w = new CLOBWrapper();
 *	// Pop in a file
 *	File f = new File("somefile.txt");
 *	w.setInput(new BufferedReader(new FileReader(f),f.length());
 *	.
 *	.
 *	mDomain.save(m);
 *	MailMessage mGet = mDomain.find(key);
 *	.
 *	Clob c = mGet.getMessage().getCLOB();
 *	long dataLen = c.length();
 *	// Using the JDBC driver's pattern match method (position()),
 *	// find a string in the file.
 *	// Fetch the stream, skip to where the pattern begins
 *	InputStream stream = c.getAsciiStream();
 *	long skipped = stream.skip(c.position("ABCD"),1));
 *	// Read data from given point.
 *	.   etc.
 * </pre>
 *
 * @see   net.sf.jrf.column.columnspecs.ClobColumnSpec
 */
public class ClobWrapper extends InputWrapper
{

    private final static int INPUTTYPE_CLOB = 1;
    private final static int INPUTTYPE_STRING = 2;
    private final static int INPUTTYPE_STRINGBUFFER = 3;
    private final static int INPUTTYPE_ASCIISTREAM = 4;
    private final static int INPUTTYPE_READER = 5;

    private int inputType;

    /**
     * Constructs a default CLOBWrapper object with
     * the default input type of CLOB.  Input object is initialized
     * to <code>null</code>.
     */
    public ClobWrapper()
    {
        super();
        inputType = INPUTTYPE_CLOB;
    }

    /**
     * Scope constructor for use by ClobColumnSpec *
     *
     * @param c                 Description of the Parameter
     * @exception SQLException  Description of the Exception
     */
    public ClobWrapper(Clob c)
        throws SQLException
    {
        setInput(c);
    }

    /**
     * Returns underlying <code>CLOB</code> or <code>null</code>
     * if none exists.
     *
     * @return   wrapped <code>CLOB</code>.
     */
    public Clob getClob()
    {
        if (this.inputType != INPUTTYPE_CLOB)
        {
            throw new IllegalStateException("Underlying object is not a Clob.");
        }
        return (Clob) super.data;
    }

    /**
     * Sets the input data and underlying CLOB object.
     *
     * @param clob           <code>CLOB</code> object to use for next database save operation.
     * @throws SQLException  if thrown by <code>Clob.length()</code>.
     */
    public void setInput(Clob clob)
        throws SQLException
    {
        this.inputType = INPUTTYPE_CLOB;
        super.setInput(clob, (int) clob.length());
    }

    /**
     * Sets the input data to an <code>String</code>.
     *
     * @param string  <code>String</code> to use for next database save operation.
     */
    public void setInput(String string)
    {
        this.inputType = INPUTTYPE_STRING;
        super.setInput(string, string.length());
    }

    /**
     * Sets the input data to a String buffer.
     *
     * @param buf  <code>StringBuffer</code> to use for next database save operation.
     */
    public void setInput(StringBuffer buf)
    {
        this.inputType = INPUTTYPE_STRINGBUFFER;
        super.setInput(buf, buf.length());
    }

    /**
     * Sets the input data to an <code>InputStream</code>..
     *
     * @param stream         <code>InputStream</code> to use for next database save operation.
     * @param storageLength  length to store.
     */
    public void setInput(InputStream stream, int storageLength)
    {
        this.inputType = INPUTTYPE_ASCIISTREAM;
        super.setInput(stream, storageLength);
    }

    /**
     * Sets the input data to an <code>Reader</code>..
     *
     * @param reader         <code>Reader</code> to use for next database save operation.
     * @param storageLength  length to store.
     */
    public void setInput(Reader reader, int storageLength)
    {
        this.inputType = INPUTTYPE_READER;
        super.setInput(reader, storageLength);
    }

    /**
     * Stores data based on current input type, calling the appropriate
     * underlying JDBC <code>setPreparedStatement</code> method.
     *
     * @param stmt           prepared statement wrapper containing the <code>Clob</code> column.
     * @param pos            index of column in SQL statement.
     * @param sqlType        data type from <code>java.sql.Type</code>.
     * @throws SQLException  if error occurs setting data for prepared statement.
     */
    public void storeData(JRFPreparedStatement stmt, int pos, int sqlType)
        throws SQLException
    {
        switch (this.inputType)
        {
            case INPUTTYPE_CLOB:
                stmt.setClob(super.data, pos);
                break;
            case INPUTTYPE_STRING:
                stmt.setString(super.data, pos, sqlType);
                break;
            case INPUTTYPE_STRINGBUFFER:
                stmt.setString(super.data.toString(), pos, sqlType);
                break;
            case INPUTTYPE_ASCIISTREAM:
                stmt.setAsciiStream(super.data, pos, super.storageLength, sqlType);
                break;
            case INPUTTYPE_READER:
                stmt.setCharacterStream(super.data, pos, super.storageLength, sqlType);
                break;
        }
    }

}
