package eionet.eunis.util.decorators;


import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.TableDecorator;

import ro.finsiel.eunis.WebContentManagement;
import ro.finsiel.eunis.jrfTables.Chm62edtCountryPersist;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.search.CountryUtil;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;


public class SpeciesSitesTableDecorator extends TableDecorator {

    /** */
    private String requestContextPath = null;

    /**
     * Lazy-loading getter for the context path of the request behind this decorator.
     */
    private String getRequestContextPath(){

        if (requestContextPath == null){
            PageContext pageContext = getPageContext();
            if (pageContext != null){
                ServletRequest request = pageContext.getRequest();
                if (request instanceof HttpServletRequest){
                    requestContextPath = ((HttpServletRequest) request).getContextPath();
                }
            }

            if (requestContextPath == null){
                requestContextPath = "";
            }
        }

        return requestContextPath;
    }

    /**
     *
     * @return id as String
     */
    public String getId() {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        return Utilities.formatString(site.getIDSite());
    }

    /**
     *
     * @return source database
     */
    public String getSource() {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        return Utilities.formatString(SitesSearchUtility.translateSourceDB(site.getSourceDB()));
    }

    /**
     *
     * @return country as HTML snippet
     */
    public String getArea() {
        StringBuilder ret = new StringBuilder();
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();
        WebContentManagement cm = (WebContentManagement) getPageContext().getAttribute("cm");

        String areaNameEn = site.getAreaNameEn();
        Chm62edtCountryPersist country = CountryUtil.findCountry(areaNameEn);

        if (country != null) {

            ret.append("<a href=\"").append(getRequestContextPath()).append("/countries/");
            ret.append(Utilities.treatURLSpecialCharacters(country.getEunisAreaCode()));
            ret.append("\" title=\"");
            ret.append(cm.cmsPhrase("Open factsheet for"));
            ret.append(" ");
            ret.append(Utilities.treatURLSpecialCharacters(areaNameEn));
            ret.append("\">");
            ret.append(Utilities.formatString(Utilities.treatURLSpecialCharacters(areaNameEn)));
            ret.append("</a>");
            ret.append(cm.cmsTitle("open_the_statistical_data_for"));
        } else {
            ret.append(Utilities.formatString(Utilities.treatURLSpecialCharacters(areaNameEn)));
        }

        return ret.toString();
    }

    /**
     *
     * @return site name as HTML snippet
     */
    public String getSiteName() {
        StringBuilder ret = new StringBuilder();
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        ret.append("<a href=\"sites/").append(site.getIDSite()).append("\">");
        ret.append(Utilities.formatString(Utilities.treatURLSpecialCharacters(site.getName())));
        ret.append("</a>");
        return ret.toString();
    }

}
