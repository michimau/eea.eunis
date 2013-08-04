package ro.finsiel.eunis.jrfTables.habitats.code;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class CodeJRFClassesTest {

    @Test
    public void test_CodeDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        CodeDomain instance = new CodeDomain(searchCriteria, sortCriteria, 0);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CodePersist() {
        CodePersist instance = new CodePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
