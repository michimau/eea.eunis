package ro.finsiel.eunis.search.species.names;

import ro.finsiel.eunis.search.AbstractSortCriteria;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 * Test the NameSortCriteria for the species package.
 */
public class NameSortCriteriaForSpeciesTest {

    @Test
    public void testInstantiation(){
        NameSortCriteria nsc = new NameSortCriteria(NameSortCriteria.SORT_FAMILY,
            AbstractSortCriteria.ASCENDENCY_ASC, Boolean.valueOf(true));
        assertEquals("&sort=4&ascendency=1", nsc.toURLParam());
        assertEquals("taxonomicNameFamily ASC", nsc.toSQL());
        assertEquals("<input type=\"hidden\" name=\"sort\" value=\"4\" /><input type=\"hidden\" name=\"ascendency\" value=\"1\" />", nsc.toFORMParam());
    }

}
