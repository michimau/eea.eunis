/**
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
 */
package net.sf.jrf.column.columnoptions;

import net.sf.jrf.column.ColumnOption;

/** */
public class SequencedPrimaryKeyColumnOption
     extends PrimaryKeyColumnOption
{

    /**Constructor for the SequencedPrimaryKeyColumnOption object */
    public SequencedPrimaryKeyColumnOption()
    {
        super();
        i_sequencedPrimaryKey = true;
    }
}
