package ro.finsiel.eunis.jrfTables.sites.species;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.SourceDb;
import ro.finsiel.eunis.search.Utilities;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SpeciesJRFClassesTest {

    @Test
    public void test_SpeciesDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        SourceDb sourceDb = SourceDb.allDatabases();

        SpeciesDomain instance = new SpeciesDomain(searchCriteria, sortCriteria, true, sourceDb, Utilities.OPERATOR_IS);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesPersist() {
        SpeciesPersist instance = new SpeciesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
