package ro.finsiel.eunis.jrfTables.species.names;

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
    public void test_HasGridDistTabDomain() {
        HasGridDistTabDomain instance = new HasGridDistTabDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HasGridDistTabPersist() {
        HasGridDistTabPersist instance = new HasGridDistTabPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ScientificNameDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria, true, true, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ScientificNamePersist() {
        ScientificNamePersist instance = new ScientificNamePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SimilarNameDomain() {
        NameSearchCriteria crit1 = new NameSearchCriteria("Canis lupus", Utilities.OPERATOR_IS);
        AbstractSearchCriteria[] searchCriteria = { crit1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        SimilarNameDomain instance = new SimilarNameDomain(searchCriteria, sortCriteria, true, true, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_VernacularNameAnyDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        VernacularNameAnyDomain instance = new VernacularNameAnyDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_VernacularNameAnyPersist() {
        VernacularNameAnyPersist instance = new VernacularNameAnyPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_VernacularNameDomain() {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        VernacularNameDomain instance = new VernacularNameDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_VernacularNamePersist() {
        VernacularNamePersist instance = new VernacularNamePersist();
        assertNotNull("Instantiation failed", instance);
    }
}
