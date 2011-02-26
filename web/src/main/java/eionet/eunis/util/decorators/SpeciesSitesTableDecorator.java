package eionet.eunis.util.decorators;


import org.displaytag.decorator.TableDecorator;

import ro.finsiel.eunis.WebContentManagement;
import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;


public class SpeciesSitesTableDecorator extends TableDecorator {

    /**
     *
     * @return
     */
    public String getId() {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        return Utilities.formatString(site.getIDSite());
    }

    /**
     *
     * @return
     */
    public String getSource() {
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        return Utilities.formatString(
                SitesSearchUtility.translateSourceDB(site.getSourceDB()));
    }

    /**
     *
     * @return
     */
    public String getArea() {
        StringBuilder ret = new StringBuilder();
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();
        WebContentManagement cm = (WebContentManagement) getPageContext().getAttribute(
                "cm");

        if (Utilities.isCountry(site.getAreaNameEn())) {
            ret.append("<a href=\"species-statistics-module.jsp?countryName=");
            ret.append(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()));
            ret.append("\" title=\"");
            ret.append(cm.cms("open_the_statistical_data_for"));
            ret.append(" ");
            ret.append(Utilities.treatURLSpecialCharacters(site.getAreaNameEn()));
            ret.append("\">");
            ret.append(
                    Utilities.formatString(
                            Utilities.treatURLSpecialCharacters(
                                    site.getAreaNameEn())));
            ret.append("</a>");
            ret.append(cm.cmsTitle("open_the_statistical_data_for"));
        } else {
            ret.append(
                    Utilities.formatString(
                            Utilities.treatURLSpecialCharacters(
                                    site.getAreaNameEn())));
        }

        return ret.toString();
    }

    /**
     *
     * @return
     */
    public String getSiteName() {
        StringBuilder ret = new StringBuilder();
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        ret.append("<a href=\"sites/").append(site.getIDSite()).append("\">");
        ret.append(
                Utilities.formatString(
                        Utilities.treatURLSpecialCharacters(site.getName())));
        ret.append("</a>");
        return ret.toString();
    }

}
