package ro.finsiel.eunis.jrfTables.habitats.references;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.species.names.NameSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class HabitatsBooksJRFClassesTest {

    @Test
    public void test_HabitatsBooksDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        HabitatsBooksDomain instance = new HabitatsBooksDomain(searchCriteria, sortCriteria, HabitatsBooksDomain.SEARCH_BOTH);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatsBooksPersist() {
        HabitatsBooksPersist instance = new HabitatsBooksPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
