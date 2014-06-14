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
package net.sf.jrf.exceptions;

import org.apache.log4j.Category;

/**
 * This class provides an abstract superclass for the non-runtime
 * exceptions. This is a convenience so that callers can simply catch (or
 * declare) DomainException, rather than individually naming all of the
 * subclasses that might get called.
 */
public abstract class DomainException
     extends Exception
{

    private final static Category LOG =
        Category.getInstance(DomainException.class.getName());

    // making the empty constructor private ensures that it isn't called
    private DomainException()
    {
        super();
    }

    /**
     *Constructor for the DomainException object
     *
     * @param message  Description of the Parameter
     */
    public DomainException(String message)
    {
        super(message);
        if (message == null || message.length() == 0)
        {
            LOG.debug("No message", this);
        }
        else
        {
            LOG.debug(this.getMessage(), this);
        }
    }

}// DomainException
