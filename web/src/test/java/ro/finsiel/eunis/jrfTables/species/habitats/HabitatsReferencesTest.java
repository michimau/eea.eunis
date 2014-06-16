package ro.finsiel.eunis.jrfTables.species.habitats;

import eionet.eunis.test.DbHelper;
import org.junit.BeforeClass;
import org.junit.Test;
import ro.finsiel.eunis.jrfTables.habitats.habitatsByReferences.RefDomain;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.utilities.SQLUtilities;
import ro.finsiel.eunis.search.habitats.habitatsByReferences.ReferencesSearchCriteria;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNotNull;

/**
 * Test for Reference Habitat Search (References -> Habitat)
 */
public class HabitatsReferencesTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-four-species-habitats.xml");
        SQLUtilities sqlUtils = DbHelper.getSqlUtilities();
        // The created date isn't set in the seed. We set it manually.
        sqlUtils.UpdateSQL("UPDATE dc_index SET CREATED='2004' WHERE ID_DC = 2409");
        // Add have_source manually
        sqlUtils.UpdateSQL("UPDATE chm62edt_habitat_references set HAVE_SOURCE=1 WHERE ID_HABITAT='1514'");
    }

    /**
     * Test for Date query issues
     *
     * @throws Exception
     */
    @Test
    public void searchByYear() throws Exception {
        ReferencesSearchCriteria criteria1 = new ReferencesSearchCriteria(null, Utilities.OPERATOR_CONTAINS, "2004", null,
                Utilities.OPERATOR_IS, null, Utilities.OPERATOR_CONTAINS, null, Utilities.OPERATOR_CONTAINS, null,
                Utilities.OPERATOR_CONTAINS, RefDomain.SEARCH_EUNIS, RefDomain.SOURCE);
        ReferencesSearchCriteria[] searchCriteria = {criteria1};
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        RefDomain referencesHabitats = new RefDomain(searchCriteria, sortCriteria, RefDomain.SEARCH_BOTH, RefDomain.SOURCE);

        assertNotNull("Instantiation failed", referencesHabitats);
        Long result = referencesHabitats.countResults();

        assertEquals(Long.valueOf(1), result);
    }
}
