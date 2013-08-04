package ro.finsiel.eunis.jrfTables.species.country;

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
        CountryDomain instance = new CountryDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CountryPersist() {
        CountryPersist instance = new CountryPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CountryRegionDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        CountryRegionDomain instance = new CountryRegionDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CountryRegionPersist() {
        CountryRegionPersist instance = new CountryRegionPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RegionDomain() {
        RegionDomain instance = new RegionDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RegionPersist() {
        RegionPersist instance = new RegionPersist();
        assertNotNull("Instantiation failed", instance);
    }
}
