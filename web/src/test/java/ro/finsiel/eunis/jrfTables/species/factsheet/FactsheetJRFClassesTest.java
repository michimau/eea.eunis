package ro.finsiel.eunis.jrfTables.species.factsheet;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class FactsheetJRFClassesTest {

    @Test
    public void test_InfoQualityReportTypeDomain() {
        InfoQualityReportTypeDomain instance = new InfoQualityReportTypeDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_InfoQualityReportTypePersist() {
        InfoQualityReportTypePersist instance = new InfoQualityReportTypePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_NatureObjectDcSourceDomain() {
        NatureObjectDcSourceDomain instance = new NatureObjectDcSourceDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_NatureObjectDcSourcePersist() {
        NatureObjectDcSourcePersist instance = new NatureObjectDcSourcePersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ReportsDistributionStatusDomain() {
        ReportsDistributionStatusDomain instance = new ReportsDistributionStatusDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_ReportsDistributionStatusPersist() {
        ReportsDistributionStatusPersist instance = new ReportsDistributionStatusPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesByNatureObjectDomain() {
        SitesByNatureObjectDomain instance = new SitesByNatureObjectDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesByNatureObjectPersist() {
        SitesByNatureObjectPersist instance = new SitesByNatureObjectPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesStatusReportTypeDomain() {
        SpeciesStatusReportTypeDomain instance = new SpeciesStatusReportTypeDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SpeciesStatusReportTypePersist() {
        SpeciesStatusReportTypePersist instance = new SpeciesStatusReportTypePersist();
        assertNotNull("Instantiation failed", instance);
    }

}
