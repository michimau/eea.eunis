package ro.finsiel.eunis.jrfTables.species.advanced;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class DictionaryJRFClassesTest {

    @Test
    public void test_DictionaryDomain() {
        DictionaryDomain instance = new DictionaryDomain("idSession");
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_DictionaryPersist() {
        DictionaryPersist instance = new DictionaryPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
