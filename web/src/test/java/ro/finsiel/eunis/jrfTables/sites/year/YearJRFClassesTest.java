package ro.finsiel.eunis.jrfTables.sites.year;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.SourceDb;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class YearJRFClassesTest {

    @Test
    public void test_YearDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        SourceDb sourceDb = SourceDb.allDatabases();

        YearDomain instance = new YearDomain(searchCriteria, sortCriteria, sourceDb);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_YearPersist() {
        YearPersist instance = new YearPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
