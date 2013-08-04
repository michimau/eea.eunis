package ro.finsiel.eunis.jrfTables.habitats.names;

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
public class NamesJRFClassesTest {

    @Test
    public void test_NamesDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSearchCriteria[] searchCriteriaExtra = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        NamesDomain instance = new NamesDomain(searchCriteria, searchCriteriaExtra, sortCriteria, NamesDomain.SEARCH_BOTH, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_NamesPersist() {
        NamesPersist instance = new NamesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
