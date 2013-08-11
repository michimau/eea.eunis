package ro.finsiel.eunis.jrfTables.species.names;

import java.util.List;

import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertEquals;
import org.junit.Test;
import org.junit.BeforeClass;

import eionet.eunis.test.DbHelper;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.species.names.NameSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

/**
 * Call the getResults()
 * This flushes out configuration errors.
 */
// OPERATOR_IS = 2
// OPERATOR_STARTS = 3
// OPERATOR_CONTAINS = 4

public class ScientificNameDomainTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-species-lyn.xml");
    }

    /**
     * Search on name IS "Salmo trutta".
     * The database has been seeded with two species - one a synonym
     */
    @Test
    public void searchAllNamesAndInvalid() throws Exception {
        NameSearchCriteria criteria1 = new NameSearchCriteria("Salmo trutta", Utilities.OPERATOR_IS);
        NameSearchCriteria[] searchCriteria = { criteria1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean searchSynonymsT = true;
        boolean showEUNISInvalidatedSpeciesT = true;
        Boolean searchVernacularT = Boolean.valueOf(true);

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria,
                searchSynonymsT, showEUNISInvalidatedSpeciesT, searchVernacularT);
        assertNotNull("Instantiation failed", instance);
        List result = instance.getResults(0, 10, sortCriteria);
        assertEquals(2, result.size());

        ScientificNamePersist listItem;
        for (Object o : result) {
            listItem = (ScientificNamePersist)o;
            assertEquals("Salmo trutta", listItem.getScientificName());
        }
    }

    /**
     * Search on name IS "Salmo trutta" - ignore invalid species.
     * The database has been seeded with two species - one a synonym
     */
    @Test
    public void searchAllNamesNotInvalid() throws Exception {
        NameSearchCriteria criteria1 = new NameSearchCriteria("Salmo trutta", Utilities.OPERATOR_IS);
        NameSearchCriteria[] searchCriteria = { criteria1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean searchSynonymsF = false;
        boolean showEUNISInvalidatedSpeciesT = true;
        Boolean searchVernacularT = Boolean.valueOf(true);

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria,
                searchSynonymsF, showEUNISInvalidatedSpeciesT, searchVernacularT);
        assertNotNull("Instantiation failed", instance);
        List result = instance.getResults(0, 10, sortCriteria);
        assertEquals(1, result.size());

        ScientificNamePersist listItem;
        for (Object o : result) {
            listItem = (ScientificNamePersist)o;
            assertEquals("Salmo trutta", listItem.getScientificName());
        }
    }

    /**
     * Search on name Contains "lynx".
     */
    @Test
    public void searchNameContainsLynx() throws Exception {
        NameSearchCriteria criteria1 = new NameSearchCriteria("Lynx", Utilities.OPERATOR_CONTAINS);
        NameSearchCriteria[] searchCriteria = { criteria1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean searchSynonymsT = true;
        boolean showEUNISInvalidatedSpeciesT = true;
        Boolean searchVernacularT = Boolean.valueOf(true);

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria,
                searchSynonymsT, showEUNISInvalidatedSpeciesT, searchVernacularT);
        assertNotNull("Instantiation failed", instance);
        // Known issue: If we search for vernacular names, then the page size must be > 0
        // If not, then pagesize=0 is the same as no limit.
        List result = instance.getResults(0, 1000, sortCriteria);
        assertEquals(16, result.size());
    }

    /**
     * Search on name starts with "lynx".
     */
    @Test
    public void searchNameStartsWithLynx() throws Exception {
        NameSearchCriteria criteria1 = new NameSearchCriteria("Lynx", Utilities.OPERATOR_STARTS);
        NameSearchCriteria[] searchCriteria = { criteria1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean searchSynonymsT = true;
        boolean showEUNISInvalidatedSpeciesT = true;
        Boolean searchVernacularT = Boolean.valueOf(true);

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria,
                searchSynonymsT, showEUNISInvalidatedSpeciesT, searchVernacularT);
        assertNotNull("Instantiation failed", instance);
        // Known issue: If we search for vernacular names, then the page size must be > 0
        // If not, then pagesize=0 is the same as no limit.
        List result = instance.getResults(0, 1000, sortCriteria);
        assertEquals(9, result.size());
    }

    /**
     * Search on name Contains "lynx" and species group is "Mammals".
     */
    @Test
    public void searchNameContainsLynAndMammalsGroup() throws Exception {
        NameSearchCriteria criteria1 = new NameSearchCriteria("Lynx", Utilities.OPERATOR_CONTAINS);
        NameSearchCriteria criteria2 = new NameSearchCriteria("Mammals",
                NameSearchCriteria.CRITERIA_GROUP, Utilities.OPERATOR_IS);
        NameSearchCriteria[] searchCriteria = { criteria1, criteria2 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];
        boolean searchSynonyms = true;
        boolean showEUNISInvalidatedSpecies = true;
        Boolean searchVernacular = Boolean.valueOf(true);

        ScientificNameDomain instance = new ScientificNameDomain(searchCriteria, sortCriteria,
                searchSynonyms, showEUNISInvalidatedSpecies, searchVernacular);
        assertNotNull("Instantiation failed", instance);
        // Known issue: If we search for vernacular names, then the page size must be > 0
        // If not, then pagesize=0 is the same as no limit.
        List result = instance.getResults(0, 1000, sortCriteria);
        assertEquals(12, result.size());
    }
}
