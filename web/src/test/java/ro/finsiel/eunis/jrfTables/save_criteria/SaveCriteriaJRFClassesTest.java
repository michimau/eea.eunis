package ro.finsiel.eunis.jrfTables.save_criteria;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SaveCriteriaJRFClassesTest {

    @Test
    public void test_CriteriasForUsersDomain() {
        CriteriasForUsersDomain instance = new CriteriasForUsersDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CriteriasForUsersPersist() {
        CriteriasForUsersPersist instance = new CriteriasForUsersPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_EunisGroupSearchCriteriaDomain() {
        EunisGroupSearchCriteriaDomain instance = new EunisGroupSearchCriteriaDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_EunisGroupSearchCriteriaPersist() {
        EunisGroupSearchCriteriaPersist instance = new EunisGroupSearchCriteriaPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_EunisGroupSearchDomain() {
        EunisGroupSearchDomain instance = new EunisGroupSearchDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_EunisGroupSearchPersist() {
        EunisGroupSearchPersist instance = new EunisGroupSearchPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
