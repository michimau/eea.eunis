package ro.finsiel.eunis.jrfTables.species.references;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertNotNull;

import org.junit.BeforeClass;
import org.junit.Test;

import ro.finsiel.eunis.jrfTables.species.speciesByReferences.RefDomain;
import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.species.speciesByReferences.ReferencesSearchCriteria;
import eionet.eunis.test.DbHelper;

/**
 * Make a search for references.
 */
public class SpeciesReferencesTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-four-species.xml");
    }

    @Test
    public void searchTitleContainsEuropaea() throws Exception {
        AbstractSearchCriteria criteria1 = new ReferencesSearchCriteria(null, null, null, null, null, "Europaea",
                Utilities.OPERATOR_CONTAINS, null, null, null, null);
        AbstractSearchCriteria[] searchCriteria = { criteria1 };
        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        RefDomain instance = new RefDomain(searchCriteria, sortCriteria, true);
        assertNotNull("Instantiation failed", instance);
        Long result = instance.countResults();
        assertEquals(Long.valueOf(3), result);
    }
}
