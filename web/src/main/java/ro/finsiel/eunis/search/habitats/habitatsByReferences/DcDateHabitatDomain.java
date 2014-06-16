package ro.finsiel.eunis.search.habitats.habitatsByReferences;


import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.join.JoinTable;
import net.sf.jrf.join.joincolumns.DateJoinColumn;
import net.sf.jrf.join.joincolumns.StringJoinColumn;
import ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksPersist;


/**
 * This class isn't really a Domain (JRF domain) but emulates the domain functionality in order to follow the
 * requirements of framework to act as a 'Data factory'. Used in habitats->references search.
 * @author finsiel
 */
public class DcDateHabitatDomain extends AbstractDomain {

    /**
     *  Returns new instance of the <code>PersistentObject</code> managed by
     *  this domain.
     *
     *@return    new instance of the <code>PersistentObject</code> managed by
     *      this domain.
     * @see #newPersistentObject()
     */
    public PersistentObject newPersistentObject() {
        return new HabitatsBooksPersist();
    }

    /**
     *  Provides the domain with the requisite information to perform its
     *  responsibilities of managing a <code>PersistentObject</code>. At an
     *  absolute minimum, this includes calls to:
     *  <ul>
     *    <li> setTableName(). Need to know entity name.
     *    <li> addColumnSpec(). Need at least one column.
     *  </ul>
     *  <p>
     *
     *  This method is called by the constructors. Failure for sub-classes to
     *  fill in required parameters will result in a <code>ConfigurationException</code>
     *  . <p>
     *
     */
    public void setup() {
        this.setTableName("chm62edt_habitat");
        this.setReadOnly(true);
        this.setTableAlias("C");

        this.addColumnSpec(new StringColumnSpec("ID_HABITAT", "getIdHabitat", "setIdHabitat", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));

        // Joined tables
        JoinTable habitatReferences = null;

        habitatReferences = new JoinTable("chm62edt_habitat_references B", "ID_HABITAT", "ID_HABITAT");
        this.addJoinTable(habitatReferences);

        JoinTable Date = null;

        Date = new JoinTable("dc_index E", "ID_DC", "ID_DC");
        Date.addJoinColumn(new StringJoinColumn("CREATED", "created", "setCreated"));
        habitatReferences.addJoinTable(Date);

    }
}
