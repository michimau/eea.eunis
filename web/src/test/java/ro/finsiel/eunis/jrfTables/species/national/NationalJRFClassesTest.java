package ro.finsiel.eunis.jrfTables.species.national;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class NationalJRFClassesTest {

    @Test
    public void test_NationalThreatStatusDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        NationalThreatStatusDomain instance = new NationalThreatStatusDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_NationalThreatStatusPersist() {
        NationalThreatStatusPersist instance = new NationalThreatStatusPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
