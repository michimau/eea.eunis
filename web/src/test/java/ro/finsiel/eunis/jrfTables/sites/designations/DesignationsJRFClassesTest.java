package ro.finsiel.eunis.jrfTables.sites.designations;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class DesignationsJRFClassesTest {

    @Test
    public void test_DesignationsDomain() {
        DesignationsDomain instance = new DesignationsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_DesignationsPersist() {
        DesignationsPersist instance = new DesignationsPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
