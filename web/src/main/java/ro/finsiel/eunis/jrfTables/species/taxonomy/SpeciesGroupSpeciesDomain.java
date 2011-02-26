package ro.finsiel.eunis.jrfTables.species.taxonomy;


import net.sf.jrf.domain.AbstractDomain;
import net.sf.jrf.domain.PersistentObject;
import net.sf.jrf.column.columnspecs.StringColumnSpec;
import net.sf.jrf.column.columnspecs.IntegerColumnSpec;


/**
 * Date: Oct 15, 2003
 * Time: 12:43:15 PM
 */
public class SpeciesGroupSpeciesDomain extends AbstractDomain {

    /**
     **/
    public PersistentObject newPersistentObject() {
        return new SpeciesGroupSpeciesPersist();
    }

    /**
     **/
    public void setup() {
        // These setters could be used to override the default.
        // this.setDatabasePolicy(new null());
        // this.setJDBCHelper(JDBCHelperFactory.create());

        this.setTableName("CHM62EDT_SPECIES");
        this.setReadOnly(true);

        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES", "getIdSpecies",
                "setIdSpecies", DEFAULT_TO_ZERO, NATURAL_PRIMARY_KEY));
        this.addColumnSpec(
                new IntegerColumnSpec("ID_SPECIES_LINK", "getIdSpeciesLink",
                "setIdSpeciesLink", DEFAULT_TO_ZERO));
        this.addColumnSpec(
                new StringColumnSpec("SCIENTIFIC_NAME", "getScientificName",
                "setScientificName", DEFAULT_TO_EMPTY_STRING));
        this.addColumnSpec(
                new StringColumnSpec("COMMON_NAME", "getCommonName",
                "setCommonName", DEFAULT_TO_EMPTY_STRING));
    }
}
