package ro.finsiel.eunis.jrfTables.sites.altitude;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class AltitudeJRFClassesTest {

    @Test
    public void test_AltitudeDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        AltitudeDomain instance = new AltitudeDomain(searchCriteria, sortCriteria, null);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_AltitudePersist() {
        AltitudePersist instance = new AltitudePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
