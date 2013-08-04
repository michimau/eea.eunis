package ro.finsiel.eunis.jrfTables.species.references;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class ReferencesJRFClassesTest {

    @Test
    public void test_ReferencesJoinDomain() {
        ReferencesJoinDomain instance = new ReferencesJoinDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ReferencesJoinPersist() {
        ReferencesJoinPersist instance = new ReferencesJoinPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesBooksDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        SpeciesBooksDomain instance = new SpeciesBooksDomain(searchCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesBooksPersist() {
        SpeciesBooksPersist instance = new SpeciesBooksPersist();
        assertNotNull("Instantiation failed", instance);
    }
}
