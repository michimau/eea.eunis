package ro.finsiel.eunis.jrfTables.habitats.legal;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class LegalJRFClassesTest {

    @Test
    public void test_EUNISLegalDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        EUNISLegalDomain instance = new EUNISLegalDomain(searchCriteria, sortCriteria);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_EUNISLegalPersist() {
        EUNISLegalPersist instance = new EUNISLegalPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
