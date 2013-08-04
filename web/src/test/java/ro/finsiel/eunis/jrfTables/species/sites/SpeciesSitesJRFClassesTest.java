package ro.finsiel.eunis.jrfTables.species.sites;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SpeciesSitesJRFClassesTest {

    @Test
    public void test_SpeciesSitesDomain() {
        SpeciesSitesDomain instance = new SpeciesSitesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesSitesPersist() {
        SpeciesSitesPersist instance = new SpeciesSitesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
