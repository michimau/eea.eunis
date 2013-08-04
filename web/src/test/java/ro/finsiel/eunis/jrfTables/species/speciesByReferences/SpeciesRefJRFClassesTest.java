package ro.finsiel.eunis.jrfTables.species.speciesByReferences;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SpeciesRefJRFClassesTest {

    @Test
    public void test_RefDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        RefDomain instance = new RefDomain(searchCriteria, sortCriteria, true, "SQL_DRV", "", "", "");
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RefPersist() {
        RefPersist instance = new RefPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
