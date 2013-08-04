package ro.finsiel.eunis.jrfTables.sites.factsheet;

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
    public void test_HumanActivityAttributesDomain() {
        HumanActivityAttributesDomain instance = new HumanActivityAttributesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HumanActivityAttributesPersist() {
        HumanActivityAttributesPersist instance = new HumanActivityAttributesPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HumanActivityDomain() {
        HumanActivityDomain instance = new HumanActivityDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_HumanActivityPersist() {
        HumanActivityPersist instance = new HumanActivityPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RegionsCodesDomain() {
        RegionsCodesDomain instance = new RegionsCodesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_RegionsCodesPersist() {
        RegionsCodesPersist instance = new RegionsCodesPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SiteHabitatsDomain() {
        SiteHabitatsDomain instance = new SiteHabitatsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SiteHabitatsPersist() {
        SiteHabitatsPersist instance = new SiteHabitatsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SiteRelationsDomain() {
        SiteRelationsDomain instance = new SiteRelationsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SiteRelationsPersist() {
        SiteRelationsPersist instance = new SiteRelationsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesDesignationsDomain() {
        SitesDesignationsDomain instance = new SitesDesignationsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesDesignationsPersist() {
        SitesDesignationsPersist instance = new SitesDesignationsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SiteSpeciesDomain() {
        SiteSpeciesDomain instance = new SiteSpeciesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SiteSpeciesPersist() {
        SiteSpeciesPersist instance = new SiteSpeciesPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesSpeciesReportAttributesDomain() {
        SitesSpeciesReportAttributesDomain instance = new SitesSpeciesReportAttributesDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_SitesSpeciesReportAttributesPersist() {
        SitesSpeciesReportAttributesPersist instance = new SitesSpeciesReportAttributesPersist();
        assertNotNull("Instantiation failed", instance);
    }
}
