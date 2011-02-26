package eionet.eunis.stripes.actions;


import net.sourceforge.stripes.action.DefaultHandler;
import net.sourceforge.stripes.action.RedirectResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.UrlBinding;


/**
 * Action bean to handle sites-factsheet functionality.
 *
 * @author Risto Alt
 * <a href="mailto:risto.alt@tieto.com">contact</a>
 */
@UrlBinding("/sites-factsheet.jsp")
public class SitesFactsheetRedirectActionBean extends AbstractStripesAction {

    private static final String[] allTypes = new String[] {
        "general", "faunaflora", "designations", "habitats", "sites", "other"};

    private String idsite = "";
    private String mapType = "";
    private String zoom = "";
    // selected tab
    private int tab;

    /**
     * This action bean only serves RDF through {@link RdfAware}.
     */
    @DefaultHandler
    public Resolution defaultAction() {

        String tabName = allTypes[tab];
        String url = "/sites/" + idsite;

        if (tabName != null && tabName.length() > 0) {
            url += "/" + tabName;
        }
        if (mapType != null && mapType.length() > 0) {
            url = url + "?mapType=" + mapType;
        }
        if (zoom != null && zoom.length() > 0) {
            url = url + "&zoom=" + zoom;
        }
        if ((mapType != null && mapType.length() > 0)
                || (zoom != null && zoom.length() > 0)) {
            url = url + "#map";
        }
        RedirectResolution redirect = new RedirectResolution(url);

        return redirect;
    }

    /**
     * @return the idsite
     */
    public String getIdsite() {
        return idsite;
    }

    /**
     * @param idsite the idsite to set
     */
    public void setIdsite(String idsite) {
        this.idsite = idsite;
    }

    /**
     * @return the tab
     */
    public int getTab() {
        return tab;
    }

    /**
     * @param tab the tab to set
     */
    public void setTab(int tab) {
        if (tab > 5 || tab < 0) {
            tab = 0;
        }
        this.tab = tab;
    }

    public String getMapType() {
        return mapType;
    }

    public void setMapType(String mapType) {
        this.mapType = mapType;
    }

    public String getZoom() {
        return zoom;
    }

    public void setZoom(String zoom) {
        this.zoom = zoom;
    }

}
