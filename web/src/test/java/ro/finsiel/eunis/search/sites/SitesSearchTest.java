package ro.finsiel.eunis.search.sites;

import java.util.ArrayList;
import java.util.List;

import junit.framework.Assert;

import org.apache.commons.lang.StringUtils;
import org.junit.BeforeClass;
import org.junit.Test;

import ro.finsiel.eunis.jrfTables.sites.names.NameDomain;
import ro.finsiel.eunis.jrfTables.sites.names.NamePersist;
import ro.finsiel.eunis.search.AbstractPaginator;
import ro.finsiel.eunis.search.AbstractSortCriteria;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.names.NameBean;
import ro.finsiel.eunis.search.sites.names.NamePaginator;
import ro.finsiel.eunis.search.sites.names.NameSortCriteria;
import eionet.eunis.test.DbHelper;

/**
 * 
 * Test module for testing sites search functionalities.
 * 
 * @author Jaak Kapten
 */
public class SitesSearchTest {

    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        DbHelper.handleSetUpOperation("seed-sites-search.xml");
    }

    /**
     * Testcase to count resultset size if fuzzy search is applied.
     */
    @Test
    public void testSearchResultCount() {
        SitesSearchTestResult result = searchSites("Lahemaa", Utilities.OPERATOR_CONTAINS, null, true);
        Assert.assertEquals(123, result.getResultsCount());
    }

    /**
     * Testcase to check proper ordering of results in case of relevance sorting criteria.
     */
    @Test
    public void testSearchResultOrdering() {
        NameSortCriteria sortCriteria = new NameSortCriteria(NameSortCriteria.SORT_RELEVANCE, NameSortCriteria.ASCENDENCY_ASC);
        SitesSearchTestResult result = searchSites("Lahemaa", Utilities.OPERATOR_CONTAINS, sortCriteria, true);

        NamePersist site0 = (NamePersist) result.getResults().get(0);
        Assert.assertEquals("Lahemaa", site0.getName());

        NamePersist site1 = (NamePersist) result.getResults().get(1);
        Assert.assertEquals("Lahemaa National Park", site1.getName());

        NamePersist site2 = (NamePersist) result.getResults().get(2);
        Assert.assertEquals("Lahemaa rahvuspark", site2.getName());

        NamePersist site28 = (NamePersist) result.getResults().get(28);
        Assert.assertEquals("Lah", site28.getName());

        NamePersist site30 = (NamePersist) result.getResults().get(30);
        Assert.assertEquals("Laho", site30.getName());

        NamePersist site122 = (NamePersist) result.getResults().get(122);
        Assert.assertEquals("Viurilanlahti", site122.getName());
    }

    /**
     * Testcase to count resultset size in case fuzzy search is not applied.
     */
    @Test
    public void testNotFuzzyResultCount() {
        SitesSearchTestResult result = searchSites("Lahemaa", Utilities.OPERATOR_CONTAINS, null, false);
        Assert.assertEquals(28, result.getResultsCount());
    }

    /**
     * Testcase to check fuzzy search results structure between fuzzy and ordinary results.
     */
    @Test
    public void testFuzzySearchCriterias() {

        String keyword = "Lahemaa";

        keyword = replaceNationalLetters(keyword);
        String substring = replaceNationalLetters(StringUtils.substring(keyword, 0, 3).toLowerCase());
        int levenshteinMatches0 = 0;
        int levenshteinMatches5 = 0;
        int levenshteinMatches10 = 0;
        int nonLevenshteinMatches = 0;

        SitesSearchTestResult result = searchSites("Lahemaa", Utilities.OPERATOR_CONTAINS, null, true);

        for (Object siteObject : result.getResults()) {
            NamePersist site = (NamePersist) siteObject;

            String siteName = replaceNationalLetters(site.getName().toLowerCase());

            if (siteName.equals(keyword.toLowerCase())) {
                nonLevenshteinMatches++;
                Assert.assertTrue("Exact match", true);
            } else if (siteName.contains(keyword.toLowerCase())) {
                nonLevenshteinMatches++;
                Assert.assertTrue("Result contains search word", true);
            } else if (siteName.startsWith(keyword.toLowerCase())) {
                nonLevenshteinMatches++;
                Assert.assertTrue("Result starts with search word", true);
            } else if (siteName.contains(substring) && (StringUtils.getLevenshteinDistance(siteName, substring) <= 10)) {

                levenshteinMatches10++;

                if (StringUtils.getLevenshteinDistance(siteName, substring) == 0) {
                    levenshteinMatches0++;
                }

                if (StringUtils.getLevenshteinDistance(siteName, substring) < 5) {
                    levenshteinMatches5++;
                }

            } else {
                Assert.assertTrue("Result does not match searching business rules", false);
            }
        }

        Assert.assertEquals(28, nonLevenshteinMatches);
        Assert.assertEquals(95, levenshteinMatches10);
        Assert.assertEquals(10, levenshteinMatches5);
        Assert.assertEquals(1, levenshteinMatches0);
    }

    /**
     * Test case for checking whether the resultset contains certain keywords
     */
    @Test
    public void testResultContains() {
        SitesSearchTestResult result = searchSites("Lahemaa", Utilities.OPERATOR_CONTAINS, null, true);

        List<String> containsSiteNames = new ArrayList<String>();
        containsSiteNames.add("Lahemaa");
        containsSiteNames.add("Lah");
        containsSiteNames.add("Lahinja");
        containsSiteNames.add("Laho");

        for (String siteName : containsSiteNames) {

            boolean siteNameFound = false;

            for (Object siteObject : result.getResults()) {
                NamePersist site = (NamePersist) siteObject;

                if (site.getName().equals(siteName)) {
                    siteNameFound = true;
                    break;
                }
            }
            Assert.assertEquals("Site name " + siteName + " not found", true, siteNameFound);
        }

    }

    /**
     * Method to replace national letters into their ASCII counterpart
     * 
     * @param source
     * @return replaced string
     */
    private String replaceNationalLetters(String source) {
        String result = source;

        result = result.replace("õ", "o");
        result = result.replace("ä", "a");
        result = result.replace("ö", "o");
        result = result.replace("ü", "u");
        result = result.replace("å", "a");

        return result;
    }

    
    /**
     * 
     * Method that reflects sites-names-result.jsp functionality for searching sites.
     * 
     * @param englishName
     * @param relationOp
     * @param sortCriteria
     * @param fuzzySearch
     * @return
     */
    private SitesSearchTestResult searchSites(String englishName, int relationOp, AbstractSortCriteria sortCriteria,
            boolean fuzzySearch) {

        SitesSearchTestResult testResult = new SitesSearchTestResult();

        NameBean formBean = new NameBean();
        formBean.setEnglishName(englishName);
        formBean.setRelationOp(Integer.toString(relationOp));
        formBean.setPageSize(Integer.toString(Integer.MAX_VALUE));

        AbstractSortCriteria[] sortCriterias = new NameSortCriteria[1];
        sortCriterias[0] = sortCriteria;

        int currentPage = Utilities.checkedStringToInt(formBean.getCurrentPage(), 0);

        boolean[] source_db = {true, true, true, true, true, true, false, true};

        NamePaginator paginator =
                new NamePaginator(new NameDomain(formBean.toSearchCriteria(), sortCriterias, null, source_db, fuzzySearch));
        paginator.setSortCriteria(sortCriterias);
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
