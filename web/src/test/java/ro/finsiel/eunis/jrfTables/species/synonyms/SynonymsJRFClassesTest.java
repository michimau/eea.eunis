package ro.finsiel.eunis.jrfTables.species.synonyms;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class SynonymsJRFClassesTest {

    @Test
    public void test_ScientificNameDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ScientificNamePersist() {
        ScientificNamePersist instance = new ScientificNamePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
