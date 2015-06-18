package ro.finsiel.eunis.jrfTables.sites.names;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.SourceDb;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class NameJRFClassesTest {

    @Test
    public void test_NameDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        SourceDb sourceDb = SourceDb.allDatabases();

        NameDomain instance = new NameDomain(searchCriteria, sortCriteria, null, sourceDb);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_NamePersist() {
        NamePersist instance = new NamePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
