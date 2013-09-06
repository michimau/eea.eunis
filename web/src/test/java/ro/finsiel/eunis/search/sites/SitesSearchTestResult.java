package ro.finsiel.eunis.search.sites;

import java.util.List;

public class SitesSearchTestResult {
    
    private List results;
    private int resultsCount;
    private int pagesCount;
    private int currentPage;
    
    public List getResults() {
        return results;
    }
    public void setResults(List results) {
        this.results = results;
    }
    public int getResultsCount() {
        return resultsCount;
    }
    public void setResultsCount(int resultsCount) {
        this.resultsCount = resultsCount;
    }
    public int getPagesCount() {
        return pagesCount;
    }
    public void setPagesCount(int pagesCount) {
        this.pagesCount = pagesCount;
    }
    public int getCurrentPage() {
        return currentPage;
    }
    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

}
