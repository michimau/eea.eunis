package ro.finsiel.eunis.search.sites;

import junit.framework.Assert;

import org.junit.BeforeClass;
import org.junit.Test;

import ro.finsiel.eunis.jrfTables.sites.names.NameDomain;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.names.NameBean;
import ro.finsiel.eunis.search.sites.names.NamePaginator;
import eionet.eunis.test.DbHelper;

public class SitesSearchTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-sites-vad.xml");

    }

    @Test
    public void searchTest() {
        SitesSearchTestResult result = searchSites("Divadlo", Utilities.OPERATOR_CONTAINS, true);
        
        
        
        Assert.assertEquals(15, result.getResultsCount());
    }

    private SitesSearchTestResult searchSites(String englishName, int relationOp, boolean fuzzySearch) {

        SitesSearchTestResult testResult = new SitesSearchTestResult();

        NameBean formBean = new NameBean();
        formBean.setEnglishName(englishName);
        formBean.setRelationOp(Integer.toString(relationOp));

        int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);

        boolean[] source_db = {true, true, true, true, true, true, false, true};

        NamePaginator paginator =
                new NamePaginator(new NameDomain(formBean.toSearchCriteria(), formBean.toSortCriteria(), null, source_db,
                        fuzzySearch));
        paginator.setSortCriteria(formBean.toSortCriteria());
        paginator.setPageSize(Utilities.checkedStringToInt(formBean.getPageSize(), AbstractPaginator.DEFAULT_PAGE_SIZE));

        try {
            testResult.setResults(paginator.getPage(currentPage));
            testResult.setResultsCount(paginator.countResults());
            testResult.setPagesCount(paginator.countPages());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        testResult.setCurrentPage(paginator.setCurrentPage(currentPage));

        return testResult;

    }

}
