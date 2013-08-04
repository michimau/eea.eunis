package ro.finsiel.eunis.jrfTables.sites.statistics;

import static junit.framework.Assert.assertNotNull;
import org.junit.Test;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;

/**
 * Simply try to instantiate the *Domain and *Persist classes.
 * This flushes out configuration errors.
 */
public class StatisticsJRFClassesTest {

    @Test
    public void test_CountrySitesFactsheetDomain() {
        CountrySitesFactsheetDomain instance = new CountrySitesFactsheetDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_CountrySitesFactsheetPersist() {
        CountrySitesFactsheetPersist instance = new CountrySitesFactsheetPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_StatisticsDomain() {
        StatisticsDomain instance = new StatisticsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_StatisticsPersist() {
        StatisticsPersist instance = new StatisticsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_StatisticSitesOverlapDomain() {
        StatisticSitesOverlapDomain instance = new StatisticSitesOverlapDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_StatisticSitesOverlapForDesignationsDomain() {
        StatisticSitesOverlapForDesignationsDomain instance = new StatisticSitesOverlapForDesignationsDomain();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_StatisticSitesOverlapForDesignationsPersist() {
        StatisticSitesOverlapForDesignationsPersist instance = new StatisticSitesOverlapForDesignationsPersist();
        assertNotNull("Instantiation failed", instance);
    }

    @Test
    public void test_StatisticSitesOverlapPersist() {
        StatisticSitesOverlapPersist instance = new StatisticSitesOverlapPersist();
        assertNotNull("Instantiation failed", instance);
    }

}
