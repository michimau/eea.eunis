package ro.finsiel.eunis.jrfTables.species.habitats;

import eionet.eunis.test.DbHelper;
import org.junit.BeforeClass;
import org.junit.Test;
import ro.finsiel.eunis.jrfTables.habitats.references.HabitatsBooksDomain;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.habitats.references.ReferencesSearchCriteria;
import ro.finsiel.eunis.utilities.SQLUtilities;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNotNull;

/**
 * Test for Habitat Reference Search (habitat -> references).
 */
public class HabitatsBooksTest {
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-four-species-habitats.xml");
        SQLUtilities sqlUtils = DbHelper.getSqlUtilities();
        // The created date isn't set in the seed. We set it manually.
        sqlUtils.UpdateSQL("UPDATE DC_INDEX SET CREATED='2004' WHERE ID_DC = 2409");
    }

    /**
     * Test for Date query issues
     *
     * @throws Exception
     */
    @Test
    public void searchNameStartsWithHelleno() throws Exception {
        ReferencesSearchCriteria criteria1 = new ReferencesSearchCriteria("Helleno", Utilities.OPERATOR_STARTS);
        ReferencesSearchCriteria[] searchCriteria = {criteria1};
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        HabitatsBooksDomain habitatsBooks = new HabitatsBooksDomain(searchCriteria, sortCriteria, HabitatsBooksDomain.SEARCH_EUNIS);

        assertNotNull("Instantiation failed", habitatsBooks);
        Long result = habitatsBooks.countResults();

        assertEquals(Long.valueOf(1), result);
    }
}
