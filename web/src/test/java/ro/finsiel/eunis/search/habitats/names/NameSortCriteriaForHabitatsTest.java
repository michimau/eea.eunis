package ro.finsiel.eunis.search.habitats.names;

import ro.finsiel.eunis.search.AbstractSortCriteria;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 * Test the NameSortCriteria for the habitats package.
 */
public class NameSortCriteriaForHabitatsTest {

    @Test
    public void testInstantiation(){
        NameSortCriteria nsc = new NameSortCriteria(NameSortCriteria.SORT_ANNEX_CODE,
            AbstractSortCriteria.ASCENDENCY_ASC, Integer.valueOf(0));
        assertEquals("&sort=4&ascendency=1", nsc.toURLParam());
        assertEquals("A.CODE_2000  ASC", nsc.toSQL());
        assertEquals("<input type=\"hidden\" name=\"sort\" value=\"4\" /><input type=\"hidden\" name=\"ascendency\" value=\"1\" />", nsc.toFORMParam());
    }

}
