package ro.finsiel.eunis.jrfTables.combined;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class CombinedJRFClassesTest {

    @Test
    public void test_HabitatsCombinedDomain() {
        HabitatsCombinedDomain instance = new HabitatsCombinedDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatsCombinedPersist() {
        HabitatsCombinedPersist instance = new HabitatsCombinedPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesCombinedDomain() {
        SitesCombinedDomain instance = new SitesCombinedDomain("idSession");
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesCombinedPersist() {
        SitesCombinedPersist instance = new SitesCombinedPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesCombinedDomain() {
        SpeciesCombinedDomain instance = new SpeciesCombinedDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesCombinedPersist() {
        SpeciesCombinedPersist instance = new SpeciesCombinedPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
