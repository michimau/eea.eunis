package ro.finsiel.eunis.jrfTables.sites.neighborhood;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class NeighborhoodJRFClassesTest {

    @Test
    public void test_NeighborhoodDomain() {
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        NeighborhoodDomain instance = new NeighborhoodDomain("SITEID", 400.0f, 55.0f, 14.0f, sortCriteria);
        assertNotNull("Instantiation failed", instance);
    }

}
