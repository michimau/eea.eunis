package ro.finsiel.eunis.jrfTables;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNotNull;

import org.junit.BeforeClass;
import org.junit.Test;

import ro.finsiel.eunis.formBeans.ReferencesSearchCriteria;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.ReferencesWrapper;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.utilities.SQLUtilities;
import eionet.eunis.test.DbHelper;

public class ReferencesTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-four-species-habitats.xml");
        SQLUtilities sqlUtils = DbHelper.getSqlUtilities();
        // The created date isn't set in the seed. We set it manually.
        sqlUtils.UpdateSQL("UPDATE DC_INDEX SET CREATED='2013'");
    }

    @Test
    public void testGetSpecies() throws Exception {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ReferencesDomain instance = new ReferencesDomain(searchCriteria, sortCriteria);
        assertNotNull("Instantiation failed", instance);
        // there is only one CHM62EDT_REPORTS in the seed
        assertEquals(1, instance.getSpeciesForAReference("2409").size());
    }

    @Test
    public void testGetSpeciesByGroup() throws Exception {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ReferencesDomain instance = new ReferencesDomain(searchCriteria, sortCriteria);
        assertNotNull("Instantiation failed", instance);
        // there is only one CHM62EDT_REPORTS in the seed
        assertEquals(1, instance.getSpeciesForAReferenceByGroup("2409").size());
    }

    @Test
    public void testGetHabitats() throws Exception {
        AbstractSearchCriteria[] searchCriteria = new AbstractSearchCriteria[0];
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ReferencesDomain instance = new ReferencesDomain(searchCriteria, sortCriteria);
        assertNotNull("Instantiation failed", instance);
        assertEquals(1, instance.getHabitatsForAReferences("2409").size());
    }

    @Test
    public void testGetResults() throws Exception {
        AbstractSearchCriteria criteria1 = new ReferencesSearchCriteria(null, null, null, null, null, "Europaea",
                Utilities.OPERATOR_CONTAINS, null, null, null, null);
        AbstractSearchCriteria[] searchCriteria = { criteria1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        ReferencesDomain instance = new ReferencesDomain(searchCriteria, sortCriteria);
        assertNotNull("Instantiation failed", instance);

        assertEquals(Long.valueOf(1), instance.countResults());
        ReferencesWrapper row = (ReferencesWrapper) instance.getResults(0, 50, sortCriteria).get(0);
        assertEquals("2013", row.getYear());
    }

}
