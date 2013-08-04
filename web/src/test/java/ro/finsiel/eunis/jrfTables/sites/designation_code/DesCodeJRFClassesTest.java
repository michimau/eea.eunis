package ro.finsiel.eunis.jrfTables.sites.designation_code;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class DesCodeJRFClassesTest {

    @Test
    public void test_DesignationDomain() {
        DesignationDomain instance = new DesignationDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_DesignationPersist() {
        DesignationPersist instance = new DesignationPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
