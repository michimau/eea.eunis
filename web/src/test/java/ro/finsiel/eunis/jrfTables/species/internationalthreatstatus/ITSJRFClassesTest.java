package ro.finsiel.eunis.jrfTables.species.internationalthreatstatus;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class ITSJRFClassesTest {

    @Test
    public void test_InternationalThreatStatusDomain() {
        InternationalThreatStatusDomain instance = new InternationalThreatStatusDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_InternationalThreatStatusPersist() {
        InternationalThreatStatusPersist instance = new InternationalThreatStatusPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
