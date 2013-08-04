package ro.finsiel.eunis.jrfTables.sites.size;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SizeJRFClassesTest {

    @Test
    public void test_SizeDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean[] source_db = {true, true, true, true, true, true, true, true};

        SizeDomain instance = new SizeDomain(searchCriteria, sortCriteria, null, source_db);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SizePersist() {
        SizePersist instance = new SizePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
