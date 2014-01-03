package eionet.eunis.util.decorators;


import org.displaytag.decorator.TableDecorator;

import ro.finsiel.eunis.jrfTables.species.factsheet.SitesByNatureObjectPersist;
import ro.finsiel.eunis.search.Utilities;
import ro.finsiel.eunis.search.sites.SitesSearchUtility;


public class HabitatsSitesTableDecorator extends TableDecorator {

    /**
     *
     * @return id of habitat
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

        return Utilities.formatString(
                SitesSearchUtility.translateSourceDB(site.getSourceDB()));
    }

    /**
     *
     * @return country (aka area)
     */
    public String getArea() {
        StringBuilder ret = new StringBuilder();
        SitesByNatureObjectPersist site = (SitesByNatureObjectPersist) getCurrentRowObject();

        ret.append(Utilities.formatString(site.getAreaNameEn()));
        return ret.toString();
    }

    /**
     *
     * @return name of site as HTML snippet
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
