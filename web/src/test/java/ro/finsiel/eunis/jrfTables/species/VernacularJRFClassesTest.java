package ro.finsiel.eunis.jrfTables.species;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class VernacularJRFClassesTest {

    @Test
    public void test_VernacularNamesDomain() {
        VernacularNamesDomain instance = new VernacularNamesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_VernacularNamesPersist() {
        VernacularNamesPersist instance = new VernacularNamesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
