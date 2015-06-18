package ro.finsiel.eunis.jrfTables.sites.size;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.SourceDb;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SizeJRFClassesTest {

    @Test
    public void test_SizeDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        SourceDb sourceDb = SourceDb.allDatabases();

        SizeDomain instance = new SizeDomain(searchCriteria, sortCriteria, null, sourceDb);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SizePersist() {
        SizePersist instance = new SizePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
