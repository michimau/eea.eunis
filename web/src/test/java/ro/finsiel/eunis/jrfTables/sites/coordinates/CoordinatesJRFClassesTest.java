package ro.finsiel.eunis.jrfTables.sites.coordinates;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.SourceDb;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class CoordinatesJRFClassesTest {

    @Test
    public void test_CoordinatesDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        SourceDb sourceDb = SourceDb.allDatabases();

        CoordinatesDomain instance = new CoordinatesDomain(searchCriteria, sortCriteria, null, sourceDb);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CoordinatesPersist() {
        CoordinatesPersist instance = new CoordinatesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
