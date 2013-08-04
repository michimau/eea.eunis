package ro.finsiel.eunis.jrfTables.habitats.sites;

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
public class HabitatsSitesJRFClassesTest {

    @Test
    public void test_HabitatsSitesDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean[] source_db = {true, true, true, true, true, true, true, true};

        HabitatsSitesDomain instance = new HabitatsSitesDomain(searchCriteria, sortCriteria, HabitatsSitesDomain.SEARCH_BOTH,
                Integer.valueOf(0), source_db);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatsSitesPersist() {
        HabitatsSitesPersist instance = new HabitatsSitesPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
