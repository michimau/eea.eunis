package ro.finsiel.eunis.jrfTables.species.groups;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class GroupsJRFClassesTest {

    @Test
    public void test_GroupsDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        GroupsDomain instance = new GroupsDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_GroupsPersist() {
        GroupsPersist instance = new GroupsPersist();
        assertNotNull("Instantiation failed", instance);
    }
}
