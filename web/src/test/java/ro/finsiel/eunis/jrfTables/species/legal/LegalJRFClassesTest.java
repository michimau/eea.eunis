package ro.finsiel.eunis.jrfTables.species.legal;

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
    public void test_ScientificLegalDomain() {
        ScientificLegalDomain instance = new ScientificLegalDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ScientificLegalPersist() {
        ScientificLegalPersist instance = new ScientificLegalPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
