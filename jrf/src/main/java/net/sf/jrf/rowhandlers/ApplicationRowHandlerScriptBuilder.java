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
package net.sf.jrf.rowhandlers;

import java.io.*;
import java.util.*;
import net.sf.jrf.ApplicationRowHandler;
import net.sf.jrf.domain.*;

/**
 * An implementation of <code>ApplicationRowHandler</code> that
 * builds an insert scripts for the domain, embedded objects and all.
 */
public class ApplicationRowHandlerScriptBuilder implements ApplicationRowHandler
{

    protected AbstractDomain domain = null;
    protected PrintWriter writer = null;
    protected boolean includeImplicitInsertCols = false;

    /**Constructor for the ApplicationRowHandlerScriptBuilder object */
    public ApplicationRowHandlerScriptBuilder() { }

    /**
     *Constructor for the ApplicationRowHandlerScriptBuilder object
     *
     * @param domain                     Description of the Parameter
     * @param writer                     Description of the Parameter
     * @param includeImplicitInsertCols  Description of the Parameter
     */
    public ApplicationRowHandlerScriptBuilder(AbstractDomain domain, PrintWriter writer, boolean includeImplicitInsertCols)
    {
        this.domain = domain;
        this.writer = writer;
        this.includeImplicitInsertCols = includeImplicitInsertCols;
    }

    /**
     * Sets <code>AbstractDomain</code> to use.
     *
     * @param includeImplicitInsertCols  if <code>true</code> implicit column status will be ignored; all values
     *                      will be inserted.
     */
    public void setIncludeImplicitInsertCols(boolean includeImplicitInsertCols)
    {
        this.includeImplicitInsertCols = includeImplicitInsertCols;
    }

    /**
     * Sets <code>AbstractDomain</code> to use.
     *
     * @param domain  <code>AbstractDomain</code> instance.
     */
    public void setDomain(AbstractDomain domain)
    {
        this.domain = domain;
    }

    /**
     * Sets <code>PrintWriter</code> to use.
     *
     * @param writer  <code>PrintWriter</code> instance.
     */
    public void setWriter(PrintWriter writer)
    {
        this.writer = writer;
    }

    /**
     * Returns <code>true</code> if next row, if any, should be fetched by the framework.
     *
     * @param aPO  Description of the Parameter
     * @return     <code>true</code> if framework should fetch the next row.
     */
    public boolean processRow(PersistentObject aPO)
    {
        this.domain.generateInsertScript(aPO, writer, includeImplicitInsertCols);
        return true;
    }

    /**
     * Returns <code>null</code> for this implementation.
     *
     * @return   <code>null</code>.
     */
    public Object getResult()
    {
        return null;
    }

    /** Description of the Method */
    public void clear()
    {
    }

}
