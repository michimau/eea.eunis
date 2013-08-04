package ro.finsiel.eunis.jrfTables.sites.habitats;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class HabitatsJRFClassesTest {

    @Test
    public void test_HabitatDomain() {
        HabitatDomain instance = new HabitatDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatPersist() {
        HabitatPersist instance = new HabitatPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesDomain() {
        SitesDomain instance = new SitesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesPersist() {
        SitesPersist instance = new SitesPersist();
        assertNotNull("Instantiation failed", instance);
    }
}
