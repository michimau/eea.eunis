package ro.finsiel.eunis.jrfTables.habitats.country;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class CountryJRFClassesTest {

    @Test
    public void test_CountryDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        CountryDomain instance = new CountryDomain(searchCriteria, sortCriteria, 0);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CountryPersist() {
        CountryPersist instance = new CountryPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
