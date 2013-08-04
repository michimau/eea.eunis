package ro.finsiel.eunis.jrfTables.species.habitats;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class HabitatsJRFClassesTest {

    @Test
    public void test_CommonRecordsDomain() {
        CommonRecordsDomain instance = new CommonRecordsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CommonRecordsPersist() {
        CommonRecordsPersist instance = new CommonRecordsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatDomain() {
        HabitatDomain instance = new HabitatDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatPersist() {
        HabitatPersist instance = new HabitatPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatNatureObjectGeoscopeDomain() {
        HabitatNatureObjectGeoscopeDomain instance = new HabitatNatureObjectGeoscopeDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatNatureObjectGeoscopePersist() {
        HabitatNatureObjectGeoscopePersist instance = new HabitatNatureObjectGeoscopePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatNatureObjectReportTypeDomain() {
        HabitatNatureObjectReportTypeDomain instance = new HabitatNatureObjectReportTypeDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatNatureObjectReportTypePersist() {
        HabitatNatureObjectReportTypePersist instance = new HabitatNatureObjectReportTypePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatsNatureObjectReportTypeSpeciesDomain() {
        HabitatsNatureObjectReportTypeSpeciesDomain instance = new HabitatsNatureObjectReportTypeSpeciesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HabitatsNatureObjectReportTypeSpeciesPersist() {
        HabitatsNatureObjectReportTypeSpeciesPersist instance = new HabitatsNatureObjectReportTypeSpeciesPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ScientificNameDomain() {
        ScientificNameDomain instance = new ScientificNameDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ScientificNamePersist() {
        ScientificNamePersist instance = new ScientificNamePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
