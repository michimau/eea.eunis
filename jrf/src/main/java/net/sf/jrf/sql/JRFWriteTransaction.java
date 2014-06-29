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
 * The Initial Developer of the Original Code is is.com (bought by wamnet.com).
 * Portions created by is.com are Copyright (C) 2000 is.com.
 * All Rights Reserved.
 *
 * Contributor: James Evans jevans@vmguys.com
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
package net.sf.jrf.sql;

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;
import net.sf.jrf.*;
import net.sf.jrf.domain.*;
import net.sf.jrf.exceptions.*;
import org.apache.log4j.Category;

/**
 * Utility class for handling write transactions among multiple
 * domains with multiple connections.
 */
public class JRFWriteTransaction extends JRFTransaction
{

    private final static Category LOG = Category.getInstance(JRFWriteTransaction.class.getName());

    /**
     * Constructs a <code>JRFTransaction</code>, setting the should synchronize connections
     * attribute to <code>true</code>.
     */
    public JRFWriteTransaction()
    {
        super();
    }

    /**
     * Constructs a <code>JRFTransaction</code>, using connection synchronization value.
     *
     * @param shouldSynchronizeConnections  Description of the Parameter
     */
    public JRFWriteTransaction(boolean shouldSynchronizeConnections)
    {
        super(shouldSynchronizeConnections);
    }

    /** Description of the Method */
    public void beginTransaction()
    {
        super.beginTransaction();
    }

    /** Rolls back all connections. */
    public void abortTransaction()
    {
        runComplete(false, 0);
    }

    /** Ends a transaction. */
    public void endTransaction()
    {
        runComplete(true, 0);
    }


    private void runComplete(boolean commit, long start)
    {
        TransactionCompleter c = new TransactionCompleter(commit, null);
        c.run();
    }

    // Leave this as a timer task for future changes.

    //private class TransactionCompleter extends TimerTask {    // 1.2 does not support.:w
    private class TransactionCompleter
    {
        private boolean commit;
        private Object waiter;

        TransactionCompleter(boolean commit, Object waiter)
        {
            this.commit = commit;
            this.waiter = waiter;
        }

        public void run()
        {
            try
            {
                int total = jrfConnections.size();
                if (LOG.isDebugEnabled())
                {
                    LOG.debug("run(): Begin " + (commit ? "endTransaction()" : "abortTransaction") + "\n" + showAll());
                }
                if (total == 0)
                {
                    throw new IllegalStateException(this +
                        ": Attempting to abort or commit a transaction without any connections!");
                }
                SQLException error = null;
        int count = 0;
                for (int i = 0; i < total; i++)
                {
                    JRFConnection c = (JRFConnection) jrfConnections.elementAt(i);
                    // The connection may not be open because for this particular transaction,
                    // no activity took place for a domain. Check closed flag; if set, skip.
                    if (!c.isConnectionOpen())
                    {
                        continue;
                    }
                    if (error != null)
                    {// Error has occurred; just close up.
                        c.closeOrReleaseResources();
                        continue;
                    }
            count++;
                    try
                    {
                        if (commit)
                        {
                            c.commit();
                        }
                        else
                        {
                            c.rollback();
                        }
                        if (LOG.isDebugEnabled())
                        {
                            LOG.debug("Successful " + (commit ? "commit " : "rollback ") + "of connection " + c.connection);
                        }
                    }
                    catch (SQLException ex)
                    {
                        // Get the first exception throw -- something at least.
                        if (error == null)
                        {
                            error = ex;
                        }// In very serious trouble here.
                        LOG.error("Failed " + (commit ? "commit " : "rollback ") + (i + i) + " of " + total + ": " + c.connection, ex);
                    }
                    finally
                    {
                        c.closeOrReleaseResources();
                    }
                }
                clearTransactionStateFlags();
                clear();
                if (error != null)
                {
                    throw new DatabaseException(error, "Commit/Rollback error.");
                }
                if (LOG.isDebugEnabled())
                {
                    LOG.debug("Successful " + (commit ? "commit " : "rollback ") + "of " + count + " connection(s)");
                }
            }
            finally
            {
                if (waiter != null)
                {
                    waiter.notify();
                }
            }
        }
    }

}
