package ro.finsiel.eunis.jrfTables.habitats.species;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.species.names.NameSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SpeciesJRFClassesTest {

    @Test
    public void testHabitatsDomain() {
        HabitatsDomain instance = new HabitatsDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testHabitatsPersist() {
        HabitatsPersist instance = new HabitatsPersist();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testScientificNameDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria,
                ScientificNameDomain.SEARCH_EUNIS, true, ScientificNameDomain.SEARCH_BOTH);
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testScientificNamePersist() {
        ScientificNamePersist instance = new ScientificNamePersist();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testSpeciesDomain() {
        SpeciesDomain instance = new SpeciesDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void testSpeciesPersist() {
        SpeciesPersist instance = new SpeciesPersist();
        assertNotNull("Instantiantion failed", instance);
    }
}
