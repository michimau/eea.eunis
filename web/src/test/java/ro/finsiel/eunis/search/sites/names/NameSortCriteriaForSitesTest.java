package ro.finsiel.eunis.search.sites.names;

import ro.finsiel.eunis.search.AbstractSortCriteria;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

/**
 * Test the NameSortCriteria for the sites package.
 */
public class NameSortCriteriaForSitesTest {

    @Test
    public void testInstantiation(){
        NameSortCriteria nsc = new NameSortCriteria(NameSortCriteria.SORT_NAME, AbstractSortCriteria.ASCENDENCY_ASC);
        assertEquals("&sort=4&ascendency=1", nsc.toURLParam());
        assertEquals("A.NAME ASC", nsc.toSQL());
        assertEquals("<input type=\"hidden\" name=\"sort\" value=\"4\" /><input type=\"hidden\" name=\"ascendency\" value=\"1\" />", nsc.toFORMParam());
    }

}
