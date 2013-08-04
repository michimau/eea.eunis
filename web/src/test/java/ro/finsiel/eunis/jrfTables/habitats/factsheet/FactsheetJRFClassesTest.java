package ro.finsiel.eunis.jrfTables.habitats.factsheet;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class FactsheetJRFClassesTest {

    @Test
    public void test_HabitatCountryDomain() {
        HabitatCountryDomain instance = new HabitatCountryDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void test_HabitatCountryPersist() {
        HabitatCountryPersist instance = new HabitatCountryPersist();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void test_HabitatLegalDomain() {
        HabitatLegalDomain instance = new HabitatLegalDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void test_HabitatLegalPersist() {
        HabitatLegalPersist instance = new HabitatLegalPersist();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void test_OtherClassificationDomain() {
        OtherClassificationDomain instance = new OtherClassificationDomain();
        assertNotNull("Instantiantion failed", instance);
    }

    @Test
    public void test_OtherClassificationPersist() {
        OtherClassificationPersist instance = new OtherClassificationPersist();
        assertNotNull("Instantiantion failed", instance);
    }
}
