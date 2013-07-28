package ro.finsiel.eunis.search.species;

import static junit.framework.Assert.assertEquals;

import java.util.List;
import org.junit.BeforeClass;
import org.junit.Test;

import eionet.eunis.test.DbHelper;
import ro.finsiel.eunis.jrfTables.species.taxonomy.SpeciesGroupSpeciesPersist;

public class SpeciesSearchUtilityTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-four-species.xml");
    }

    @Test
    public void countSpeciesInGroup() {
        Long result = SpeciesSearchUtility.countUniqueSpecies(1, true);
        Long expected = new Long(1);
        assertEquals(expected, result);
    }

    @Test
    public void checkTaxanomyChildrenForOrder() {
        boolean result = SpeciesSearchUtility.IdTaxonomyHasChildren("15");
        assertEquals(true, result);
    }

    /**
     * This Family doesn't have children.
     */
    @Test
    public void checkTaxanomyChildrenForFamily() {
        boolean result = SpeciesSearchUtility.IdTaxonomyHasChildren("16");
        assertEquals(false, result);
    }

    @Test
    public void findSpeciesforFamily() {
        List result = SpeciesSearchUtility.FindSpeciesforIdTaxonomy("16", true);
        assertEquals(2, result.size());
        Object[] resultAsArray = result.toArray();
        SpeciesGroupSpeciesPersist s;

        s = (SpeciesGroupSpeciesPersist)resultAsArray[0];
        assertEquals(new Integer(9970), s.getIdSpecies());
        s = (SpeciesGroupSpeciesPersist)resultAsArray[1];
        assertEquals(new Integer(127496), s.getIdSpecies());
    }

    /* getThreatNational is defective - not used in production? */
    /*
    @Test
    public void getSalmonThreatsForEurope() {
        List result = SpeciesSearchUtility.getThreatNational(9970, "Europe");
        assertEquals(1, result.size());
        for (Object o : result) {
            System.out.println(o.getClass().getName());
        }
    }
    */

}
