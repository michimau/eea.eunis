package ro.finsiel.eunis.jrfTables.sites.names;

import java.util.List;

import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;
import org.junit.Test;
import org.junit.BeforeClass;

import eionet.eunis.test.DbHelper;

import ro.finsiel.eunis.search.AbstractSearchCriteria;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.sites.names.NameSearchCriteria;
import ro.finsiel.eunis.search.Utilities;

/**
 * Call the getResults()
 */
// OPERATOR_IS = 2
// OPERATOR_STARTS = 3
// OPERATOR_CONTAINS = 4

public class NameTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-sites-vad.xml");
    }


    /**
     * Emulate the plain site search on sites.jsp.
     */
    @Test
    public void searchStartsVadehavet() throws Exception {
        String country = null;
        String minDesignationDate = null;
        String maxDesignationDate = null;
        NameSearchCriteria criteria1 = new NameSearchCriteria("vadehavet",
            Utilities.OPERATOR_STARTS, country, minDesignationDate, maxDesignationDate);
        NameSearchCriteria[] searchCriteria = { criteria1 };

        boolean[] source_db = {true, true, true, true, true, true, true, true};
        boolean fuzzySearch = true;

        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        NameDomain instance = new NameDomain(searchCriteria, sortCriteria, null, source_db, fuzzySearch);
        assertNotNull("Instantiation failed", instance);
        List result = instance.getResults(0, 1000, sortCriteria);

        //NamePersist listItem;
        //for (Object o : result) {
        //    listItem = (NamePersist)o;
        //    System.out.println(listItem.getName());
        //}
    }

    /**
     * Emulate the plain site search on sites.jsp. There is a site with code 912
     * in the test data. We want it to be between the 10 first hits when there
     * are no other sort criteria.
     */
    @Test
    public void searchStartsCode912() throws Exception {
        String country = null;
        String minDesignationDate = null;
        String maxDesignationDate = null;
        NameSearchCriteria criteria1 = new NameSearchCriteria("912",
            Utilities.OPERATOR_STARTS, country, minDesignationDate, maxDesignationDate);
        NameSearchCriteria[] searchCriteria = { criteria1 };

        boolean[] source_db = {true, true, true, true, true, true, true, true};
        boolean fuzzySearch = true;

        AbstractSortCriteria[] sortCriteria = new AbstractSortCriteria[0];

        NameDomain instance = new NameDomain(searchCriteria, sortCriteria, null, source_db, fuzzySearch);
        assertNotNull("Instantiation failed", instance);
        List result = instance.getResults(0, 10, sortCriteria);

        boolean code912found = false;
        NamePersist listItem;
        for (Object o : result) {
            listItem = (NamePersist)o;
            if ("912".equals(listItem.getIdSite())) {
                code912found = true;
            }
        }
        assertTrue(code912found);
    }
}
