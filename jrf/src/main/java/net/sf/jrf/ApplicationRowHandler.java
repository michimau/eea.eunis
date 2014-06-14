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
 * Contributor: Jonathan Carlson (joncrlsn@users.sf.net)
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
package net.sf.jrf;

import net.sf.jrf.domain.PersistentObject;

/**
 * A simple interface to applications to handle the results of each data row from a
 * database query, where the <code>PersistentObject</code> instance has been constructed by
 * the framework.  This class offers an alternative to the inner-interface of <code>AbstractDomain</code>
 * where row-by-row processing is handled at the <code>java.sql.ResultSet</code> level.
 * This interface was primarily designed for the handling of
 * blob, clobs and streams.  Applications must have the capability of calling
 * stream methods on the current result set before <code>next()</code> is called,
 * which will close all streams on the row.
 * <p>
 * Example usage with Blobs:
 * <pre>
 *  public class BlobData {
 *  		private BlobWrapper b;
 *		private String key;
 *     	.
 *		.
 *		public getData() {
 *			return this.b;
 *		}
 * .
 * .
 * private class MyBlobHandler implements ApplicationRowHandler {
 *
 *	public boolean processRow(PersistentObject aPO) {
 *		BlobData bd= (BlobData) aPO;
 *		Blob b = bd.getData().getBlob();
 *		.	// call some blob methods.
 *		.
 *		return true;
 *	}
 * }
 * .
 * .
 * BlobDataDomain bDomain = new BlobDataDomain();
 * .
 * .
 * MyBlobHandler bh = new MyBlobHandler();
 * bDomain.find("2345",b);
 * // etc.
 * </pre>
 * <p>
 *
 * @see   net.sf.jrf.domain.AbstractDomain.RowHandler
 */
public interface ApplicationRowHandler
{

    /**
     * Returns <code>true</code> if next row, if any, should be fetched by the framework.
     *
     * @param obj  persistent object to process.
     * @return     <code>true</code> if framework should fetch the next row.
     */
    public boolean processRow(PersistentObject obj);


    /**
     * Returns resulting object constructed by each call to <code>processRow</code>, if any.
     *
     * @return   constructed object built from iterative calls to <code>processRow()</code> or <code>null</code>
     * if not applicable.
     */
    public Object getResult();

    /**
     * Clears any underlying data structures, if any, to prepare for a new query.
     */
    public void clear();
}
