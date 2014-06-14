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
 * Contributor: ______________________________
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
package net.sf.jrf.util;

import java.io.*;
import java.sql.*;

import net.sf.jrf.sql.*;
import org.apache.log4j.Category;
import org.vmguys.appgen.*;

/**
 * Executes all SQL statements scripts in a given source file.
 * Assumes comments in file match Java's (/*).
 */
public class ScriptRunner
{

    private static Category LOG = Category.getInstance(ScriptRunner.class.getName());
    private static char QUOTE = '\'';

    ScriptRunner(String fileName, boolean stopOnError, char commandSeparator)
        throws FileNotFoundException, IOException
    {
        StringBuffer contents = new StringBuffer();
        StringBuffer line = new StringBuffer();
        CodeGenUtil.readFile(fileName, contents);
        int i = 0;
        JRFConnection conn = JRFConnectionFactory.create();
        StatementExecuter sqlExec = conn.getStatementExecuter();
        int lineNum = 0;
        while (i < contents.length())
        {
            try
            {
                i = getLine(i, contents, line, commandSeparator);
                if (line.length() == 0)
                {
                    break;
                }
                lineNum++;
                LOG.debug("Executing [" + line + "]");
                sqlExec.executeUpdate(line.toString());
            }
            catch (IllegalArgumentException ex)
            {
                LOG.error("Script parsing error; unable to continue. Offset is " + i + "; execution line is " + lineNum, ex);
                break;
            }
            catch (SQLException ex)
            {
                LOG.error("Error executing " + line.toString(), ex);
                if (stopOnError)
                {
                    System.out.println("Stopping on SQL error. See logs. Statement was: ");
                    System.out.println(line.toString());
                    break;
                }
            }
        }
    }

    private int getLine(int offset, StringBuffer contents, StringBuffer line, char commandSeparator)
    {

        line.setLength(0);
        offset = CodeGenUtil.findFirstNonCommentedOutCharacter(contents, offset);
        boolean inQuotes = false;
        while (offset < contents.length())
        {
            char c1 = (char) contents.charAt(offset++);
            if (c1 == QUOTE)
            {
                char c2;
                line.append(c1);
                if (offset == contents.length())
                {
                    throw new IllegalArgumentException("Error in script file; no terminating quote: " + line.toString());
                }
                c2 = (char) contents.charAt(offset++);
                line.append(c2);
                if (inQuotes)
                {
                    // Handle double quotes.
                    if (c1 != c2)
                    {// escaped quotes.
                        inQuotes = false;
                    }
                }
                else
                {
                    inQuotes = true;
                }
            }
            else if (c1 == commandSeparator && !inQuotes)
            {
                break;
            }
            else
            {
                line.append(c1);
            }
        }
        return offset;
    }

    /**
     * Main run method.
     * Arguments:
     * 0 file name to run.
     * 1 stop on error (true/false)
     *
     * @param args  Description of the Parameter
     */
    public static void main(String args[])
    {
        if (args.length < 2)
        {
            System.err.println("Usage java net.sf.jrf.util.ScriptRunner filename stoponerror(true/false) commandSeparator. ");
            System.exit(0);
        }
        try
        {
            ScriptRunner run = new ScriptRunner(args[0], new Boolean(args[1]).booleanValue(), args[2].charAt(0));
        }
        catch (Exception e)
        {
            System.out.println("Failed run; see logs");
            LOG.error("Run failed: ", e);
        }
    }
}




